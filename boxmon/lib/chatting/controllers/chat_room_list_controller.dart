import 'package:boxmon/chatting/models/chat_room_item_model.dart';
import 'package:boxmon/chatting/services/chat_service.dart';
import 'package:boxmon/chatting/services/chat_socket_service.dart';
import 'package:get/get.dart';

class ChatRoomListController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  final ChatSocketService _socketService = Get.find<ChatSocketService>();

  final RxList<ChatRoomItemModel> rooms = <ChatRoomItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  bool _socketReady = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _ensureSocketConnected();
    await fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetched = await _chatService.fetchChatRooms();
      rooms.assignAll(fetched);
    } catch (e) {
      error.value = '채팅방 목록을 불러오지 못했습니다.';
    } finally {
      isLoading.value = false;
    }
  }

  void onShipmentAccepted(int shipmentId) {
    if (rooms.any((room) => room.shipmentId == shipmentId)) return;
    rooms.insert(
      0,
      ChatRoomItemModel(
        shipmentId: shipmentId,
        title: '운송 #$shipmentId',
        subtitle: '배차가 수락되었습니다.',
        shipmentStatus: 'ASSIGNED',
      ),
    );
  }

  Future<void> _ensureSocketConnected() async {
    if (_socketReady) return;
    try {
      await _socketService.connect();
      _socketReady = true;
    } catch (_) {
      error.value = '채팅 연결에 실패했습니다.';
    }
  }
}
