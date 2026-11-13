import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF004B87, // ✅ Your desired primary color
    <int, Color>{
      50: Color(0xFFE1ECF3),
      100: Color(0xFFB3CFE1),
      200: Color(0xFF80AFCC),
      300: Color(0xFF4D8FB7),
      400: Color(0xFF2677A7),
      500: Color(0xFF004B87), // ✅ Primary
      600: Color(0xFF00447F),
      700: Color(0xFF003B74),
      800: Color(0xFF003269),
      900: Color(0xFF002257),
    },
  );


  ///LOGO
  static const Color primaryColor = Color(0xFF004B87);
  static const Color secondaryColor = Color(0xFFE74C3C);
  static const Color scaffoldColor=Color(0xFF004B87);
  static const Color primaryLogoColor400=Color(0xFF004B87);
  static const Color blackText=Color(0xFF868786);
  static const Color blackText2=Color(0xFF000000);
  static const Color blackText3=Color(0xFF444444);
  static const Color onetimeColor=Color(0xFFEFFAF4);
  static const Color onetimeColorLabel=Color(0xFF378463);

  ///TEXT COLORS
  static const Color primaryTextColor600 = Color(0xFF444444);
  static const Color primaryTextColorH1600 = Color(0xFF000000);///
  static const Color primaryTextColorH1400 = Color(0xFF000000);///
  static const Color hintTextColorH1400 = Color(0xFF6D6D6D);///
  static const Color termsAndConditionsColor400 = Color(0xFF0000FF);///
  /// cards
  static const Color primaryCardColor = Color(0xFFFFFFFF);
  static const Color secondaryCardColor = Color(0xFFEDF5FB);
  static const Color secondaryCardColorBG = Color(0xFFCFECFF);

  ///BUTTON COLORS
  static const Color inActiveCheckBox = Color(0xFFD9D9D9);
  static const Color reSendText400 = Color(0xFFD80404);
  static const Color BUTTONCOLOR = Color(0xFFE74C3C);
  static const Color primaryButtonColor = Color(0xFF101317);

  static const Color notificationColor = Color(0x1AFFFFFF);
  static const Color pageViewColor = Color(0xFFFFFFFF);
  ///LOGO  background colors
  static const Color logoBackgroundPrimaryColor = Color(0xFFFFFFFF);///Register Account Screen
  static const Color headerTextPrimaryColor = Color(0x8002469F);///Register Account Screen


  static const Color lightBlue = Color(0xFF83C0CF);
  static const Color pageViewExist = Color(0x4D101317);
  static const Color pageViewBackGround = Color(0xE6EDF6);
///form field label colors
  static const Color formLabelColor = Color(0xFF101317);
  static const Color formHintColor = Color(0x4D101317);
  ///checkboxEpty
  static const Color checkBoxEmpty = Color(0x1A101317);
  ///


  static const Color successColor = Colors.green;
}


class AppGradients {
  static const LinearGradient mainGradient = LinearGradient(
    colors: [
      AppColors.lightBlue,
      Color(0xffc3dafe),
      Color(0xffa5b4fc),
      Color(0xffc3dafe),
      AppColors.primaryColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient mainGradient2 = LinearGradient(
    colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
double getResponsiveFontSize(BuildContext context, {double mobileSize = 16, double tabletSize = 26}) {
  return MediaQuery.of(context).size.width > 600 ? tabletSize : mobileSize;
}