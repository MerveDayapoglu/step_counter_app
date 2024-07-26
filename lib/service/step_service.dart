import 'package:hive/hive.dart';
import 'package:step_counter_app/data/model/step_data.dart';

class StepService {
  final Box<StepData> _stepDataBox = Hive.box<StepData>('stepDataBox');
//Gelen adım sayısının hive veritabanına kaydetme
  Future<void> saveSteps(int stepsValue) async {
    final DateTime today = DateTime.now();
    final StepData existingData = _stepDataBox.values.firstWhere(
      (stepData) => _isSameDay(stepData.date, today),
      orElse: () => StepData(date: DateTime(1970), steps: -1),
    );

    if (existingData.steps == -1) {
      final StepData stepData = StepData(date: today, steps: stepsValue);
      //Veritabanında değer yoksa ekler
      await _stepDataBox.add(stepData);
    } else {
      final StepData updatedData = StepData(date: today, steps: stepsValue);
      //Veritabanında veri varsa günceller
      await _stepDataBox.put(existingData.key, updatedData);
    }
  }

  //Verinin var olduğunu kontrol etme için tarihleri karşılaştırma
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

//Adım sayısı ekranda gösterirken çağrılan fonksiyon
  Future<StepData?> getTodaySteps() async {
    final DateTime today = DateTime.now();
    final StepData existingData = _stepDataBox.values.firstWhere(
      (stepData) => _isSameDay(stepData.date, today),
      orElse: () => StepData(date: today, steps: 0),
    );
    return existingData;
  }

//Grafiklerde adım sayılarının gösterilmesi için
  Map<String, int> getWeeklySteps() {
    final Map<String, int> weeklySteps = {
      "S": 0,
      "M": 0,
      "TU": 0,
      "W": 0,
      "TH": 0,
      "FRI": 0,
      "SAT": 0,
    };

    final DateTime now = DateTime.now();
    for (StepData stepData in _stepDataBox.values) {
      if (stepData.date.isAfter(now.subtract(const Duration(days: 7)))) {
        final String day = _getDayOfWeek(stepData.date.weekday);
        weeklySteps[day] = (weeklySteps[day] ?? 0) + stepData.steps;
      }
    }

    return weeklySteps;
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return "S";
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "TU";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "TH";
      case DateTime.friday:
        return "FRI";
      case DateTime.saturday:
        return "SAT";
      default:
        return "";
    }
  }

  Future<void> clearStepsData() async {
    await _stepDataBox.clear();
  }
}
