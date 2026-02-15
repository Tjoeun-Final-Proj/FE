import 'package:boxmon/core/components/app_nav_bar.dart';
import 'package:flutter/material.dart';

class OwnerAlarm extends StatelessWidget {
  const OwnerAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(""),
      ),
      body: const Center(child: Text("Hello 나는 오너 알림이야")),
    );
  }
}
