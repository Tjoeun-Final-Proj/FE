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

## 아키텍처: MVVM (Model-View-ViewModel)

프로젝트는 MVVM 패턴을 기반으로 다음과 같이 구조화되어 있습니다.

*   **`lib/core`**: 앱 전반에 걸쳐 사용되는 공통적인 요소들을 포함합니다.
    *   `components`: 재사용 가능한 위젯 및 UI 요소.
    *   `design`: 디자인 시스템 (색상, 간격, 텍스트 스타일, 보더 라디우스, 테마 등)을 정의하여 일관된 UI/UX를 보장합니다.
*   **`lib/data`**: 데이터 처리 및 저장 로직을 담당합니다.
    *   `datasource`: API 통신(`remote`) 또는 로컬 데이터베이스(`local`)와 같은 특정 데이터 소스와의 상호작용을 정의합니다.
    *   `repository`: `domain` 계층의 리포지토리 인터페이스를 구현하며, 여러 데이터 소스(`datasource`)로부터 데이터를 가져와 `domain` 계층으로 전달합니다.
*   **`lib/domain`**: 앱의 핵심 비즈니스 로직을 정의합니다.
    *   `entity`: 앱의 핵심 데이터 모델.
    *   `repository`: 데이터 소스에 대한 추상화된 인터페이스.
    *   `usecase`: 특정 비즈니스 로직을 수행하는 단일 책임 원칙을 따르는 클래스. `repository` 인터페이스를 사용하여 데이터를 조작합니다.
*   **`lib/presentation`**: 사용자 인터페이스(UI) 및 UI 로직을 담당합니다.
    *   `views`: 화면에 표시되는 위젯.
    *   `controllers`: GetX Controller로 구현되며, `ViewModel` 역할을 수행합니다. `View`와 `domain` 계층(`usecase`) 사이의 상호작용을 관리하고, `View`의 상태를 업데이트합니다.
    *   `bindings`: GetX 의존성 주입(Dependency Injection)을 설정하여 `Controller`와 `Service` 등을 초기화하고 연결합니다.

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
