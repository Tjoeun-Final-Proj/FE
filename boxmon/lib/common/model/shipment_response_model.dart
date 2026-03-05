// 상세 조회 받는 모델

class ShipmentResponseModel {
  final int? shipmentId;           // Long -> int
  final String? pickupAddress;
  final String? dropoffAddress;
  final DateTime? pickupDesiredAt; // LocalDateTime -> DateTime
  final DateTime? dropoffDesiredAt; // LocalDateTime -> DateTime
  final double? estimatedDistance; // Double -> double
  final double? cargoWeight;       // Double -> double
  final String? vehicleType;
  final String? description;
  final double? profit;            // BigDecimal/Double -> double

  ShipmentResponseModel({
    this.shipmentId,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupDesiredAt,
    this.dropoffDesiredAt,
    this.estimatedDistance,
    this.cargoWeight,
    this.vehicleType,
    this.description,
    this.profit,
  });

  // 서버 응답(JSON)을 객체로 변환하는 factory 생성자
  factory ShipmentResponseModel.fromJson(Map<String, dynamic> json) {
    return ShipmentResponseModel(
      shipmentId: json['shipmentId'] as int?,
      pickupAddress: json['pickupAddress'] as String?,
      dropoffAddress: json['dropoffAddress'] as String?,
      pickupDesiredAt: json['pickupDesiredAt'] != null
          ? DateTime.parse(json['pickupDesiredAt'])
          : null,
      dropoffDesiredAt: json['dropoffDesiredAt'] != null
          ? DateTime.parse(json['dropoffDesiredAt'])
          : null,
      estimatedDistance: json['estimatedDistance']?.toDouble(),
      cargoWeight: json['cargoWeight']?.toDouble(),
      vehicleType: json['vehicleType'] as String?,
      description: json['description'] as String?,
      profit: json['profit']?.toDouble(),
    );
  }
}