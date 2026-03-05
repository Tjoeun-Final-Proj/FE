import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token_model.dart';

// kisweb 쓰는 이유, 인증 토큰을 웹에서는 flutter_secure_storage가 지원되지 않기 때문에
// flutter_secure_storage 쓰는 이유 보안상의 이유
class TokenService extends GetxService {
  final _storage = const FlutterSecureStorage();
  
  // 고정 키 이름입니다.
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userTypeKey = 'user_type';
  static const String _userIdKey = 'user_id';
  // 디바이스 토큰을 저장하는 장소
  String? _deviceToken;
  // 메모리에 들고있을 엑세스 토큰
  String? _currentAccessToken;
  String? _userType;
  int? _userId;
  String? get accessToken => _currentAccessToken;

  String? get deviceToken => _deviceToken;
  String? get userType => _userType; // << 외부내부 DRIVER / SHIPPER 비교
  int? get userId => _userId;
  // 로그인하자마자 디바이스 토큰을 가져옵니다.
  Future<TokenService> init() async {
    try {
      // 1. FCM 인스턴스에서 토큰 가져오기
      // ※ Firebase.initializeApp()이 main에서 먼저 실행되어야 합니다.
      await Future.delayed(Duration(seconds: 1));

      _deviceToken = await FirebaseMessaging.instance.getToken();
      // 2. 로그 찍기
      if (_deviceToken != null) {
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        print("📱 [Device Token] 획득 성공!");
        print("🔑 Token: $_deviceToken");
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      } else {
        print("⚠️ [Device Token] 토큰을 가져오지 못했습니다.");
      }
    } catch (e) {
      print("❌ [Device Token] 에러 발생: $e");
    }
    return this;
  }

  // 토큰 저장 하는 컨트롤러입니다.
  Future<void> saveToken(
    String accessToken,
    String refreshToken,
    String userType, {
    int? userId,
  }) async {
    _currentAccessToken = accessToken; // 🔥 추가
    _userType = userType;
    _userId = userId;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);
      await prefs.setString(_userTypeKey, userType);
      if (userId != null) {
        await prefs.setInt(_userIdKey, userId);
      } else {
        await prefs.remove(_userIdKey);
      }
    } else {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      await _storage.write(key: _userTypeKey, value: userType);
      if (userId != null) {
        await _storage.write(key: _userIdKey, value: userId.toString());
      } else {
        await _storage.delete(key: _userIdKey);
      }
    }
  }

  // 토큰 불러오는 함수에요
  Future<Token?> loadToken() async {
    String? accessToken;
    String? refreshToken;
    String? userType;
    int? userId;

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString(_accessTokenKey);
      refreshToken = prefs.getString(_refreshTokenKey);
      userType = prefs.getString(_userTypeKey);
      userId = prefs.getInt(_userIdKey);
    } else {
      accessToken = await _storage.read(key: _accessTokenKey);
      refreshToken = await _storage.read(key: _refreshTokenKey);
      userType = await _storage.read(key: _userTypeKey);
      final String? userIdRaw = await _storage.read(key: _userIdKey);
      userId = int.tryParse(userIdRaw ?? '');
    }

    // 💡 여기서 값을 확인하고 Token 객체를 반환해야 함!
    if (accessToken != null && accessToken.isNotEmpty) {
      _currentAccessToken = accessToken; // 🔥 추가
      _userType = userType; // 비교 들어갈 예정
      _userId = userId;
      print("✅ [TokenService] 토큰 로드 성공!");
      return Token(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        userType: userType ?? '',
        userId: userId,
      );
    }

    print("⚠️ [TokenService] 저장된 토큰이 없습니다.");
    return null; // 값이 없을 때만 null 반환
  }

  // 토큰 삭제 (로그아웃 시 사용할꺼에요)
  Future<void> clearToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userTypeKey);
      await prefs.remove(_userIdKey);
    } else {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userTypeKey);
      await _storage.delete(key: _userIdKey);
    }

    _currentAccessToken = null;
    _userType = null;
    _userId = null;
  }

// 미들웨어로 분리할 로드 driver 함수입니다.
    Future<bool> loadIsDriver() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTypeKey) == "DRIVER" ? true : false;
    }
    else {
      String? userType = await _storage.read(key: _userTypeKey);
      return userType == "DRIVER" ? true : false;
    }
  }

  // ✅ 401 발생 시 토큰 갱신
  Future<bool> refreshToken() async {
    _currentAccessToken = null; // 갱신 시 기존 토큰 초기화
    Token? token = await loadToken();
    if (token == null) return false;
      return false;
    }
  }
