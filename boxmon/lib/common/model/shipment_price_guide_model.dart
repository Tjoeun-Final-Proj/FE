class ShipmentPriceGuidePoint {
  final double x; // lng
  final double y; // lat

  const ShipmentPriceGuidePoint({
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
      };
}

class ShipmentPriceGuideRequest {
  final ShipmentPriceGuidePoint pickupPoint;
  final ShipmentPriceGuidePoint dropoffPoint;
  final ShipmentPriceGuidePoint? waypoint1Point;
  final ShipmentPriceGuidePoint? waypoint2Point;

  const ShipmentPriceGuideRequest({
    required this.pickupPoint,
    required this.dropoffPoint,
    this.waypoint1Point,
    this.waypoint2Point,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'pickupPoint': pickupPoint.toJson(),
      'dropoffPoint': dropoffPoint.toJson(),
    };
    if (waypoint1Point != null) {
      map['waypoint1Point'] = waypoint1Point!.toJson();
    }
    if (waypoint2Point != null) {
      map['waypoint2Point'] = waypoint2Point!.toJson();
    }
    return map;
  }
}

class ShipmentPriceGuideResponse {
  final double estimatedDistanceKm;
  final int recommendedPrice;

  const ShipmentPriceGuideResponse({
    required this.estimatedDistanceKm,
    required this.recommendedPrice,
  });

  factory ShipmentPriceGuideResponse.fromJson(Map<String, dynamic> json) {
    return ShipmentPriceGuideResponse(
      estimatedDistanceKm:
          (json['estimatedDistanceKm'] as num?)?.toDouble() ?? 0.0,
      recommendedPrice: (json['recommendedPrice'] as num?)?.toInt() ?? 0,
    );
  }
}
