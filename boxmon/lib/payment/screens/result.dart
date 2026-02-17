import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/model/tosspayments_result.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.arguments로 넘어온 Success 데이터를 받습니다.
    final Success res = Get.arguments as Success;

    return Scaffold(
      appBar: AppBar(title: const Text('결제 결과')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎉 결제가 성공했습니다!', 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            _buildResultRow('주문 ID (orderId)', res.orderId),
            _buildResultRow('결제 키 (paymentKey)', res.paymentKey),
            _buildResultRow('결제 금액 (amount)', '${res.amount}원'),
            
            const Spacer(),
            TextButton(
              onPressed: () => Get.offAllNamed('/'), // 홈으로 돌아가기
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Divider(),
        ],
      ),
    );
  }
}