import 'package:clock_app/alarm/data/alarm_settings_schema.dart';
import 'package:clock_app/alarm/data/weekdays.dart';
import 'package:clock_app/alarm/types/alarm_runner.dart';
import 'package:clock_app/alarm/types/schedules/alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/daily_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/dates_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/once_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/range_alarm_schedule.dart';
import 'package:clock_app/alarm/types/schedules/weekly_alarm_schedule.dart';
import 'package:clock_app/alarm/types/weekday.dart';
import 'package:clock_app/common/types/list_item.dart';
import 'package:clock_app/common/utils/time_of_day.dart';
import 'package:clock_app/settings/data/settings_schema.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/settings.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

List<AlarmSchedule> createSchedules(Settings settings) {
  return [
    OnceAlarmSchedule(),
    DailyAlarmSchedule(),
    WeeklyAlarmSchedule(settings.getSetting("Week Days")),
    DatesAlarmSchedule(settings.getSetting("Dates")),
    RangeAlarmSchedule(
      settings.getSetting("Date Range"),
      settings.getSetting("Interval"),
    ),
  ];
}

class Alarm extends ListItem {
  bool _isEnabled = true;
  bool _isFinished = false;
  TimeOfDay _timeOfDay;
  Settings _settings = Settings(
      appSettings.getSettingGroup("Default Settings").copy().settingItems);

  late List<AlarmSchedule> _schedules;

  @override
  int get id => currentScheduleId;
  bool get isEnabled => _isEnabled;
  bool get isFinished => _isFinished;
  TimeOfDay get timeOfDay => _timeOfDay;
  Settings get settings => _settings;
  String get label => _settings.getSetting("Label").value;
  Type get scheduleType => _settings.getSetting("Type").value;
  String get ringtoneUri => _settings.getSetting("Melody").value;
  bool get vibrate => _settings.getSetting("Vibration").value;
  double get snoozeLength => _settings.getSetting("Length").value;
  TimeDuration get risingVolumeDuration =>
      _settings.getSetting("Rising Volume").value
          ? _settings.getSetting("Time To Full Volume").value
          : TimeDuration.zero;
  AlarmSchedule get activeSchedule =>
      _schedules.firstWhere((schedule) => schedule.runtimeType == scheduleType);
  List<AlarmRunner> get activeAlarmRunners => activeSchedule.alarmRunners;
  bool get isRepeating =>
      [DailyAlarmSchedule, WeeklyAlarmSchedule].contains(scheduleType);
  DateTime? get nextScheduleDateTime => activeSchedule.currentScheduleDateTime;
  int get currentScheduleId => activeSchedule.currentAlarmRunnerId;

  Alarm(this._timeOfDay) {
    _schedules = createSchedules(_settings);
  }

  Alarm.fromAlarm(Alarm alarm)
      : _isEnabled = alarm._isEnabled,
        _timeOfDay = alarm._timeOfDay,
        _settings = alarm._settings.copy() {
    _schedules = createSchedules(_settings);
  }

  T getSchedule<T extends AlarmSchedule>() {
    return _schedules.whereType<T>().first;
  }

  dynamic getSetting(String name) {
    return _settings.getSetting(name);
  }

  void setSetting(BuildContext context, String name, dynamic value) {
    _settings.getSetting(name).setValue(context, value);
  }

  void toggle() {
    if (_isEnabled) {
      disable();
    } else {
      enable();
    }
  }

  void setIsEnabled(bool enabled) {
    if (enabled) {
      enable();
    } else {
      disable();
    }
  }

  void schedule() {
    _isEnabled = true;

    for (var schedule in _schedules) {
      if (schedule.runtimeType == scheduleType) {
        schedule.schedule(_timeOfDay);
      } else {
        schedule.cancel();
      }
    }
  }

  void cancel() {
    for (var alarm in _schedules) {
      alarm.cancel();
    }
  }

  void enable() {
    _isEnabled = true;
    schedule();
  }

  void disable() {
    _isEnabled = false;
    cancel();
  }

  void finish() {
    disable();
    _isFinished = true;
  }

  void update() {
    if (_isEnabled) {
      schedule();

      if (activeSchedule.isDisabled) {
        disable();
      }
      if (activeSchedule.isFinished) {
        finish();
      }
    }
  }

  void setTimeOfDay(TimeOfDay timeOfDay) {
    _timeOfDay = timeOfDay;
  }

  bool hasScheduleWithId(int scheduleId) {
    return _schedules.any((schedule) => schedule.hasId(scheduleId));
  }

  List<Weekday> getWeekdays() {
    return (getSetting("Week Days") as ToggleSetting<int>)
        .selected
        .map((weekdayId) =>
            weekdays.firstWhere((weekday) => weekday.id == weekdayId))
        .toList();
  }

  List<DateTime> getDates() {
    return (getSetting("Dates") as DateTimeSetting).value;
  }

  DateTime getStartDate() {
    return (getSetting("Date Range") as DateTimeSetting).value[0];
  }

  DateTime getEndDate() {
    return (getSetting("Date Range") as DateTimeSetting).value[1];
  }

  Duration getInterval() {
    return (getSetting("Interval") as SelectSetting<Duration>).value;
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : _timeOfDay = TimeOfDayUtils.fromJson(json['timeOfDay']),
        _isEnabled = json['enabled'],
        _isFinished = json['finished'],
        _settings = Settings(appSettings
            .getSettingGroup("Default Settings")
            .copy()
            .settingItems) {
    _settings.fromJson(json['settings']);
    _schedules = [
      OnceAlarmSchedule.fromJson(json['schedules'][0]),
      DailyAlarmSchedule.fromJson(json['schedules'][1]),
      WeeklyAlarmSchedule.fromJson(
        json['schedules'][2],
        _settings.getSetting("Week Days"),
      ),
      DatesAlarmSchedule.fromJson(
        json['schedules'][3],
        settings.getSetting("Dates"),
      ),
      RangeAlarmSchedule.fromJson(
        json['schedules'][4],
        settings.getSetting("Date Range"),
        settings.getSetting("Interval"),
      ),
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        'timeOfDay': _timeOfDay.toJson(),
        'enabled': _isEnabled,
        'finished': _isFinished,
        'schedules': _schedules
            .map<Map<String, dynamic>>((schedule) => schedule.toJson())
            .toList(),
        'settings': _settings.toJson(),
      };
}
