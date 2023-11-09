class NumberOfFallModel {
  final int value;
  final DateTime dateTime;

  NumberOfFallModel({
    required this.value,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'date_time': dateTime.toIso8601String(),
    };
  }

  factory NumberOfFallModel.fromMap(Map<String, dynamic> map) {
    return NumberOfFallModel(
      value: int.tryParse(map['value'].toString()) ?? 0,
      dateTime: DateTime.tryParse(map['fromDate']) ?? DateTime.tryParse(map['date_time']) ?? DateTime.now(),
    );
  }
}