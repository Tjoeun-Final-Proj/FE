import 'package:boxmon/map/model/geocoding_repository.dart';
import 'package:boxmon/map/model/naver_address_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';


class MapViewModel extends GetxController {
  final GeocodingRepository _repository;
  
  // late 키워드로 선언 (onMapReady에서 초기화)
  late NaverMapController _mapController;

  // Rx 변수: GetX의 반응형 상태 관리
  var currentAddress = "".obs;
  var isLoading = false.obs;
  var selectedLatLng = Rxn<NLatLng>();

  var currentBuildingName = "".obs; // 건물명 추가

  MapViewModel(this._repository);

  // 지도가 준비되었을 때 컨트롤러 주입
  void onMapReady(NaverMapController controller) {
    _mapController = controller;
    print("✅ 네이버 맵 컨트롤러가 준비되었습니다.");
  }

  // 마커 업데이트 (기존 마커 제거 후 새로 생성)
  void _updateMarker(NLatLng latLng) {
    _mapController.clearOverlays();
    final marker = NMarker(id: 'selected_loc', position: latLng);
    _mapController.addOverlay(marker);
    print("📌 지도에 마커가 표시되었습니다.");
  }

// MapViewModel 내의 주소 변환 로직 예시
Future<void> handleMapTap(NLatLng latLng, {String? buildingName}) async {
  try {
    isLoading.value = true;
    _updateMarker(latLng);

    final result = await _fetchAddress(latLng.latitude, latLng.longitude);
    String finalAddr = result?.fullAddress ?? ""; 

    if (finalAddr.isNotEmpty) {
      // 최종 결과 업데이트
      currentAddress.value = finalAddr;
      
      // 🔥 [로그 투척 3] 뷰에 뿌려지기 직전의 최종 문자열
      print("🚀 [Final Update] 화면에 뜰 주소: ${currentAddress.value}");
      print("📍 [Coordinates] 위도: ${latLng.latitude}, 경도: ${latLng.longitude}");
    }
  } catch (e) {
    print("❓ [Unexpected Error] $e");
  } finally {
    isLoading.value = false;
  }
}
  // API 호출 내부 메서드
  Future<NaverAddressModel?> _fetchAddress(double lat, double lng) async {
  isLoading.value = true;
  
  // .env에서 키 가져오기 (비어있는지 확인용 로그 포함)
  final String clientId = dotenv.env['X-NCP-APIGW-API-KEY-ID'] ?? "";
  final String clientSecret = dotenv.env['X-NCP-APIGW-API-KEY'] ?? "";

  print("🔑 [Key Check] ID: ${clientId.isEmpty ? 'Empty' : 'OK'}, Secret: ${clientSecret.isEmpty ? 'Empty' : 'OK'}");
  
  print("🚀 [API 요청 시작] --------------------------");
  print("🔗 URL: https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc");
  
  try {
    // 1. 요청 시점에 헤더와 파라미터를 명시적으로 전달
    final response = await _repository.fetchAddressWithKeys(
      lat: lat, 
      lng: lng, 
      id: clientId, 
      secret: clientSecret
    );
// 🔥 [로그 투척 1] 네이버가 준 전체 가공 데이터 확인
    print("진짜 데이터 ${response.buidlingName}");
    print("------------------------------------------");
    print("📊 [Naver API Raw Result] 가공된 주소: ${response.fullAddress}");
    print("------------------------------------------");

    return response;
  } on DioException catch (e) {
  print("❌ [Dio 에러 상세 발생] --------------------------");
  print("🚩 상태 코드: ${e.response?.statusCode}");
  print("🔍 서버 응답 데이터: ${e.response?.data}"); 
  
  // 3개 파람값(coords, sourcecrs, output) 확인 로그 추가
  print("📋 보낸 파라미터(Params): ${e.requestOptions.queryParameters}");
  
  print("📝 보낸 헤더(Headers): ${e.requestOptions.headers}");
  print("🔗 전체 요청 URL: ${e.requestOptions.uri}"); // 실제 완성된 전체 URL 확인
  print("------------------------------------------");
} catch (e) {
    print("❓ [알 수 없는 에러]: $e");
  } finally {
    isLoading.value = false;
    print("🏁 [API 요청 종료] --------------------------");
  }
  return null;
}

}
