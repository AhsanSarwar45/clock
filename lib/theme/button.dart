import 'package:clock_app/theme/color.dart';
import 'package:clock_app/theme/font.dart';
import 'package:flutter/material.dart';

TextButtonThemeData textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    textStyle: TextStyle(
      fontSize: 32,
      fontVariations: FontVariations.extraBold,
      // color: Theme.of(context).colorScheme.onBackground,
    ),
  ),
);
