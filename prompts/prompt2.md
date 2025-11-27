# Sign-Up/Sign-In Screen Implementation

## Prompt:

I'm building a Flutter sandwich shop app and need to add a sign-up/sign-in screen. Here are the requirements:

### 1. Create a new screen
- Create a new screen called `AuthScreen` (or `SignInScreen`) in the `lib/views/` directory

### 2. Screen should include:
- A username text field
- A password text field (with obscured text)
- A "Sign In" button
- Simple form validation (fields shouldn't be empty)
- Basic styling consistent with the app's existing design using `app_styles.dart`

### 3. Navigation:
- Add a link/button at the bottom of `OrderScreen` that navigates to this new auth screen
- The button should follow the same `StyledButton` pattern used in the existing code

### 4. No actual authentication needed
- Just show a success message (SnackBar) when the user submits valid credentials

### 5. Follow the existing code patterns:
- Use `StatefulWidget`
- Use `TextEditingController` for form inputs
- Dispose controllers properly
- Follow the app's existing styling conventions

### Please provide the complete code for:
1. The new `AuthScreen` widget
2. The modifications needed to `order_screen.dart` to add the navigation button