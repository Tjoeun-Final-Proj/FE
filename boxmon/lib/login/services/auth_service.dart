import 'package:boxmon/login/models/common_model.dart';
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
  Future<CommonModel?> signupEmail(Map<String, dynamic> userData) async {
  try {
    print("🚀 최종 요청 주소: ${_dio.options.baseUrl}user/signup");
    print("=== [POST] /user/signup 요청 시작 ===");

    final response = await _dio.post(
      'user/signup',
      data: userData,
    );

    print("--- 서버 응답 성공 ---");
    print("상태 코드: ${response.statusCode}");
    print("응답 바디: ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 204) {
        // Backend returns CommonModel, which contains accessToken
        return CommonModel.fromJson(response.data);
      }
      // Handle non-2xx errors
    } on dio.DioException catch (e) {
      String? errorMessage;
      if (e.response != null && e.response?.data is Map) {
        // Check if the backend sent a structured error response
        errorMessage = e.response?.data['error']?.toString();
      }

      if (e.response?.statusCode == 409) {
        errorMessage = errorMessage ?? '이미 가입된 이메일 주소입니다.';
      } else {
        errorMessage = errorMessage ?? '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      }

      print('DioError in registerWithEmail: ${e.message ?? errorMessage}');
    } catch (e) {
      print('Unexpected error in registerWithEmail: $e');
    }
    return null;
  }

  // 화주 로그인하는 함수
  Future<bool> userlogin(String email, String password) async {
  try {
    final response = await _dio.post(
      'user/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print('✅ [Login Success]: ${response.data}');

      // 1. 서버 응답 데이터에서 토큰 추출 (서버 응답 구조에 맞게 수정하세요!)
      // 만약 { "accessToken": "...", "refreshToken": "..." } 구조라면:
      final String accessToken = response.data['accessToken'] ?? '';
      final String refreshToken = response.data['refreshToken'] ?? '';

      // 2. TokenService를 사용해 기기에 저장 (반드시 await!)
      final TokenService tokenService = TokenService();
      await tokenService.saveToken(
        accessToken,
        refreshToken,
      );

      print('💾 [Token Saved] 토큰이 기기에 저장되었습니다.');
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

  // void logout() {
  //   tokenController.clearToken();
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
  }