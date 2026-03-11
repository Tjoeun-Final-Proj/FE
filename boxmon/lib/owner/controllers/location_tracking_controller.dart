import 'dart:async';
import 'dart:io';

import 'package:boxmon/map/model/location_log_request.dart';
import 'package:boxmon/map/model/location_point.dart';
import 'package:boxmon/map/services/location_service.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationTrackingController extends GetxController {
  final LocationService _locationService = LocationService();
  static final Duration _collectInterval =
      kDebugMode ? const Duration(seconds: 5) : const Duration(seconds: 30);
  static final int _batchSize = kDebugMode ? 3 : 10;

  // 1. 관찰 가능한 상태 변수들
  var isTracking = false.obs;
  var locationBuffer = <LocationPoint>[].obs; // 현재 쌓인 좌표 리스트
  var isLoading = false.obs;

  StreamSubscription<Position>? _positionSubscription;
  int? _currentShipmentId;
  int _sessionId = 0;
  bool _isDispatching = false;

  int? get currentShipmentId => _currentShipmentId;

  // 2. 운행 시작 시 호출 (외부에서 shipmentId를 넘겨줌)
  Future<void> startTracking(int shipmentId) async {
    // 기존 세션이 남아있으면 먼저 종료해 중복 전송을 방지
    if (isTracking.value || _positionSubscription != null) {
      await stopTracking(flushRemaining: true);
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ [실패] [위치추적] 위치 서비스가 비활성화되어 추적을 시작할 수 없습니다.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("❌ [실패] [위치추적] 위치 권한이 없어 추적을 시작할 수 없습니다. permission=$permission");
      return;
    }

    final int newSessionId = ++_sessionId;
    _currentShipmentId = shipmentId;
    locationBuffer.clear();
    isTracking.value = true;

    // Android foreground notification을 활성화하면 화면이 꺼져도(강제종료 제외) 추적 유지 가능
    final LocationSettings locationSettings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
            intervalDuration: _collectInterval,
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: "BoxMon 위치 추적 중",
              notificationText: "운송 완료 전까지 위치를 기록합니다.",
              enableWakeLock: true,
            ),
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
          );

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) async {
      if (!isTracking.value || _currentShipmentId == null || newSessionId != _sessionId) {
        return;
      }
      await _collectCurrentLocation(position, newSessionId);
    }, onError: (e) {
      print("❌ [실패] [위치추적] 스트림 오류: $e");
    });

    print("🚀 [시작] [위치추적] 위치 추적 시작 (Shipment ID: $shipmentId, session: $newSessionId)");
  }

  // 3. 실시간 좌표 수집 로직
  Future<void> _collectCurrentLocation(Position position, int sessionId) async {
    try {
      // 모델 객체 생성
      final newPoint = LocationPoint(
        lat: position.latitude,
        lng: position.longitude,
        at: DateTime.now().toIso8601String(),
      );

      // 버퍼(리스트)에 추가
      locationBuffer.add(newPoint);
      print("📍 좌표 추가됨: ${locationBuffer.length}/$_batchSize");

      // 🎯 배치 수량이 쌓였는지 체크하여 서버 전송
      if (locationBuffer.length >= _batchSize) {
        await _dispatchLocationLogs(sessionId: sessionId);
      }
    } catch (e) {
      print("❌ [실패] [위치추적] 좌표 수집 실패: $e");
    }
  }

  // 서버로 데이터 묶음 전송 (로그 강화 버전)
  Future<void> _dispatchLocationLogs({required int sessionId, bool force = false}) async {
    if (!isTracking.value || _currentShipmentId == null || sessionId != _sessionId) return;
    if (_isDispatching) return;
    if (locationBuffer.isEmpty) return;
    if (!force && locationBuffer.length < _batchSize) return;

    // 1. 현재 전송할 데이터 스냅샷 찍기
    _isDispatching = true;
    final int sendCount = locationBuffer.length;
    final request = LocationLogRequest(
      shipmentId: _currentShipmentId!,
      points: List.from(locationBuffer),
    );

    print(
      "📤 [API 전송 시도] ShipmentID: $_currentShipmentId | 데이터 개수: $sendCount개",
    );
    print(
      "📦 [Payload] ${request.toServerPayload()['locationChunk']}",
    ); // 서버로 가는 실제 문자열 확인

    isLoading.value = true;

    // 2. 서비스 호출 및 결과 대기
    bool success = await _locationService.sendLocationLog(request);

    isLoading.value = false;

    if (success) {
      // ✅ 성공 로그
      print("✅ [API 전송 성공] 서버에 $sendCount개의 좌표가 정상 등록되었습니다.");
      if (sessionId == _sessionId) {
        locationBuffer.clear();
      }
    } else {
      // ❌ 실패 로그
      print(
        "      🚨 [API 전송 실패] 서버 응답 오류. 다음 주기에 재시도합니다. (현재 버퍼: ${locationBuffer.length}개)",
      );
    }
    _isDispatching = false;
  }

  // 5. 운행 종료 시 중지
  Future<void> stopTracking({bool flushRemaining = true}) async {
    final int stoppingSessionId = _sessionId;

    await _positionSubscription?.cancel();
    _positionSubscription = null;

    if (flushRemaining &&
        _currentShipmentId != null &&
        locationBuffer.isNotEmpty &&
        stoppingSessionId == _sessionId) {
      await _dispatchLocationLogs(sessionId: stoppingSessionId, force: true);
    }

    _sessionId++;
    isTracking.value = false;
    _isDispatching = false;
    _currentShipmentId = null;
    locationBuffer.clear();
    print("🛑 [성공] [위치추적] 위치 추적 중지");
  }

  @override
  void onClose() {
    _positionSubscription?.cancel();
    super.onClose();
  }
}
