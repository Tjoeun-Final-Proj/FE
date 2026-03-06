import 'package:flutter/material.dart';

class OwnerChatting extends StatelessWidget {
  const OwnerChatting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(""),
      ),
      body: const Center(child: Text("Hello 나는 오너 채팅이야")),
    );
  }
}