import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:flutter/material.dart';

class CommonChatting extends StatelessWidget {
  const CommonChatting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(""),
      ),
      body: const Center(child: Text("Hello 나는 공통 채팅이야")),
    );
  }
}
