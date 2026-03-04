import 'dart:async';

import 'package:boxmon/map/model/location_log_request.dart';
import 'package:boxmon/map/model/location_point.dart';
import 'package:boxmon/map/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationTrackingController extends GetxController {
  final LocationService _locationService = LocationService();
  
  // 1. 관찰 가능한 상태 변수들
  var isTracking = false.obs;
  var locationBuffer = <LocationPoint>[].obs; // 현재 쌓인 좌표 리스트
  var isLoading = false.obs;

  Timer? _timer;
  int? _currentShipmentId;

  // 2. 운행 시작 시 호출 (외부에서 shipmentId를 넘겨줌)
  void startTracking(int shipmentId) async {
    if (isTracking.value) return; // 이미 돌고 있으면 중복 실행 방지

    _currentShipmentId = shipmentId;
    isTracking.value = true;

    // 🎯 30초마다 주기적으로 실행되는 타이머 시작
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _collectCurrentLocation();
    });
    
    print("🚀 위치 추적 시작 (Shipment ID: $shipmentId)");
  }

  // 3. 실시간 좌표 수집 로직
  Future<void> _collectCurrentLocation() async {
    try {
      // 현재 위치 가져오기 (정확도는 Medium으로 설정하여 배터리 절약)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // 모델 객체 생성
      final newPoint = LocationPoint(
        lat: position.latitude,
        lng: position.longitude,
        at: DateTime.now().toIso8601String(),
      );

      // 버퍼(리스트)에 추가
      locationBuffer.add(newPoint);
      print("📍 좌표 추가됨: ${locationBuffer.length}/10");

      // 🎯 10개가 쌓였는지 체크하여 서버 전송
      if (locationBuffer.length >= 10) {
        await _dispatchLocationLogs();
      }
    } catch (e) {
      print("🚨 좌표 수집 실패: $e");
    }
  }

  // 서버로 데이터 묶음 전송 (로그 강화 버전)
  Future<void> _dispatchLocationLogs() async {
    if (_currentShipmentId == null || locationBuffer.isEmpty) return;

    // 1. 현재 전송할 데이터 스냅샷 찍기
    final int sendCount = locationBuffer.length;
    final request = LocationLogRequest(
      shipmentId: _currentShipmentId!,
      points: List.from(locationBuffer), 
    );

    print("📤 [API 전송 시도] ShipmentID: $_currentShipmentId | 데이터 개수: $sendCount개");
    print("📦 [Payload] ${request.toServerPayload()['locationChunk']}"); // 서버로 가는 실제 문자열 확인

    isLoading.value = true;
    
    // 2. 서비스 호출 및 결과 대기
    bool success = await _locationService.sendLocationLog(request);
    
    isLoading.value = false;

    if (success) {
      // ✅ 성공 로그
      print("✅ [API 전송 성공] 서버에 $sendCount개의 좌표가 정상 등록되었습니다.");
      locationBuffer.clear(); 
    } else {
      // ❌ 실패 로그
      print("      🚨 [API 전송 실패] 서버 응답 오류. 다음 주기에 재시도합니다. (현재 버퍼: ${locationBuffer.length}개)");
    }
  }

  // 5. 운행 종료 시 중지
  void stopTracking() {
    _timer?.cancel();
    isTracking.value = false;
    locationBuffer.clear();
    print("🛑 위치 추적 중지");
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}