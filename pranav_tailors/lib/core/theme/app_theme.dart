// ════════════════════════════════════════════════════════════════════════════
//  app_theme.dart
//  Pranav Ladies Tailors — Blush Rose Variation 3
//  Full theme configuration: Colors · Typography · Spacing · Radii · Shadows
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Re-export convenience ───────────────────────────────────────────────────
export 'package:flutter/material.dart' show ThemeData, BuildContext, Theme;

// ════════════════════════════════════════════════════════════════════════════
//  1. APP COLORS
// ════════════════════════════════════════════════════════════════════════════

abstract class AppColors {
  AppColors._();

  // ── Primary — Blush Rose ─────────────────────────────────────────────────
  /// Deep rose – used for primary actions, active states, brand identity.
  static const Color primary        = Color(0xFFC2185B);

  /// Soft pastel version of the primary — lighter tint for backgrounds/chips.
  static const Color primaryLight   = Color(0xFFF8BBD0);

  /// Darker rose — pressed / ripple state of primary.
  static const Color primaryDark    = Color(0xFF880E4F);

  /// High-contrast text on primary-coloured surfaces.
  static const Color onPrimary      = Color(0xFFFFFFFF);

  // ── Secondary — Warm Gold ────────────────────────────────────────────────
  /// Dark gold — used for highlights, badges, premium accents.
  static const Color secondary      = Color(0xFFB8860B);

  /// Light gold — backgrounds for gold-tinted chips and banners.
  static const Color secondaryLight = Color(0xFFF5D87A);

  /// High-contrast text on gold surfaces.
  static const Color onSecondary    = Color(0xFF1C0A14);

  // ── Background & Surface ─────────────────────────────────────────────────
  /// App-wide background — very soft blush white.
  static const Color background     = Color(0xFFFFFBFD);

  /// Standard white card/sheet surface.
  static const Color surface        = Color(0xFFFFFFFF);

  /// Secondary surface — light rose tint for cards, drawers, bottom-sheets.
  static const Color surface2       = Color(0xFFFFF0F5);

  /// Text / icons drawn on top of primary surfaces.
  static const Color onBackground   = Color(0xFF1C0A14);

  /// Text / icons drawn on top of white surface cards.
  static const Color onSurface      = Color(0xFF1C0A14);

  // ── Border ───────────────────────────────────────────────────────────────
  /// Soft rose border for inputs, dividers, card edges.
  static const Color border         = Color(0xFFF8D7E6);

  /// Stronger border — focused input fields.
  static const Color borderFocus    = Color(0xFFC2185B);

  // ── Text ─────────────────────────────────────────────────────────────────
  /// Primary text — near-black with a warm rose undertone.
  static const Color textPrimary    = Color(0xFF1C0A14);

  /// Secondary text — muted rosewood for labels, subtitles.
  static const Color textSecondary  = Color(0xFF7B4060);

  /// Hint / placeholder text — very muted.
  static const Color textHint       = Color(0xFFB08090);

  /// Inverted text — white used on dark/primary-coloured elements.
  static const Color textInverse    = Color(0xFFFFFFFF);

  // ── Semantic ─────────────────────────────────────────────────────────────
  /// Success states — completed orders, confirmations.
  static const Color success        = Color(0xFF2E7D32);
  static const Color successLight   = Color(0xFFE8F5E9);

  /// Error states — validation failures, destructive actions.
  static const Color error          = Color(0xFFB71C1C);
  static const Color errorLight     = Color(0xFFFFEBEE);

  /// Urgent / warning — due-today orders, low-stock alerts.
  static const Color urgent         = Color(0xFFE65100);
  static const Color urgentLight    = Color(0xFFFFF3E0);

  // ── Misc ─────────────────────────────────────────────────────────────────
  /// Pure white shorthand.
  static const Color white          = Color(0xFFFFFFFF);

  /// Transparent shorthand.
  static const Color transparent    = Colors.transparent;

  /// Scrim / modal overlay.
  static const Color scrim          = Color(0x80000000);

  // ── Topbar Gradient stops ────────────────────────────────────────────────
  static const Color topbarStart    = Color(0xFFC2185B);
  static const Color topbarEnd      = Color(0xFF880E4F);
}

// ════════════════════════════════════════════════════════════════════════════
//  2. APP TEXT STYLES  (Poppins via google_fonts)
// ════════════════════════════════════════════════════════════════════════════

abstract class AppTextStyles {
  AppTextStyles._();

  // ── Headings ─────────────────────────────────────────────────────────────

  /// 28 sp · Bold — Page titles, hero text.
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );

  /// 22 sp · SemiBold — Section headings, dialog titles.
  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.35,
  );

  /// 18 sp · SemiBold — Card headings, sub-sections.
  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Subheading ────────────────────────────────────────────────────────────

  /// 16 sp · Medium — List item titles, row labels.
  static TextStyle get subheading => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// 14 sp · Regular — General body text.
  static TextStyle get body => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 14 sp · Medium — Emphasised body text, clickable items.
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 14 sp · Regular — Secondary / muted body text.
  static TextStyle get bodySecondary => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── Caption ───────────────────────────────────────────────────────────────

  /// 12 sp · Regular — Timestamps, helper text, footnotes.
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// 12 sp · Medium — Muted labels, chip text.
  static TextStyle get captionMedium => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ── Label ─────────────────────────────────────────────────────────────────

  /// 11 sp · SemiBold — Badges, status pills, tab bar labels.
  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.3,
  );

  /// 10 sp · Bold — Tiny overline / badge count text.
  static TextStyle get labelSmall => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.8,
    height: 1.2,
  );

  // ── Button ────────────────────────────────────────────────────────────────

  /// 15 sp · SemiBold — Primary and secondary button labels.
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // ── Input ─────────────────────────────────────────────────────────────────

  /// 14 sp · Regular — Text field input value.
  static TextStyle get input => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 13 sp · Regular — Placeholder / hint inside text fields.
  static TextStyle get inputHint => GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.4,
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  3. APP SPACING
// ════════════════════════════════════════════════════════════════════════════

abstract class AppSpacing {
  AppSpacing._();

  static const double xxs  =  2.0;
  static const double xs   =  4.0;
  static const double sm   =  8.0;
  static const double md   = 12.0;
  static const double base = 16.0;
  static const double lg   = 20.0;
  static const double xl   = 24.0;
  static const double xxl  = 32.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;

  // ── Named Semantic Shortcuts ─────────────────────────────────────────────
  static const double cardPadding     = base;
  static const double screenPadding   = base;
  static const double sectionGap      = xl;
  static const double inputPaddingH   = md;
  static const double inputPaddingV   = md;
  static const EdgeInsets screenInsets =
      EdgeInsets.symmetric(horizontal: screenPadding, vertical: base);
  static const EdgeInsets cardInsets  =
      EdgeInsets.all(cardPadding);
}

// ════════════════════════════════════════════════════════════════════════════
//  4. APP BORDER RADIUS
// ════════════════════════════════════════════════════════════════════════════

abstract class AppBorderRadius {
  AppBorderRadius._();

  static const double none   =  0.0;
  static const double xs     =  4.0;
  static const double sm     =  8.0;
  static const double md     = 12.0;
  static const double lg     = 16.0;
  static const double xl     = 20.0;
  static const double xxl    = 24.0;
  static const double full   = 999.0;

  // ── Named ────────────────────────────────────────────────────────────────
  static const double input   = md;
  static const double card    = lg;
  static const double button  = md;
  static const double chip    = full;
  static const double dialog  = xl;
  static const double sheet   = xxl;
  static const double avatar  = full;

  // ── BorderRadius objects ─────────────────────────────────────────────────
  static BorderRadius get cardRadius   => BorderRadius.circular(card);
  static BorderRadius get inputRadius  => BorderRadius.circular(input);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get chipRadius   => BorderRadius.circular(chip);
  static BorderRadius get dialogRadius => BorderRadius.circular(dialog);
  static BorderRadius get sheetRadius  => BorderRadius.vertical(
      top: Radius.circular(sheet));
}

// ════════════════════════════════════════════════════════════════════════════
//  5. APP SHADOWS
// ════════════════════════════════════════════════════════════════════════════

abstract class AppShadows {
  AppShadows._();

  /// Barely-visible lift for flat cards.
  static List<BoxShadow> get subtle => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Standard card elevation.
  static List<BoxShadow> get card => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.04),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, 1),
    ),
  ];

  /// Prominent shadow for action buttons, bottom-sheets.
  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.14),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.06),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  /// Heavy shadow for modals and floating panels.
  static List<BoxShadow> get modal => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.16),
      blurRadius: 40,
      spreadRadius: 0,
      offset: const Offset(0, 16),
    ),
  ];

  /// Top-bar / app-bar gradient shadow.
  static List<BoxShadow> get topbar => [
    BoxShadow(
      color: AppColors.primaryDark.withValues(alpha: 0.30),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}

// ════════════════════════════════════════════════════════════════════════════
//  6. FULL THEME DATA
// ════════════════════════════════════════════════════════════════════════════

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,

      // Primary
      primary:          AppColors.primary,
      onPrimary:        AppColors.onPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,

      // Secondary
      secondary:          AppColors.secondary,
      onSecondary:        AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.onSecondary,

      // Tertiary (reuse urgent/gold for chart accents)
      tertiary:          AppColors.urgent,
      onTertiary:        AppColors.white,
      tertiaryContainer: AppColors.urgentLight,
      onTertiaryContainer: AppColors.urgent,

      // Error
      error:          AppColors.error,
      onError:        AppColors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,

      // Background / Surface
      surface:             AppColors.surface,
      onSurface:           AppColors.onSurface,
      surfaceContainerHighest: AppColors.surface2,
      onSurfaceVariant:    AppColors.textSecondary,

      // Outline
      outline:        AppColors.border,
      outlineVariant: AppColors.borderFocus,

      // Scrim
      scrim: AppColors.scrim,
      shadow: AppColors.primary,

      // Inverse
      inverseSurface:   AppColors.textPrimary,
      onInverseSurface: AppColors.white,
      inversePrimary:   AppColors.primaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // ── Scaffold ────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Typography ──────────────────────────────────────────────────────
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge:   AppTextStyles.headingLarge,
        displayMedium:  AppTextStyles.headingMedium,
        displaySmall:   AppTextStyles.headingSmall,
        headlineLarge:  AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        headlineSmall:  AppTextStyles.headingSmall,
        titleLarge:     AppTextStyles.subheading,
        titleMedium:    AppTextStyles.bodyMedium,
        titleSmall:     AppTextStyles.captionMedium,
        bodyLarge:      AppTextStyles.body,
        bodyMedium:     AppTextStyles.body,
        bodySmall:      AppTextStyles.caption,
        labelLarge:     AppTextStyles.button,
        labelMedium:    AppTextStyles.label,
        labelSmall:     AppTextStyles.labelSmall,
      ),

      // ── AppBar ──────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor:  AppColors.primary,
        foregroundColor:  AppColors.white,
        elevation:        0,
        centerTitle:      false,
        titleTextStyle:   AppTextStyles.subheading.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        iconTheme:  const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
        shadowColor: AppColors.primaryDark,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Elevated Button ─────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.primaryLight,
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.6),
          elevation:    0,
          shadowColor:  Colors.transparent,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.buttonRadius),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl, vertical: AppSpacing.md),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.buttonRadius),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),

      // ── Text Button ─────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        ),
      ),

      // ── Input Decoration ────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:      true,
        fillColor:   AppColors.surface,
        hintStyle:   AppTextStyles.inputHint,
        labelStyle:  AppTextStyles.bodySecondary,
        errorStyle:  AppTextStyles.caption.copyWith(color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPaddingH,
          vertical:   AppSpacing.inputPaddingV,
        ),
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.borderFocus, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
      ),

      // ── Card ────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color:        AppColors.surface,
        elevation:    0,
        shadowColor:  Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.cardRadius,
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        margin: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs, horizontal: 0),
      ),

      // ── Chip ────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:      AppColors.surface2,
        selectedColor:        AppColors.primaryLight,
        disabledColor:        AppColors.surface2,
        labelStyle:           AppTextStyles.label,
        padding:              const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.chipRadius),
        side: const BorderSide(color: AppColors.border),
      ),

      // ── Floating Action Button ───────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor:  AppColors.primary,
        foregroundColor:  AppColors.white,
        elevation:        4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg)),
      ),

      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:     AppColors.surface,
        selectedItemColor:   AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        elevation:           8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:   TextStyle(
          fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w400),
      ),

      // ── Navigation Bar (Material 3) ──────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:          AppColors.surface,
        indicatorColor:           AppColors.primaryLight,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textHint, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.label.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.label.copyWith(color: AppColors.textHint);
        }),
        elevation:   0,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Drawer ──────────────────────────────────────────────────────────
      drawerTheme: const DrawerThemeData(
        backgroundColor:  AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation:        16,
        width:            280,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppBorderRadius.xxl),
          ),
        ),
      ),

      // ── List Tile ────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor:        Colors.transparent,
        selectedTileColor: AppColors.primaryLight,
        selectedColor:    AppColors.primary,
        iconColor:        AppColors.textSecondary,
        titleTextStyle:   AppTextStyles.body,
        subtitleTextStyle: AppTextStyles.caption,
        contentPadding:   const EdgeInsets.symmetric(
            horizontal: AppSpacing.base, vertical: AppSpacing.xs),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm)),
      ),

      // ── Dialog ──────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor:  AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation:        0,
        shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.dialogRadius),
        titleTextStyle:   AppTextStyles.headingSmall,
        contentTextStyle: AppTextStyles.body,
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor:  AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation:        0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppBorderRadius.sheet),
          ),
        ),
        modalElevation: 0,
      ),

      // ── Snack Bar ────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:  AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: AppColors.white),
        actionTextColor:  AppColors.secondaryLight,
        behavior:         SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm)),
        elevation: 4,
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color:     AppColors.border,
        thickness: 1.0,
        space:     1.0,
      ),

      // ── Switch / Checkbox / Radio ────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textHint),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primaryLight
                : AppColors.border),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary
                : Colors.transparent),
        checkColor: WidgetStateProperty.all(AppColors.white),
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xs)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textHint),
      ),

      // ── Progress Indicator ───────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color:            AppColors.primary,
        linearTrackColor: AppColors.primaryLight,
        circularTrackColor: AppColors.primaryLight,
      ),

      // ── Tab Bar ──────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor:         AppColors.primary,
        unselectedLabelColor: AppColors.textHint,
        labelStyle:         AppTextStyles.label.copyWith(
            color: AppColors.primary),
        unselectedLabelStyle: AppTextStyles.label.copyWith(
            color: AppColors.textHint),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 2.5),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.border,
      ),

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(
          color: AppColors.textSecondary, size: 22),
      primaryIconTheme: const IconThemeData(
          color: AppColors.white, size: 22),
    );
  }
}
