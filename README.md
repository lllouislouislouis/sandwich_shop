<!-- README for Sandwich Shop Flutter app -->

# Sandwich Shop App

A compact Flutter demo app for creating simple sandwich orders. The UI lets users select sandwich size, pick a bread type, add notes, and increase or decrease quantity while seeing a live preview with emoji sandwiches.

This repository is a Year 2 university project demonstrating Flutter UI, state management, small reusable widgets, and widget tests.

---

## Key features

- Select sandwich size: six-inch or footlong (switch control).
- Choose bread: `white`, `wheat`, or `wholemeal` (dropdown).
- Add order notes using a `TextField` (e.g., "no onions").
- Increment / decrement quantity with bounds enforced by `OrderRepository`.
- Live order preview (`OrderItemDisplay`) showing count, bread, type, and emoji.
- Reusable `StyledButton` used for Add / Remove actions.
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

When the app starts you will see a live order preview and controls:

- Size toggle: a `Switch` between six-inch and footlong. The UI displays `six-inch` on the left and `footlong` on the right.
- Bread dropdown: choose `white`, `wheat`, or `wholemeal`.
- Notes: add free-text notes in the `TextField` (e.g. "Extra mayo").
- Add / Remove: press the Add (plus) and Remove (minus) buttons to change quantity. The buttons become disabled when the repository prevents further increments/decrements.

Important flows:

- Start with quantity 0. Tap Add to increase; the preview updates with sandwich emoji and text.
- If you reach `maxQuantity` (configured via `OrderScreen(maxQuantity: ...)`), Add will be disabled.
- Notes update the preview live.

### Running tests

Run widget tests with:

```powershell
flutter test
```

If tests fail, run `flutter analyze` and inspect the failing test output in `test/views/widget_test.dart`.

---

## Project structure

Top-level structure (important folders/files):

- `lib/`
	- `main.dart` — main app entry. Contains `OrderScreen`, `StyledButton`, and `OrderItemDisplay`.
	- `repositories/` — contains `order_repository.dart` which enforces quantity bounds and exposes increment/decrement logic.
	- `viewa/app_styles.dart` — app text styles and theme snippets used in the UI.
- `test/` — widget tests for UI behaviour (e.g., quantity changes, dropdown selection, notes).
- `pubspec.yaml` — dependencies and assets.

Key files:

- `lib/main.dart`: UI, widgets, and glue logic for the sample app.
- `lib/repositories/order_repository.dart`: business rules for quantity, max limit, canIncrement/canDecrement methods.
- `test/views/widget_test.dart`: automated tests that verify core UI behaviour.

Dependencies (from `pubspec.yaml`):

- `flutter` (framework)
- other dependencies are minimal — check `pubspec.yaml` for the exact list used in the project.

Development tools: VS Code or Android Studio recommended for debugging and running tests.

---

Contribution guidelines

- Fork the repository, make changes on a feature branch, and open a pull request.
- Keep changes focused and include tests for functional changes.

---

## Contact

- Author: Louis
- Email: (up2266268@myport.ac.uk)
- GitHub: https://github.com/lllouislouislouis

If you'd like help improving tests or adding CI, open an issue or PR with details.

---