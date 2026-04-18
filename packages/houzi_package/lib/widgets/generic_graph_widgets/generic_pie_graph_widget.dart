import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/graphs/pie_chart_data_model.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';

class GenericPieGraphWidget extends StatelessWidget {
  final List<PieChartDataModel> dataList;
  final EdgeInsetsGeometry padding;
  final double? chartSize;
  final double? chartAspectRatio;
  final double chartCenterSpaceRadius;
  final double chartSectionRadius;
  final double chartSectionsSpace;
  final double chartStartDegreeOffset;
  final bool? showGraphTitles;

  const GenericPieGraphWidget({
    super.key,
    required this.dataList,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0,),
    this.chartSize,
    this.chartAspectRatio = 1.0,
    this.chartCenterSpaceRadius = 40,
    this.chartSectionRadius = 20,
    this.chartSectionsSpace = 0,
    this.chartStartDegreeOffset = -90,
    this.showGraphTitles = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPieChart(context),
        
            Column(
              mainAxisSize: MainAxisSize.min,
              children: dataList.map((data) {
                return GenericWidgetRow(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 12.0),
                  iconData: AppThemePreferences.circleIcon,
                  iconSize: AppThemePreferences.insightsCardIconSize,
                  text:
                      "${UtilityMethods.getLocalizedString(data.title)}",
                      subText: "${data.value} ${UtilityMethods.getLocalizedString("views")}",
                  fontSize: 14,
                  removeDecoration: false,
                  onTap: () {},
                );
              }).toList(),
            ),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final total = dataList.fold<int>(0, (sum, item) => sum + item.value);
    
    Widget chart = PieChart(
      PieChartData(
        sectionsSpace: chartSectionsSpace,
        centerSpaceRadius: chartCenterSpaceRadius,
        startDegreeOffset: chartStartDegreeOffset,
        sections: dataList.map((data) {
          final percentage = total > 0 ? (data.value / total) * 100 : 0;
          return PieChartSectionData(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            showTitle: showGraphTitles,
            color: data.color,
            value: data.value.toDouble(),
            // title: '${percentage.toStringAsFixed(1)}%',
            // titleStyle: AppThemePreferences().appTheme.bodyTextStyle?.copyWith(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 12,
            //     ) ??
            //     Theme.of(context).textTheme.bodyMedium!.copyWith(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 12,
            //         ),
            radius: chartSectionRadius,
          );
        }).toList(),
      ),
    );

    // Apply size constraints
    if (chartSize != null) {
      return SizedBox(
        width: chartSize,
        height: chartSize,
        child: chart,
      );
    } else {
      return AspectRatio(
        aspectRatio: chartAspectRatio!,
        child: chart,
      );
    }
  }
}