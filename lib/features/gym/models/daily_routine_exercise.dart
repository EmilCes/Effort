class DailyRoutineExercise {

  final int series;
  final int repetitions;

  DailyRoutineExercise({
    required this.series,
    required this.repetitions,
  });


  Map<String, dynamic> toJson() {
    var json = {
      "series": series,
      "repetitions": repetitions
    };

    return json;
  }

  factory DailyRoutineExercise.fromJson(Map<String, dynamic> json) {

    var dailyRoutineExercise = DailyRoutineExercise(
      series: json['series'] as int,
      repetitions: json['repetitions'] as int
    );

    return dailyRoutineExercise;
  }

}