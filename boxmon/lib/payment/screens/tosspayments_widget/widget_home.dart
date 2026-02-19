import 'package:flutter/material.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';

/// [WidgetHome] 위젯은 사용자에게 결제 수단 및 주문 관련 정보를 입력받아
/// 결제를 시작하는 화면을 제공합니다.
class WidgetHome extends StatelessWidget {
  /// 기본 생성자입니다.
  const WidgetHome({super.key});
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class UIState {
  String clientKey;
  String customerKey;
  Currency currency;
  String country;
  num amount;
  String? variantKeyMethod;
  String? variantKeyAgreement;
  String? redirectUrl;

  UIState({
    required this.clientKey,
    required this.customerKey,
    required this.currency,
    required this.country,
    required this.amount,
    this.variantKeyMethod,
    this.variantKeyAgreement,
    this.redirectUrl,
  });
}
