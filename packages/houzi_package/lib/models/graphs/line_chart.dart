import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';

class LineGraphSeries {
  final String label;
  final List<FlSpot> data;
  final Color color;
  LineGraphSeries({required this.label, required this.data, required this.color});
}

class InsightsChartEntry {
  final String date;
  final String label;
  final int views;
  final int uniqueViews;

  InsightsChartEntry({
    required this.date,
    required this.label,
    required this.views,
    required this.uniqueViews,
  });

  
}
