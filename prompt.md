# Feature Request: Cart Item Modification

## Context
I have a Flutter sandwich shop application with the following structure:
- **Order Screen**: Users select sandwich type, size, bread type, and quantity, then add items to cart
- **Cart Screen**: Displays cart items with their details and total price
- **Models**: `Sandwich` (type, size, bread type) and `Cart` (manages items and pricing)
- **Repository**: `PricingRepository` for price calculations

## Required Features

### 1. Modify Item Quantity in Cart
**User Story**: As a user, I want to increase or decrease the quantity of an item already in my cart without removing it entirely.

**Acceptance Criteria**:
- Display increment (+) and decrement (-) buttons next to each cart item's quantity
- Increment button increases quantity by 1
- Decrement button decreases quantity by 1
- When quantity reaches 1 and user clicks decrement, the item should be removed from cart (see feature 2)
- Cart total price should update automatically when quantity changes
- Show a brief confirmation message (SnackBar) indicating the quantity change

### 2. Remove Item from Cart
**User Story**: As a user, I want to completely remove an item from my cart with a single action.

**Acceptance Criteria**:
- Display a delete/remove icon button for each cart item
- Clicking the button removes the item entirely, regardless of quantity
- Show a confirmation SnackBar message: "Item removed from cart"
- Cart total should update immediately
- If cart becomes empty, display message: "Your cart is empty"

### 3. Clear Entire Cart
**User Story**: As a user, I want to clear all items from my cart at once.

**Acceptance Criteria**:
- Add a "Clear Cart" button at the bottom of the cart screen
- Button should be disabled/hidden when cart is empty
- Clicking shows a confirmation dialog: "Are you sure you want to clear your cart?"
- If user confirms, remove all items and show SnackBar: "Cart cleared"
- If user cancels, close dialog without changes

### 4. Edit Item Details (Advanced)
**User Story**: As a user, I want to modify the sandwich configuration (size, bread type) of an item already in my cart.

**Acceptance Criteria**:
- Add an "Edit" button for each cart item
- Navigate to a modified order screen with current item details pre-filled
- User can modify size, bread type, and quantity
- "Update Cart" button replaces the original item with the modified version
- "Cancel" button returns to cart without changes
- Show SnackBar: "Item updated successfully"

## Technical Requirements
- Use the existing `Cart` model methods (add, remove, clear)
- Maintain consistency with current app styling (use `app_styles.dart`)
- Ensure all modifications trigger `setState()` or Provider notifications
- Write widget tests for each new feature
- Handle edge cases (empty cart, minimum quantities, etc.)

## UI Considerations
- Use Flutter's Material Design icons (Icons.add, Icons.remove, Icons.delete, Icons.edit)
- Ensure buttons are appropriately sized and spaced
- Display item price updates in real-time
- Maintain scrollable layout for carts with many items

Please implement these features following Flutter best practices, with clear code comments and proper error handling.