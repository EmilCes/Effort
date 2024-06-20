import 'exercise.dart';

class DailyRoutine {

  final int? routineId;
  final String? name;
  final bool? isOwner;
  String? day;
  List<Exercise>? exercises;

  DailyRoutine({
    this.routineId,
    this.day,
    required this.name,
    this.isOwner,
    this.exercises
  });


  static DailyRoutine empty() => DailyRoutine(name: '');

  Map<String, dynamic> toJson() {
    var json = {
      "name": name,
    };

    return json;
  }

  factory DailyRoutine.fromJson(Map<String, dynamic> json) {
    var exercisesFromJson = json['exercises'] as List?;
    List<Exercise>? exerciseList;

    var dailyRoutine = DailyRoutine(
      routineId: json['routineId'] as int?,
      name: json['name'] as String?,
      isOwner: json['isOwner'] as bool?,
      day: json['day'] as String?
    );

    if (exercisesFromJson != null) {
      exerciseList = exercisesFromJson.map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();
      dailyRoutine.exercises = exerciseList;
    }

    return dailyRoutine;
  }

}