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

> **Note**: All code was implemented in a single session on **2026-10-22**. The milestones below represent a retrospective organization of the work for project planning and documentation purposes. They do not reflect actual historical development dates. The detailed entries below are **proposed/planned milestones** for documentation purposes only.

### Commit-to-Milestone Mapping

The 15 commits in this repository map to the following retrospective milestones:

| Commit | Date | Milestone | Phase |
|--------|------|-----------|-------|
| `7b685dd` | 2026-10-22 | Project initialization & Flutter configuration | August: Foundation |
| `4baa1a4` | 2026-10-22 | Data models & mock financial data | August: Foundation |
| `410ef8f` | 2026-10-22 | Core theme, constants, formatters | August: Foundation |
| `0fb4a69` | 2026-10-22 | Reusable finance dashboard widgets | August: Foundation |
| `bb29ff3` | 2026-10-22 | Riverpod state management providers | September: Technical Planning |
| `5c9c77c` | 2026-10-22 | App entry point & bottom navigation | September: Technical Planning |
| `433451f` | 2026-10-22 | Home dashboard screen | September: Feature Specifications |
| `392a472` | 2026-10-22 | Transaction management (CRUD, search, filter) | September: Feature Specifications |
| `828c82f` | 2026-10-22 | Budget tracking with progress monitoring | September: Feature Specifications |
| `ac03188` | 2026-10-22 | Analytics & reports with charts | September: Feature Specifications |
| `1e89c07` | 2026-10-22 | Profile & settings screen | September: Feature Specifications |
| `b95f0c4` | 2026-10-22 | Widget test with SharedPreferences mock | September: Technical Planning |
| `c3b6a0c` | 2026-10-22 | Code formatting & cleanup | October: Implementation |
| `8232d64` | 2026-10-22 | Platform configurations (Android/iOS) | October: Implementation |
| `d24a2a0` | 2026-10-22 | Documentation & retrospective timeline | October: Implementation |

### August 2026 — Foundation & Product Design (Proposed)

> **Planning activities** that informed the implementation. No code was written during this period.

| Date | Milestone | Deliverable | Related Commits |
|------|-----------|-------------|-----------------|
| Aug 3 | Project Vision | Vision document, objectives, target users | — |
| Aug 5 | Requirements | Core finance management requirements | — |
| Aug 7 | Tech Stack | Flutter/Dart selection, architecture plan | — |
| Aug 9 | App Structure | Folder organization, module boundaries | `7b685dd` |
| Aug 11 | Design System | Color palette, typography, Material 3 theme | `410ef8f` |
| Aug 13 | Dashboard Design | Balance cards, summary cards, quick actions | `0fb4a69` |
| Aug 15 | Navigation Plan | 5-tab bottom nav, screen workflows | `5c9c77c` |
| Aug 17 | Data Models | Transaction, Budget, Category, User entities | `4baa1a4` |
| Aug 19 | Income/Expense Flow | Transaction types, categories, workflows | `4baa1a4` |
| Aug 21 | Budget Planning | Monthly budgets, progress indicators | `4baa1a4` |
| Aug 24 | Analytics Requirements | Chart types, insights, savings rate | — |
| Aug 27 | Profile/Settings Plan | Theme, currency, notifications, biometrics | — |
| Aug 30 | Scope Review | Feature prioritization, implementation order | — |

### September 2026 — Technical Planning & Feature Specifications (Proposed)

> **Technical specification** activities. Detailed designs that guided implementation.

| Date | Milestone | Deliverable | Related Commits |
|------|-----------|-------------|-----------------|
| Sep 2 | Architecture Finalize | Component structure, data flow | `bb29ff3`, `5c9c77c` |
| Sep 4 | State Management | Riverpod providers, data flow | `bb29ff3` |
| Sep 6 | Transaction Filtering | Search, filter, sort specifications | `392a472` |
| Sep 8 | Budget Calculations | Spending limits, progress rules | `828c82f` |
| Sep 10 | Dashboard Calculations | Monthly totals, savings rate | `433451f` |
| Sep 12 | Chart Specifications | Bar/donut charts, legends, tooltips | `ac03188` |
| Sep 14 | Reusable Widgets | Shared UI component library | `0fb4a69` |
| Sep 16 | Profile/Settings Spec | Theme, currency, notifications | `1e89c07` |
| Sep 18 | Validation & Errors | Input validation, error handling | `392a472` |
| Sep 20 | Test Scenarios | Core workflow test cases | `b95f0c4` |
| Sep 22 | Accessibility Review | Responsive layouts, visual consistency | `c3b6a0c` |
| Sep 24 | Task Prioritization | Implementation order by feature | — |
| Sep 26 | Dependencies Review | Third-party packages, integrations | — |
| Sep 28 | Spec Review | Final feature specification sign-off | — |
| Sep 30 | Documentation Consolidation | Milestone notes, technical docs | `d24a2a0` |

### October 2026 (Actual: Implementation & Polish)

> **Actual implementation** completed on **2026-10-22** in a single development session.

| Commit | Description |
|--------|-------------|
| `7b685dd` | Initialize Flutter project structure |
| `4baa1a4` | Add data models and mock financial data |
| `410ef8f` | Implement core theme, constants, and formatters |
| `0fb4a69` | Build reusable finance dashboard widgets |
| `bb29ff3` | Set up Riverpod state management providers |
| `5c9c77c` | Implement app entry point and bottom navigation |
| `433451f` | Implement home dashboard screen |
| `392a472` | Add transaction management with search and filtering |
| `828c82f` | Build budget tracking with progress monitoring |
| `ac03188` | Implement analytics and reports with charts |
| `1e89c07` | Add profile and settings screen |
| `b95f0c4` | Add widget test with SharedPreferences mock |
| `c3b6a0c` | Apply dart format and clean up test imports |
| `8232d64` | Add Flutter platform configurations and retrospective timeline |
| `d24a2a0` | Update README with detailed retrospective milestone timeline |

> **Note**: All code was implemented in a single session on **2026-10-22**. The August/September milestones above represent a **retrospective organization** of the work for project planning and documentation purposes. They do **not** reflect actual historical development dates. The detailed entries are **proposed/planned milestones** for documentation purposes only.

## License

This project is for educational and demonstration purposes.