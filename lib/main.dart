import 'dart:core';
import 'dart:io';
import 'package:clock_app/audio/types/ringtone_manager.dart';
import 'package:clock_app/common/logic/lock_screen_flags.dart';
import 'package:clock_app/navigation/data/route_observer.dart';
import 'package:clock_app/theme/color.dart';
import 'package:clock_app/timer/screens/timer_notification_screen.dart';
import 'package:flutter/material.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_boot_receiver/flutter_boot_receiver.dart';
import 'package:timezone/data/latest_all.dart';

import 'package:clock_app/alarm/logic/handle_boot.dart';
import 'package:clock_app/audio/logic/audio_session.dart';
import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:clock_app/navigation/types/routes.dart';
import 'package:clock_app/notifications/logic/notifications.dart';
import 'package:clock_app/settings/logic/initialize_settings.dart';
import 'package:clock_app/theme/theme.dart';
import 'package:clock_app/navigation/screens/nav_scaffold.dart';
import 'package:clock_app/clock/logic/timezone_database.dart';
import 'package:clock_app/alarm/screens/alarm_notification_screen.dart';
import 'package:clock_app/notifications/types/notifications_controller.dart';
import 'package:clock_app/audio/types/ringtone_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeTimeZones();
  await initializeAppDataDirectory();
  await initializeSettings();
  await initializeDatabases();
  await AndroidAlarmManager.initialize();
  await RingtoneManager.initialize();
  await RingtonePlayer.initialize();
  await initializeAudioSession();
  await BootReceiver.initialize(handleBoot);
  await initializeNotifications();
  AppVisibilityListener.initialize();
  await LockScreenFlagManager.initialize();

  String appDataDirectory = await getAppDataDirectoryPath();
  String path = '$appDataDirectory/ringing-alarm.txt';
  File file = File(path);
  if (!file.existsSync()) {
    file.createSync();
  }
  file.writeAsStringSync("", mode: FileMode.writeOnly);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();

  static void setColorScheme(BuildContext context, ColorScheme colorScheme) {
    _AppState state = context.findAncestorStateOfType<_AppState>()!;
    state.setColorScheme(colorScheme);
  }
}

class _AppState extends State<App> {
  ThemeData _theme = defaultTheme;

  @override
  void initState() {
    NotificationController.setListeners();
    super.initState();
  }

  setColorScheme(ColorScheme colorScheme) {
    setState(() {
      _theme = _theme.copyWith(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        cardColor: colorScheme.surface,
        textTheme: _theme.textTheme.apply(
          bodyColor: colorScheme.onBackground,
          displayColor: colorScheme.onBackground,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Clock',
      theme: _theme,
      initialRoute: Routes.rootRoute,
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        Routes.push(settings.name ?? Routes.rootRoute);
        switch (settings.name) {
          case Routes.rootRoute:
            return MaterialPageRoute(builder: (context) => const NavScaffold());

          case Routes.alarmNotificationRoute:
            return MaterialPageRoute(
              builder: (context) {
                final List<int> scheduleIds = settings.arguments as List<int>;
                return AlarmNotificationScreen(scheduleId: scheduleIds[0]);
              },
            );

          case Routes.timerNotificationRoute:
            return MaterialPageRoute(
              builder: (context) {
                final List<int> scheduleIds = settings.arguments as List<int>;
                return TimerNotificationScreen(scheduleIds: scheduleIds);
              },
            );

          default:
            assert(false, 'Page ${settings.name} not found');
            return null;
        }
      },
    );
  }
}
