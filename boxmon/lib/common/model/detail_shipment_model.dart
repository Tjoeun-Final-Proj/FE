class ShipDetailResponseModel {
  final int? shipmentId;
  final String? shipmentNumber;
  final String? shipmentStatus;
  final DateTime? createdAt;
  final int? shipperId;
  final String? shipperName;
  final int? driverId;
  final String? driverName;
  final PointModel? currentDriverPoint;
  final double? distanceToDestination;
  final DateTime? estimatedArrivalTime;
  final String? pickupAddress;
  final String? waypoint1Address;
  final String? waypoint2Address;
  final String? dropoffAddress;
  final DateTime? pickupDesiredAt;
  final DateTime? dropoffDesiredAt;
  final String? cargoType;
  final String? cargoVolume;
  final double? cargoWeight;
  final String? vehicleType;
  final String? description;
  final int? price;
  final int? platformFee;
  final int? profit;
  final PointModel? pickupPoint;
  final PointModel? dropoffPoint;
  final String? cargoPhotoUrl;
  final String? companyName;
  final String? dropoffPhotoUrl;
  final bool? driverCancelToggle;  // 차주 취소 요청 여부
  final bool? shipperCancelToggle; // 화주 취소 요청 여부

  ShipDetailResponseModel({
    this.shipmentId,
    this.shipmentNumber,
    this.shipmentStatus,
    this.createdAt,
    this.shipperId,
    this.shipperName,
    this.driverId,
    this.driverName,
    this.currentDriverPoint,
    this.distanceToDestination,
    this.estimatedArrivalTime,
    this.pickupAddress,
    this.waypoint1Address,
    this.waypoint2Address,
    this.dropoffAddress,
    this.pickupDesiredAt,
    this.dropoffDesiredAt,
    this.cargoType,
    this.cargoVolume,
    this.cargoWeight,
    this.vehicleType,
    this.description,
    this.price,
    this.platformFee,
    this.profit,
    this.pickupPoint,
    this.dropoffPoint,
    this.cargoPhotoUrl,
    this.companyName,
    this.dropoffPhotoUrl,
    this.driverCancelToggle,
    this.shipperCancelToggle,
  });

  factory ShipDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ShipDetailResponseModel(
      shipmentId: json['shipmentId'] as int?,
      shipmentNumber: json['shipmentNumber'] as String?,
      shipmentStatus: json['shipmentStatus'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
      shipperId: json['shipperId'] as int?,
      shipperName: json['shipperName'] as String?,
      driverId: json['driverId'] as int?,
      driverName: json['driverName'] as String?,
      currentDriverPoint: json['currentDriverPoint'] != null 
          ? PointModel.fromJson(json['currentDriverPoint']) 
          : null,
      distanceToDestination: _parseDouble(json['distanceToDestination']),
      estimatedArrivalTime: _parseDateTime(json['estimatedArrivalTime']),
      pickupAddress: json['pickupAddress'] as String?,
      waypoint1Address: json['waypoint1Address'] as String?,
      waypoint2Address: json['waypoint2Address'] as String?,
      dropoffAddress: json['dropoffAddress'] as String?,
      pickupDesiredAt: _parseDateTime(json['pickupDesiredAt']),
      dropoffDesiredAt: _parseDateTime(json['dropoffDesiredAt']),
      cargoType: json['cargoType'] as String?,
      cargoVolume: json['cargoVolume'] as String?,
      cargoWeight: _parseDouble(json['cargoWeight']),
      vehicleType: json['vehicleType'] as String?,
      description: json['description'] as String?,
      price: json['price'] as int?,
      platformFee: json['platformFee'] as int?,
      profit: json['profit'] as int?,
      pickupPoint: json['pickupPoint'] != null 
          ? PointModel.fromJson(json['pickupPoint']) 
          : null,
      dropoffPoint: json['dropoffPoint'] != null 
          ? PointModel.fromJson(json['dropoffPoint']) 
          : null,
      cargoPhotoUrl: json['cargoPhotoUrl'] as String?,
      companyName: json['companyName'] as String?,
      dropoffPhotoUrl: json['dropoffPhotoUrl'] as String?,
      driverCancelToggle: json['driverCancelToggle'] as bool?,
      shipperCancelToggle: json['shipperCancelToggle'] as bool?,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

// 좌표(x, y) 처리를 위한 모델
class PointModel {
  final double? x;
  final double? y;

  PointModel({this.x, this.y});

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      x: ShipDetailResponseModel._parseDouble(json['x']),
      y: ShipDetailResponseModel._parseDouble(json['y']),
    );
  }
}
