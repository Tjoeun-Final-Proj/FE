class CommonModel {
  final String email;
  final String password;
  final String name;
  final String phone;
  final DateTime birth;
  final String userType;
  final String? message; // 성공 메시지용 추가

  CommonModel({required this.email, required this.password, required this.name, required this.phone, required this.birth, required this.userType, this.message});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phone: json['phone'],
      birth: DateTime.parse(json['birth']),
      userType: json['userType'],
      message: json['message'] ?? "Success",
    );
  }
}