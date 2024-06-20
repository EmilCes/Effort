import 'package:effort/features/gym/models/daily_routine_exercise.dart';
import 'package:effort/features/gym/models/muscle.dart';

class Exercise {

  final int? exerciseId;
  final String name;
  final String? description;
  final String? videoUrl;
  final String? creatorId;
  DailyRoutineExercise? dailyRoutineExercise;
  List<MuscleEffort>? muscles;

  Exercise({
    this.exerciseId,
    required this.name,
    this.description,
    this.videoUrl,
    this.creatorId,
    this.dailyRoutineExercise,
    this.muscles
  });


  static Exercise empty() => Exercise(name: '', description: '', videoUrl: '', creatorId: '');

  Map<String, dynamic> toJson() {
    var json = {
      "name": name,
      "description": description,
      "videoUrl": videoUrl,
      "creatorId": creatorId
    };

    return json;
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var musclesFromJson = json['muscles'] as List?;
    List<MuscleEffort>? muscleList;

    var exercise = Exercise(
      exerciseId: json['exerciseId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      videoUrl: json['videoUrl'] as String?,
      creatorId: json['creatorId'] as String?
    );

    if (musclesFromJson != null) {
      muscleList = musclesFromJson.map((muscleJson) => MuscleEffort.fromJson(muscleJson)).toList();
      exercise.muscles = muscleList;
    }

    if (json['dailyRoutineExercise'] != null) {
      exercise.dailyRoutineExercise = DailyRoutineExercise.fromJson(json['dailyRoutineExercise']);
    }

    return exercise;
  }

}