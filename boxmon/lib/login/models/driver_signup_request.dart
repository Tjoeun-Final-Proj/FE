class DriverSignupRequest {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String birth;
  final String userType;
  final String businessNumber;
  final String certNumber;
  final int isPushEnabled;

  DriverSignupRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.birth,
    this.userType = "DRIVER", // 기본값 설정
    this.isPushEnabled = 1,    // 기본값 설정
    required this.businessNumber,
    required this.certNumber
  });

  // 서버에 보낼 JSON 맵으로 변환
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'name': name,
    'phone': phone,
    'birth': birth,
    'userType': userType,
    'isPushEnabled': isPushEnabled,
    'businessNumber': businessNumber,
    'certNumber': certNumber
  };
}