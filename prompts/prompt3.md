# Feature Request: Navigation Drawer Implementation

## Overview
Implement a reusable navigation Drawer widget that slides in from the left side of the screen and is accessible from all screens in the Flutter sandwich shop app.

## Requirements

### 1. Drawer Structure
- **Header Section**: Display app branding
  - App logo (use existing logo from assets/images/logo.png)
  - App name: "Sandwich Shop"
  - Background color: Orange (matching app theme)

- **Navigation Items**: Four main menu options with icons
  - 🍔 Order (restaurant_menu icon)
  - 🛒 Checkout (shopping_cart icon)
  - 👤 Sign In (login icon)
  - ℹ️ About Us (info icon)

### 2. User Interactions

**When user taps "Order":**
- Close the drawer
- Navigate to OrderScreen (home screen)
- If already on OrderScreen, just close drawer

**When user taps "Checkout":**
- Close the drawer
- Check if cart has items
- If cart is empty, show SnackBar: "Your cart is empty. Add items before checking out."
- If cart has items, navigate to CheckoutScreen with current cart

**When user taps "Sign In":**
- Close the drawer
- Navigate to AuthScreen
- If already signed in (future enhancement), show "Already signed in as [username]"

**When user taps "About Us":**
- Close the drawer
- Navigate to AboutScreen

### 3. Implementation Approach

**Create a Reusable Widget:**
- Create `AppScaffold` widget in `lib/widgets/app_scaffold.dart`
- Widget should accept: title (String), body (Widget), optional floatingActionButton
- Should include the AppBar and Drawer automatically
- Reduces code duplication across all screens

**Update All Screens:**
- Replace `Scaffold` with `AppScaffold` in:
  - OrderScreen
  - CheckoutScreen
  - AuthScreen
  - AboutScreen

**Update main.dart:**
- Define named routes for all screens:
  - `/` → OrderScreen
  - `/checkout` → CheckoutScreen (requires cart argument)
  - `/auth` → AuthScreen
  - `/about` → AboutScreen

### 4. Technical Details

**Drawer Behavior:**
- Automatically add hamburger menu icon to AppBar
- Swipe from left edge should also open drawer
- Tapping outside drawer or back button should close it
- Use `Navigator.pop(context)` to close drawer before navigation
- Use `Navigator.pushReplacementNamed()` for main navigation to prevent stack buildup

**Cart Access:**
- Use Provider pattern to access cart from any screen
- Import: `Provider.of<Cart>(context, listen: false)` to get cart instance
- Check cart item count before allowing checkout navigation

**Styling:**
- Match existing app theme (orange accent color)
- Use existing text styles from app_styles.dart
- Maintain consistent padding and spacing

### 5. Files to Create/Modify

**New File:**
- `lib/widgets/app_scaffold.dart` - Reusable scaffold with drawer

**Files to Modify:**
- `lib/main.dart` - Update routing configuration
- `lib/views/order_screen.dart` - Replace Scaffold with AppScaffold
- `lib/views/checkout_screen.dart` - Replace Scaffold with AppScaffold
- `lib/views/auth_screen.dart` - Replace Scaffold with AppScaffold
- `lib/views/about_screen.dart` - Replace Scaffold with AppScaffold

### 6. Error Handling
- Handle navigation to checkout with empty cart gracefully
- Ensure cart state persists across navigation
- Handle back button press appropriately

### 7. Future Considerations
- Add visual indicator for current screen in drawer
- Disable/highlight navigation items based on current route
- Add user profile section in drawer header when signed in