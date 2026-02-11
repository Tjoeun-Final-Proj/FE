class Token {
  final String accessToken;
  final String refreshToken;
  final String userType;

  Token({required this.accessToken, required this.refreshToken, required this.userType});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accesstoken': accessToken,
      'refreshtoken': refreshToken,
      'usertype': userType
    };
  }
}