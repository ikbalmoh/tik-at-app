# GEMINI.md - Project gartix (eTiket Pariwisata)

## Project Overview
**gartix** is a Flutter-based e-Ticketing application designed for the tourism industry. It is developed and copyrighted by **CV. Airy**. The application manages ticket sales, user authentication, and hardware integration (specifically bluetooth thermal printers) for ticket issuance.

### Core Technologies
- **Framework:** [Flutter](https://flutter.dev/) (SDK >= 3.2.1)
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Routing:** [GetX](https://pub.dev/packages/get)
- **Networking:** [Dio](https://pub.dev/packages/dio)
- **Local Storage:** [GetStorage](https://pub.dev/packages/get_storage)
- **Data Modeling:** [Freezed](https://pub.dev/packages/freezed), [Json Serializable](https://pub.dev/packages/json_serializable), and [Equatable](https://pub.dev/packages/equatable)
- **UI & Layout:** [Responsive Framework](https://pub.dev/packages/responsive_framework)
- **Backend Services:** Firebase (Core, Analytics, Crashlytics)
- **Hardware Integration:** [Blue Thermal Printer](https://pub.dev/packages/blue_thermal_printer) (Bluetooth)

---

## Architecture & Design Patterns
The project follows a **Modular Pattern** using GetX for state management, dependency injection, and routing.

### Directory Structure
- `lib/core/`: Application-wide core configurations.
    - `routes/`: Centralized routing configuration and middleware using GetX.
- `lib/modules/`: Domain-specific modules (auth, setting, splash, ticket, transaction).
    - Each module typically follows this internal structure:
        - `controller/`:
            - `<module>_controller.dart`: GetxController for business logic.
            - `<module>_bindings.dart`: GetX bindings for dependency injection.
            - `<module>_service.dart`: API/External service interactions.
            - `<module>_state.dart`: State definitions (using Equatable or Freezed).
            - `<module>.dart`: Barreled exports for the controller directory.
        - `model/`: Data models specific to the module (using Freezed).
        - `widget/`: UI implementation, including screens and a `components/` subdirectory for sub-widgets.
- `lib/shared/`: Shared resources and utilities.
    - `components/`: Generic, reusable UI components.
    - `data/`: Shared constants like colors and network-related constants.
    - `utils/`: Common utilities (networking, formatting, theme, etc.).

### Networking Flow
- Centralized Dio configuration in `lib/shared/utils/fetch.dart` via the `fetch()` function.
- **CustomInterceptors:**
    - `onRequest`: Dynamically sets `baseUrl` from `GetStorage` and adds `Authorization` Bearer token.
    - `onError`: Processes error messages and handles 401 Unauthorized status by clearing authentication via `AuthController`.

### State Management
- Uses GetX `GetxController` with reactive state (`.obs`).
- UI components use `Obx` or `GetBuilder` to react to state changes.
- Controllers are injected using `Bindings` and accessed via `Get.find()`.

---

## Development Conventions

### Coding Style
- Follow standard Flutter/Dart linting rules (enforced by `analysis_options.yaml`).
- Use GetX for state management, dependency injection, and navigation.
- Use `Obx` for fine-grained reactive UI updates.

### Data Modeling
- Use `Freezed` for complex data models to ensure immutability and easy JSON serialization.
- Use `Equatable` for simple state classes where value equality is needed without the full boilerplate of Freezed.
- Run the build runner after modifying models:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

### Naming Conventions
- Modules: lowercase (e.g., `lib/modules/auth`).
- Files: snake_case (e.g., `auth_controller.dart`).
- Controllers: camelCase (e.g., `AuthController`).

---

## Building and Running

### Prerequisites
- Flutter SDK installed and configured.
- Android/iOS development environment (Android is required for thermal printer features).
- FVM (Flutter Version Management) is used in this project (noted by `.fvmrc`).

### Key Commands
- **Install Dependencies:** `flutter pub get`
- **Run in Debug Mode:** `flutter run`
- **Generate Code (Freezed):** `flutter pub run build_runner build`
- **Run Tests:** `flutter test`
- **Build Android:** `flutter build apk`

---

## Key Workflows

### 1. App Initialization
- `main.dart` initializes Firebase and core services (`initServices()`).
- Core controllers like `SettingController` and `AuthController` are registered globally using `Get.put()`.
- `App` (in `lib/app.dart`) configures `GetMaterialApp` with routes and initial bindings.

### 2. Printer Management (Android Only)
- Managed by `SettingController`.
- Handles bluetooth printer discovery and connection.
- Stores printer configuration in `GetStorage`.

### 3. API Configuration
- Managed by `SettingController`.
- Users can update the API base URL in settings, which is then persisted in `GetStorage` and used dynamically by the `fetch()` utility.
