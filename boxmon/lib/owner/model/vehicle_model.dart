class VehicleModel {
  final String? vehicleNumber; // "12가 3457"
  final String? vehicleType; // "CARGO", "VAN", "WINGBODY" 등
  final bool canRefrigerate; // 냉장 가능 여부
  final bool canFreeze; // 냉동 가능 여부
  final double weightCapacity; // 1.0 (톤)

  VehicleModel({
    this.vehicleNumber,
    this.vehicleType,
    this.canRefrigerate = false,
    this.canFreeze = false,
    this.weightCapacity = 0.0,
  });

  // 1. JSON Map을 객체로 변환 (서버 응답 처리)
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleNumber: json['vehicleNumber'] as String?,
      vehicleType: json['vehicleType'] as String?,
      canRefrigerate: json['canRefrigerate'] as bool? ?? false,
      canFreeze: json['canFreeze'] as bool? ?? false,
      // num으로 받아서 double로 안전하게 변환
      weightCapacity: (json['weightCapacity'] as num? ?? 0.0).toDouble(),
    );
  }

  // 2. 객체를 JSON Map으로 변환 (서버 등록용)
  Map<String, dynamic> toJson() {
    return {
      "vehicleNumber": vehicleNumber,
      "vehicleType": vehicleType,
      "canRefrigerate": canRefrigerate,
      "canFreeze": canFreeze,
      "weightCapacity": weightCapacity,
    };
  }
}
