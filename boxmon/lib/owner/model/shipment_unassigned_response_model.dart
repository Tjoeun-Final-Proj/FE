class ShipmentUnassignedResponseModel {
  final double? cargoWeight;
  final String? description;
  final String? dropoffAddress;
  final DateTime? dropoffDesiredAt;
  final double? estimatedDistance;
  final String? pickupAddress;
  final DateTime? pickupDesiredAt;
  final int? profit;
  final int? shipmentId;
  final String? vehicleType;

  ShipmentUnassignedResponseModel({
    this.cargoWeight,
    this.description,
    this.dropoffAddress,
    this.dropoffDesiredAt,
    this.estimatedDistance,
    this.pickupAddress,
    this.pickupDesiredAt,
    this.profit,
    this.shipmentId,
    this.vehicleType,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory ShipmentUnassignedResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      // 💡 factory 생성자는 반드시 return을 해줘야 합니다!
      return ShipmentUnassignedResponseModel(
        cargoWeight: (json["cargoWeight"] as num?)?.toDouble(),
        description: json["description"] ?? "",
        dropoffAddress: json["dropoffAddress"],
        dropoffDesiredAt: json["dropoffDesiredAt"] != null
            ? DateTime.parse(json["dropoffDesiredAt"])
            : null,
        estimatedDistance: (json["estimatedDistance"] as num?)?.toDouble(),
        pickupAddress: json["pickupAddress"],
        pickupDesiredAt: json["pickupDesiredAt"] != null
            ? DateTime.parse(json["pickupDesiredAt"])
            : null,
        profit: json["profit"],
        shipmentId: json["shipmentId"],
        vehicleType: json["vehicleType"],
      );
    } catch (e, stacktrace) {
      print("🚒 [모델 파싱 에러] 특정 필드 변환 실패!");
      print("🚒 에러 내용: $e");
      print("🚒 문제된 JSON 데이터: $json");
      print("🚒 스택트레이스: $stacktrace");
      rethrow; // 에러를 다시 던져서 서비스/컨트롤러에서도 알 수 있게 함
    }
  }
}
