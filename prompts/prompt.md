# Feature Request: Cart Item Modification for Flutter Sandwich Shop App

## Context
I have a Flutter sandwich shop application with two main screens:
- **Order Screen**: Users browse and select sandwiches to add to their cart
- **Cart Screen**: Users view their selected items and see the total price

## Objective
Implement cart modification functionality to allow users to manage items in their cart before checkout.

## Required Features

### 1. Change Item Quantity
**Description**: Users should be able to increase or decrease the quantity of items already in their cart.

**User Actions**:
- Tap a "+" button to increase quantity by 1
- Tap a "-" button to decrease quantity by 1
- If quantity reaches 0 via the "-" button, the item should be removed from the cart

**Expected Behavior**:
- Quantity changes should immediately update the item's subtotal
- The cart total should recalculate automatically
- Minimum quantity should be 1 (or 0 if removing)
- Display a visual confirmation of the quantity change

### 2. Remove Item from Cart
**Description**: Users should be able to completely remove an item from their cart regardless of quantity.

**User Actions**:
- Tap a "Remove" or trash icon button next to the cart item
- Optional: Show a confirmation dialog before removing

**Expected Behavior**:
- Item should be immediately removed from the cart
- Cart total should recalculate automatically
- If the cart becomes empty, display an appropriate empty state message
- Optional: Show a snackbar with "Item removed" message and optional "Undo" action

### 3. Edit Item Customizations (Optional Enhancement)
**Description**: Users can modify sandwich customizations (toppings, bread type, etc.) for items already in the cart.

**User Actions**:
- Tap an "Edit" button on the cart item
- Navigate to a modification screen with current selections pre-filled
- Save changes to update the cart item

**Expected Behavior**:
- Original item should be replaced with the modified version
- Price should update based on new customizations
- User can cancel without making changes

## Technical Requirements
- State management should keep the cart synchronized across screens
- All price calculations should handle decimal values correctly
- UI should be responsive and provide immediate feedback
- Consider using Flutter's built-in widgets (ListView, Card, IconButton, etc.)

## Current Project Setup
- Flutter SDK: >=2.17.0 <4.0.0
- Minimal dependencies (cupertino_icons only)
- Material Design enabled

Please provide complete, working Flutter code with explanations for implementing these cart modification features.