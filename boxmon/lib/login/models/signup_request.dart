class SignupRequest {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String birth;
  final String deviceToken;
  final String userType;
  final int isPushEnabled;

  SignupRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.birth,
    required this.deviceToken,
    this.userType = "SHIPPER", // 기본값 설정
    this.isPushEnabled = 1,    // 기본값 설정
  });

  // 서버에 보낼 JSON 맵으로 변환
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'phone': phone,
    'birth': birth,
    'deviceToken': deviceToken,
    'userType': userType,
    'isPushEnabled': isPushEnabled,
  };
}