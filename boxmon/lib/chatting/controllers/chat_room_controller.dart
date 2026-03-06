import 'package:boxmon/chatting/models/chat_message_model.dart';
import 'package:boxmon/chatting/services/chat_service.dart';
import 'package:boxmon/chatting/services/chat_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final ChatSocketService _socketService = Get.find<ChatSocketService>();

  final TextEditingController inputController = TextEditingController();
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  int shipmentId = 0;
  final RxString roomTitle = '채팅'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = (Get.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;
    shipmentId = args['shipmentId'] as int? ?? 0;
    roomTitle.value = args['roomTitle'] as String? ?? '채팅';

    await _loadHistory();
    await _connectAndSubscribe();
  }

  Future<void> _loadHistory() async {
    try {
      isLoading.value = true;
      error.value = '';
      final history = await _chatService.fetchMessages(shipmentId);
      messages.assignAll(history);
      messages.sort((a, b) {
        final aAt = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bAt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aAt.compareTo(bAt);
      });
    } catch (_) {
      error.value = '메시지 이력을 불러오지 못했습니다.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _connectAndSubscribe() async {
    try {
      await _socketService.connect();
      _socketService.subscribeRoom(
        shipmentId: shipmentId,
        onMessage: (message) {
          messages.add(message);
          messages.sort((a, b) {
            final aAt = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bAt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return aAt.compareTo(bAt);
          });
        },
      );
    } catch (e) {
      error.value = '채팅 연결에 실패했습니다. ($e)';
    }
  }

  void sendText() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    _socketService.sendText(shipmentId: shipmentId, content: text);
    inputController.clear();
  }

  @override
  void onClose() {
    _socketService.unsubscribeRoom(shipmentId);
    inputController.dispose();
    super.onClose();
  }
}
