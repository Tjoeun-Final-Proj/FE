import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token_model.dart';

// kisweb 쓰는 이유, 인증 토큰을 웹에서는 flutter_secure_storage가 지원되지 않기 때문에
// flutter_secure_storage 쓰는 이유 보안상의 이유
class TokenService extends GetxService {
  final _storage = const FlutterSecureStorage();
  
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // 토큰 저장 하는 컨트롤러입니다.
  Future<void> saveToken(String accessToken, String refreshToken) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);
    } else {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  // 토큰 불러오는 함수에요
  Future<Token?> loadToken() async {
    String? accessToken;
    String? refreshToken;

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString(_accessTokenKey);
      refreshToken = prefs.getString(_refreshTokenKey);
    } else {
      accessToken = await _storage.read(key: _accessTokenKey);
      refreshToken = await _storage.read(key: _refreshTokenKey);
    }

    // 💡 여기서 값을 확인하고 Token 객체를 반환해야 함!
    if (accessToken != null && accessToken.isNotEmpty) {
      print("✅ [TokenService] 토큰 로드 성공!");
      return Token(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
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
    } else {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
    }
  }

  // ✅ 401 발생 시 토큰 갱신
  Future<bool> refreshToken() async {
    Token? token = await loadToken();
    if (token == null) return false;
      return false;
    }
  }
