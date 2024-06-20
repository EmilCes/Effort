class MuscleEffort {

  final int? muscleId;
  final String name;

  MuscleEffort({
    this.muscleId,
    required this.name
  });


  static MuscleEffort empty() => MuscleEffort(name: '');

  Map<String, dynamic> toJson() {
    return {
      "name": name
    };
  }

  factory MuscleEffort.fromJson(Map<String, dynamic> json) {
    return MuscleEffort(
        muscleId: json['muscleId'] as int?,
        name: json['muscleName'] as String
    );
  }
}