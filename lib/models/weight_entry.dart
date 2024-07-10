class WeightEntry {
  final DateTime date;
  final double weight;

  WeightEntry(
    this.date,
    this.weight,
  );

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'weight': weight,
  };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
    DateTime.parse(json['date']),
    json['weight'],
  );
}
