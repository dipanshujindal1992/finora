import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Income/Expense colors (consistent across themes)
  static const Color incomeColor = Color(0xFF10B981); // Emerald 500
  static const Color expenseColor = Color(0xFFEF4444); // Red 500
  static const Color warningColor = Color(0xFFF59E0B); // Amber 500
  static const Color incomeLight = Color(0xFFD1FAE5);
  static const Color expenseLight = Color(0xFFFEF2F2);
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color incomeDark = Color(0xFF064E3B);
  static const Color expenseDark = Color(0xFF7F1D1D);
  static const Color warningDark = Color(0xFF78350F);

  // Light theme colors
  static const Color lightPrimary = Color(0xFF059669); // Emerald 600
  static const Color lightPrimaryContainer = Color(0xFFD1FAE5); // Emerald 100
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryFixed = Color(0xFFA7F3D0); // Emerald 200
  static const Color lightOnPrimaryFixed = Color(0xFF022C1B); // Emerald 950

  static const Color lightSecondary = Color(0xFF0F766E); // Teal 700
  static const Color lightSecondaryContainer = Color(0xFFCCFBF1); // Teal 100
  static const Color lightOnSecondary = Color(0xFFFFFFFF);

  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightSurfaceContainerHighest = Color(0xFFF5F5F5);
  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightOnSurfaceVariant = Color(0xFF49454F);

  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOnErrorContainer = Color(0xFF410002);

  static const Color lightOutline = Color(0xFF79747E);
  static const Color lightOutlineVariant = Color(0xFFCAC4D0);
  static const Color lightShadow = Color(0xFF000000);
  static const Color lightScrim = Color(0xFF000000);
  static const Color lightInverseSurface = Color(0xFF313033);
  static const Color lightInverseOnSurface = Color(0xFFF4EFF4);
  static const Color lightInversePrimary = Color(0xFF6CEBA9);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF6CEBA9); // Emerald 300
  static const Color darkPrimaryContainer = Color(0xFF045C3B); // Emerald 800
  static const Color darkOnPrimary = Color(0xFF022C1B); // Emerald 950
  static const Color darkPrimaryFixed = Color(0xFFA7F3D0); // Emerald 200
  static const Color darkOnPrimaryFixed = Color(0xFF022C1B); // Emerald 950

  static const Color darkSecondary = Color(0xFF5EEAD4); // Teal 300
  static const Color darkSecondaryContainer = Color(0xFF0F766E); // Teal 700
  static const Color darkOnSecondary = Color(0xFF003D3A);

  static const Color darkSurface = Color(0xFF1C1B1F);
  static const Color darkSurfaceContainerHighest = Color(0xFF27262A);
  static const Color darkOnSurface = Color(0xFFE6E1E5);
  static const Color darkOnSurfaceVariant = Color(0xFFCAC4D0);

  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkErrorContainer = Color(0xFF93000A);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6);

  static const Color darkOutline = Color(0xFF938F99);
  static const Color darkOutlineVariant = Color(0xFF49454F);
  static const Color darkShadow = Color(0xFF000000);
  static const Color darkScrim = Color(0xFF000000);
  static const Color darkInverseSurface = Color(0xFFE6E1E5);
  static const Color darkInverseOnSurface = Color(0xFF313033);
  static const Color darkInversePrimary = Color(0xFF059669);
}

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimary: AppColors.lightOnPrimary,
      primaryFixed: AppColors.lightPrimaryFixed,
      onPrimaryFixed: AppColors.lightOnPrimaryFixed,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondary: AppColors.lightOnSecondary,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      error: AppColors.lightError,
      errorContainer: AppColors.lightErrorContainer,
      onError: AppColors.lightOnError,
      onErrorContainer: AppColors.lightOnErrorContainer,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      shadow: AppColors.lightShadow,
      scrim: AppColors.lightScrim,
      inverseSurface: AppColors.lightInverseSurface,
      onInverseSurface: AppColors.lightInverseOnSurface,
      inversePrimary: AppColors.lightInversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(colorScheme),
      navigationBarTheme: _navigationBarTheme(colorScheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dividerTheme: _dividerTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      progressIndicatorTheme: _progressIndicatorTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimary: AppColors.darkOnPrimary,
      primaryFixed: AppColors.darkPrimaryFixed,
      onPrimaryFixed: AppColors.darkOnPrimaryFixed,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondary: AppColors.darkOnSecondary,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      error: AppColors.darkError,
      errorContainer: AppColors.darkErrorContainer,
      onError: AppColors.darkOnError,
      onErrorContainer: AppColors.darkOnErrorContainer,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      shadow: AppColors.darkShadow,
      scrim: AppColors.darkScrim,
      inverseSurface: AppColors.darkInverseSurface,
      onInverseSurface: AppColors.darkInverseOnSurface,
      inversePrimary: AppColors.darkInversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme),
      filledButtonTheme: _filledButtonTheme(colorScheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme),
      textButtonTheme: _textButtonTheme(colorScheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavigationBarTheme(colorScheme),
      navigationBarTheme: _navigationBarTheme(colorScheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(colorScheme),
      chipTheme: _chipTheme(colorScheme),
      dividerTheme: _dividerTheme(colorScheme),
      listTileTheme: _listTileTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      progressIndicatorTheme: _progressIndicatorTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    return GoogleFonts.interTextTheme()
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        )
        .copyWith(
          displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.25,
            color: colorScheme.onSurface,
          ),
          displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: colorScheme.onSurface,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            color: colorScheme.onSurface,
          ),
          titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: colorScheme.onSurface,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: colorScheme.onSurface,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            color: colorScheme.onSurface,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: colorScheme.onSurfaceVariant,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: colorScheme.onSurface,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: colorScheme.onSurface,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant,
          ),
        );
  }

  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      actionsIconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shadowColor: colorScheme.shadow,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
        disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.primary,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colorScheme.error,
      ),
      prefixIconColor: colorScheme.onSurfaceVariant,
      suffixIconColor: colorScheme.onSurfaceVariant,
    );
  }

  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
      ColorScheme colorScheme) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      height: 72,
      backgroundColor: colorScheme.surface,
      elevation: 8,
      indicatorColor: colorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          );
        }
        return GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colorScheme.primary, size: 24);
        }
        return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
      }),
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(
      ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      highlightElevation: 10,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      extendedTextStyle:
          GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      extendedIconLabelSpacing: 12,
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor:
          colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
      selectedColor: colorScheme.primaryContainer,
      secondarySelectedColor: colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSecondaryContainer,
      ),
      brightness: colorScheme.brightness,
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      selectedShadowColor: Colors.transparent,
    );
  }

  static DividerThemeData _dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  static ListTileThemeData _listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.transparent,
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.5),
      iconColor: colorScheme.onSurfaceVariant,
      textColor: colorScheme.onSurface,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
      ),
      leadingAndTrailingTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: colorScheme.surface,
      showDragHandle: true,
      dragHandleColor: colorScheme.onSurfaceVariant,
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    );
  }

  static ProgressIndicatorThemeData _progressIndicatorTheme(
      ColorScheme colorScheme) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    );
  }

  static SliderThemeData _sliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(alpha: 0.12),
      valueIndicatorColor: colorScheme.primary,
      valueIndicatorTextStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onPrimary,
      ),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
    );
  }

  static TabBarThemeData _tabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorColor: colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      dividerColor: Colors.transparent,
    );
  }
}
