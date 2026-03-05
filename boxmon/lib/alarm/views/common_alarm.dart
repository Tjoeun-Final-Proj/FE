import 'package:flutter/material.dart';

class CommonAlarm extends StatelessWidget {
  const CommonAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(""),
      ),
      body: const Center(child: Text("Hello 나는 공통 알림이야")),
    );
  }
}