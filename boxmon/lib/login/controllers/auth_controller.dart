import 'package:boxmon/login/models/driver_signup_request.dart';
import 'package:boxmon/login/models/signup_request.dart';
import 'package:boxmon/login/models/token_model.dart';
import 'package:boxmon/login/services/auth_service.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final phoneController = TextEditingController();
  final businessNumberController = TextEditingController();
  final certNumberController = TextEditingController();

  var isAuthenticated = false.obs;
  var isLoading = false.obs;
  var isLoginSuccess = false.obs;
  var isDriver = false.obs;

  // 검증로직입니다.
  var emailError = "".obs;
  var passwordError = "".obs;
  var confirmPasswordError = "".obs;
  var nameError = "".obs;
  var birthError = "".obs;
  var phoneError = "".obs;

  void login(String email, String password) {
    emailError.value = "";
    passwordError.value = "";

    // 이메일 검증 '@' 포함 여부 체크
    if (!email.contains('@')) {
      emailError.value = "유효한 이메일 주소를 입력해주세요.";
      return;
    }

    // 비밀번호 검증
    if (password.isEmpty) {
      passwordError.value = "비밀번호를 입력해주세요.";
      return;
    }

    // 검증 통과 시 로그인 시도
    try {
      isLoading.value = true;
      _authService.userlogin(email, password);
      print("로그인 시도 중...");
    } catch (e) {
      Get.snackbar("로그인 실패", "아이디 또는 비밀번호를 확인해주세요.");
    } finally {
      isLoading.value = false;
    }
  }

  // 생년월일용 포맷터 변수 (클래스 선언 없이 바로 사용)
  final birthFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    var text = newValue.text.replaceAll('-', '');
    if (text.length > 8) text = text.substring(0, 8);

    var newString = "";
    for (int i = 0; i < text.length; i++) {
      newString += text[i];
      if ((i == 3 || i == 5) && i != text.length - 1) newString += "-";
    }
    return newValue.copyWith(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  });

  void commonSignup1() {
    // 모든 에러 초기화
    emailError.value = "";
    passwordError.value = "";
    confirmPasswordError.value = "";
    nameError.value = "";
    birthError.value = "";
    phoneError.value = "";

    // 값 가져오기
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();
    String birth = birthController.text.trim();
    String phone = phoneController.text.trim();

    // 3. 순차적 검증 (유효성 검사)
    if (email.isEmpty || !email.contains('@')) {
      emailError.value = "올바른 이메일 형식을 입력해주세요.";
      return;
    }
    if (password.isEmpty) {
      passwordError.value = "비밀번호를 입력해주세요.";
      return;
    }
    if (password != confirmPassword) {
      confirmPasswordError.value = "비밀번호가 일치하지 않습니다.";
      return;
    }
    if (name.isEmpty) {
      nameError.value = "이름을 입력해주세요.";
      return;
    }
    if (birth.length != 8) {
      birthError.value = "생년월일 8자리를 입력해주세요 (예: 19900101).";
      return;
    }
    if (phone.isEmpty) {
      phoneError.value = "휴대전화 번호를 입력해주세요.";
      return;
    }

    // 4. 모든 검증 통과 시 서버 통신 로직 실행
    print("회원가입 로직 실행!");
  }

  // 이제 외부에서 호출 가능합니다.
  Future<void> checkAuthStatus() async {
    print('🚀 [AuthCheck] 인증 체크 시작');

    Token? token = await _tokenService.loadToken();

    if (token != null && token.accessToken.isNotEmpty) {
      Get.offAllNamed(AppRoutes.commonHome);
    } else {
      Get.offAllNamed(AppRoutes.selectLogin);
    }
  }

  Future<void> commonSignup() async {
    isLoading.value = true;
    debugPrint("\n--- 📝 [Signup Process Start] ---");

    try {
      // 1. 디바이스 토큰 확보
      final tokenService = Get.find<TokenService>();
      final String dToken = tokenService.deviceToken ?? "NO_TOKEN_FOUND";

      debugPrint("📍 STEP 1: 디바이스 토큰 확인 -> $dToken");

      // 2. 요청 모델 생성 (데이터 캡슐화)
      final signupRequest = SignupRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        birth: birthController.text.trim(),
      );

      debugPrint("📍 STEP 2: 전송 데이터 모델 구성 완료");
      debugPrint("📦 Payload: ${signupRequest.toJson()}");

      // 3. 서비스 호출 (이제 bool 값을 반환함)
      debugPrint("📡 STEP 3: 서버 API 호출 시도...");
      bool isSuccess = await _authService.signupEmail(signupRequest);

      // 4. 결과 처리
      if (isSuccess) {
        debugPrint("✅ STEP 4: 회원가입 최종 성공!");

        Get.snackbar(
          "회원가입 완료",
          "가입을 축하합니다! 로그인 페이지로 이동합니다.",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );

        // 약간의 여유를 주고 이동 (스낵바 보여주기용)
        await Future.delayed(const Duration(milliseconds: 1500));

        // 로그인 창으로 쫓아내기 (이전 스택 모두 삭제)
        Get.offAllNamed(AppRoutes.login);
      } else {
        debugPrint("⚠️ STEP 4: 회원가입 실패 (서버 에러)");
        Get.snackbar("알림", "회원가입에 실패했습니다. 데이터를 다시 확인해주세요.");
      }
    } catch (e, stack) {
      debugPrint("🚨 [Unknown Error] 치명적 오류 발생!");
      debugPrint("▶️ Error: $e");
      debugPrint("▶️ StackTrace: $stack");

      Get.snackbar("오류", "시스템 오류가 발생했습니다.", backgroundColor: Colors.orange);
      isLoginSuccess.value = false;
    } finally {
      isLoading.value = false;
      debugPrint("--- 🏁 [Signup Process End] ---\n");
    }
  }

  // 차주용 회원가입 로직입니다.
  Future<void> driverSignup() async {
    isLoading.value = true;
    debugPrint("\n--- 📝 [Signup Process Start] ---");

    try {
      // 1. 디바이스 토큰 확보
      final tokenService = Get.find<TokenService>();
      final String dToken = tokenService.deviceToken ?? "NO_TOKEN_FOUND";

      debugPrint("📍 STEP 1: 디바이스 토큰 확인 -> $dToken");

      // 2. 요청 모델 생성 (데이터 캡슐화)
      final driversignup = DriverSignupRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        birth: birthController.text.trim(),
        businessNumber: businessNumberController.text.trim(),
        certNumber: certNumberController.text.trim(),
      );

      debugPrint("📍 STEP 2: 전송 데이터 모델 구성 완료");
      debugPrint("📦 Payload: ${driversignup.toJson()}");

      // 3. 서비스 호출 (이제 bool 값을 반환함)
      debugPrint("📡 STEP 3: 서버 API 호출 시도...");
      bool isSuccess = await _authService.driverSignupEmail(driversignup);

      // 4. 결과 처리
      if (isSuccess) {
        debugPrint("✅ STEP 4: 회원가입 최종 성공!");

        Get.snackbar(
          "회원가입 완료",
          "가입을 축하합니다! 로그인 페이지로 이동합니다.",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );

        // 약간의 여유를 주고 이동 (스낵바 보여주기용)
        await Future.delayed(const Duration(milliseconds: 1500));

        // 로그인 창으로 쫓아내기 (이전 스택 모두 삭제)
        Get.offAllNamed(AppRoutes.ownerLogin);
      } else {
        debugPrint("⚠️ STEP 4: 회원가입 실패 (서버 에러)");
        Get.snackbar("알림", "회원가입에 실패했습니다. 데이터를 다시 확인해주세요.");
      }
    } catch (e, stack) {
      debugPrint("🚨 [Unknown Error] 치명적 오류 발생!");
      debugPrint("▶️ Error: $e");
      debugPrint("▶️ StackTrace: $stack");

      Get.snackbar("오류", "시스템 오류가 발생했습니다.", backgroundColor: Colors.orange);
      isLoginSuccess.value = false;
    } finally {
      isLoading.value = false;
      debugPrint("--- 🏁 [Signup Process End] ---\n");
    }
  }
  // Future<bool> checkIsOwner() async {
  //   Token token = await _tokenService.loadToken() ??
  //       Token(accessToken: '', refreshToken: '', userId: '', isOwner: 0);
  //   isOwner.value = token.isOwner == 1;
  //   return isOwner.value;
  // }

  Future<void> login1(String email, String password) async {
    print("---------- 로그인 시도 ----------");
    print("Email: $email");
    print("Password: $password");
    isLoading.value = true;
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("알림", "이메일과 비밀번호를 모두 입력해주세요.");
      return; // 값이 없으면 여기서 중단
    }
    // 1. 로딩 다이얼로그 표시
    if (!Get.isDialogOpen!) {
      Get.dialog(
        const PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("로그인 중입니다..."),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }

    try {
      // 2. 실제 로그인 요청
      final success = await _authService.userlogin(email, password);
      print("로그인 서비스 응답 결과: $success");

      // 3. 다이얼로그 닫기
      if (Get.isDialogOpen!) Get.back();

      // 4. 결과에 따른 분기 처리 (이 부분이 누락되어 있었습니다)
      if (success == true) {
        print("로그인 성공: 홈 화면으로 이동합니다.");
        isLoading.value = false;
        Get.offAllNamed(AppRoutes.commonHome);
      } else {
        print("로그인 실패: 아이디 또는 비밀번호 불일치.");
        isLoading.value = false;
        Get.snackbar("로그인 실패", "아이디 또는 비밀번호를 확인해주세요.");
      }
    } catch (e, stackTrace) {
      // 5. 에러 발생 시 상세 로그 출력
      print("!!! 로그인 과정 중 예외 발생 !!!");
      print("에러 내용: $e");
      print("스택 트레이스: $stackTrace");

      if (Get.isDialogOpen!) Get.back();
      isLoading.value = false;
      Get.snackbar("에러", "네트워크 문제나 서버 오류가 발생했습니다.");
    } finally {
      print("---------- 로그인 프로세스 종료 ----------");
    }
  }

  // 차주 구분하는 로직입니다.
  Future<bool> checkIsDriver() async {
    Token token =
        await _tokenService.loadToken() ??
        Token(accessToken: '', refreshToken: '', userType: '');
    isDriver.value = token.userType == 'DRIVER';
    return isDriver.value;
  }

  // ✅ 로그아웃 처리
  Future<void> userlogout() async {
    _tokenService.clearToken();
    // isAuthenticated.value = false;
    Get.offAllNamed(AppRoutes.selectLogin);
  }

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
}
