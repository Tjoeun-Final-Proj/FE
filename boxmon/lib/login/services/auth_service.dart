import 'package:boxmon/login/models/driver_signup_request.dart';
import 'package:boxmon/login/models/signup_request.dart';
import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class AuthService extends GetxService {
  // final TokenService tokenController = TokenService();
  String? accessToken;
  String? refreshToken;
  late Token token;
  final dio.Dio _dio =
      Get.find<dio.Dio>(); // Base URL이 http://10.0.2.2:8080/api 로 설정된채로 가져와짐
  final TokenService _tokenService = Get.find<TokenService>();

  /// =================================================
  /// 이메일 기반 회원가입 처리
  /// - 성공 시 accessToken 포함 CommonModel 반환
  /// =================================================
  // lib/login/services/auth_service.dart
  // 화주 회원가입
  Future<bool> signupEmail(SignupRequest request) async {
    try {
      final response = await _dio.post(
        'user/shipperSignup',
        data: request.toJson(),
      );

      // 로그 확인용
      print("📥 서버 응답 바디: ${response.data}");

      // 상태 코드가 200~299 사이면 성공으로 간주
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ Dio 에러: ${e.response?.data}");
      return false;
    } catch (e) {
      print("❌ 일반 에러: $e");
      return false;
    }
  }

  // 차주 회원가입
  Future<bool> driverSignupEmail(DriverSignupRequest request) async {
    try {
      final response = await _dio.post(
        'user/driverSignup',
        data: request.toJson(),
      );

      // 로그 확인용
      print("📥 서버 응답 바디: ${response.data}");

      // 상태 코드가 200~299 사이면 성공으로 간주
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      print("❌ Dio 에러: ${e.response?.data}");
      return false;
    } catch (e) {
      print("❌ 일반 에러: $e");
      return false;
    }
  }

  // 화주/차주 로그인하는 함수
  Future<bool> userlogin(String email, String password) async {
    try {
      final response = await _dio.post(
        'user/login',
        data: {
          'email': email,
          'password': password,
          'deviceToken': _tokenService.deviceToken,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ [Login Success]: ${response.data}');

        // 1. 서버 응답 데이터에서 토큰 추출 (서버 응답 구조에 맞게 수정하세요!)
        // 만약 { "accessToken": "...", "refreshToken": "..." } 구조라면:
        final String accessToken = response.data['accessToken'] ?? '';
        final String refreshToken = response.data['refreshToken'] ?? '';
        final String userType = response.data['userType'] ?? '';
        final int? userId = response.data['userId'] is int
            ? response.data['userId'] as int
            : int.tryParse('${response.data['userId'] ?? ''}');
        final String? userName = response.data['name']?.toString();

        // 2. TokenService를 사용해 기기에 저장 (반드시 await!)
        await _tokenService.saveToken(
          accessToken,
          refreshToken,
          userType,
          userId: userId,
          userName: userName,
        );

        return true;
      } else {
        print('⚠️ [Login Failed]: Status Code ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if (e is dio.DioException) {
        print('❌ [Network Error]: ${e.message}');
      } else {
        print('❌ [Unknown Error]: $e');
      }
      return false;
    }
  }
}
  // void logout() {
  //   TokenService.clearToken();
  // }

// 미들웨어로 쓸 예정이에요 26.02.05
  // Future<bool> commonRegistration(String id, String pw, String name, String nickname, String number, String gender) async {
  //   final lambdaResponse = await http.post(
  //     Uri.parse(
  //         'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp'),
  //     body: jsonEncode({
  //       "id": id,
  //       "pw": pw,
  //       "name": name,
  //       "nickname": nickname,
  //       "number": number,
  //       "gender": gender,
  //       "is_owner": "0"
  //     }),
  //     headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //   );
  //   var responseData = jsonDecode(lambdaResponse.body);
  //   final LambdaResponse response = LambdaResponse.fromJson(responseData);
  //   try{
  //     if(response.statusCode == 200){
  //       return true;
  //     }
  //     else{
  //       return false;
  //     }
  //   } catch (e){
  //     print("JSON Parsing Error: $e");
  //     return false;
  //   }
  // }

// 미들웨어로 쓸 예정이에요 26.02.05
  // Future<bool> ownerRegistration(String id, String pw, String name, String nickname, String number, String gender) async {
  //   final lambdaResponse = await http.post(
  //     Uri.parse(
  //         'https://v79h9dyx08.execute-api.ap-northeast-2.amazonaws.com/WeaveAPI/SignUp'),
  //     body: jsonEncode({
  //       "id": id,
  //       "pw": pw,
  //       "name": name,
  //       "nickname": nickname,
  //       "number": number,
  //       "gender": gender,
  //       "is_owner": "1"
  //     }),
  //     headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //   );
  //   var responseData = jsonDecode(lambdaResponse.body);
  //   final LambdaResponse response = LambdaResponse.fromJson(responseData);
  //   try{
  //     if(response.statusCode == 200){
  //       return true;
  //     }
  //     else{
  //       return false;
  //     }
  //   } catch (e){
  //     print("JSON Parsing Error: $e");
  //     return false;
  //   }
  // }
