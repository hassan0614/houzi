import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/string_ext.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';

class SearchByStatusWidget extends StatelessWidget {
  final int? totalSwitches;
  final List<String> labels;
  final int initialLabelIndex;
  final double fontSize;
  final double minHeight;
  final double minWidth;
  final double borderWidth;
  final double cornerRadius;
  final bool radiusStyle;
  final bool shouldCupertinoSlider;
  final Function(int?)? onToggle;

  const SearchByStatusWidget({
    super.key,
    required this.labels,
    this.totalSwitches,
    this.initialLabelIndex = 0,
    this.fontSize = 16.0,
    this.minHeight = 40.0,
    this.minWidth = 72.0,
    this.borderWidth = 1.0,
    this.cornerRadius = 8.0,
    this.radiusStyle = false,
    this.shouldCupertinoSlider = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldCupertinoSlider) {
      double _minWidth = minWidth;
      for (var element in labels) {
        _minWidth = max(_minWidth, element.textWidth(
            AppThemePreferences().appTheme.bodyTextStyle!.copyWith(
                fontSize: fontSize)));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ToggleSwitch(
          animate: false,
          cornerRadius: cornerRadius,
          borderWidth: borderWidth,
          minHeight: minHeight,
          minWidth: _minWidth,
          radiusStyle: radiusStyle,
          fontSize: fontSize,
          inactiveBgColor: AppThemePreferences().appTheme
              .switchUnselectedBackgroundColor,
          inactiveFgColor: AppThemePreferences().appTheme
              .switchUnselectedItemTextColor,
          activeFgColor: AppThemePreferences().appTheme
              .switchSelectedItemTextColor,
          activeBgColor: [
            AppThemePreferences().appTheme.switchSelectedBackgroundColor!,
          ],
          totalSwitches: totalSwitches!,
          labels: labels,
          initialLabelIndex: initialLabelIndex == -1 ? 0 : initialLabelIndex,
          onToggle: onToggle,
        ),
      );
    } else {
      return TabBarTitleWidget(
        itemList: labels,
        initialSelection: initialLabelIndex == -1 ? 0 : initialLabelIndex,
        onSegmentChosen: onToggle,
      );
    }
  }
}