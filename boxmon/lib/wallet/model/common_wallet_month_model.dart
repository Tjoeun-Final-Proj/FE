

class CommonWalletMonthModel {
  final int? shipmentId;
  final String? shipmentStatus;
  final String? settlementStatus;
  final int? price;
  final String? pickupAddress;
  final String? dropoffAddress;
  final DateTime? pickupDesiredAt;
  final DateTime? dropoffDesiredAt;
  final DateTime? createdAt;

  CommonWalletMonthModel({
    this.shipmentId,
    this.shipmentStatus,
    this.settlementStatus,
    this.price,
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupDesiredAt,
    this.dropoffDesiredAt,
    this.createdAt,
  });

  // JSON Map을 단일 객체로 변환
  factory CommonWalletMonthModel.fromJson(Map<String, dynamic> json) {
    return CommonWalletMonthModel(
      shipmentId: json['shipmentId'] as int?,
      shipmentStatus: json['shipmentStatus'] as String?,
      settlementStatus: json['settlementStatus'] as String?,
      price: json['price'] as int?,
      pickupAddress: json['pickupAddress'] as String?,
      dropoffAddress: json['dropoffAddress'] as String?,
      // 날짜 데이터가 ISO8601 형식이므로 DateTime으로 파싱
      pickupDesiredAt: json['pickupDesiredAt'] != null 
          ? DateTime.parse(json['pickupDesiredAt']) 
          : null,
      dropoffDesiredAt: json['dropoffDesiredAt'] != null 
          ? DateTime.parse(json['dropoffDesiredAt']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  // JSON 리스트를 객체 리스트로 변환하는 정적 메서드
  static List<CommonWalletMonthModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CommonWalletMonthModel.fromJson(json)).toList();
  }
}