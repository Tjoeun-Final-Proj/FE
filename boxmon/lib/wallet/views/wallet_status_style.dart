import 'package:flutter/material.dart';

class WalletStatusStyle {
  WalletStatusStyle._();

  static Color chipColor(String? status) {
    final raw = (status ?? '').trim();
    final normalized = _normalize(raw);

    if (_equalsAny(normalized, const ['done', '운송완료', '배송완료', '완료'])) {
      return const Color(0xFF6A6A6A);
    }
    if (_equalsAny(normalized, const ['intransit', '운송중', '배송중', '이동중'])) {
      return const Color(0xFF2E7D32);
    }
    if (_equalsAny(normalized, const ['assigned', '배차완료', '배차확정', '배정'])) {
      return const Color(0xFF1565C0);
    }
    if (_equalsAny(normalized, const ['requested', '요청', '배차요청', '배차대기', '대기', '접수'])) {
      return const Color(0xFFEF6C00);
    }
    if (_equalsAny(normalized, const ['canceled', 'cancelled', '취소', '취소됨', '미배차'])) {
      return const Color(0xFFD32F2F);
    }
    return const Color(0xFF616161);
  }

  static bool _equalsAny(String value, List<String> candidates) {
    for (final candidate in candidates) {
      if (value == _normalize(candidate)) return true;
    }
    return false;
  }

  static String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
  }
}
