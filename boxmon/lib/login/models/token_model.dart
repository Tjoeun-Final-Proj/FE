class Token {
  final String accessToken;
  final String refreshToken;
  final String userType;
  final int? userId;
  final String? userName;
  final String? userEmail;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
    this.userId,
    this.userName,
    this.userEmail,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userType: json['userType'],
      userId: json['userId'] as int?,
      userName: json['userName'] ?? json['name'],
      userEmail: json['userEmail'] ?? json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accesstoken': accessToken,
      'refreshtoken': refreshToken,
      'usertype': userType,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}
