class NaverAddressModel {
  final String fullAddress;
  final String buidlingName;

  NaverAddressModel({required this.fullAddress,
  required this.buidlingName});

  factory NaverAddressModel.fromJson(Map<String, dynamic> json) {
    try {
      final results = json['results'] as List?;
      if (results == null || results.isEmpty) {
        return NaverAddressModel(fullAddress: "주소 정보 없음", buidlingName: "");
      }

      // 1. 상세 주소 데이터(addr 또는 roadaddr)를 우선 탐색
      final addrData = results.firstWhere(
      (res) => res['land'] != null && 
               res['land']['addition0'] != null && 
               res['land']['addition0']['value'].toString().isNotEmpty,
      // 건물명 있는 데이터가 없으면 그때 일반 주소를 찾습니다.
      orElse: () => results.firstWhere(
        (res) => res['name'] == 'roadaddr' || res['name'] == 'addr',
        orElse: () => results[0],
      ),
    );

      final region = addrData['region'] ?? {};
      final land = addrData['land']; // 상세 번지 정보

      // 2. 지역 정보 조합 (시/도 + 구/군 + 동/면)
      String area1 = region['area1']?['name'] ?? "";
      String area2 = region['area2']?['name'] ?? "";
      String area3 = region['area3']?['name'] ?? "";
      
      String baseAddr = "$area1 $area2 $area3".trim();

      // 3. 상세 번지 조합 (number1-number2)
      String detailAddr = "";
      if (land != null) {
        String n1 = land['number1'] ?? "";
        String n2 = land['number2'] ?? "";
        detailAddr = n1 + (n2.isNotEmpty ? "-$n2" : "");
      }

      // 4. 건물명 조합 (addition0의 value가 있을 때만)
     String pureBuildingName = "";
      if (land?['addition0'] != null && 
          land['addition0']['value'] != null && 
          land['addition0']['value'].toString().isNotEmpty) {
        pureBuildingName = land['addition0']['value'].toString();
      }

      // 5. 최종 조합 주소 생성
      String formattedBuilding = pureBuildingName.isNotEmpty ? " ($pureBuildingName)" : "";
      String finalFullAddress = "$baseAddr $detailAddr$formattedBuilding".trim();

      return NaverAddressModel(
        fullAddress: finalFullAddress.isNotEmpty ? finalFullAddress : "상세 주소 없음",
        buidlingName: pureBuildingName,
      );
    } catch (e) {
      return NaverAddressModel(fullAddress: "주소 해석 오류", buidlingName: "");
    }
  }
}