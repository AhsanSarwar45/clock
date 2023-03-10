import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/common/widgets/fields/slider_field.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

class SliderSettingCard extends StatefulWidget {
  final SliderSetting setting;
  final bool showSummaryView;
  final void Function(double)? onChanged;

  const SliderSettingCard({
    Key? key,
    required this.setting,
    this.showSummaryView = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SliderSettingCard> createState() => _SliderSettingCardState();
}

class _SliderSettingCardState extends State<SliderSettingCard> {
  @override
  Widget build(BuildContext context) {
    SliderField sliderCard = SliderField(
      name: widget.setting.name,
      value: widget.setting.value,
      min: widget.setting.min,
      max: widget.setting.max,
      unit: widget.setting.unit,
      onChanged: (value) {
        setState(() {
          widget.setting.setValue(context, value);
        });
        widget.onChanged?.call(widget.setting.value);
      },
    );

    return widget.showSummaryView
        ? sliderCard
        : CardContainer(child: sliderCard);
  }
}
