import 'package:boxmon/wallet/model/common_wallet_month_model.dart';
import 'package:boxmon/wallet/services/owner_wallet_servcie.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OwnerWalletController extends GetxController {
  final OwnerWalletServcie _walletService = Get.find<OwnerWalletServcie>();

  var isLoading = false.obs;
  var summaryData = <String, dynamic>{}.obs;
  
  // 🎯 정산 리스트를 담을 RxList
  var settlementList = <CommonWalletMonthModel>[].obs;

  // 현재 선택된 연도와 월 (초기값: 현재 날짜)
  var selectedYear = DateTime.now().year.obs;
  var selectedMonth = DateTime.now().month.obs;

// 2. UI에서 바로 쓸 포맷팅된 getter (오타 방지 및 편의성)
  String get thisMonthTotal => NumberFormat('#,###').format(summaryData['thisMonthTotalAmount'] ?? 0);
  String get lastMonthTotal => NumberFormat('#,###').format(summaryData['lastMonthTotalAmount'] ?? 0);
  String get differenceAmount => NumberFormat('#,###').format((summaryData['difference'] ?? 0).abs());
  // 절약했는지 더 썼는지 판별
  bool get isSaved => (summaryData['difference'] ?? 0) >= 0;
  @override
  void onInit() {
    super.onInit();
    refreshAll(); // 페이지 진입 시 요약과 리스트 모두 로드
  }

  // 전체 데이터 새로고침
  Future<void> refreshAll() async {
    await Future.wait([
      fetchSummary2(),
      fetchSettlementList2(),
    ]);
  }

  // 3. API 호출 함수
  Future<void> fetchSummary2() async {
    try {
      isLoading.value = true;
      print("💳 [WalletController] 정산 데이터 동기화 시작...");

      final result = await _walletService.getSettlementSummary1();

      if (result != null) {
        summaryData.assignAll(result);
        print("✅ [WalletController] 데이터 로드 성공: $result");
      }
    } finally {
      isLoading.value = false;
    }
  }
  // 2. 🎯 월별 정산 리스트 가져오기
  Future<void> fetchSettlementList2() async {
    try {
      isLoading.value = true;
      final result = await _walletService.getSettlementList1(
        selectedYear.value, 
        selectedMonth.value
      );

      if (result != null) {
        settlementList.assignAll(result);
        print("🎯 리스트 로드 완료: ${settlementList.length}건");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 월 변경 시 호출 (Next/Prev 버튼용)
  void changeMonth(int delta) {
    int nextMonth = selectedMonth.value + delta;
    if (nextMonth > 12) {
      selectedYear.value++;
      selectedMonth.value = 1;
    } else if (nextMonth < 1) {
      selectedYear.value--;
      selectedMonth.value = 12;
    } else {
      selectedMonth.value = nextMonth;
    }
    fetchSettlementList2(); // 월 변경 후 리스트 다시 불러오기
  }
}