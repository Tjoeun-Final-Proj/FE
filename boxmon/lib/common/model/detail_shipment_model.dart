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
  });

  factory ShipDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return ShipDetailResponseModel(
      shipmentId: json['shipmentId'] as int?,
      shipmentNumber: json['shipmentNumber'] as String?,
      shipmentStatus: json['shipmentStatus'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      shipperId: json['shipperId'] as int?,
      shipperName: json['shipperName'] as String?,
      driverId: json['driverId'] as int?,
      driverName: json['driverName'] as String?,
      currentDriverPoint: json['currentDriverPoint'] != null 
          ? PointModel.fromJson(json['currentDriverPoint']) 
          : null,
      distanceToDestination: json['distanceToDestination']?.toDouble(),
      estimatedArrivalTime: json['estimatedArrivalTime'] != null 
          ? DateTime.parse(json['estimatedArrivalTime']) 
          : null,
      pickupAddress: json['pickupAddress'] as String?,
      waypoint1Address: json['waypoint1Address'] as String?,
      waypoint2Address: json['waypoint2Address'] as String?,
      dropoffAddress: json['dropoffAddress'] as String?,
      pickupDesiredAt: json['pickupDesiredAt'] != null 
          ? DateTime.parse(json['pickupDesiredAt']) 
          : null,
      dropoffDesiredAt: json['dropoffDesiredAt'] != null 
          ? DateTime.parse(json['dropoffDesiredAt']) 
          : null,
      cargoType: json['cargoType'] as String?,
      cargoVolume: json['cargoVolume'] as String?,
      cargoWeight: json['cargoWeight']?.toDouble(),
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
    );
  }
}

// 좌표(x, y) 처리를 위한 모델
class PointModel {
  final double? x;
  final double? y;

  PointModel({this.x, this.y});

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      x: json['x']?.toDouble(),
      y: json['y']?.toDouble(),
    );
  }
}