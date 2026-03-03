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
      
      // 날짜 파싱
      pickupDesiredAt: json['pickupDesiredAt'] != null 
          ? DateTime.parse(json['pickupDesiredAt']) 
          : null,
      dropoffDesiredAt: json['dropoffDesiredAt'] != null 
          ? DateTime.parse(json['dropoffDesiredAt']) 
          : null,

      // 🔥 새로 추가된 필드 파싱
      // cargoWeight와 estimatedDistance는 num으로 받아서 toDouble() 처리 (에러 방지 꿀팁)
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