import 'package:boxmon/chatting/controllers/chat_room_list_controller.dart';
import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonChatting extends StatelessWidget {
  CommonChatting({super.key});

  final ChatRoomListController controller = Get.find<ChatRoomListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('채팅방', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        if (controller.rooms.isEmpty) {
          return const Center(child: Text('참여 가능한 채팅방이 없습니다.'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRooms,
          child: ListView.separated(
            itemCount: controller.rooms.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final room = controller.rooms[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.local_shipping)),
                title: Text(room.title),
                subtitle: Text(room.subtitle),
                trailing: Text(
                  room.shipmentStatus,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.chatRoom,
                    arguments: {
                      'shipmentId': room.shipmentId,
                      'roomTitle': room.title,
                    },
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
