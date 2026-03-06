class Token {
  final String accessToken;
  final String refreshToken;
  final String userType;
  final int? userId;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.userType,
    this.userId,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userType: json['userType'],
      userId: json['userId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accesstoken': accessToken,
      'refreshtoken': refreshToken,
      'usertype': userType,
      'userId': userId,
    };
  }
}
