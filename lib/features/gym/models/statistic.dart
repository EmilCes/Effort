class Statistic {

  final DateTime day;
  final int time;

  Statistic({
    required this.day,
    required this.time
  });

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "time": time
    };
  }

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
        day: DateTime.parse(json['day'] as String),
        time: json['time'] as int
    );
  }
}