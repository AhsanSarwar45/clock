import 'dart:ui';

import 'package:clock_app/clock/types/time.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/theme/color.dart';
import 'package:flutter/material.dart';

import 'package:clock_app/settings/types/setting.dart';

List<SettingItem> settingsItems = [
  SettingGroup(
    "General",
    [
      SelectSetting<TimeFormat>(
        "Time Format",
        [
          SelectSettingOption("12 Hours", TimeFormat.h12),
          SelectSettingOption("24 Hours", TimeFormat.h24),
          SelectSettingOption("Device Settings", TimeFormat.device),
        ],
        description: "12 or 24 hour time",
      ),
      SwitchSetting("Show Seconds", true),
    ],
    icon: FluxIcons.settings,
    description: "Set app wide settings like time format",
  ),
  SettingGroup(
      "Appearance",
      [
        SelectSetting<ColorScheme>(
          "Color Scheme",
          [
            SelectSettingOption("Light", lightColorScheme),
            SelectSettingOption("Dark", darkColorScheme),
          ],
          onSelect: (context, index, colorScheme) {
            App.setColorScheme(context, colorScheme);
          },
        ),
        ColorSetting("Accent Color", const Color.fromARGB(255, 9, 163, 184)),
      ],
      icon: FluxIcons.settings,
      description: "Set themes, colors and change layout"),
];

Settings appSettings = Settings(settingsItems);
