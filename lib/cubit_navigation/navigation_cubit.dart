import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:pedometer/pedometer.dart';
import 'package:step_counter_app/data/model/step_data.dart';
import 'package:step_counter_app/service/step_service.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final StepService stepService;
  int?
      initialSteps; //Günün başlangıcında adımsayar için kullanılan pedometerde bulunan toplam adım sayısını tutarak gün içinde eklenen adımları çıkarırken kullanılan değişken

  NavigationCubit(this.stepService)
      : super(NavigationState(
            selectedIndex: 0,
            steps: '0',
            miles: 0.0,
            calories: 0.0,
            duration: 0.0));
            
  //Sayfa ilk açıldığında çalışarak adım sayısının gösterilmesi için
  Future<void> initPlatformState() async {
    final hasPermissions = await FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      await FlutterBackground.initialize();
    }
    await FlutterBackground.enableBackgroundExecution();
    //Hive veritabanından bugünün adım sayısı çekilir
    final StepData? stepData = await stepService.getTodaySteps();
    //Bugünün adım verisi bulunuyorsa steps değerine çekilen verinin adım sayısı atanır
    if (stepData != null) {
      emit(state.copyWith(
        steps: stepData.steps.toString(),
        miles: calculateMiles(stepData.steps),
        calories: calculateCalories(stepData.steps),
        duration: calculateDuration(stepData.steps),
      ));
    } else {
      //Bugünün adım verisi yoksa adım sayısı olarak steps değerine 0 değeri atanır
      emit(
          state.copyWith(steps: '0', miles: 0.0, calories: 0.0, duration: 0.0));
    }
    //Adım sayımını dinlemeyi başlatır
    if (state.stepCountSubscription == null) {
      final subscription = Pedometer.stepCountStream.listen(
        (event) async {
          //initialSteps değişkenine toplam adım sayısı atanır eğer bugüne ait adım sayısı varsa bu değer çıkarılır
          initialSteps ??= event.steps - (stepData?.steps ?? 0);

          final int stepsSinceMidnight = event.steps - (initialSteps ?? 0);
          emit(state.copyWith(
            steps: stepsSinceMidnight.toString(),
            miles: calculateMiles(stepsSinceMidnight),
            calories: calculateCalories(stepsSinceMidnight),
            duration: calculateDuration(stepsSinceMidnight),
          ));
          await stepService.saveSteps(stepsSinceMidnight);
        },
        onError: (error) {
          emit(state.copyWith(steps: 'Step Count not available'));
        },
        onDone: () {
          state.stepCountSubscription?.cancel();
          _restartStream();
        },
        cancelOnError: true,
      );

      emit(state.copyWith(stepCountSubscription: subscription));
    }
  }

  //arka planda saymaya devam etmesi için
  void _restartStream() {
    final subscription = Pedometer.stepCountStream.listen(
      (event) async {
        final int stepsSinceMidnight = event.steps - (initialSteps ?? 0);
        emit(state.copyWith(
          steps: stepsSinceMidnight.toString(),
          miles: calculateMiles(stepsSinceMidnight),
          calories: calculateCalories(stepsSinceMidnight),
          duration: calculateDuration(stepsSinceMidnight),
        ));
        await stepService.saveSteps(stepsSinceMidnight);
      },
      onError: (error) {
        emit(state.copyWith(steps: 'Step Count not available'));
      },
      onDone: () {
        _restartStream();
      },
      cancelOnError: true,
    );

    emit(state.copyWith(stepCountSubscription: subscription));
  }
  //sayfa geçişi için
  void setSelectedIndex(int index) =>
      emit(state.copyWith(selectedIndex: index));

  //zamanlayıcı başlatıp gece yarısı olduğunda adım sayısını sıfırlar
  void resetStepsAtMidnight() {
    final DateTime now = DateTime.now();
    final DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    final Duration timeUntilMidnight = midnight.difference(now);

    Timer(timeUntilMidnight, () {
      initialSteps = null;
      emit(state.copyWith(
        steps: '0',
        miles: 0.0,
        calories: 0.0,
        duration: 0.0,
      ));
      resetStepsAtMidnight();
    });
  }

  double calculateCalories(int steps) {
    double caloriesValue = (steps * 0.0566);
    return caloriesValue;
  }

  double calculateMiles(int steps) {
    double milesValue = (2.2 * steps) / 5280;
    return milesValue;
  }

  double calculateDuration(int steps) {
    double durationValue = (steps * 1 / 1000);
    return durationValue;
  }

  @override
  Future<void> close() {
    state.stepCountSubscription?.cancel();
    FlutterBackground.disableBackgroundExecution();
    return super.close();
  }
}
