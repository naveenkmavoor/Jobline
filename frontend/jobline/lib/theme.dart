import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/typography/text_styles.dart';

const _smallTextScaleFactor = 0.80;

/// Namespace for the Jobline [ThemeData].
class JoblineTheme {
  /// Standard `ThemeData` for Jobline UI.
  static ThemeData get standard {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: lightColorScheme,
      appBarTheme: _appBarTheme,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
          // color: JoblineColors.white,
          ),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textTheme: _textTheme,
      dialogBackgroundColor: JoblineColors.whiteBackground,
      dialogTheme: _dialogTheme,
      tooltipTheme: _tooltipTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      dividerTheme: _dividerTheme,
    );
  }

  /// `ThemeData` for Jobline UI for small screens.
  static ThemeData get small {
    return standard.copyWith(textTheme: _smallTextTheme);
  }

  /// `ThemeData` for Jobline UI for medium screens.
  static ThemeData get medium {
    return standard.copyWith(textTheme: _smallTextTheme);
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: JoblineTextStyle.headline1,
      displayMedium: JoblineTextStyle.headline2,
      displaySmall: JoblineTextStyle.headline3,
      headlineMedium: JoblineTextStyle.headline4,
      headlineSmall: JoblineTextStyle.headline5,
      titleLarge: JoblineTextStyle.headline6,
      titleMedium: JoblineTextStyle.subtitle1,
      titleSmall: JoblineTextStyle.subtitle2,
      bodyLarge: JoblineTextStyle.bodyText1,
      bodyMedium: JoblineTextStyle.bodyText2,
      bodySmall: JoblineTextStyle.caption,
      labelSmall: JoblineTextStyle.overline,
      labelLarge: JoblineTextStyle.button,
    );
  }

  static TextTheme get _smallTextTheme {
    return TextTheme(
      displayLarge: JoblineTextStyle.headline1.copyWith(
        fontSize: _textTheme.displayLarge!.fontSize! * _smallTextScaleFactor,
      ),
      displayMedium: JoblineTextStyle.headline2.copyWith(
        fontSize: _textTheme.displayMedium!.fontSize! * _smallTextScaleFactor,
      ),
      displaySmall: JoblineTextStyle.headline3.copyWith(
        fontSize: _textTheme.displaySmall!.fontSize! * _smallTextScaleFactor,
      ),
      headlineMedium: JoblineTextStyle.headline4.copyWith(
        fontSize: _textTheme.headlineMedium!.fontSize! * _smallTextScaleFactor,
      ),
      headlineSmall: JoblineTextStyle.headline5.copyWith(
        fontSize: _textTheme.headlineSmall!.fontSize! * _smallTextScaleFactor,
      ),
      titleLarge: JoblineTextStyle.headline6.copyWith(
        fontSize: _textTheme.titleLarge!.fontSize! * _smallTextScaleFactor,
      ),
      titleMedium: JoblineTextStyle.subtitle1.copyWith(
        fontSize: _textTheme.titleMedium!.fontSize! * _smallTextScaleFactor,
      ),
      titleSmall: JoblineTextStyle.subtitle2.copyWith(
        fontSize: _textTheme.titleSmall!.fontSize! * _smallTextScaleFactor,
      ),
      bodyLarge: JoblineTextStyle.bodyText1.copyWith(
        fontSize: _textTheme.bodyLarge!.fontSize! * _smallTextScaleFactor,
      ),
      bodyMedium: JoblineTextStyle.bodyText2.copyWith(
        fontSize: _textTheme.bodyMedium!.fontSize! * _smallTextScaleFactor,
      ),
      bodySmall: JoblineTextStyle.caption.copyWith(
        fontSize: _textTheme.bodySmall!.fontSize! * _smallTextScaleFactor,
      ),
      labelSmall: JoblineTextStyle.overline.copyWith(
        fontSize: _textTheme.labelSmall!.fontSize! * _smallTextScaleFactor,
      ),
      labelLarge: JoblineTextStyle.button.copyWith(
        fontSize: _textTheme.labelLarge!.fontSize! * _smallTextScaleFactor,
      ),
    );
  }

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(color: JoblineColors.white);
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: JoblineColors.white,
        elevation: 0,
        backgroundColor: JoblineColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        textStyle: JoblineTextStyle.buttonSmall,
        minimumSize: const Size(145, 54),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: JoblineColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        side: const BorderSide(
          color: JoblineColors.primaryColor,
        ),
        textStyle: JoblineTextStyle.buttonSmall,
        minimumSize: const Size(145, 45),
      ),
    );
  }

  static TooltipThemeData get _tooltipTheme {
    return const TooltipThemeData(
      decoration: BoxDecoration(
        color: JoblineColors.charcoal,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.all(10),
      textStyle: TextStyle(color: JoblineColors.white),
    );
  }

  static DialogTheme get _dialogTheme {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: JoblineColors.whiteBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
  }

  static TabBarTheme get _tabBarTheme {
    return const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 2,
          color: JoblineColors.blue,
        ),
      ),
      labelColor: JoblineColors.blue,
      unselectedLabelColor: JoblineColors.black25,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      space: 0,
      thickness: 1,
      color: JoblineColors.black25,
    );
  }

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF365CA8),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD9E2FF),
    onPrimaryContainer: Color(0xFF001944),
    secondary: Color(0xFF575E71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCE2F9),
    onSecondaryContainer: Color(0xFF141B2C),
    tertiary: Color(0xFF725572),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFDD7FA),
    onTertiaryContainer: Color(0xFF2A132C),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFEFBFF),
    onBackground: Color(0xFF1B1B1F),
    outline: Color(0xFF757780),
    onInverseSurface: Color(0xFFF2F0F4),
    inverseSurface: Color(0xFF303034),
    inversePrimary: Color(0xFFB0C6FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF365CA8),
    outlineVariant: Color(0xFFC5C6D0),
    scrim: Color(0xFF000000),
    surface: Color(0xFFFBF8FD),
    onSurface: Color(0xFF1B1B1F),
    surfaceVariant: Color(0xFFE1E2EC),
    onSurfaceVariant: Color(0xFF44464F),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB0C6FF),
    onPrimary: Color(0xFF002D6E),
    primaryContainer: Color(0xFF18438F),
    onPrimaryContainer: Color(0xFFD9E2FF),
    secondary: Color(0xFFBFC6DC),
    onSecondary: Color(0xFF293042),
    secondaryContainer: Color(0xFF404659),
    onSecondaryContainer: Color(0xFFDCE2F9),
    tertiary: Color(0xFFE0BBDE),
    onTertiary: Color(0xFF412742),
    tertiaryContainer: Color(0xFF593D5A),
    onTertiaryContainer: Color(0xFFFDD7FA),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1B1B1F),
    onBackground: Color(0xFFE3E2E6),
    outline: Color(0xFF8F9099),
    onInverseSurface: Color(0xFF1B1B1F),
    inverseSurface: Color(0xFFE3E2E6),
    inversePrimary: Color(0xFF365CA8),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFB0C6FF),
    outlineVariant: Color(0xFF44464F),
    scrim: Color(0xFF000000),
    surface: Color(0xFF121316),
    onSurface: Color(0xFFC7C6CA),
    surfaceVariant: Color(0xFF44464F),
    onSurfaceVariant: Color(0xFFC5C6D0),
  );
}
