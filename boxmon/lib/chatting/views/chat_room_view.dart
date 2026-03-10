import 'package:boxmon/chatting/controllers/chat_room_controller.dart';
import 'package:boxmon/chatting/models/chat_message_model.dart';
import 'package:boxmon/login/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomView extends StatelessWidget {
  ChatRoomView({super.key});

  final ChatRoomController controller = Get.put(ChatRoomController());
  final TokenService tokenService = Get.find<TokenService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Obx(
          () => Text(
            controller.roomTitle.value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.error.value.isNotEmpty &&
                  controller.messages.isEmpty) {
                return Center(child: Text(controller.error.value));
              }

              if (controller.messages.isEmpty) {
                return const Center(child: Text('아직 메시지가 없습니다.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isMine = _isMine(message.senderId);
                  final isImage = _isImageMessage(message);
                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: isImage
                          ? const EdgeInsets.all(4)
                          : const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        color: isMine
                            ? const Color(0xFF1F5AA6)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isImage
                          ? _buildImageBubble(message.content)
                          : Text(
                              message.content,
                              style: TextStyle(
                                color: isMine ? Colors.white : Colors.black87,
                              ),
                            ),
                    ),
                  );
                },
              );
            }),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              color: Colors.white,
              child: Row(
                children: [
                  Obx(
                    () => IconButton(
                      onPressed: controller.isUploadingImage.value
                          ? null
                          : () => _showImageSourceSheet(context),
                      icon: controller.isUploadingImage.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add_photo_alternate_outlined),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.inputController,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onSubmitted: (_) => controller.sendText(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: controller.sendText,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isMine(int senderId) => tokenService.userId == senderId;

  bool _isImageMessage(ChatMessageModel message) {
    return message.contentType.toString().toUpperCase().trim() == 'IMG_URL';
  }

  Widget _buildImageBubble(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 220,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 220,
            height: 160,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            width: 220,
            height: 160,
            child: Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('카메라'),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.sendImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('앨범'),
                onTap: () {
                  Navigator.of(context).pop();
                  controller.sendImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


