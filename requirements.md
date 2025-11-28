# Requirements Document: Cart Item Modification Feature

## 1. Feature Overview

### 1.1 Feature Name
Cart Item Management and Modification

### 1.2 Purpose
Enable users to modify their cart contents after adding items, providing flexibility to adjust orders before checkout. This reduces friction in the ordering process and improves user satisfaction by allowing corrections without requiring users to restart their order.

### 1.3 Scope
This feature encompasses all functionality related to modifying cart items including:
- Adjusting item quantities
- Removing items from the cart
- Editing item customizations (optional)
- Viewing updated prices and totals in real-time

### 1.4 Business Value
- Reduces cart abandonment by allowing easy modifications
- Improves user experience and satisfaction
- Decreases customer support requests related to order corrections
- Increases order accuracy and reduces refunds/remakes

---

## 2. User Stories

### 2.1 Quantity Adjustment

**US-001: Increase Item Quantity**
- **As a** customer
- **I want to** increase the quantity of an item already in my cart
- **So that** I can order multiple of the same sandwich without re-selecting it

**US-002: Decrease Item Quantity**
- **As a** customer
- **I want to** decrease the quantity of an item in my cart
- **So that** I can reduce my order size without removing the item entirely

**US-003: Auto-Remove at Zero Quantity**
- **As a** customer
- **I want** items to be automatically removed when quantity reaches zero
- **So that** my cart stays clean and only shows items I actually want

### 2.2 Item Removal

**US-004: Quick Remove Item**
- **As a** customer
- **I want to** completely remove an item from my cart with one action
- **So that** I can quickly correct my order without decreasing quantity multiple times

**US-005: Remove Confirmation**
- **As a** customer
- **I want to** see a confirmation before removing high-quantity items
- **So that** I don't accidentally delete items I meant to keep

**US-006: Empty Cart State**
- **As a** customer
- **I want to** see a helpful message when my cart is empty
- **So that** I know I need to add items before proceeding

### 2.3 Item Customization

**US-007: Edit Existing Item**
- **As a** customer
- **I want to** modify the customizations of an item already in my cart
- **So that** I can correct mistakes without removing and re-adding the item

**US-008: Cancel Edits**
- **As a** customer
- **I want to** cancel editing without saving changes
- **So that** I can review customization options without affecting my current order

### 2.4 Price Updates

**US-009: Real-Time Price Updates**
- **As a** customer
- **I want to** see prices update immediately when I modify items
- **So that** I always know my current order total

---

## 3. Acceptance Criteria

### 3.1 Quantity Adjustment Feature

**AC-001: Increase Quantity Button**
- [ ] A clearly visible "+" button is displayed next to each cart item
- [ ] Tapping "+" increases quantity by exactly 1
- [ ] Quantity change is reflected immediately in the UI
- [ ] Item subtotal updates instantly (quantity × unit price)
- [ ] Cart total recalculates and displays updated value
- [ ] Button has appropriate touch feedback (ripple/highlight)
- [ ] No upper limit on quantity (or reasonable limit like 99)

**AC-002: Decrease Quantity Button**
- [ ] A clearly visible "-" button is displayed next to each cart item
- [ ] Tapping "-" decreases quantity by exactly 1
- [ ] Quantity change is reflected immediately in the UI
- [ ] Item subtotal updates instantly
- [ ] Cart total recalculates automatically
- [ ] Button is disabled when quantity is 1 (or becomes a remove action)
- [ ] Button has appropriate touch feedback

**AC-003: Remove at Zero Quantity**
- [ ] When quantity reaches 0, item is removed from cart
- [ ] Removal animation is smooth and clear
- [ ] Cart total updates to reflect removal
- [ ] If cart becomes empty, empty state is displayed
- [ ] No error or crash occurs during removal

**AC-004: Quantity Display**
- [ ] Current quantity is clearly visible between +/- buttons
- [ ] Quantity display updates in real-time
- [ ] Font size is readable and consistent
- [ ] Quantity is properly aligned with buttons

### 3.2 Item Removal Feature

**AC-005: Remove Button Functionality**
- [ ] Remove button (trash icon or text) is visible on each cart item
- [ ] Button is distinguishable from quantity controls
- [ ] Tapping button removes item immediately (or shows confirmation)
- [ ] Removal works regardless of current quantity
- [ ] Cart total updates immediately after removal
- [ ] UI provides smooth transition/animation

**AC-006: Confirmation Dialog (Optional)**
- [ ] Dialog appears for items with quantity > 1
- [ ] Dialog clearly states item name and quantity being removed
- [ ] "Confirm" and "Cancel" options are clearly labeled
- [ ] Tapping "Cancel" closes dialog without changes
- [ ] Tapping "Confirm" removes item and closes dialog
- [ ] Dialog is dismissible by tapping outside (cancels action)

**AC-007: Removal Feedback**
- [ ] Snackbar appears confirming removal
- [ ] Snackbar displays item name that was removed
- [ ] "Undo" option is available in snackbar (5-second window)
- [ ] Tapping "Undo" restores item with original quantity
- [ ] Snackbar auto-dismisses after timeout

**AC-008: Empty Cart State**
- [ ] When last item is removed, empty state message displays
- [ ] Message is clear and helpful (e.g., "Your cart is empty")
- [ ] Optional: Display a button to return to order screen
- [ ] Optional: Show image/icon for visual appeal
- [ ] Cart total shows $0.00 or is hidden

### 3.3 Edit Customizations Feature (Optional)

**AC-009: Edit Button Display**
- [ ] "Edit" button/icon is visible on each cart item
- [ ] Button is distinguishable from other controls
- [ ] Button label/icon clearly indicates edit functionality

**AC-010: Edit Navigation**
- [ ] Tapping "Edit" navigates to customization screen
- [ ] Current customizations are pre-selected/displayed
- [ ] Item name and base price are visible
- [ ] User can modify any available customizations

**AC-011: Save Edited Item**
- [ ] "Save" button is clearly visible
- [ ] Tapping "Save" updates cart item with new customizations
- [ ] Price recalculates based on new selections
- [ ] User returns to cart screen
- [ ] Updated item displays new customizations and price

**AC-012: Cancel Edit**
- [ ] "Cancel" or back button is available
- [ ] Tapping cancel returns to cart without changes
- [ ] Original item customizations remain unchanged
- [ ] No unintended side effects occur

### 3.4 Technical Requirements

**AC-013: State Management**
- [ ] Cart state persists across screen navigation
- [ ] Changes to cart are immediately reflected on all screens
- [ ] No race conditions or state inconsistencies
- [ ] Cart survives app backgrounding (within session)

**AC-014: Price Calculations**
- [ ] All prices use appropriate decimal precision (2 decimal places)
- [ ] No rounding errors in calculations
- [ ] Currency symbol displays correctly ($)
- [ ] Subtotals and totals always match mathematical accuracy
- [ ] Tax calculations (if applicable) are correct

**AC-015: Performance**
- [ ] UI updates occur within 100ms of user action
- [ ] No visible lag when modifying cart items
- [ ] Smooth animations (60fps) during transitions
- [ ] App remains responsive with 50+ cart items

**AC-016: Error Handling**
- [ ] No crashes occur during any cart operation
- [ ] Invalid states are prevented (negative quantities, null items)
- [ ] Appropriate error messages for edge cases
- [ ] Graceful degradation if state becomes corrupted

**AC-017: Accessibility**
- [ ] All buttons have semantic labels for screen readers
- [ ] Touch targets meet minimum size requirements (44x44pt)
- [ ] Color contrast meets WCAG AA standards
- [ ] Keyboard navigation works (if applicable)

### 3.5 UI/UX Requirements

**AC-018: Visual Design**
- [ ] Cart items are clearly distinguishable from each other
- [ ] Active/pressed states are visually apparent
- [ ] Disabled states are visually distinct
- [ ] Layout is consistent with existing app design
- [ ] Responsive layout works on different screen sizes

**AC-019: User Feedback**
- [ ] Loading states shown for async operations (if any)
- [ ] Success feedback for completed actions
- [ ] Clear visual indication of current cart state
- [ ] Animations enhance rather than hinder usability

---

## 4. Out of Scope

The following items are explicitly NOT included in this feature:
- Checkout and payment processing
- Order history or saved carts
- User authentication or account management
- Sharing carts with other users
- Promotional codes or discounts
- Multiple cart management
- Delivery scheduling

---

## 5. Dependencies

- Existing Order Screen functionality must be working
- Existing Cart Screen must display items correctly
- Sandwich item data model must include customization fields
- State management solution must be implemented

---

## 6. Testing Requirements

### 6.1 Unit Tests
- [ ] Cart state management logic
- [ ] Price calculation functions
- [ ] Quantity increase/decrease logic
- [ ] Item removal logic

### 6.2 Widget Tests
- [ ] Quantity buttons render correctly
- [ ] Remove button renders correctly
- [ ] Cart item displays correctly
- [ ] Empty cart state displays correctly

### 6.3 Integration Tests
- [ ] Add item, modify quantity, verify total
- [ ] Remove item, verify cart updates
- [ ] Edit item, verify changes persist
- [ ] Empty cart, verify empty state

### 6.4 Manual Testing
- [ ] Test on multiple device sizes
- [ ] Verify animations are smooth
- [ ] Test rapid button tapping
- [ ] Test with network interruption (if applicable)

---

## 7. Success Metrics

- Cart modification completion rate > 90%
- Average time to modify cart < 10 seconds
- Cart abandonment rate decreases by 15%
- Zero critical bugs in production within first month
- User satisfaction score for cart functionality > 4.5/5

---

## 8. Release Criteria

This feature is considered complete and ready for release when:
- All acceptance criteria marked as complete
- All unit and integration tests passing
- Manual testing completed on iOS and Android
- No P0 or P1 bugs remaining
- Code review approved
- Documentation updated



# Requirements Document: Sign-Up/Sign-In Screen

## 1. Feature Description

### Overview
This feature adds a dedicated authentication screen to the Flutter sandwich shop application, allowing users to enter their credentials before accessing the ordering system.

### Purpose
- Provide a user interface for entering username and password credentials
- Establish a foundation for future authentication and user management features
- Create a professional entry point to the application
- Demonstrate form validation and navigation patterns in Flutter

### Scope
This is a **Phase 1 implementation** focusing on UI/UX only:
- No backend authentication
- No data persistence
- No password encryption
- Basic client-side validation only

## 2. User Stories

### User Story 1: First-Time User Sign-In
**As a** new customer visiting the sandwich shop app  
**I want to** see a sign-in screen when I access the app  
**So that** I can enter my credentials to access the ordering system

**Acceptance Criteria:**
- User sees a clean, professional sign-in interface
- Username and password fields are clearly labeled
- Password field obscures entered text
- Sign-in button is prominently displayed

### User Story 2: Entering Credentials
**As a** user attempting to sign in  
**I want to** enter my username and password  
**So that** I can proceed to order sandwiches

**Acceptance Criteria:**
- Username field accepts alphanumeric input
- Password field masks characters as they are typed
- Both fields support standard text editing (cut, copy, paste)
- Keyboard appears automatically when field is tapped

### User Story 3: Form Validation
**As a** user submitting the sign-in form  
**I want to** receive feedback if my input is invalid  
**So that** I know what needs to be corrected

**Acceptance Criteria:**
- Cannot submit with empty username field
- Cannot submit with empty password field
- Clear error messages appear for invalid submissions
- Sign-in button is disabled or shows validation errors

### User Story 4: Successful Sign-In
**As a** user with valid credentials  
**I want to** receive confirmation when I successfully sign in  
**So that** I know my credentials were accepted

**Acceptance Criteria:**
- Success message appears after valid submission
- User receives visual feedback (SnackBar or dialog)
- Navigation to next screen occurs after confirmation

### User Story 5: Accessing Sign-In from Order Screen
**As a** user on the order screen  
**I want to** easily navigate to the sign-in screen  
**So that** I can manage my authentication status

**Acceptance Criteria:**
- Clear button/link at bottom of order screen
- Button follows existing app styling patterns
- Navigation is smooth and intuitive
- User can return to order screen after authentication

## 3. Acceptance Criteria

### 3.1 Screen Implementation

#### AC-1.1: File Structure
- [ ] New file created at `lib/views/auth_screen.dart`
- [ ] File follows existing project naming conventions
- [ ] Proper imports included (material.dart, app_styles.dart, etc.)

#### AC-1.2: Widget Structure
- [ ] Screen implemented as `StatefulWidget`
- [ ] Appropriate state management for form fields
- [ ] Proper widget lifecycle methods implemented

#### AC-1.3: UI Components
- [ ] Screen includes username TextField
- [ ] Screen includes password TextField with `obscureText: true`
- [ ] Screen includes submit button labeled "Sign In"
- [ ] Layout is responsive and centered
- [ ] Components follow existing app styling from `app_styles.dart`

### 3.2 Form Functionality

#### AC-2.1: Text Controllers
- [ ] `TextEditingController` created for username field
- [ ] `TextEditingController` created for password field
- [ ] Controllers properly initialized in `initState()`
- [ ] Controllers properly disposed in `dispose()`

#### AC-2.2: Validation Logic
- [ ] Username field validates non-empty input
- [ ] Password field validates non-empty input
- [ ] Validation occurs on form submission
- [ ] Clear error messages displayed for invalid input
- [ ] Error messages follow app's text styling

#### AC-2.3: Submit Behavior
- [ ] Submit button only enabled when both fields have content
- [ ] Pressing submit with valid input shows success SnackBar
- [ ] Success message displays for 2-3 seconds
- [ ] Form clears after successful submission (optional)

### 3.3 Navigation Implementation

#### AC-3.1: Navigation from Order Screen
- [ ] Button added to bottom of `OrderScreen` widget tree
- [ ] Button uses `StyledButton` component pattern
- [ ] Button label clearly indicates "Sign In" or "Account"
- [ ] Button includes appropriate icon (e.g., `Icons.login` or `Icons.person`)
- [ ] Button positioned within `SingleChildScrollView` for accessibility

#### AC-3.2: Navigation Behavior
- [ ] Tapping button navigates to `AuthScreen` using `Navigator.push()`
- [ ] MaterialPageRoute used for navigation
- [ ] Back button returns user to `OrderScreen`
- [ ] Navigation animation is smooth (default Flutter transition)

### 3.4 Code Quality

#### AC-4.1: Code Standards
- [ ] Code follows Dart style guidelines
- [ ] Proper const constructors used where applicable
- [ ] No unused imports or variables
- [ ] Meaningful variable and function names

#### AC-4.2: Consistency
- [ ] Styling matches existing app theme
- [ ] Component patterns match existing code (e.g., `StyledButton`)
- [ ] Spacing and layout consistent with `OrderScreen`
- [ ] Colors and fonts from `app_styles.dart` used throughout

#### AC-4.3: Best Practices
- [ ] No memory leaks (controllers disposed)
- [ ] Proper use of BuildContext
- [ ] Appropriate use of const and final keywords
- [ ] Widget tree optimized (no unnecessary rebuilds)

### 3.5 User Experience

#### AC-5.1: Visual Feedback
- [ ] User receives immediate feedback on interactions
- [ ] Loading states indicated if applicable
- [ ] Success/error messages are clear and helpful
- [ ] UI remains responsive during all operations

#### AC-5.2: Accessibility
- [ ] Text fields have proper labels for screen readers
- [ ] Touch targets meet minimum size requirements (48x48 dp)
- [ ] Color contrast meets accessibility standards
- [ ] Keyboard navigation works properly

## 4. Technical Specifications

### 4.1 Dependencies
- No new dependencies required
- Uses existing Flutter material library
- Uses existing app_styles.dart for consistency

### 4.2 File Modifications
1. **New File**: `lib/views/auth_screen.dart`
   - Contains `AuthScreen` StatefulWidget
   - Contains `_AuthScreenState` private state class

2. **Modified File**: `lib/views/order_screen.dart`
   - Add navigation button in build method
   - Import auth_screen.dart

### 4.3 State Management
- Local state management using StatefulWidget
- TextEditingController for form field state
- No global state changes required

## 5. Future Considerations

### Phase 2 Enhancements (Not in Current Scope)
- Backend authentication integration
- Password strength requirements
- "Forgot Password" functionality
- "Remember Me" option
- Biometric authentication
- User session management
- Secure credential storage
- Sign-up vs Sign-in mode toggle

### Technical Debt
- Authentication logic placeholder for future implementation
- Consider moving to separate auth service layer
- May need to refactor when adding real authentication

## 6. Success Metrics

### Completion Criteria
The feature is considered complete when:
1. All acceptance criteria are met
2. Code compiles without errors or warnings
3. Manual testing confirms all user stories work as expected
4. Code review approved by team member or instructor
5. Documentation updated (if applicable)

### Testing Checklist
- [ ] Username field accepts input correctly
- [ ] Password field obscures text correctly
- [ ] Empty field validation works
- [ ] Success message appears on valid submission
- [ ] Navigation to/from auth screen works
- [ ] Back button behavior is correct
- [ ] No console errors or warnings
- [ ] UI looks correct on different screen sizes
- [ ] TextControllers properly disposed (no memory leaks)