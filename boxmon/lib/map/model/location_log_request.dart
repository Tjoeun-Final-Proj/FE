import 'dart:convert';

import 'package:boxmon/map/model/location_point.dart';

class LocationLogRequest {
  final int shipmentId;
  final List<LocationPoint> points;

  LocationLogRequest({required this.shipmentId, required this.points});

  // 🎯 핵심: 서버가 원하는 '문자열 형태의 JSON'으로 변환
  Map<String, dynamic> toServerPayload() {
    return {
      "shipmentId": shipmentId,
      // 리스트를 먼저 JSON으로 만들고, 그걸 다시 String으로 변환(Serialize)
      "locationChunk": jsonEncode(points.map((p) => p.toJson()).toList()),
    };
  }
}
