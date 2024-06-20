import 'package:effort/features/gym/models/daily_routine.dart';

class WeeklyRoutine {
  final String? weeklyRoutineId;
  final String name;
  List<DailyRoutine>? routines;

  WeeklyRoutine({
    this.weeklyRoutineId,
    required this.name,
    this.routines
  });

  static WeeklyRoutine empty() => WeeklyRoutine(name: '');

  Map<String, dynamic> toJson() {
    return {
      "weeklyroutineId": weeklyRoutineId,
      "name": name,
      "routines": routines
    };
  }

  factory WeeklyRoutine.fromJson(Map<String, dynamic> json) {

    var routinesFromJson = json['routines'] as List?;
    List<DailyRoutine> routinesList;

    var weeklyRoutine = WeeklyRoutine(
      weeklyRoutineId: json['weeklyroutineId'] as String?,
      name: json['name'] as String
    );

    if (routinesFromJson != null) {
      routinesList = routinesFromJson.map((routineJson) => DailyRoutine.fromJson(routineJson)).toList();
      weeklyRoutine.routines = routinesList;
    }

    return weeklyRoutine;
  }

  static const List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

}