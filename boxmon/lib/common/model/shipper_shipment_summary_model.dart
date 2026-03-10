class ShipperShipmentSummaryModel {
  final int requestedCount;
  final int assignedCount;
  final int inTransitCount;
  final int doneCount;

  ShipperShipmentSummaryModel({
    required this.requestedCount,
    required this.assignedCount,
    required this.inTransitCount,
    required this.doneCount,
  });

  factory ShipperShipmentSummaryModel.fromJson(Map<String, dynamic> json) {
    return ShipperShipmentSummaryModel(
      requestedCount: _toInt(json['requestedCount']) ?? 0,
      assignedCount: _toInt(json['assignedCount']) ?? 0,
      inTransitCount: _toInt(json['inTransitCount']) ?? 0,
      doneCount: _toInt(json['doneCount']) ?? 0,
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
