import 'dart:io';

class ShipmentModel {
  // 1. 서버 JSON 구조에 맞춰 변수 타입 조정
  final Map<String, double>? pickupPoint;
  final String? pickupAddress;
  final DateTime? pickupDesiredAt;
  final Map<String, double>? dropoffPoint;
  final String? dropoffAddress;
  final DateTime? dropoffDesiredAt;
  final Map<String, double>? waypoint1Point;
  final String? waypoint1Address;
  final Map<String, double>? waypoint2Point;
  final String? waypoint2Address;
  final int? price;
  final String? vehicleType;
  final String? cargoType;
  final double? cargoWeight;
  final String? cargoVolume;
  final bool? needRefrigerate;
  final bool? needFreeze;
  final String? description;
  final String? cargoPhotoUrl;
  final String? companyName;
  final File? files;

  ShipmentModel({
    this.pickupPoint,
    this.pickupAddress,
    this.pickupDesiredAt,
    this.dropoffPoint,
    this.dropoffAddress,
    this.dropoffDesiredAt,
    this.waypoint1Point,
    this.waypoint1Address,
    this.waypoint2Point,
    this.waypoint2Address,
    this.price,
    this.vehicleType,
    this.cargoType,
    this.cargoWeight,
    this.cargoVolume,
    this.needRefrigerate,
    this.needFreeze,
    this.description,
    this.cargoPhotoUrl,
    this.companyName,
    this.files
  });

  // 2. 서버로 보낼 때 사용하는 변환 함수 (핵심!)
  Map<String, dynamic> toJson() {
    return {
      "pickupPoint": pickupPoint,
      "pickupAddress": pickupAddress,
      // DateTime을 서버가 이해하는 문자열로 변환 (ISO8601 형식)
      "pickupDesiredAt": pickupDesiredAt?.toIso8601String(),
      "dropoffPoint": dropoffPoint,
      "dropoffAddress": dropoffAddress,
      "dropoffDesiredAt": dropoffDesiredAt?.toIso8601String(),
      "waypoint1Point": waypoint1Point,
      "waypoint1Address": waypoint1Address,
      "waypoint2Point": waypoint2Point,
      "waypoint2Address": waypoint2Address,
      "price": price,
      "vehicleType": vehicleType,
      "cargoType": cargoType,
      "cargoWeight": cargoWeight,
      "cargoVolume": cargoVolume,
      "needRefrigerate": needRefrigerate,
      "needFreeze": needFreeze,
      "description": description,
      "cargoPhotoUrl": cargoPhotoUrl,
      "companyName": companyName,
    };
  }

  // 3. 서버 응답을 받을 때 사용하는 함수 (안전하게 처리)
  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      pickupPoint: json['pickupPoint'] != null ? Map<String, double>.from(json['pickupPoint']) : null,
      pickupAddress: json['pickupAddress'],
      pickupDesiredAt: json['pickupDesiredAt'] != null ? DateTime.parse(json['pickupDesiredAt']) : null,
      dropoffPoint: json['dropoffPoint'] != null ? Map<String, double>.from(json['dropoffPoint']) : null,
      dropoffAddress: json['dropoffAddress'],
      dropoffDesiredAt: json['dropoffDesiredAt'] != null ? DateTime.parse(json['dropoffDesiredAt']) : null,
      // ... 나머지도 동일한 방식으로 null 체크하며 파싱 ...
      price: json['price'],
      companyName: json['companyName'],
      files: null, // 파일은 별도로 처리 
    );
  }
}