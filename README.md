<!-- README for Sandwich Shop Flutter app -->

# Sandwich Shop App

A compact Flutter demo app for creating simple sandwich orders. The UI lets users select sandwich size, pick a bread type, add notes, and increase or decrease quantity while seeing a live preview with emoji sandwiches. Includes navigation features, checkout screen, and authentication.

This repository is a Year 2 university project demonstrating Flutter UI, state management, navigation, reusable widgets, and widget tests.

---

## Key features

- Select sandwich size: six-inch or footlong (switch control).
- Choose bread: `white`, `wheat`, or `wholemeal` (dropdown).
- Add order notes using a `TextField` (e.g., "no onions").
- Increment / decrement quantity with bounds enforced by `OrderRepository`.
- Live order preview (`OrderItemDisplay`) showing count, bread, type, and emoji.
- Reusable `StyledButton` used for Add / Remove actions.
- Navigation drawer for accessing different screens.
- Checkout screen for reviewing cart items.
- Authentication/sign-in screen.
- About screen with app information.
- Widget tests that assert UI behaviour.

---

## Installation & Setup

### Prerequisites

- OS: Windows (project paths and desktop target present), but app also runs on mobile/web with proper setup.
- Flutter SDK (stable channel) — install from https://docs.flutter.dev/get-started/install
- Git
- Recommended IDE: Visual Studio Code
- If running Windows desktop target: Visual Studio with "Desktop development with C++" workload

Verify environment:

```powershell
flutter --version
git --version
```

### Clone the repository

```powershell
git clone <your-repo-url>
cd "sandwich_shop/sandwich_shop"
```

### Install dependencies

```powershell
flutter pub get
```

### Run the app

- Run on Windows desktop:

```powershell
flutter run -d windows
```

- Run on a connected device or emulator (list devices, then run):

```powershell
flutter devices
flutter run -d <device-id>
```

- Run on web (Chrome):

```powershell
flutter run -d chrome
```

---

## Usage

When the app starts you will see the order screen with a navigation drawer:

- **Navigation Drawer**: Access Order, Checkout, Sign In, and About screens.
- **Size toggle**: a `Switch` between six-inch and footlong. The UI displays `six-inch` on the left and `footlong` on the right.
- **Bread dropdown**: choose `white`, `wheat`, or `wholemeal`.
- **Notes**: add free-text notes in the `TextField` (e.g. "Extra mayo").
- **Add / Remove**: press the Add (plus) and Remove (minus) buttons to change quantity. The buttons become disabled when the repository prevents further increments/decrements.
- **Checkout**: navigate to checkout screen to review your cart items.

Important flows:

- Start with quantity 0. Tap Add to increase; the preview updates with sandwich emoji and text.
- If you reach `maxQuantity` (configured via `OrderScreen(maxQuantity: ...)`), Add will be disabled.
- Notes update the preview live.
- Use the navigation drawer to switch between screens.

### Running tests

Run widget tests with:

```powershell
flutter test
```

If tests fail, run `flutter analyze` and inspect the failing test output in `test/` directory.

---

## Project structure

Top-level structure:

- `lib/`
    - `main.dart` — app entry point with routing configuration.
    - `views/` — screen widgets
        - `app_styles.dart` — app text styles and theme.
        - `order_screen.dart` — main order creation screen.
        - `checkout_screen.dart` — checkout/cart review screen.
        - `auth_screen.dart` — sign-in screen.
        - `about_screen.dart` — about us screen.
    - `widgets/` — reusable widgets
        - `app_scaffold.dart` — reusable scaffold with navigation drawer.
        - `styled_button.dart` — custom button widget.
        - `order_item_display.dart` — order preview widget.
    - `models/` — data models (cart, order).
    - `repositories/` — business logic
        - `order_repository.dart` — order management and quantity bounds.
- `test/` — widget tests.
- `pubspec.yaml` — dependencies and assets.

Key files:

- `lib/main.dart`: app entry and routing configuration.
- `lib/views/order_screen.dart`: main UI and order creation logic.
- `lib/repositories/order_repository.dart`: business rules for quantity bounds and order management.
- `test/views/widget_test.dart`: automated tests for UI behaviour.

Dependencies (from `pubspec.yaml`):

- `flutter` (framework)
- `provider: ^6.0.0` (state management)
- See `pubspec.yaml` for the complete list.

Development tools: VS Code recommended for debugging and running tests.

---

## Contribution guidelines

- Fork the repository, make changes on a feature branch, and open a pull request.
- Keep changes focused and include tests for functional changes.

---

## Contact

- Author: Louis
- Email: up2266268@myport.ac.uk
- GitHub: https://github.com/lllouislouislouis

If you'd like help improving tests or adding CI, open an issue or PR with details.

---