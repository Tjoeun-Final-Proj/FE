class DriverShipmentSummaryModel {
  final DateTime? firstPickupDesiredAt;
  final int inTransitCount;
  final int todayScheduleCount;

  DriverShipmentSummaryModel({
    required this.firstPickupDesiredAt,
    required this.inTransitCount,
    required this.todayScheduleCount,
  });

  factory DriverShipmentSummaryModel.fromJson(Map<String, dynamic> json) {
    return DriverShipmentSummaryModel(
      firstPickupDesiredAt: json['firstPickupDesiredAt'] != null
          ? DateTime.tryParse('${json['firstPickupDesiredAt']}')
          : null,
      inTransitCount: _toInt(json['inTransitCount']) ?? 0,
      todayScheduleCount: _toInt(json['todayScheduleCount']) ?? 0,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

