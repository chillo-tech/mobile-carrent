import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorStyle {
  static const MaterialColor primarySwatchColor = MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffe04747), //10%
      100: Color(0xffe45c5c), //20%
      200: Color(0xffe77070), //30%
      300: Color(0xffeb8585), //40%
      400: Color(0xffee9999), //50%
      500: Color(0xfff1adad), //60%
      600: Color(0xfff5c2c2), //70%
      700: Color(0xfff8d6d6), //80%
      800: Color(0xfffcebeb), //90%
      900: Color(0xffffffff), //100%
    },
  );

  static const lightPrimaryColor = Color(0xFFCC3300);
  static const lightAccentColor = Color(0xFFDD3333);

  static const cardColorLight = Color(0xFF241E21);
  static const fontColorLight = Color(0xFF241E21);
  static const grey = Color(0xFFE1E1E1);
  static const bgFieldGrey = Color(0xFFE8E8E8);
  static const hintColor = Color(0xFF5E5E5E);
  static const unselectedTabColor = Color(0xFF585757);
  static const fontColorDarkTitle = Color(0xFF32353E);
  static const carComponentBg = Color(0xFFE4E1E1);
  static const iconColorLight = Color.fromARGB(255, 36, 30, 33);

  static const white = Color(0xFFFFFFFF);
  static const lightWhiteBackground = Color(0xFFF4F4F4);
  static const lightWhite = Color(0xFFE8E8E8);
  static const blackBackground = Color.fromARGB(255, 36, 30, 33);
  static const textBlackColor = Color.fromARGB(255, 29, 21, 3);
  static const textBlackColor1 = Color.fromARGB(255, 51, 51, 51);
  static const lightGreyColor = Color.fromARGB(255, 118, 120, 122);
  static const lightGreyColor1 = Color.fromARGB(255, 228, 229, 230);
  static const lightGreyColor2 = Color.fromARGB(255, 118, 118, 118);
  static const lightGreyColor3 = Color.fromARGB(255, 181, 181, 181);
  static const lightGreyColor4 = Color.fromARGB(255, 239, 239, 239);
  static const greyColor = Color.fromARGB(255, 102, 102, 102);
  static const greyColor1 = Color.fromARGB(255, 129, 129, 129);
  static const bottomBarDark = Color(0xFF202833);
  static const pinkColor = Color(0xFFFCEBEB);
  static const pinkColor1 = Color(0xFFF1ABAB);
  static const brunColor = Color(0xFF5D1515);
  static const borderColor = Color.fromARGB(255, 219, 219, 219);
  static const borderColor1 = Color.fromARGB(255, 227, 227, 227);
  static const dividerColor = Color(0xFF767676);
  static const backgroundColor = Color.fromARGB(255, 228, 228, 228);
  static const backgroundColor1 = Color.fromARGB(255, 244, 242, 242);
  static const greyColor2 = Color.fromARGB(255, 226, 226, 226);
  static const containerBg = Color(0xFFF3F3F3);
  static const success = Color(0xFF077C40);
  static const opacGrey = Color(0xFF898989);

  static const lightRedBackground = Color(0xFFFCEBEB);
  static const addPictureBg = Color(0xFF323232);
}

class Themes {
  static TextTheme lightTextTheme = TextTheme(
    bodySmall: GoogleFonts.ubuntu(
      color: ColorStyle.textBlackColor,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    displayLarge: GoogleFonts.ubuntu(
      color: ColorStyle.textBlackColor,
      fontSize: 28,
      fontWeight: FontWeight.normal,
    ),
    headlineLarge: GoogleFonts.ubuntu(
      color: ColorStyle.textBlackColor,
      fontSize: 28,
      fontWeight: FontWeight.normal,
    ),
    headlineSmall: GoogleFonts.ubuntu(
      color: ColorStyle.textBlackColor,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: GoogleFonts.ubuntu(
      fontSize: 16,
      color: ColorStyle.textBlackColor,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: GoogleFonts.ubuntu(fontSize: 25),
    displayMedium: GoogleFonts.ubuntu(fontSize: 30),
    bodyMedium:
        GoogleFonts.ubuntu(fontSize: 15, color: ColorStyle.lightAccentColor),
    bodyLarge: GoogleFonts.ubuntu(fontSize: 16),
    titleMedium: GoogleFonts.ubuntu(fontSize: 16),
    labelLarge: GoogleFonts.ubuntu(fontSize: 16),
    labelSmall: GoogleFonts.ubuntu(fontSize: 16),
    titleLarge: GoogleFonts.ubuntu(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ColorStyle.blackBackground,
    ),
  );

  static final smallTextStyle = GoogleFonts.ubuntu(
    fontSize: 14,
    color: ColorStyle.lightPrimaryColor,
  );

  static final largeTextStyle = GoogleFonts.ubuntu(
    fontSize: 14,
    color: ColorStyle.textBlackColor,
  );

  static final labelStyle = Themes.smallTextStyle.merge(
    const TextStyle(
      color: ColorStyle.textBlackColor1,
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    unselectedWidgetColor: const Color(0xFFFCEBEB),
    primaryColor: ColorStyle.lightPrimaryColor,
    toggleButtonsTheme: const ToggleButtonsThemeData(
      color: ColorStyle.lightPrimaryColor,
      fillColor: Color(0xFFFCEBEB),
      selectedBorderColor: ColorStyle.lightPrimaryColor,
      borderColor: ColorStyle.lightPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      color: Colors.white,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ColorStyle.lightPrimaryColor,
      selectionColor: ColorStyle.fontColorLight,
      selectionHandleColor: ColorStyle.fontColorDarkTitle,
    ),
    cardColor: ColorStyle.cardColorLight,
    canvasColor: const Color(0xFFFFFFFF),
    scaffoldBackgroundColor: const Color(0xFFE4E4E4),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xFFFCEBEB)),
      checkColor: MaterialStateProperty.all(ColorStyle.lightPrimaryColor),
      overlayColor: MaterialStateProperty.all(const Color(0xFFFCEBEB)),
      side: MaterialStateBorderSide.resolveWith(
          (states) => const BorderSide(color: ColorStyle.lightPrimaryColor)),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: ColorStyle.lightPrimaryColor),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return ColorStyle.lightPrimaryColor;
        return null;
      }),
      overlayColor: MaterialStateProperty.all(ColorStyle.lightPrimaryColor),
      visualDensity: VisualDensity.compact,
    ),
    dividerColor: ColorStyle.iconColorLight,
    hintColor: ColorStyle.hintColor,
    fontFamily: GoogleFonts.lato().fontFamily,
    textTheme: lightTextTheme,
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: ColorStyle.lightAccentColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 14.0),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      errorStyle: GoogleFonts.lato(
        color: Colors.red,
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ColorStyle.lightPrimaryColor,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ColorStyle.bgFieldGrey,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ColorStyle.bgFieldGrey,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      suffixStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Get.theme.textSelectionTheme.selectionColor,
      ),
    ),
    dialogBackgroundColor: ColorStyle.lightWhiteBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorStyle.cardColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorStyle.lightPrimaryColor,
        backgroundColor: Colors.transparent,
        side: const BorderSide(
          width: 1,
          color: ColorStyle.lightPrimaryColor,
        ),
        textStyle: GoogleFonts.ubuntu(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorStyle.lightPrimaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        minimumSize: const Size.fromHeight(0),
      ),
    ),
    // checkboxTheme: CheckboxThemeData(
    //   fillColor: MaterialStateProperty.all(Color(0xFFFCEBEB)),
    //   checkColor: MaterialStateProperty.all(ColorStyle.lightPrimaryColor),
    //   overlayColor: MaterialStateProperty.all(Color(0xFFFCEBEB)),
    //   side: MaterialStateBorderSide.resolveWith(
    //       (states) => BorderSide(color: ColorStyle.lightPrimaryColor)),
    //   visualDensity: VisualDensity.compact,
    //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(4),
    //     side: BorderSide(color: ColorStyle.lightPrimaryColor),
    //   ),
    // ).copyWith(
    //   fillColor: MaterialStateProperty.resolveWith<Color?>(
    //       (Set<MaterialState> states) {
    //     if (states.contains(MaterialState.disabled)) {
    //       return null;
    //     }
    //     if (states.contains(MaterialState.selected)) {
    //       return ColorStyle.lightPrimaryColor;
    //     }
    //     return null;
    //   }),
    // ),
    // radioTheme: RadioThemeData(
    //   fillColor: MaterialStateProperty.resolveWith((states) {
    //     if (states.contains(MaterialState.selected))
    //       return ColorStyle.lightPrimaryColor;

    //     return null;
    //   }),
    //   overlayColor: MaterialStateProperty.all(ColorStyle.lightPrimaryColor),
    //   visualDensity: VisualDensity.compact,
    // ).copyWith(
    //   fillColor: MaterialStateProperty.resolveWith<Color?>(
    //       (Set<MaterialState> states) {
    //     if (states.contains(MaterialState.disabled)) {
    //       return null;
    //     }
    //     if (states.contains(MaterialState.selected)) {
    //       return ColorStyle.lightPrimaryColor;
    //     }
    //     return null;
    //   }),
    // ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return ColorStyle.lightPrimaryColor;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return null;
        }
        if (states.contains(MaterialState.selected)) {
          return ColorStyle.lightPrimaryColor;
        }
        return null;
      }),
    ),
  );
}
