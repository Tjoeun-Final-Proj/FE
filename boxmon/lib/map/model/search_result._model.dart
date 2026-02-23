class SearchResult {
  final String title;
  final String address;
  final double lat;
  final double lng;

  SearchResult({
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    // 📌 안전하게 값을 가져오기 위해 null 체크를 포함합니다.
    final roadAddr = json['roadAddress'] ?? "";
    final jibunAddr = json['jibunAddress'] ?? "";
    
    return SearchResult(
      // 제목으로 쓸만한 값이 없으므로 도로명 주소의 뒷부분이나 전체 주소를 씁니다.
      title: roadAddr.isNotEmpty ? roadAddr : jibunAddr, 
      address: roadAddr,
      // 네이버 Geocode API에서 x는 경도, y는 위도이며 String으로 오므로 파싱이 필요합니다.
      lat: double.parse(json['y'] ?? "0.0"),
      lng: double.parse(json['x'] ?? "0.0"),
    );
  }
}