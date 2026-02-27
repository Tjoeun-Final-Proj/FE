import 'package:boxmon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tosspayments_widget_sdk_flutter/model/paymentData.dart';

class PayHome extends StatefulWidget {
  const PayHome({super.key});

  @override
  State<PayHome> createState() => _PayHomeState();
}

class _PayHomeState extends State<PayHome> {
  final _form = GlobalKey<FormState>();
  late String payMethod = '카드';
  late String orderId;
  late String orderName;
  late String amount;
  late String customerName = "황덕배";
  late String customerEmail = "test@example.com";

 @override
  void initState() {
    super.initState();
    
    // 2. 이전 화면에서 보낸 arguments를 안전하게 꺼냅니다.
    final dynamic args = Get.arguments;
    
    if (args != null && args is Map) {
      // 전달받은 배송 ID와 금액을 변수에 할당
      final String shipmentId = args['shipmentId'] ?? 0;
      final int rawAmount = args['amount'] ?? 0;

      orderId = shipmentId; // 배송 ID를 주문번호로 사용
      amount = rawAmount.toString(); // 금액을 문자열로 변환하여 할당
    } else {
      // 데이터가 없을 경우를 대비한 예외 처리
      orderId = '${DateTime.now().millisecondsSinceEpoch}';
      amount = "50000"; 
    }
    orderName = '일반 용달 운송';
    
    print("🎯 [PayHome] 데이터 로드 완료: ID=$orderId, Price=$amount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. 전체 배경색을 연한 그레이로 깔아 대비를 줍니다.
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text('결제 하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // --- 섹션 1: 결제 수단 ---
              _buildCardSection(
                title: "결제 수단",
                child: DropdownButtonFormField<String>(
                  initialValue: '카드',
                  decoration: const InputDecoration(
                    border: InputBorder.none, // 카드 안이라 선을 없앰
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (String? newValue) => payMethod = newValue ?? '카드',
                  items: ['카드', '계좌이체', '휴대폰', '상품권']
                      .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),

              // --- 섹션 2: 주문 정보 ---
              _buildCardSection(
        title: "주문 정보",
        child: Column(
          children: [
            _buildStyledField('주문번호', initial: orderId, onSaved: (v) => orderId = v!), // 하드코딩 제거
            const Divider(),
            _buildStyledField('주문명', initial: orderName, onSaved: (v) => orderName = v!),
            const Divider(),
            _buildStyledField('결제금액', initial: amount, isNumber: true, onSaved: (v) => amount = v!), // 하드코딩 제거
          ],
        ),
      ),

              const SizedBox(height: 16),

              // --- 섹션 3: 고객 정보 ---
              _buildCardSection(
                title: "고객 정보",
                child: Column(
                  children: [
                    _buildStyledField('이름', initial: customerName, onSaved: (v) => customerName = v!),
                    const Divider(),
                    _buildStyledField('이메일', initial: customerEmail, onSaved: (v) => customerEmail = v!),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 결제 버튼 ---
              ElevatedButton(
                onPressed: () async {
                  _form.currentState!.save();
                  PaymentData data = PaymentData(
                    paymentMethod: payMethod,
                    orderId: orderId,
                    orderName: orderName,
                    amount: int.parse(amount),
                    customerName: customerName,
                    customerEmail: customerEmail,
                    successUrl: "https://success.url", // 실제 Constants 값으로 변경 가능
                    failUrl: "https://fail.url",
                  );
                  
                  var result = await Get.toNamed(AppRoutes.tossPaymentsResult, arguments: data);
                  if (result != null) {
                    Get.toNamed(AppRoutes.tossPaymentsResult, arguments: result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0047AB),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  '결제하기',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 재사용 가능한 꾸미기용 위젯 함수들 ---

  Widget _buildCardSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildStyledField(String label, {required String initial, bool isNumber = false, required FormFieldSetter<String> onSaved}) {
    return TextFormField(
      initialValue: initial,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      onSaved: onSaved,
    );
  }
}