class InventoryModel {
  final int? shipmentId;
  final String? shipmentStatus;
  final int? price;
  final int? profit;
  final String? pickupAddress;
  final String? dropoffAddress;
  final DateTime? pickupDesiredAt;
  final DateTime? dropoffDesiredAt;
  final double? cargoWeight;
  final String? description;
  final double? estimatedDistance;
  final String? vehicleType;
  final String? waypoint1Address;
  final String? waypoint2Address;

  InventoryModel({
    this.shipmentId,
    this.shipmentStatus,
    this.price,
    this.profit,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupDesiredAt,
    this.dropoffDesiredAt,
    this.cargoWeight,
    this.description,
    this.estimatedDistance,
    this.vehicleType,
    this.waypoint1Address,
    this.waypoint2Address,
  });

  // JSON Map을 단일 객체로 변환
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      shipmentId: json['shipmentId'] as int?,
      shipmentStatus: json['shipmentStatus'] as String?,
      price: json['price'] as int? ?? 0,
      profit: json['profit'] as int? ?? 0,
      pickupAddress: json['pickupAddress'] as String?,
      dropoffAddress: json['dropoffAddress'] as String?,

      // 🔥 경유지 데이터 파싱 추가 (이게 빠지면 리스트에 안 나와요!)
      waypoint1Address: json['waypoint1Address'] as String?,
      waypoint2Address: json['waypoint2Address'] as String?,

      pickupDesiredAt: json['pickupDesiredAt'] != null
          ? DateTime.parse(json['pickupDesiredAt'])
          : null,
      dropoffDesiredAt: json['dropoffDesiredAt'] != null
          ? DateTime.parse(json['dropoffDesiredAt'])
          : null,

      cargoWeight: json['cargoWeight'] != null
          ? (json['cargoWeight'] as num).toDouble()
          : null,
      description: json['description'] as String?,
      estimatedDistance: json['estimatedDistance'] != null
          ? (json['estimatedDistance'] as num).toDouble()
          : null,
      vehicleType: json['vehicleType'] as String?,
    );
  }
  // JSON 리스트를 객체 리스트로 변환하는 정적 메서드
  static List<InventoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InventoryModel.fromJson(json)).toList();
  }
}
