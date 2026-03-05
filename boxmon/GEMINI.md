# Boxmon Flutter Project Overview

이 문서는 Flutter 기반의 모바일 애플리케이션 프로젝트인 "Boxmon"의 개요, 주요 기술 스택, 아키텍처 및 개발 컨벤션을 설명합니다.

## 프로젝트 개요

Boxmon 프로젝트는 Flutter 프레임워크를 사용하여 개발된 모바일 애플리케이션입니다. GetX를 통한 상태 관리 및 라우팅, Dio를 통한 API 통신, 그리고 명확한 디자인 시스템을 특징으로 합니다. MVVM(Model-View-ViewModel) 아키텍처 패턴을 적극적으로 활용하여 코드의 유지보수성과 확장성을 높였습니다.

### 주요 기능 (예상)

*   사용자 및 사업자 로그인/회원가입 기능
*   Splash 화면
*   사용자 및 사업자 홈, 주문, 설정 화면
*   API를 통한 백엔드 시스템과의 연동

### 주요 기술 스택

*   **프레임워크:** Flutter
*   **상태 관리 및 라우팅:** GetX
*   **HTTP 통신:** Dio
*   **로컬 스토리지:** `get_storage`, `shared_preferences`, `flutter_secure_storage`
*   **보안:** `bcrypt` (비밀번호 해싱 관련)
*   **아이콘:** `hugeicons`
*   **폰트:** Pretendard

## 아키텍처: Feature-First MVVM

프로젝트는 기능(Feature) 중심의 MVVM 패턴을 기반으로 다음과 같이 구조화되어 있습니다.

*   **`lib/core`**: 앱 전반에 걸쳐 사용되는 공통적인 요소들을 포함합니다.
    *   `components`: 재사용 가능한 위젯 및 전역 UI 요소.
    *   `design`: 디자인 시스템 (색상, 간격, 텍스트 스타일, 테마 등) 정의.
*   **`lib/[feature]`**: 각 기능(도메인)별로 독립적인 폴더를 구성합니다. (예: `login`, `owner`, `payment`, `wallet` 등)
    *   `views`: 화면 UI 위젯.
    *   `controllers`: GetX Controller 기반의 ViewModel. UI 상태 관리 및 서비스 호출.
    *   `services`: 외부 API 통신 및 데이터 처리 로직.
    *   `models`: 데이터 모델 및 DTO 정의.
    *   `bindings`: GetX 의존성 주입(DI) 설정.
*   **`lib/common`**: 여러 도메인에서 공유하거나 기사 앱의 기본 기능을 담은 공통 도메인.
*   **`lib/routes` & `lib/middlewares`**: 앱의 라우팅 체계 및 접근 제어 로직 관리.

## 빌드 및 실행


### 프로젝트 의존성 설치

프로젝트에 필요한 모든 Dart 패키지를 설치합니다.

```bash
flutter pub get
```

### 앱 실행

개발 모드로 앱을 실행합니다.

```bash
flutter run
```

### 빌드

각 플랫폼(Android, iOS 등)에 맞는 배포용 빌드를 생성합니다.

```bash
flutter build apk # Android APK 빌드
flutter build ios # iOS 앱 빌드 (macOS 필요)
flutter build appbundle # Android App Bundle 빌드
```

## 개발 컨벤션

### 코드 스타일 및 린트

*   `analysis_options.yaml` 파일을 통해 `package:flutter_lints/flutter.yaml`에서 권장하는 린트 규칙을 따릅니다.
*   코드 일관성과 품질 유지를 위해 `flutter analyze` 명령어를 주기적으로 실행하여 린트 오류 및 경고를 확인합니다.

### 라우팅

*   GetX의 라우팅 시스템을 사용하며, 모든 라우트는 `lib/routes/app_routes.dart`에 중앙 집중식으로 정의됩니다.
*   `GetPage`를 통해 라우트 이름, 페이지 위젯, 그리고 바인딩을 명시합니다.

### 상태 관리

*   GetX Controller를 사용하여 MVVM 패턴의 ViewModel 역할을 수행합니다.
*   Controller 내에서 `TextEditingController`와 같은 리소스는 `onClose` 메서드에서 반드시 `dispose()`하여 메모리 누수를 방지합니다.

### 디자인 시스템

*   `lib/core/design` 폴더 내에서 색상(`app_colors.dart`), 간격(`app_spacing.dart`), 텍스트 스타일(`app_text_styles.dart`), 보더 라디우스(`app_border_radius.dart`), 앱 테마(`app_theme.dart`) 등을 별도로 관리하여 디자인 일관성을 유지합니다.
*   `Pretendard` 폰트가 앱 전반에 걸쳐 사용됩니다.

### 로깅

*   API 통신(`Dio`) 및 중요한 비즈니스 로직 처리 시 `debugPrint`를 사용하여 상세한 로그를 남깁니다. (예: `AuthController`의 `commonSignup` 메서드)
*   로그 메시지에는 `📌 [기능명]`, `🚀 [기능명]`, `📥 [기능명]`, `📦 [기능명]`, `✅ [기능명]`, `⚠️ [기능명]`, `❌ [기능명]`, `🏁 [기능명]`과 같은 접두사를 사용하여 로그의 목적과 흐름을 명확히 합니다.

### API 통신

*   Dio 패키지를 사용하여 API 요청을 처리합니다. Dio 인터셉터를 활용하여 요청/응답 로그를 상세하게 기록하고, 인증 토큰 추가, 오류 처리 등을 구현할 수 있습니다.
*   `AuthService`와 같은 서비스 클래스에서 실제 API 호출 로직을 담당합니다.
