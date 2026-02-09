import 'package:boxmon/login/models/common_model.dart';
import 'package:boxmon/login/services/auth_service.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  //final TokenService _tokenService = TokenService();
  // final AuthService _authService = AuthService();

  final _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final phoneController = TextEditingController();
  // var isAuthenticated = false.obs;
  // var isOwner = false.obs;
  var isLoading = false.obs;
  var isLoginSuccess = false.obs;


  @override
  void onClose() {
    // 메모리 누수 방지를 위해 닫아주는 설정 (선택사항이지만 권장)
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    birthController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> commonSignup() async {
         isLoading.value = true; // 로딩 시작
      try {
          debugPrint("📌 [Signup] 회원가입 시작: ${emailController.text}");
   
          // 1. 데이터 준비 (여기서는 Map을 사용하지만, UserSignupRequest 모델을 사용하는 것이 더 좋습니다.)
          final userData = {
            "email": emailController.text,
            "password": passwordController.text,
            "name": nameController.text,
            "phone": phoneController.text,
            "birth": birthController.text, // 실제로는 DateTime 객체를 문자열로 변환해야 할 수 있습니다.
          };
        debugPrint("🚀 [Signup] SignUpUseCase (또는 AuthService) 호출 시작. 데이터: $userData");
        // 2. 유스케이스 (또는 서비스) 호출
        // CommonModel? result = await _signUpUseCase.execute(userData); // 유스케이스 사용 시
        CommonModel? result = await _authService.signupEmail(userData); // 현재 _authService 사용 시
        debugPrint("📥 [Signup] API 응답 수신 완료. result: $result");
        // 3. 결과 처리
        if (result != null) {
          debugPrint("✅ [Signup] 회원가입 성공. 응답 메시지: ${result.message}");
          Get.snackbar("회원가입 성공", result.message ?? "회원가입이 완료되었습니다.");
          Get.offAllNamed(AppRoutes.login);
          isLoginSuccess.value = true;
        } else {
          debugPrint("⚠️ [Signup] 회원가입 실패: result가 null입니다.");
          Get.snackbar("회원가입 실패", "알 수 없는 오류로 회원가입에 실패했습니다. 다시 시도해주세요.");
          isLoginSuccess.value = false;
        }
      } on DioException catch (e) {
        debugPrint("❌ [Signup] DioException 발생: ${e.response?.statusCode}");
        debugPrint("❌ [Signup] DioException 응답 데이터: ${e.response?.data}");
        debugPrint("❌ [Signup] DioException 메시지: ${e.message}");

        String errorMessage = "회원가입 중 네트워크 오류가 발생했습니다.";
        if (e.response != null && e.response?.data != null && e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? errorMessage;
        }
        Get.snackbar("회원가입 오류", errorMessage);
        isLoginSuccess.value = false;
      } catch (e, stackTrace) {
        debugPrint("❌ [Signup] 예상치 못한 예외 발생");
        debugPrint("❌ error: $e");
        debugPrint("❌ stackTrace:\n$stackTrace");

        Get.snackbar("회원가입 오류", "예상치 못한 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        isLoginSuccess.value = false;
      } finally {
        isLoading.value = false; // 로딩 종료
        debugPrint("🏁 [Signup] 회원가입 프로세스 종료");
      }
    }
  // ✅ 앱 실행 시 토큰 검증 및 자동 로그인 처리
  // Future<bool> checkAuthStatus() async {
  //   bool isValid = await _tokenService.refreshToken();
  //   isAuthenticated.value = isValid;
  //   Get.offAllNamed(AppRoutes.LOGIN);
  //   return isValid;
  // }

  // Future<bool> checkIsOwner() async {
  //   Token token = await _tokenService.loadToken() ??
  //       Token(accessToken: '', refreshToken: '', userId: '', isOwner: 0);
  //   isOwner.value = token.isOwner == 1;
  //   return isOwner.value;
  // }

  // Future<void> _checkAuthStatus() async {
  //   Token token = await _tokenService.loadToken() ??
  //       Token(accessToken: '', refreshToken: '', userId: '', isOwner: 0);
  //   bool isValid = token.accessToken != '';
  //   isAuthenticated.value = isValid;
  //   isOwner.value = token.isOwner == 1;
  //   if (isValid) {
  //     Get.offAllNamed(AppRoutes.HOME);
  //   }
  // }

  // Future<void> login(String email, String password) async {
  //   isLoading.value = true;

  //   if (!Get.isDialogOpen!) {
  //     Get.dialog(
  //       const PopScope(
  //         canPop: false,
  //         child: Dialog(
  //           child: Padding(
  //             padding: EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(),
  //                 SizedBox(height: 16),
  //                 Text("로그인 중입니다..."),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       barrierDismissible: false,
  //     );
  //   }

    // 실제 로그인 요청
    //final success = await _authService.login(email, password);

   // print(BCrypt.hashpw(password, BCrypt .gensalt Function() Function ));

    // if (success) {
    //   final token = await _tokenService.loadToken();
    //   isAuthenticated.value = true;
    //   isLoading.value = false;
    //   isOwner.value = token!.isOwner == 1;
    //   Get.offAllNamed(AppRoutes.HOME);
    // } else {
    //   isLoading.value = false;
    //   Get.snackbar("로그인 실패", "아이디나 비밀번호를 확인하세요");
    // }
  }

  // // ✅ 로그아웃 처리
  // Future<void> logout() async {
  //   //await _tokenService.clearToken();
  //  // _authService.logout();
  //   isAuthenticated.value = false;
  //   //Get.offAllNamed(AppRoutes.AUTH);
  // }

  // Future<void> commonRegistration(String id, String pw, String name,
  //     String nickname, String number, String gender) async {
  //   isLoading.value = true;
  //   await Future.delayed(Duration(milliseconds: 100));
  //   if (!Get.isDialogOpen!) {
  //     Get.dialog(
  //       PopScope(
  //         canPop: false,
  //         child: Dialog(
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: const [
  //                 CircularProgressIndicator(),
  //                 SizedBox(height: 16),
  //                 Text("회원가입 중입니다..."),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       barrierDismissible: false,
  //     );
  //   }
    // final success = await _authService.commonRegistration(
    //     id, pw, name, nickname, number, gender);

    // if (success) {
    //   isLoading.value = false;
    //   Get.snackbar("회원가입 성공", "로그인 해주세요");
    //   Get.offAllNamed(AppRoutes.LOGIN);
    // } else {
    //   isLoading.value = false;
    //   Get.snackbar("회원가입 실패", "회원가입에 실패했습니다");
    // }
  

  // 사업자 검증 코드 로직입니다.
  // Future<bool> validateBusinessNumber(String bno) async {
  //   const serviceKey = "RK1Tb5xIod4LWDuarSN6uUOZpHG%2BZgpTmbySBU8n2yiBcpZWwrYoUY6h80Chcv0EGXCRKTszOFCDpItZ4ZO%2FMA%3D%3D";
  //   final url = Uri.parse("https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=$serviceKey");

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"b_no": [bno]}),
  //     );

  //     if (response.statusCode != 200) {
  //       return false;
  //     }

  //     final data = jsonDecode(response.body);
  //     final statusList = data['data'] as List<dynamic>?;

  //     if (statusList == null || statusList.isEmpty) {
  //       return false;
  //     }

  //     // 사업자 상태 코드 확인
  //     final status = statusList[0]['b_stt_cd'];
  //     return status != null && status.toString().isNotEmpty;
  //   }
  //   // 예외 처리 추가
  //   catch (e) {
  //     print("사업자 유효성 검사 중 오류 발생: $e");
  //     return false;
  //   }
  // }

  // Future<void> ownerRegistration(String id, String pw, String name,
  //     String nickname, String number, String gender) async {
  //   isLoading.value = true;
  //   await Future.delayed(Duration(milliseconds: 100));
  //   if (!Get.isDialogOpen!) {
  //     Get.dialog(
  //       const PopScope(
  //         canPop: false,
  //         child: Dialog(
  //           child: Padding(
  //             padding: EdgeInsets.all(20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 CircularProgressIndicator(),
  //                 SizedBox(height: 16),
  //                 Text("회원가입 중입니다..."),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       barrierDismissible: false,
  //     );
  //   }
    // final success = await _authService.ownerRegistration(
    //     id, pw, name, nickname, number, gender);

    // if (success) {
    //   isLoading.value = false;
    //   Get.snackbar("회원가입 성공", "로그인 해주세요");
    //   Get.toNamed(AppRoutes.LOGIN);
    // } else {
    //   isLoading.value = false;
    //   Get.snackbar("회원가입 실패", "회원가입에 실패했습니다");
    // }
  

  // ✅ 401 오류 발생 시 토큰 갱신 // 제가 쓸게욘~~
  // Future<bool> handle401() async {
  //   bool success = await _tokenService.refreshToken();
  //   if (success) {
  //     isAuthenticated.value = true;
  //   } else {
  //     await logout();
  //   }
  //   return success;
  // }