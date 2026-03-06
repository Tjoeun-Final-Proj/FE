import 'dart:async';

import 'package:boxmon/map/model/location_log_request.dart';
import 'package:boxmon/map/model/location_point.dart';
import 'package:boxmon/map/services/location_service.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart'; // 🎯 추가
import 'package:get/get.dart';

class OwnerHomeController extends GetxController {
  late NaverMapController mapController;
  final LocationService _locationService = LocationService();
  final List<LocationPoint> _locationBuffer = [];
  final int _targetShipmentId = 7;

  // 위치 구독을 위한 스트림 변수
  StreamSubscription<Position>? _positionStream;

  @override
  void onInit() {
    super.onInit();
    print("🛠️ 컨트롤러 시작됨. 위치 수집 테스트 시작...");

    // 1. 일단 현재 위치 한 번 찍어보기 (성공 확인용)
    _testCurrentLocation();

    // 🎯 2. [이게 빠졌습니다!] 실시간 수집 엔진 가동
    _startRealtimeLocationTracking();

    print("🛰️ 실시간 수집 엔진 가동 명령 전달 완료!");
  }

  Future<void> _testCurrentLocation() async {
    try {
      // 🎯 여기서 '직접' 현재 위치를 한 번 가져와봅니다.
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
        "📍 [TEST SUCCESS] 현재 좌표: ${position.latitude}, ${position.longitude}",
      );
    } catch (e) {
      print("❌ [TEST FAILED] 위치를 가져올 수 없음: $e");
      // 여기서 'Location services are disabled'가 뜨면 에뮬레이터 GPS 설정이 꺼진 것
    }
  }

  // 1. GPS 엔진 시작
  Future<void> _startRealtimeLocationTracking() async {
    // 권한 체크는 필수
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 🎯 여기서 '계속' 좌표를 뽑아냅니다.
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high, // 고정밀도
            distanceFilter: 0, // 10미터 이동할 때마다 호출
          ),
        ).listen((Position position) {
          // 🎯 지도가 아니라 GPS 하드웨어에서 직접 좌표를 받아옴
          handleLocationUpdate(position.latitude, position.longitude);
        });
  }

  void onMapReady(NaverMapController controller) async {
    mapController = controller;
    print("🛠️ [Controller] 지도 준비 완료");
    mapController.setLocationTrackingMode(NLocationTrackingMode.follow);
    mapController.getLocationOverlay().setIsVisible(true);
  }

  void handleLocationUpdate(double lat, double lng) async {
    final newPoint = LocationPoint(
      lat: lat,
      lng: lng,
      at: DateTime.now().toIso8601String(),
    );

    _locationBuffer.add(newPoint);

    // 🎯 로그 1: 현재 버퍼 상태 실시간 감시
    print("🚩 [수집 중] 버퍼 크기: ${_locationBuffer.length}/10 | 좌표: $lat, $lng");

    // 10개가 쌓였을 때만 전송 로직이 실행됩니다.
    if (_locationBuffer.length >= 10) {
      print("🚀 [전송 시도] 10개 쌓임! 이제 서비스를 호출합니다.");

      // 🎯 로그 2: shipmentId가 제대로 있는지 확인 (이게 null이면 서버에서 에러남)
      print("🆔 ShipmentID 확인: $_targetShipmentId");

      try {
        final request = LocationLogRequest(
          shipmentId: _targetShipmentId,
          points: List.from(_locationBuffer),
        );

        // 🎯 로그 3: 실제 서비스 함수 호출 직전
        print("📡 [Service 호출] sendLocationLog로 데이터 전달 중...");

        bool success = await _locationService.sendLocationLog(request);

        if (success) {
          _locationBuffer.clear();
          print("✅ [완료] 서버가 잘 받았다고 함. 버퍼 비움.");
        } else {
          print("❌ [실패] 서버는 연결됐으나 응답이 에러임 (서비스 내부 로그 확인)");
        }
      } catch (e) {
        print("🚨 [에러] 서비스 호출 중 예외 발생: $e");
      }
    }
  }

  Future<void> _sendBatchToServer() async {
    print("🚀 [Service] 10개 쌓임! 서버 전송 시도");
    final request = LocationLogRequest(
      shipmentId: _targetShipmentId,
      points: List.from(_locationBuffer),
    );

    bool success = await _locationService.sendLocationLog(request);
    if (success) {
      _locationBuffer.clear();
      print("✅ [Service] 전송 성공 및 버퍼 초기화");
    }
  }

  @override
  void onClose() {
    // 🎯 컨트롤러 꺼질 때 GPS 구독 해제 (배터리 절약)
    _positionStream?.cancel();
    super.onClose();
  }
}
