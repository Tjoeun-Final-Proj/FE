# Boxmon Project Repository Guidelines

## 1. 프로젝트 구조 분석 (Feature-First Architecture)
현재 프로젝트는 기능(Feature) 단위로 폴더를 구성하는 'Feature-First' 아키텍처를 따르고 있으며, 각 기능 내부에서 MVVM(Model-View-ViewModel) 패턴을 적용하고 있습니다.

### 핵심 시스템 폴더
- `lib/core`: 앱 전반에서 사용되는 공용 인프라.
  - `components/`: 전역에서 재사용되는 UI 컴포넌트 (네비게이션 바 등).
  - `design/`: 디자인 시스템 (색상, 간격, 텍스트 스타일, 테마).
- `lib/routes`: 중앙 집중식 라우팅 정의 (`app_routes.dart`).
- `lib/middlewares`: 라우트 진입 시 권한 체크 등을 수행하는 가드 로직.
- `lib/common`: 여러 도메인에서 공통으로 사용되는 배송/주문 로직 및 기사(Common) 앱의 핵심 기능.

### 도메인(기능)별 폴더
각 폴더는 독립적인 기능 단위를 나타내며, 내부적으로 `bindings`, `controllers`, `models`, `services`, `views` 구조를 가집니다.
- `lib/login`: 인증, 회원가입, 토큰 관리.
- `lib/owner`: 화주 전용 기능 (차량 등록, 미배차 목록 등).
- `lib/payment`: Toss Payments 연동 및 결제 결과 처리.
- `lib/wallet`: 정산 및 지갑 관리.
- `lib/map`: 네이버 지도 연동, 주소 검색 및 지오코딩.
- `lib/drive-list`: 기사용 운송 목록 및 인벤토리 관리.
- `lib/alarm` & `lib/chatting`: 알림 및 채팅 UI 스켈레톤.

## 2. 폴더별 역할군 (Role Definitions)
- `views/` (또는 `screens/`): UI 위젯. 비즈니스 로직은 포함하지 않고 Controller의 상태를 관찰하여 화면을 구성합니다.
- `controllers/` (또는 `controller/`): GetXController를 상속받은 ViewModel. UI 상태 관리 및 Service 호출을 담당합니다.
- `services/`: API 통신, 로컬 저장소 I/O 등 외부 데이터 소스와의 인터페이스를 담당합니다.
- `models/` (또는 `model/`): 데이터 구조 정의 및 JSON 직렬화/역직렬화.
- `bindings/` (또는 `binding/`): GetX의 의존성 주입(DI) 설정.

## 3. 신규 기능 추가 가이드라인
신규 기능을 추가할 때는 다음 단계를 따릅니다.

1. **도메인 결정**: 기존 도메인에 속하는지, 새로운 도메인 폴더를 생성해야 하는지 결정합니다.
2. **폴더 구조 생성**: 해당 도메인 내부에 `bindings`, `controllers`, `models`, `services`, `views` 폴더를 생성합니다.
   - *주의*: 기존 프로젝트에서 단수(`model`)와 복수(`models`)가 혼용되고 있으나, 가급적 해당 폴더의 기존 컨벤션을 따르거나 신규 폴더의 경우 복수형 사용을 권장합니다.
3. **의존성 주입**: `bindings`를 작성하고 `lib/routes/app_routes.dart`에 해당 페이지와 바인딩을 등록합니다.
4. **UI 구현**: `views`에 화면을 구현하며, `GetBuilder` 또는 `Obx`를 사용하여 상태 변화를 반영합니다.
5. **비즈니스 로직**: `services`에서 API를 정의하고 `controllers`에서 이를 호출하여 상태를 업데이트합니다.

## 4. 경로 추론 및 파일 찾기 규칙
파일 경로를 생략하고 파일명만 언급할 경우 다음 규칙에 따라 위치를 파악합니다.
- `*controller.dart` -> `lib/<domain>/controllers/`
- `*service.dart` -> `lib/<domain>/services/`
- `*model.dart` -> `lib/<domain>/models/`
- `*view.dart` 또는 `*screen.dart` -> `lib/<domain>/views/`
- `*binding.dart` -> `lib/<domain>/bindings/`

동일한 파일명이 여러 도메인에 존재할 경우, 현재 작업 중인 문맥(화주용 `owner`, 기사용 `common`, 결제 `payment` 등)을 우선순위로 둡니다.

## 5. 최종 확인 사항
- 모든 파일은 `Pretendard` 폰트와 `lib/core/design`에 정의된 테마를 준수해야 합니다.
- 로깅 시 `📌 [기능명]`, `🚀 [시작]`, `✅ [성공]`, `❌ [실패]` 접두사를 사용하여 흐름을 명시합니다.
- `flutter analyze`를 통해 린트 에러가 없는지 확인합니다.
