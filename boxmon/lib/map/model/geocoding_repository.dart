import "package:boxmon/map/model/search_result._model.dart";
import "package:boxmon/map/services/map_service.dart";

import "../model/naver_address_model.dart";

abstract class GeocodingRepository {
  final MapService _mapService;

  GeocodingRepository(this._mapService);

  // 🔥 이 함수가 정의되어 있어야 합니다!
  Future<List<SearchResult>> fetchSearchResults(String query) async {
  try {
    final data = await _mapService.fetchPlaceSearch(query);
    
    if (data['status'] == 'OK' && data['addresses'] != null) {
      final List items = data['addresses'];
      return items.map((json) => SearchResult.fromJson(json)).toList();
    }
    return [];
  } catch (e) {
    // 📌 여기서 에러가 나면 모델 파싱 문제일 확률이 높습니다.
    print("❌ Repository 파싱 에러: $e");
    return [];
  }
}
  
  // 1. ViewModel에서 호출할 메서드의 규격을 정의합니다. (설계도)
  Future<NaverAddressModel> fetchAddressWithKeys({
    required double lat,
    required double lng,
    required String id,
    required String secret,
  });

  // 2. 기존에 사용하던 일반 호출 메서드 (필요시 유지)
  Future<NaverAddressModel> fetchAddress(double lat, double lng);

  
}