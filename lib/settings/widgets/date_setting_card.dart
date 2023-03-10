import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/date_picker_field.dart';
import 'package:clock_app/common/widgets/fields/duration_picker_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/timer/types/time_duration.dart';
import 'package:flutter/material.dart';

class DateSettingCard extends StatefulWidget {
  final DateTimeSetting setting;
  final bool showSummaryView;
  final void Function(List<DateTime>)? onChanged;

  const DateSettingCard({
    Key? key,
    required this.setting,
    this.showSummaryView = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DateSettingCard> createState() => _DateSettingCardState();
}

class _DateSettingCardState extends State<DateSettingCard> {
  @override
  Widget build(BuildContext context) {
    Widget input = DatePickerField(
      title: widget.setting.name,
      description: widget.setting.description,
      value: widget.setting.value,
      rangeOnly: widget.setting.rangeOnly,
      onChange: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showSummaryView ? input : CardContainer(child: input);
  }
}
