import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionState(isGranted: false, message: ''));

  Future<void> requestPermissions() async {
    //Fiziksel aktivite izni
    var activityRecognitionStatus =
        await Permission.activityRecognition.request();

    var batteryOptimizationStatus =
        await Permission.ignoreBatteryOptimizations.request();

    if (activityRecognitionStatus.isGranted &&
        batteryOptimizationStatus.isGranted) {
      emit(PermissionState(isGranted: true, message: 'Permission Granted'));
    } else {
      emit(PermissionState(
          isGranted: false, message: 'Step Counter not available'));
    }
  }
}
