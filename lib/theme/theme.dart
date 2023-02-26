import 'package:clock_app/theme/font.dart';
import 'package:clock_app/theme/slider.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/card.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/dialog.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/time_picker.dart';

ThemeData defaultTheme = ThemeData(
  fontFamily: 'Rubik',
  // canvasColor: Colors.transparent,
  textTheme: textTheme.apply(
    bodyColor: lightColorScheme.onBackground,
    displayColor: lightColorScheme.onBackground,
  ),
  cardTheme: cardTheme,
  colorScheme: lightColorScheme,
  timePickerTheme: timePickerTheme,
  dialogTheme: dialogTheme,
  switchTheme: switchTheme,
  snackBarTheme: snackBarTheme,
  inputDecorationTheme: inputTheme,
  radioTheme: radioTheme,
  sliderTheme: sliderTheme,
  // textButtonTheme: textButtonTheme,
);

// ThemeData theme2 = ThemeData(
//   fontFamily: 'Rubik',
//   // canvasColor: Colors.transparent,
//   textTheme: textTheme,
//   cardTheme: cardTheme,
//   colorScheme: colorScheme,
//   timePickerTheme: timePickerTheme,
//   dialogTheme: dialogTheme,
//   switchTheme: switchTheme,
//   snackBarTheme: snackBarTheme,
//   inputDecorationTheme: inputTheme,
//   scaffoldBackgroundColor: ColorTheme.backgroundColor,
//   radioTheme: radioTheme,
//   sliderTheme: sliderTheme,
//   // textButtonTheme: textButtonTheme,
// );
