class LocationPoint {
  final double lat;
  final double lng;
  final String at;

  LocationPoint({required this.lat, required this.lng, required this.at});

  // Map으로 변환 (jsonEncode를 위해 필요)
  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng, 'at': at};

  // 필요시 JSON에서 객체로 생성
  factory LocationPoint.fromJson(Map<String, dynamic> json) {
    return LocationPoint(lat: json['lat'], lng: json['lng'], at: json['at']);
  }
}
