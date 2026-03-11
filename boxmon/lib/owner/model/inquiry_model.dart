// inquiry_model.dart

class User {
  final int? userId;
  final String? email;
  final String? name;
  final String? phone;

  User({this.userId, this.email, this.name, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    email: json["email"],
    name: json["name"],
    phone: json["phone"],
  );
}

class Admin {
  final int? adminId;
  final String? name;

  Admin({this.adminId, this.name});

  factory Admin.fromJson(Map<String, dynamic> json) =>
      Admin(adminId: json["adminId"], name: json["name"]);
}

class InquiryDetail {
  final int? contactId;
  final User? user;
  final String? contactContent;
  final String? answerContent;
  final DateTime? createdAt;
  final Admin? answerer;

  InquiryDetail({
    this.contactId,
    this.user,
    this.contactContent,
    this.answerContent,
    this.createdAt,
    this.answerer,
  });

  factory InquiryDetail.fromJson(Map<String, dynamic> json) => InquiryDetail(
    contactId: json["contactId"],
    user: json["userId"] == null ? null : User.fromJson(json["userId"]),
    contactContent: json["contactContent"],
    answerContent: json["answerContent"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    answerer: json["answererId"] == null
        ? null
        : Admin.fromJson(json["answererId"]),
  );
}

class InquiryItem {
  final InquiryDetail inquiry;
  final String contentUrl;
  final int attatchmentId;

  InquiryItem({
    required this.inquiry,
    required this.contentUrl,
    required this.attatchmentId,
  });

  factory InquiryItem.fromJson(Map<String, dynamic> json) => InquiryItem(
    inquiry: InquiryDetail.fromJson(json["contactId"]),
    contentUrl: json["content"],
    attatchmentId: json["attatchmentId"],
  );
}
