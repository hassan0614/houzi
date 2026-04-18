import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/models/graphs/line_chart.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class GenericLineGraphWidget extends StatefulWidget {
  final String title;
  final List<LineGraphSeries> seriesList;
  final List<String> xLabels;
  final double minY;
  final double maxY;
  final double barWidth;
  final bool preventCurveOverShooting;
  final bool isStepLineChart;
  final bool isStrokeCapRound;
  final bool showBorderData;
  final bool showGridData;
  final bool showTitlesData;
  final bool showLeftSideTitles;
  final bool showBottomTitles;
  final bool showRightSideTitles;
  final bool showTopTitles;
  final bool makeCurvedLine;
  final bool showDotsData;
  final bool showBelowBarColor;
  final bool isStrokeJoinRound;
  final bool showLegendLineGraphWidget;
  final bool legendIsClickable;

  const GenericLineGraphWidget({
    Key? key,
    required this.title,
    required this.seriesList,
    required this.xLabels,
    this.minY = 0,
    this.maxY = 1,
    this.barWidth = 2.0,
    this.preventCurveOverShooting = true,
    this.isStepLineChart = false,
    this.isStrokeCapRound = true,
    this.showBorderData = false,
    this.showGridData = false,
    this.showTitlesData = true,
    this.showLeftSideTitles = true,
    this.showBottomTitles = true,
    this.showRightSideTitles = false,
    this.showTopTitles = false,
    this.makeCurvedLine = true,
    this.showDotsData = true,
    this.showBelowBarColor = true,
    this.isStrokeJoinRound = true,
    this.showLegendLineGraphWidget = true,
    this.legendIsClickable = false,
  }) : super(key: key);

  @override
  State<GenericLineGraphWidget> createState() => _GenericLineGraphWidgetState();
}

class _GenericLineGraphWidgetState extends State<GenericLineGraphWidget> {
  late List<bool> _crossedOut;

  @override
  void initState() {
    super.initState();
    _crossedOut = List.filled(widget.seriesList.length, false);
  }

  void _toggleCrossedOut(int index) {
    setState(() {
      _crossedOut[index] = !_crossedOut[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only show series that are not crossed out
    final visibleSeries = <LineGraphSeries>[];
    for (int i = 0; i < widget.seriesList.length; i++) {
      if (!_crossedOut[i]) {
        visibleSeries.add(widget.seriesList[i]);
      }
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.showLegendLineGraphWidget
              ? LineGraphLegend(
                  seriesList: widget.seriesList,
                  legendIsClickable: widget.legendIsClickable,
                  crossedOut: _crossedOut,
                  onLegendTap: widget.legendIsClickable ? _toggleCrossedOut : null,
                )
              : const SizedBox.shrink(),
          SizedBox(
            height: 200,
            child: LineGraphChart(
              seriesList: visibleSeries,
              xLabels: widget.xLabels,
              minY: widget.minY,
              maxY: widget.maxY,
              barWidth: widget.barWidth,
              preventCurveOverShooting: widget.preventCurveOverShooting,
              isStepLineChart: widget.isStepLineChart,
              isStrokeCapRound: widget.isStrokeCapRound,
              showBorderData: widget.showBorderData,
              showGridData: widget.showGridData,
              showTitlesData: widget.showTitlesData,
              showLeftSideTitles: widget.showLeftSideTitles,
              showBottomTitles: widget.showBottomTitles,
              showRightSideTitles: widget.showRightSideTitles,
              showTopTitles: widget.showTopTitles,
              makeCurvedLine: widget.makeCurvedLine,
              showDotsData: widget.showDotsData,
              showBelowBarColor: widget.showBelowBarColor,
              isStrokeJoinRound: widget.isStrokeJoinRound,
            ),
          ),
        ],
      ),
    );
  }
}

class LineGraphChart extends StatefulWidget {
  final List<LineGraphSeries> seriesList;
  final List<String> xLabels;
  final double barWidth;
  final double minY;
  final double maxY;
  final bool preventCurveOverShooting;
  final bool isStepLineChart;
  final bool isStrokeCapRound;
  final bool showBorderData;
  final bool showGridData;
  final bool showTitlesData;
  final bool showLeftSideTitles;
  final bool showBottomTitles;
  final bool showRightSideTitles;
  final bool showTopTitles;
  final bool makeCurvedLine;
  final bool showDotsData;
  final bool showBelowBarColor;
  final bool isStrokeJoinRound;

  const LineGraphChart({
    Key? key,
    required this.seriesList,
    required this.xLabels,
    required this.minY,
    required this.maxY,
    required this.barWidth,
    required this.preventCurveOverShooting,
    required this.isStepLineChart,
    required this.isStrokeCapRound,
    required this.showBorderData,
    required this.showGridData,
    required this.showTitlesData,
    required this.showLeftSideTitles,
    required this.showBottomTitles,
    required this.showRightSideTitles,
    required this.showTopTitles,
    required this.makeCurvedLine,
    required this.showDotsData,
    required this.showBelowBarColor,
    required this.isStrokeJoinRound,
  }) : super(key: key);

  @override
  State<LineGraphChart> createState() => _LineGraphChartState();
}

class _LineGraphChartState extends State<LineGraphChart>
    with SingleTickerProviderStateMixin {
  bool _isDataLoaded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      opacity: _isDataLoaded ? 1.0 : 0.0,
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LineChart(
            _lineChartData(
                barWidth: widget.barWidth,
                preventCurveOverShooting: widget.preventCurveOverShooting,
                isStepLineChart: widget.isStepLineChart,
                isStrokeCapRound: widget.isStrokeCapRound,
                showBorderData: widget.showBorderData,
                showGridData: widget.showGridData,
                showTitlesData: widget.showTitlesData,
                showLeftSideTitles: widget.showLeftSideTitles,
                showBottomTitles: widget.showBottomTitles,
                showRightSideTitles: widget.showRightSideTitles,
                showTopTitles: widget.showTopTitles,
                makeCurvedLine: widget.makeCurvedLine,
                showDotsData: widget.showDotsData,
                showBelowBarColor: widget.showBelowBarColor,
                isStrokeJoinRound: widget.isStrokeJoinRound),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  LineChartData _lineChartData({
    required bool preventCurveOverShooting,
    required bool isStepLineChart,
    required bool isStrokeCapRound,
    required bool showBorderData,
    required bool showGridData,
    required bool showTitlesData,
    required bool showLeftSideTitles,
    required bool showBottomTitles,
    required bool showRightSideTitles,
    required bool showTopTitles,
    required bool makeCurvedLine,
    required bool showDotsData,
    required bool showBelowBarColor,
    required bool isStrokeJoinRound,
    required double barWidth,
  }) {
    return LineChartData(
      minY: widget.minY,
      lineTouchData: _lineTouchData(),
      maxY: widget.maxY,
      borderData: FlBorderData(show: showBorderData),
      gridData: FlGridData(
        show: showGridData,
        drawVerticalLine: false,
        horizontalInterval: 3,
        drawHorizontalLine: true,
        checkToShowHorizontalLine: (double value) => true,
      ),

      titlesData: FlTitlesData(
        show: showTitlesData,

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: showLeftSideTitles,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GenericTextWidget(
                  "${value.toInt().toString()}",
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: showBottomTitles,
            interval: 2,
            getTitlesWidget: (value, meta) {
              int idx = value.toInt();
              if (idx >= 0 && idx < widget.xLabels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0,),
                  child: Transform.rotate(
                  angle: -0.785398,
                  child: GenericTextWidget(
                    widget.xLabels[idx],
                    style: const TextStyle(fontSize: 9),
                  ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        rightTitles:
            AxisTitles(sideTitles: SideTitles(showTitles: showRightSideTitles)),
        topTitles:
            AxisTitles(sideTitles: SideTitles(showTitles: showTopTitles)),
      ),
      lineBarsData: widget.seriesList
          .map((series) => LineChartBarData(
                spots: series.data,
                isCurved: makeCurvedLine,
                color: series.color,
                barWidth: barWidth,
                preventCurveOverShooting: preventCurveOverShooting,
                isStepLineChart: isStepLineChart,
                isStrokeCapRound: isStrokeCapRound,
                isStrokeJoinRound: isStrokeJoinRound,
                dotData: FlDotData(show: showDotsData),
                belowBarData: BarAreaData(
                  show: showBelowBarColor,
                  gradient: LinearGradient(
                    colors: [
                      series.color.withValues(alpha: 0.5),
                      series.color.withValues(alpha: 0.5),
                    ],
                    stops: const [0.5, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ))
          .toList(),
    );
  }
 LineTouchData _lineTouchData(){
    return LineTouchData(
  touchTooltipData: LineTouchTooltipData(
    getTooltipColor: (touchedSpot) => touchedSpot.bar.color ?? Colors.blueGrey,
    
    getTooltipItems: (List<LineBarSpot> touchedSpots) {
      if (touchedSpots.isEmpty) return [];
      int touchedIndex = 0;
      return List.generate(touchedSpots.length, (i) {
        if (i == touchedIndex) {
          final spot = touchedSpots[i];
          final series = widget.seriesList.firstWhere(
            (s) => s.color == spot.bar.color,
            orElse: () => widget.seriesList[spot.barIndex],
          );
          final label = series.label;
          final xLabel = (spot.x.toInt() >= 0 && spot.x.toInt() < widget.xLabels.length)
              ? widget.xLabels[spot.x.toInt()]
              : '';
          return LineTooltipItem(
            "$label\n${spot.y.toStringAsFixed(2)}\n$xLabel",
            const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        } else {
          return null;
        }
      });
    },
    
    tooltipBorder: BorderSide(
      color: Colors.white.withOpacity(0.2),
      width: 1,
    ),
    tooltipBorderRadius: BorderRadius.circular(8),
    tooltipPadding: EdgeInsets.all(8),
  ),
  
  getTouchedSpotIndicator: (barData, spotIndexes) {
    return spotIndexes.map((index) {
      return TouchedSpotIndicatorData(
        FlLine(
          color: barData.color!.withOpacity(0.3),
          strokeWidth: 1.5,
          dashArray: [5, 5],
        ),
        FlDotData(
          show: true,
        ),
      );
    }).toList();
  },
  
  
  touchSpotThreshold: 15,
);

  }
}

class LineGraphLegend extends StatelessWidget {
  final List<LineGraphSeries> seriesList;
  final bool legendIsClickable;
  final List<bool>? crossedOut;
  final void Function(int index)? onLegendTap;
  const LineGraphLegend({
    Key? key,
    required this.seriesList,
    this.legendIsClickable = false,
    this.crossedOut,
    this.onLegendTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(seriesList.length, (i) {
        final series = seriesList[i];
        final isCrossed = crossedOut != null && crossedOut!.length > i && crossedOut![i];
        final textWidget = GenericTextWidget(
          series.label,
          style: TextStyle(
            fontSize: 12,
            decoration: isCrossed ? TextDecoration.lineThrough : null,
          ),
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(width: 16, height: 4, color: series.color),
              const SizedBox(width: 4),
              legendIsClickable && onLegendTap != null
                  ? GestureDetector(
                      onTap: () => onLegendTap!(i),
                      child: textWidget,
                    )
                  : textWidget,
            ],
          ),
        );
      }),
    );
  }
}
