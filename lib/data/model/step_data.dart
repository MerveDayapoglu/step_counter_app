import 'package:hive/hive.dart';

part 'step_data.g.dart';

@HiveType(typeId: 0)
class StepData extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late int steps;

  StepData({required this.date, required this.steps});
}
