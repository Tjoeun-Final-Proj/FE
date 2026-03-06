class ChatMessageModel {
  final int? chatId;
  final int shipmentId;
  final int senderId;
  final String senderRole;
  final String contentType;
  final String content;
  final DateTime? createdAt;

  const ChatMessageModel({
    required this.chatId,
    required this.shipmentId,
    required this.senderId,
    required this.senderRole,
    required this.contentType,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      chatId: json['chatId'] as int?,
      shipmentId: _toInt(json['shipmentId']) ?? 0,
      senderId: _toInt(json['senderId']) ?? 0,
      senderRole: '${json['senderRole'] ?? ''}',
      contentType: '${json['contentType'] ?? 'TEXT'}',
      content: '${json['content'] ?? ''}',
      createdAt: DateTime.tryParse('${json['createdAt'] ?? ''}'),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}
