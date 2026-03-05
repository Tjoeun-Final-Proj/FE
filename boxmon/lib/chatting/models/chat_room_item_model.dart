class ChatRoomItemModel {
  final int shipmentId;
  final String title;
  final String subtitle;
  final String shipmentStatus;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const ChatRoomItemModel({
    required this.shipmentId,
    required this.title,
    required this.subtitle,
    required this.shipmentStatus,
    this.lastMessage,
    this.lastMessageAt,
  });

  ChatRoomItemModel copyWith({
    String? title,
    String? subtitle,
    String? shipmentStatus,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return ChatRoomItemModel(
      shipmentId: shipmentId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      shipmentStatus: shipmentStatus ?? this.shipmentStatus,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
