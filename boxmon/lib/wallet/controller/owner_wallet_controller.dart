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
  String get thisMonthTotal =>
      NumberFormat('#,###').format(summaryData['thisMonthTotalAmount'] ?? 0);
  String get lastMonthTotal =>
      NumberFormat('#,###').format(summaryData['lastMonthTotalAmount'] ?? 0);
  String get differenceAmount =>
      NumberFormat('#,###').format((summaryData['difference'] ?? 0).abs());
  // 절약했는지 더 썼는지 판별
  bool get isSaved => (summaryData['difference'] ?? 0) >= 0;
  @override
  void onInit() {
    super.onInit();
    refreshAll(); // 페이지 진입 시 요약과 리스트 모두 로드
  }

  // 전체 데이터 새로고침
  Future<void> refreshAll() async {
    await Future.wait([fetchSummary2(), fetchSettlementList2()]);
  }

  // 3. API 호출 함수 - 요약 데이터
  Future<void> fetchSummary2() async {
    try {
      isLoading.value = true;
      print("📊 [WalletController-Summary] 요약 데이터 요청 시작...");

      final result = await _walletService.getSettlementSummary1();

      if (result != null) {
        summaryData.assignAll(result);
        print(
          "✅ [WalletController-Summary] 로드 성공! 이번 달 총액: ${summaryData['thisMonthTotalAmount']}, 차액: ${summaryData['difference']}",
        );
      } else {
        print("⚠️ [WalletController-Summary] 응답은 성공했으나 데이터가 null입니다.");
      }
    } catch (e) {
      print("❌ [WalletController-Summary] 요약 데이터 로드 실패: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 2. 🎯 월별 정산 리스트 가져오기
  Future<void> fetchSettlementList2() async {
    final year = selectedYear.value;
    final month = selectedMonth.value;

    try {
      isLoading.value = true;
      print("📋 [WalletController-List] 리스트 데이터 요청 시작... 대상: $year년 $month월");

      final result = await _walletService.getSettlementList1(year, month);

      if (result != null) {
        settlementList.assignAll(result);
        print(
          "✅ [WalletController-List] 로드 성공! 총 ${settlementList.length}건의 정산 내역이 있습니다. (대상: $year년 $month월)",
        );
      } else {
        settlementList.clear(); // null일 경우 기존 리스트 비우기
        print(
          "⚠️ [WalletController-List] 결과가 null입니다. 빈 리스트로 초기화합니다. (대상: $year년 $month월)",
        );
      }
    } catch (e) {
      print("❌ [WalletController-List] 리스트 데이터 로드 실패: $e");
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
