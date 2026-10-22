class AppConstants {
  static const String appName = 'Finora';
  static const String appVersion = '1.0.0';
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';
  static const String dateFormat = 'dd MMM yyyy';
  static const String dateFormatShort = 'dd MMM';
  static const String dateFormatMonth = 'MMM yyyy';
  static const String timeFormat = 'HH:mm';

  static const int defaultBudgetLimit = 0;
  static const double chartAnimationDuration = 800;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);

  static const double borderRadiusSmall = 8;
  static const double borderRadiusMedium = 12;
  static const double borderRadiusLarge = 16;
  static const double borderRadiusXLarge = 20;
  static const double borderRadiusCircular = 24;

  static const double spacingXS = 4;
  static const double spacingSM = 8;
  static const double spacingMD = 16;
  static const double spacingLG = 24;
  static const double spacingXL = 32;

  static const double iconSizeSM = 16;
  static const double iconSizeMD = 20;
  static const double iconSizeLG = 24;
  static const double iconSizeXL = 32;

  static const double avatarSizeSM = 32;
  static const double avatarSizeMD = 40;
  static const double avatarSizeLG = 56;
  static const double avatarSizeXL = 80;

  static const List<String> paymentMethods = [
    'UPI',
    'Credit Card',
    'Debit Card',
    'Net Banking',
    'Cash',
    'Wallet',
    'Auto Pay',
    'Bank Transfer',
  ];

  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transport',
    'Shopping',
    'Bills & Utilities',
    'Entertainment',
    'Health & Fitness',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Investment',
    'Freelance',
    'Business',
    'Gift',
    'Other Income',
  ];

  static const String sharedPrefsThemeKey = 'theme_mode';
  static const String sharedPrefsCurrencyKey = 'currency';
  static const String sharedPrefsNotificationsKey = 'notifications_enabled';
  static const String sharedPrefsBiometricKey = 'biometric_enabled';
  static const String sharedPrefsFirstLaunchKey = 'first_launch';
}
