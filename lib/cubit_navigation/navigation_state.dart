part of 'navigation_cubit.dart';

class NavigationState {
  final int selectedIndex;
  final String steps;
  final StreamSubscription<StepCount>? stepCountSubscription;
  final double miles;
  final double calories;
  final double duration;


  NavigationState( 
      {required this.selectedIndex,
      required this.steps,
      this.stepCountSubscription, required this.miles, required this.calories, required this.duration});

  NavigationState copyWith(
      {int? selectedIndex,
      String? steps,
      StreamSubscription<StepCount>? stepCountSubscription,
      double? miles,
      double? calories,
      double? duration}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      steps: steps ?? this.steps,
      stepCountSubscription:
          stepCountSubscription ?? this.stepCountSubscription,
      miles: miles ?? this.miles,
      calories: calories ?? this.calories,
      duration: duration ?? this.duration
    );
  }
}
