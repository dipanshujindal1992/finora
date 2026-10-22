# Finora - Personal Finance Management App

A modern, production-ready personal finance management app built with Flutter and Dart. Finora helps users track their balance, income, expenses, transactions, budgets, and spending habits with a beautiful, premium fintech UI.

## Features

### 🏠 Home Dashboard
- Personalized greeting with user profile
- Total balance card with gradient design
- Monthly income, expenses, and savings summary
- Savings progress indicator
- Income vs Expenses bar chart (6 months)
- Spending by category donut chart
- Recent transactions list
- Quick actions: Add Income, Add Expense, Transfer, View Reports

### 💳 Transactions
- Complete transaction history with realistic mock data
- Search transactions by name
- Filter by type (All, Income, Expense)
- Filter by category and date range
- Add, edit, and delete transactions
- Swipe-to-delete with confirmation
- Empty states for filtered results

### 📊 Analytics & Reports
- Monthly income vs expenses comparison (6 months)
- Weekly spending bar chart
- Category-wise expense breakdown (donut chart + legend)
- Monthly savings rate indicator
- Smart financial insights based on spending patterns
- Month selection for historical data

### 💰 Budgets
- Create budgets for 6 categories (Food, Transport, Shopping, Bills, Entertainment, Health)
- Visual progress bars with color coding
- Over-budget and near-limit warnings
- Real-time spending updates from transactions
- Add, edit, and delete budgets
- Monthly budget summary

### ➕ Add Transaction
- Form with validation for amount, title, category, date, payment method
- Income/Expense type selector with visual cards
- Category selection with icon chips
- Date picker with calendar
- Payment method selector (UPI, Credit Card, Debit Card, etc.)
- Optional notes field
- Edit existing transactions

### 👤 Profile & Settings
- User profile with avatar
- Statistics overview (transactions count, total income/expenses)
- Theme selection (System, Light, Dark)
- Currency selection (INR, USD, EUR, GBP)
- Notification preferences
- Biometric authentication toggle
- Data export, privacy policy, terms of service
- Reset all data option

## Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget with navigation
├── core/
│   ├── theme/
│   │   └── app_theme.dart    # Material 3 light/dark themes
│   ├── constants/
│   │   └── app_constants.dart # App-wide constants
│   └── utils/
│       └── formatters.dart    # Currency, date, number formatting
├── models/
│   ├── models.dart            # Barrel export
│   ├── transaction_model.dart # Transaction entity + TransactionType enum
│   ├── budget_model.dart      # Budget entity
│   ├── category_model.dart    # CategoryType enum with icons/colors
│   └── user_model.dart        # UserProfile + AppThemeMode enum
├── data/
│   └── mock_data.dart         # 24 realistic transactions, 6 budgets, user profile
├── providers/
│   ├── app_providers.dart     # Riverpod state providers (transactions, budgets, filters, calculations)
│   └── settings_providers.dart # Theme/settings persistence with SharedPreferences
├── screens/
│   ├── home/
│   │   └── home_screen.dart   # Dashboard with balance, charts, recent transactions
│   ├── transactions/
│   │   └── transactions_screen.dart # Full transaction list with search/filter
│   ├── analytics/
│   │   └── analytics_screen.dart  # Charts and insights
│   ├── budgets/
│   │   └── budgets_screen.dart    # Budget management
│   ├── profile/
│   │   └── profile_screen.dart    # Settings and profile
│   └── add_transaction/
│       └── add_transaction_screen.dart # Transaction form
└── widgets/
    ├── balance_card.dart      # Gradient balance card
    ├── transaction_tile.dart  # Animated transaction list item
    ├── budget_progress_card.dart # Budget progress with warnings
    ├── charts.dart            # Bar charts, donut chart, legends
    ├── common_widgets.dart    # Reusable UI components
    └── bottom_navigation.dart # Navigation bar + FAB
```

### State Management
- **Riverpod** for reactive state management
- `StateNotifierProvider` for mutable lists (transactions, budgets)
- `Provider` for computed values (monthly totals, category spending, savings rate)
- `StateProvider` for UI state (selected month, filters)

### Data Flow
1. Mock data initialized in `MockData` class
2. Providers watch transaction/budget lists
3. Computed providers derive analytics (totals, charts data)
4. UI reacts to provider changes automatically
5. Settings persisted via `SharedPreferences`

### Theming
- **Material 3** with custom color schemes
- **Light theme**: Clean white/off-white with emerald primary
- **Dark theme**: Deep navy surfaces with emerald accents
- **System theme** support
- Consistent spacing, typography (Google Fonts Inter), and border radius
- Semantic colors for income (green), expense (red), warning (amber)

## Mock Data

The app includes 24 realistic transactions for October 2026:
- **Income**: Salary (₹65,000), Freelance (₹15,000), Dividends (₹2,450), Investment returns (₹5,000)
- **Expenses**: Groceries, dining, transport, shopping, bills, entertainment, health
- **Categories**: Food, Transport, Shopping, Bills, Entertainment, Health, Salary, Investment
- **6 Budgets** with limits and current spending
- **User Profile**: Priya Sharma with INR currency

All amounts in Indian Rupees (₹) with realistic merchant names.

## Getting Started

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher
- Android Studio / VS Code with Flutter extension

### Installation
```bash
# Clone the repository
cd finora

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Commands
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release
```

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.4.9 | State management |
| fl_chart | ^0.66.0 | Charts (bar, pie) |
| shared_preferences | ^2.2.2 | Settings persistence |
| intl | ^0.19.0 | Date/number formatting |
| uuid | ^4.2.1 | Unique ID generation |
| google_fonts | ^6.1.0 | Inter font family |
| lottie | ^3.0.0 | Animations (ready for future use) |

## Design System

### Colors
- **Primary**: Emerald 600 (#059669)
- **Income**: Emerald 500 (#10B981)
- **Expense**: Red 500 (#EF4444)
- **Warning**: Amber 500 (#F59E0B)
- **Surface**: Light (#FAFAFA) / Dark (#1C1B1F)

### Typography
- **Font**: Google Fonts Inter
- **Scale**: Material 3 type scale (Display, Headline, Title, Body, Label)

### Spacing
- Base unit: 4px
- Scale: XS(4), SM(8), MD(16), LG(24), XL(32)

### Border Radius
- Small: 8px, Medium: 12px, Large: 16px, XL: 20px, Circular: 24px

## Testing

```bash
# Run widget tests
flutter test

# Run with coverage
flutter test --coverage
```

## Important Notes

⚠️ **This is a demo app with mock data only.** No real banking connections, payment gateways, or backend services are implemented. All financial data is stored locally on the device.

## Future Enhancements

- [ ] Local database (SQLite/Hive) for persistent transactions
- [ ] Data export to CSV/PDF
- [ ] Recurring transactions
- [ ] Multiple accounts/wallets
- [ ] Cloud sync with Firebase
- [ ] Push notifications for bill reminders
- [ ] Advanced charts (trend lines, forecasts)
- [ ] Multi-language support
- [ ] Accessibility improvements

## Development Timeline (Retrospective)

> **Note**: All code was implemented in a single session on **2026-10-22**. The milestones below represent a retrospective organization of the work for project planning and documentation purposes. They do not reflect actual historical development dates.

### August 2026 (Planned: Foundation)
- [x] Project initialization and Flutter configuration
- [x] Core theme system (Material 3 light/dark)
- [x] Reusable UI widgets (charts, cards, form fields)
- [x] Data models (Transaction, Budget, Category, User)
- [x] Mock financial data (24 transactions, 6 budgets)

### September 2026 (Planned: Features)
- [x] Dashboard with balance, charts, quick actions
- [x] Bottom navigation (Home, Transactions, Analytics, Budgets, Profile)
- [x] Transaction management (search, filter, CRUD)
- [x] Budget tracking with progress monitoring
- [x] Analytics (charts, insights, savings rate)
- [x] Profile & Settings (theme, currency, notifications)

### October 2026 (Actual: Implementation & Polish)
- [x] Complete implementation of all features (2026-10-22)
- [x] Code formatting and static analysis
- [x] Widget test with SharedPreferences mock
- [x] Platform configurations (Android/iOS)
- [x] Documentation and GitHub release

## License

This project is for educational and demonstration purposes.