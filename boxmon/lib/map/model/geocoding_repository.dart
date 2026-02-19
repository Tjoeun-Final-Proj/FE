import "../model/naver_address_model.dart";

abstract class GeocodingRepository {
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