import 'dart:io';

import 'package:boxmon/common/model/shipment_model.dart';
import 'package:boxmon/common/services/shipment_service.dart';
import 'package:boxmon/map/model/geocoding_repository.dart';
import 'package:boxmon/map/model/naver_address_model.dart';
import 'package:boxmon/map/model/search_result._model.dart';
import 'package:boxmon/map/services/map_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// 설문 순서: 1. 지도 준비 -> 2. 현재 위치로 찾기 -> 3. 검색어 입력 -> 4. 장소 선택 -> 5. 지도에 마커 표시 및 주소 변환
enum AddressType { start, end, stopover1, stopover2 }
enum TempType { none, frozen, refrigerated } // 타입을 명확히 정의 (안함, 냉동, 냉장)
enum VehicleType {
  BULK("벌크"),
  VAN("밴"),
  DUMP("덤프 트럭"),
  TANKER("탱크로리"),
  CARGO("1톤 카고"),
  WINGBODY("윙바디");

  // UI에 보여줄 한글 이름을 함께 정의
  final String krName;
  const VehicleType(this.krName);
}

var selectedVehicleType = VehicleType.CARGO.obs; // 초기값

class MapViewModel extends GetxController {
  final MapService _mapService;
  final ShipmentService _shipmentService = Get.find<ShipmentService>();
  // 상세주소 입력용
  final detailAddressController = TextEditingController();

  final GeocodingRepository _repository;
  final RxList<SearchResult> searchResults = <SearchResult>[].obs;

  // 요금 입력
  final priceController = TextEditingController(); // 요금 입력 컨트롤러

  
  MapViewModel(this._mapService, this._repository);
  // late 키워드로 선언 (onMapReady에서 초기화)
  NaverMapController? _mapController;

  // Rx 변수: GetX의 반응형 상태 관리
  var currentAddress = "".obs;
  var isLoading = false.obs;
  var selectedLatLng = Rxn<NLatLng>();
  var isSearching = false.obs; // 검색 관리 여부
  var currentBuildingName = "".obs; // 건물명 추가

  // 설문 순서
  var currentStep = 0.obs; // PageView의 현재 인덱스
  var activeType = AddressType.start.obs; // 현재 입력 중인 대상

  // 현재위치로 바꿀 계획입니다.
  var targetLocation = const NLatLng(37.5540455, 126.9708338).obs;

  // 연락처
  var startContact = "".obs;
  var stopover1Contact = "".obs;
  var stopover2Contact = "".obs;
  var endContact = "".obs;

  // final TextEditingController searchController = TextEditingController(); // 검색어 기반으로 넘김

  // 엘레베이터 토글
  var hasElevator = true.obs;

  // 온도 타입 선택 (냉동/냉장/없음)
  var selectedTempType = TempType.none.obs;

  // 설문 단계입니다.
  var startFullAddress = "".obs;
  var endFullAddress = "".obs;
  var stopover1Address = "".obs;
  var stopover2Address = "".obs;
  
  final ImagePicker _picker = ImagePicker();
var selectedCargoImage = Rxn<File>(); // 🔥 딱 1장만 담을 수 있는 변수 (Rxn은 null 허용)

  // 교통수단 선택입니다.
  var selectedVehicle = "1톤 카고".obs;
  var selectedVehicleDesc = "적재함이 개방된 형태의 트럭이에요.".obs;

  // 달력
  var pickupDateTime = "".obs;
  var deliveryDateTime = "".obs;
  var formatDateTime = (DateTime date, TimeOfDay time) {
    // 날짜와 시간을 포맷팅하여 문자열로 반환
    return "${date.year}년 ${date.month}월 ${date.day}일 ${time.hour}시 ${time.minute}분";
  };
  // --- [추가] 화물 규격 및 중량 입력용 컨트롤러 ---
  final weightController = TextEditingController(); // 중량


// 1. 관찰 가능한 Enum 변수 추가 (클래스 상단 변수 선언부)
var selectedVehicleType = VehicleType.CARGO.obs; 

// 2. 교통수단 선택 함수 수정 (인자에 VehicleType 추가)
void updateVehicle(VehicleType type, String title, String desc) {
  // 서버 전송을 위한 Enum 값 저장 (DUMP, TANKER 등)
  selectedVehicleType.value = type;
  
  // UI 표시를 위한 한글 이름과 설명 저장
  selectedVehicle.value = title;
  selectedVehicleDesc.value = desc;
  
  print("🚚 차량 선택 완료: ${type.name} ($title)");
}
// 기존 formatDateTime 변수를 아래와 같이 실제 객체를 저장하는 방식으로 병행하면 좋습니다.
var pickupDateRaw = Rxn<DateTime>();
var deliveryDateRaw = Rxn<DateTime>();

// 날짜 선택 시 호출되는 로직 보완 (View에서 호출 시)
void updatePickupDateTime(DateTime date, TimeOfDay time) {
  final now = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  pickupDateRaw.value = now;
  pickupDateTime.value = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00";
}

  // MapViewModel 클래스 상단에 추가
  var startLat = 0.0.obs;
  var startLng = 0.0.obs;
  var endLat = 0.0.obs;
  var endLng = 0.0.obs;
  var stop1Lat = 0.0.obs;
  var stop1Lng = 0.0.obs;
  var stop2Lat = 0.0.obs;
  var stop2Lng = 0.0.obs;

  // 화물 상세 요청사항 입력
  var cargoDescription = "".obs;    // 상세 요청사항 텍스트
  // --- [추가] 화물 정보를 담을 그릇들 ---
  final companyNameController = TextEditingController(); // 회사 이름
  final widthController = TextEditingController();       // 가로
  final lengthController = TextEditingController();      // 세로
  final heightController = TextEditingController();      // 높이
  
  // 갤러리에서 사진 딱 1장만 선택하기
Future<void> pickSingleCargoImage() async {
  // pickMultiImage 대신 pickImage 사용
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    selectedCargoImage.value = File(image.path); // 선택한 사진 저장
  }
}
Future<void> submitShipmentRequest() async {
    try {
      isLoading.value = true;
      print("🎮 [Controller] 배송 생성 프로세스 시작...");

      // 1. 화면에 따로따로 입력된 [가로], [세로], [높이]를 "1개의 문장"으로 묶어줍니다.
      String combinedDescription = "${widthController.text}x${lengthController.text}x${heightController.text} cm";
      
      // 상세 요청사항 적은 게 있다면 뒤에 붙여줍니다.
      if (cargoDescription.value.isNotEmpty) {
        combinedDescription += " / 요청사항: ${cargoDescription.value}";
      }

      // 2. 서버로 보낼 'ShipmentModel' 상자에 지금까지 모은 데이터를 다 담습니다.
      final requestModel = ShipmentModel(
        pickupAddress: startFullAddress.value, // 출발지
        dropoffAddress: endFullAddress.value,  // 도착지
        cargoWeight: double.tryParse(weightController.text) ?? 0.0, // 중량
        description: combinedDescription, // 🔥 위에서 하나로 묶은 글자가 여기에 들어갑니다!
        vehicleType: selectedVehicleType.value.name, // 차량 종류
        // (필요하다면 pickupPoint, price 등의 나머지 값도 여기에 똑같이 넣어주시면 됩니다)
      );

      // 3. 사진 파일(1장)과 모델 상자를 서비스 함수에 넘겨서 서버로 POST 전송합니다!
      // (주의: _shipmentService 부분은 덕배님이 실제로 쓰시는 서비스 객체 이름으로 맞춰주세요)
      String? shipmentId = await _shipmentService.createShipment(
        requestModel, 
        files: selectedCargoImage.value, // 선택한 사진 파일 딱 1장!
      );

      // 4. 전송 성공 / 실패에 따른 화면 이동 처리
      if (shipmentId != null) {
        print("✅ 배송 요청 성공! 발급된 ID: $shipmentId");
        
        // 결제 화면으로 이동
        Get.toNamed('/tossPayments', arguments: {
          'shipmentId': shipmentId,
          // 'amount': requestModel.price, // 요금 변수가 있다면 같이 넘겨줍니다.
        });

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar("성공", "배송 요청이 정상적으로 등록되었습니다.");
        });
      } else {
        print("❌ 배송 생성 실패 (서버에서 null 반환)");
        Get.snackbar("오류", "배송 요청에 실패했습니다. 다시 시도해주세요.", snackPosition: SnackPosition.BOTTOM);
      }
      
    } catch (e) {
      print("🚨 [Controller] 예상치 못한 에러 발생: $e");
    } finally {
      isLoading.value = false;
    }
  }

// 사진 삭제하기
void removeImage() {
  selectedCargoImage.value = null; // null로 비워버림
}
void confirmAddressSelection(PageController pageController) {
  String finalAddr = currentAddress.value;
  if (detailAddressController.text.isNotEmpty) {
    finalAddr += " ${detailAddressController.text}";
  }

  // 핵심: 현재 targetLocation에 담긴 좌표를 타입별 변수에 할당
  switch (activeType.value) {
    case AddressType.start:
      startFullAddress.value = finalAddr;
      startLat.value = targetLocation.value.latitude;
      startLng.value = targetLocation.value.longitude;
      break;
    case AddressType.end:
      endFullAddress.value = finalAddr;
      endLat.value = targetLocation.value.latitude;
      endLng.value = targetLocation.value.longitude;
      break;
    case AddressType.stopover1:
      stopover1Address.value = finalAddr;
      stop1Lat.value = targetLocation.value.latitude;
      stop1Lng.value = targetLocation.value.longitude;
      break;
    case AddressType.stopover2:
      stopover2Address.value = finalAddr;
      stop2Lat.value = targetLocation.value.latitude;
      stop2Lng.value = targetLocation.value.longitude;
      break;
  }

  pageController.jumpToPage(0); 
  _resetSearchState(); // 기존에 만든 리셋 함수 활용
}
  
  // 지도가 준비되었을 때 컨트롤러 주입
  void onMapReady(NaverMapController controller) {
    _mapController = controller;
    print("✅ 네이버 맵 컨트롤러가 준비되었습니다.");

    // 🔥 지도가 로드되자마자 '검색했던 위치'로 카메라 이동
    _mapController?.updateCamera(
      NCameraUpdate.withParams(target: targetLocation.value, zoom: 16),
    );
  }

  // 2단계: 검색 결과 클릭 시 3단계(지도)로 이동 준비
  void selectLocation(SearchResult item) {
    targetLocation.value = NLatLng(item.lat, item.lng);
    currentAddress.value = item.address;
    currentBuildingName.value = item.title;
    
    // 지도가 떠 있다면 즉시 카메라 이동
    _mapController?.updateCamera(NCameraUpdate.withParams(
      target: targetLocation.value,
      zoom: 16,
    ));
  }

void startAddressSetup(AddressType type, PageController pageController) {
  // 1. 현재 어떤 주소를 입력할지 설정 (출발/도착/경유)
  activeType.value = type;
  
  // 2. 이전 검색 기록 및 상세주소 입력값 초기화
  searchResults.clear();
  detailAddressController.clear();
  currentAddress.value = "";
  currentBuildingName.value = "";
  
  // 3. 2단계(검색 화면)로 이동
  pageController.animateToPage(
    1, 
    duration: const Duration(milliseconds: 300), 
    curve: Curves.ease
  );
}

  // 검색 상태 리셋 함수
  void _resetSearchState() {
    searchResults.clear();
    currentAddress.value = "";
    currentBuildingName.value = "";
    detailAddressController.clear();
  }

  // 최종 5번 페이지로 가기 전 데이터 검증
  bool canRequestDispatch() {
    return startFullAddress.value.isNotEmpty && endFullAddress.value.isNotEmpty;
  }

  // 마커 업데이트 (기존 마커 제거 후 새로 생성)
  void _updateMarker(NLatLng latLng) {
    _mapController?.clearOverlays();
    final marker = NMarker(id: 'selected_loc', position: latLng);
    _mapController?.addOverlay(marker);
    print("📌 지도에 마커가 표시되었습니다.");
  }

  // 2. "현재 위치로 찾기" 버튼을 눌렀을 때
  Future<void> useCurrentLocation() async {
    isLoading.value = true;
    try {
      // Geolocator 패키지 등을 사용하여 실제 GPS 좌표를 가져옴
      // Position position = await Geolocator.getCurrentPosition();
      
      // 임시 좌표 (실제로는 position.latitude 등 사용)
      targetLocation.value = NLatLng(37.5665, 126.9780); 
      currentAddress.value = "현재 위치 근처 주소 정보...";
      currentBuildingName.value = "내 위치";
      
    } finally {
      isLoading.value = false;
    }
  }
  

// 검색어 기반으로 위치 이동 (예시용, 실제로는 API 호출 필요)
Future<void> searchLocation(String query) async {
    print("📌 [LOG 1] 검색 시작: 입력값 = '$query'");
    
    isSearching.value = true;
   try {
    final results = await _repository.fetchSearchResults(query);

    // 🔥 이 부분이 핵심: Rx 리스트를 갈아끼워줍니다.
    searchResults.assignAll(results);
    
    if (results.isEmpty) {
      Get.snackbar("알림", "검색 결과가 없습니다.");
    }
  }catch (e) {
    print("❌ API 호출 중 에러 발생: $e");
  } finally {
      isSearching.value = false;
      print("📌 [LOG 4] 검색 프로세스 종료 (로딩 바 숨김)");
    }
  }

//   // 🛠 2. 장소 선택 (데이터 확정 및 지도 준비)
//   void selectLocation(SearchResult item) {
//     print("📌 [LOG 5] 장소 선택됨: ${item.title}");
    
//     targetLocation.value = NLatLng(item.lat, item.lng);
//     currentAddress.value = item.address;
//     currentBuildingName.value = item.title;

//     print("📌 [LOG 6] 좌표 업데이트 완료: ${item.lat}, ${item.lng} -> 지도 이동 준비");

//     // 2. 만약 지도 컨트롤러가 이미 준비되어 있다면 즉시 이동
//   // (이미 3단계에 한 번이라도 들어갔던 경우를 대비)
//   print("📌 [LOG 6] 지도 카메라 즉시 이동 실행");
//   _mapController?.updateCamera(
//     NCameraUpdate.withParams(
//       target: targetLocation.value,
//       zoom: 16, // 적절한 줌 레벨
//     ),
//   );
// }

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
