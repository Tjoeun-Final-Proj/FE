import 'package:boxmon/map/model/location_point.dart';

class LocationRouteResponse {
  final int shipmentId;
  final int pointCount;
  final bool truncated;
  final List<LocationPoint> points;

  LocationRouteResponse({
    required this.shipmentId,
    required this.pointCount,
    required this.truncated,
    required this.points,
  });

  factory LocationRouteResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawPoints = (json['points'] as List<dynamic>?) ?? [];

    return LocationRouteResponse(
      shipmentId: _toInt(json['shipmentId']) ?? 0,
      pointCount: _toInt(json['pointCount']) ?? rawPoints.length,
      truncated: json['truncated'] == true,
      points: rawPoints
          .where((e) => e is Map)
          .map((e) => LocationPoint.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
