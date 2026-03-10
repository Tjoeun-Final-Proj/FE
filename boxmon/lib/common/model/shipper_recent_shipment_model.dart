class ShipperRecentShipmentModel {
  final String routeText;
  final String shipmentStatus;
  final String lastUpdatedLabel;

  ShipperRecentShipmentModel({
    required this.routeText,
    required this.shipmentStatus,
    required this.lastUpdatedLabel,
  });

  factory ShipperRecentShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipperRecentShipmentModel(
      routeText: (json['routeText'] as String?)?.trim() ?? '',
      shipmentStatus: (json['shipmentStatus'] as String?)?.trim() ?? '',
      lastUpdatedLabel: (json['lastUpdatedLabel'] as String?)?.trim() ?? '',
    );
  }
}
