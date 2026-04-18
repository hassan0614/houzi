import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/graphs/line_chart.dart';
import 'package:houzi_package/models/graphs/pie_chart_data_model.dart';
import 'package:houzi_package/models/insights_model/pie_chart_configs.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_graph_widgets/generic_pie_graph_widget.dart';
import 'package:houzi_package/widgets/generic_graph_widgets/generic_line_graph_widget.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/generic_toggle_button_widget/generic_toggle_button.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fl_chart/fl_chart.dart';


typedef PropertySelectedCallback = void Function(String propertyId, String propertyTitle);
typedef PropertySelectionCallback = void Function(String? propertyId);

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  final ApiManager _apiManager = ApiManager();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  final ScrollController _dropdownScrollController = ScrollController();

  List<dynamic> insightsAllProperties = [];
  List<dynamic> insightsPropertiesData = [];
  List<dynamic> insightUsersData = [];

  bool isLoading = false;
  bool isRefreshing = false;
  bool isInternetConnected = true;
  bool isInsightsDataLoading = false;
  bool isPropertiesLoading = false;
  bool isInsightsDataLoaded = false;
  bool isPropertiesLoaded = false;
  bool isPropertySelectionLoading = false;

  String? selectedPropertyId;
  String? errorMessage;
  String selectedTimePeriod = INSIGHTS_VALUE_SORT_LAST_DAYS;

  // Pagination
  int _currentPage = 1;
  bool _isLoadingMoreProperties = false;
  bool _hasMoreProperties = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _dropdownScrollController.addListener(_scrollListener);
    _loadDataProgressively();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _refreshController.dispose();
    _dropdownScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_dropdownScrollController.position.pixels >=
        _dropdownScrollController.position.maxScrollExtent - 50 &&
        !_isLoadingMoreProperties &&
        _hasMoreProperties) {
      _loadMoreProperties();
    }
  }

  Future<void> _loadDataProgressively() async {
    if (_isDisposed) return;

    try {
      if (!mounted) return;
      setState(() {
        errorMessage = null;
        isInsightsDataLoading = true;
        isPropertiesLoading = true;
      });

      await _loadInsightsData();
      if (_isDisposed) return;

      await _loadPropertiesData();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isInsightsDataLoading = false;
        isPropertiesLoading = false;
      });
      _showToast(errorMessage ??
          UtilityMethods.getLocalizedString("error_loading_data"));
    }
  }

  Future<void> _loadInsightsData() async {
    try {
      await fetchInsightsData();
      if (_isDisposed) return;

      if (!isInternetConnected) {
        if (!mounted) return;
        setState(() {
          errorMessage =
              UtilityMethods.getLocalizedString("no_internet_connection");
          isInsightsDataLoading = false;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        isInsightsDataLoaded = true;
        isInsightsDataLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isInsightsDataLoading = false;
      });
      throw e;
    }
  }

  Future<void> _loadPropertiesData() async {
    try {
      await fetchAllProperties().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (!mounted) return [];
          setState(() {
            isPropertiesLoading = false;
            isPropertiesLoaded = false;
          });
          return [];
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isPropertiesLoading = false;
        isPropertiesLoaded = false;
      });
    }
  }

  Future<void> _loadMoreProperties() async {
    if (!_hasMoreProperties || _isLoadingMoreProperties) return;

    setState(() {
      _isLoadingMoreProperties = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final response =
      await _apiManager.fetchAllUsersProperties(page: nextPage);

      if (response.success && response.internet) {
        final newData = response.result ?? [];

        if (mounted && !_isDisposed) {
          setState(() {
            insightsAllProperties.addAll(newData);
            _currentPage = nextPage;
            _hasMoreProperties =
                newData.length >= 100;
          });
        }
      }
    } catch (e) {
      print("Error loading more properties: $e");
      _showToast("Error loading more Properties: $e");
    } finally {
      if (mounted && !_isDisposed) {
        setState(() {
          _isLoadingMoreProperties = false;
        });
      }
    }
  }

  Future<List<dynamic>> fetchAllProperties() async {
    try {
      setState(() {
        isPropertiesLoading = true;
      });

      final response = await _apiManager.fetchAllUsersProperties(page: 1);

      if (mounted && !_isDisposed) {
        setState(() {
          isInternetConnected = response.internet;
          if (response.success && response.internet) {
            insightsAllProperties = response.result ?? [];
            _currentPage = 1;
            _hasMoreProperties = insightsAllProperties.length >=
                100;
          }
          isPropertiesLoaded = true;
          isPropertiesLoading = false;
        });
      }
    } catch (e) {
      print("Error in fetchAllProperties: $e");
      _showToast("Error in fetchAllProperties: $e");
      if (mounted && !_isDisposed) {
        setState(() {
          insightsAllProperties = [];
          isPropertiesLoading = false;
          isPropertiesLoaded = false;
        });
      }
    }

    return insightsAllProperties;
  }

  void _onPropertySelected(String? propertyId) async {
    if (propertyId != null && propertyId != selectedPropertyId) {
      if (!mounted) return;
      setState(() {
        selectedPropertyId = propertyId;
        isPropertySelectionLoading = true;
      });

      try {
        await fetchInsightsData(propertyId: int.tryParse(propertyId));

        if (!mounted) return;
        setState(() {
          isPropertySelectionLoading = false;
        });
      } catch (e) {
        _showToast(e.toString());
        if (!mounted) return;
        setState(() {
          isPropertySelectionLoading = false;
        });
      }
    }
  }

  Future<List<dynamic>> fetchInsightsData(
      {String? timePeriod, int? propertyId}) async {
    List<dynamic> tempList = [];
    List list = [];
    late ApiResponse<List> response;

    response = await _apiManager.fetchUserInsights(
        timePeriod: timePeriod, propertyId: propertyId);

    if (mounted && !_isDisposed) {
      setState(() {
        isInternetConnected = response.internet;
        if (response.success && response.internet) {
          list = response.result ?? [];
        }
        if (list.isNotEmpty) {
          tempList = list;
        }
        if (tempList.isNotEmpty) {
          insightUsersData = tempList;
        }
      });
    }
    return insightUsersData;
  }

  void _handleRefresh() async {
    if (!mounted) return;
    setState(() {
      selectedPropertyId = null;
      insightsAllProperties.clear();
      insightsPropertiesData.clear();
      insightUsersData.clear();
      isInsightsDataLoaded = false;
      isPropertiesLoaded = false;
      _currentPage = 1;
      _hasMoreProperties = true;
    });
    await _loadDataProgressively();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("insights"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const MaterialClassicHeader(),
        onRefresh: _handleRefresh,
        child: _buildProgressiveBody(),
      ),
    );
  }

  Widget _buildProgressiveBody() {
    if (isInsightsDataLoading && insightUsersData.isEmpty) {
      return const LoadingIndicatorWidget();
    }

    if (errorMessage != null &&
        !isInsightsDataLoaded &&
        insightUsersData.isEmpty) {
      return noResultFoundPage();
    }

    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          isPropertiesLoading
              ? _buildPropertiesShimmer()
              : _buildInsightPropertiesDropDown(
              context, Future.value(insightsAllProperties)),
          const SizedBox(height: 10,),
          if (isPropertySelectionLoading) ...[
            _buildInsightsCardShimmer(
                title: UtilityMethods.getLocalizedString("views")),
            _buildInsightsCardShimmer(
                title: UtilityMethods.getLocalizedString("unique_views")),
            _buildPieChartShimmer(
                title: UtilityMethods.getLocalizedString("visits")),
            _buildPieChartShimmer(
                title: UtilityMethods.getLocalizedString("Top Countries")),
            _buildPieChartShimmer(
                title: UtilityMethods.getLocalizedString("devices")),
            _buildPieChartShimmer(
                title: UtilityMethods.getLocalizedString("browsers")),
            _buildPieChartShimmer(
                title: UtilityMethods.getLocalizedString("platforms")),
          ] else if (isInsightsDataLoaded || insightUsersData.isNotEmpty) ...[
            _buildViewsCard(),
            _buildUniqueViewsCard(),
            _buildLineGraphCard(),
            ..._buildDynamicPieCharts(),
          ] else ...[
            _buildInsightsCardShimmer(
                title: UtilityMethods.getLocalizedString("views")),
            _buildInsightsCardShimmer(
                title: UtilityMethods.getLocalizedString("unique_views")),
            _buildInsightsCardShimmer(
                title: UtilityMethods.getLocalizedString("visits")),
          ],
        ],
      ),
    );
  }

  Widget _buildPropertiesShimmer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Shimmer.fromColors(
        baseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor!,
        highlightColor:
        AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
            borderRadius: BorderRadius.circular(
                AppThemePreferences.globalRoundedCornersRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsCardShimmer({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: CardWidget(
        shape: AppThemePreferences.roundedCorners(
            AppThemePreferences.globalRoundedCornersRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor:
                AppThemePreferences().appTheme.shimmerEffectBaseColor!,
                highlightColor:
                AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppThemePreferences
                            .shimmerLoadingWidgetContainerColor,
                        borderRadius: BorderRadius.circular(
                            AppThemePreferences.globalRoundedCornersRadius),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(
                          3,
                              (index) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppThemePreferences
                                      .shimmerLoadingWidgetContainerColor,
                                  borderRadius: BorderRadius.circular(
                                      AppThemePreferences
                                          .globalRoundedCornersRadius),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartShimmer({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CardWidget(
        shape: AppThemePreferences.roundedCorners(
            AppThemePreferences.globalRoundedCornersRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenericWidgetRow(
                padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                iconData: AppThemePreferences.circleIcon,
                iconSize: AppThemePreferences.insightsCardIconSize,
                text: title,
                removeDecoration: false,
                onTap: () {},
              ),
              Shimmer.fromColors(
                baseColor:
                AppThemePreferences().appTheme.shimmerEffectBaseColor!,
                highlightColor:
                AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color:
                    AppThemePreferences.shimmerLoadingWidgetContainerColor,
                    borderRadius: BorderRadius.circular(
                        AppThemePreferences.globalRoundedCornersRadius),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_found"),
    );
  }

  Widget _buildInsightPropertiesDropDown(
      BuildContext context, Future<List<dynamic>> futureInsightPropertiesList) {
    if (isPropertiesLoading) {
      return _buildPropertiesShimmer();
    }

    if (!isPropertiesLoaded || insightsAllProperties.isEmpty) {
      return _buildNoPropertiesMessage();
    }

    return _PaginatedPropertiesDropdown(
      properties: insightsAllProperties,
      selectedPropertyId: selectedPropertyId,
      onPropertySelected: _onPropertySelected,
      labelText: UtilityMethods.getLocalizedString("filter_by_listing"),
      hintText: UtilityMethods.getLocalizedString("select"),
    );
  }

  Widget _buildNoPropertiesMessage() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CardWidget(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("no_property_available"),
              style: AppThemePreferences().appTheme.bodyTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightsCard(
      {required String title, String? subText, required Widget child}) {
    return InsightCard(
      title: title,
      subText: subText,
      child: child,
    );
  }

  List<Widget> _buildDynamicPieCharts() {
    final userInsight =
    insightUsersData.isNotEmpty ? insightUsersData.first : null;
    if (userInsight == null) return [];

    final List<PieChartConfig> chartConfigs = [
      PieChartConfig(
        title: 'Top Countries',
        data: userInsight.countries ?? [],
      ),
      PieChartConfig(
        title: 'devices',
        data: userInsight.device ?? [],
      ),
      PieChartConfig(
        title: 'browsers',
        data: userInsight.browser ?? [],
      ),
      PieChartConfig(
        title: 'platforms',
        data: userInsight.platform ?? [],
      ),
    ];

    return chartConfigs
        .where((config) => config.data.isNotEmpty)
        .map((config) => _buildPieChartGeneric(
      title: UtilityMethods.getLocalizedString(config.title),
      data: config.data,
    ))
        .toList();
  }

  Widget _buildPieChartGeneric(
      {required String title, required List<dynamic> data}) {
    List<PieChartDataModel> pieData = [];
    int index = 0;

    for (final item in data) {
      String name = item.name ?? '';
      int count = 0;

      if (name.isEmpty || name.trim().isEmpty) {
        name = "Unknown";
      }

      if (item.count != null) {
        count = item.count;
      }

      if (count > 0) {
        pieData.add(PieChartDataModel(
          title: name,
          value: count,
          color: AppThemePreferences
              .colors[index % AppThemePreferences.colors.length],
        ));
        index++;
      }
    }

    if (pieData.isEmpty) {
      return _buildInsightsCard(
        title: title,
        child: Center(
            child: GenericTextWidget(
                UtilityMethods.getLocalizedString("no_data"))),
      );
    }

    return _buildInsightsCard(
      title: title,
      child: GenericPieGraphWidget(
        chartSize: 150,
        dataList: pieData,
      ),
    );
  }

  Widget _buildViewsCard() {
    final userInsight =
    insightUsersData.isNotEmpty ? insightUsersData.first : null;

    if (userInsight == null ||
        userInsight.views == null ||
        userInsight.views!.isEmpty) {
      return _buildInsightsCard(
        title: UtilityMethods.getLocalizedString("views"),
        child: Center(
          child:
          GenericTextWidget(UtilityMethods.getLocalizedString("no_data")),
        ),
      );
    }

    return _buildInsightsCard(
      title: UtilityMethods.getLocalizedString("views"),
      child: Row(
        children: userInsight.views!
            .take(3)
            .map<Widget>((view) => Expanded(
          child: buildInsightsCard(
            labelNumber: view.count?.toString() ?? "0",
            isTrendingUp: _isTrendingUp(view.percentage ?? 0),
            percentage:
            UtilityMethods.formatPercentage(view.percentage ?? 0),
            timePeriod: view.period ?? "Unknown",
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildUniqueViewsCard() {
    final userInsight =
    insightUsersData.isNotEmpty ? insightUsersData.first : null;

    if (userInsight == null ||
        userInsight.uniqueViews == null ||
        userInsight.uniqueViews!.isEmpty) {
      return _buildInsightsCard(
        title: UtilityMethods.getLocalizedString("unique_views"),
        child: Center(
          child:
          GenericTextWidget(UtilityMethods.getLocalizedString("no_data")),
        ),
      );
    }

    return _buildInsightsCard(
      title: UtilityMethods.getLocalizedString("unique_views"),
      child: Row(
        children: userInsight.uniqueViews!
            .take(3)
            .map<Widget>((view) => Expanded(
          child: buildInsightsCard(
            labelNumber: view.count?.toString() ?? "0",
            isTrendingUp: _isTrendingUp(view.percentage ?? 0),
            percentage:
            UtilityMethods.formatPercentage(view.percentage ?? 0),
            timePeriod: view.period ?? "Unknown",
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget buildInsightsCard({
    required String labelNumber,
    required bool isTrendingUp,
    required String percentage,
    required String timePeriod,
  }) {
    return SizedBox(
      height: 130,
      child: CardWidget(
        shape: AppThemePreferences.roundedCorners(
            AppThemePreferences.globalRoundedCornersRadius),
        color: isTrendingUp
            ? AppThemePreferences().appTheme.trendingUpCardColor
            : AppThemePreferences().appTheme.trendingDownCardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GenericTextWidget(
                      labelNumber,
                      style: AppThemePreferences().appTheme.heading01TextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isTrendingUp
                      ? (AppThemePreferences().appTheme.trendingUpIcon ??
                      const SizedBox(width: 12, height: 12))
                      : (AppThemePreferences().appTheme.trendingDownIcon ??
                      const SizedBox(width: 12, height: 12)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: GenericTextWidget(
                      percentage,
                      style: AppThemePreferences().appTheme.label04TextStyle!.copyWith(
                        color: isTrendingUp
                            ? AppThemePreferences.trendingUpIconColor
                            : AppThemePreferences.trendingDownIconColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: GenericTextWidget(
                    timePeriod,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: AppThemePreferences().appTheme.tag01TextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  bool _isTrendingUp(int percentage) {
    return percentage > 0;
  }

  void _showToast(String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget _buildLineGraphCard() {
    return _LineGraphCard(
      chartEntries: insightUsersData.isNotEmpty
          ? (insightUsersData.first.chartsList ?? [])
          : [],
      selectedTimePeriod: selectedTimePeriod,
      onTimePeriodSelected: onGraphTimePeriodSelected,
      propertyId: selectedPropertyId,
    );
  }

  Future<List<dynamic>> onGraphTimePeriodSelected(
      String timePeriod, int id) async {
    setState(() {
      selectedTimePeriod = timePeriod;
    });
    await fetchInsightsData(timePeriod: timePeriod, propertyId: id);
    return insightUsersData;
  }
}

class InsightCard extends StatelessWidget {
  final String title;
  final String? subText;
  final Widget child;

  InsightCard({
    super.key,
    required this.title,
    this.subText,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
          AppThemePreferences.globalRoundedCornersRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.0,
          children: [
            GenericWidgetRow(
              padding:
              const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
              iconData: AppThemePreferences.circleIcon,
              iconSize: AppThemePreferences.insightsCardIconSize,
              text: UtilityMethods.getLocalizedString(title),
              removeDecoration: false,
              onTap: () {},
            ),
            child,
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _LineGraphCard extends StatefulWidget {
  final List<InsightsChartEntry> chartEntries;
  final String selectedTimePeriod;
  final Future<List<dynamic>> Function(String, int) onTimePeriodSelected;
  final String? propertyId;

  const _LineGraphCard({
    required this.chartEntries,
    required this.selectedTimePeriod,
    required this.onTimePeriodSelected,
    required this.propertyId,
    Key? key,
  }) : super(key: key);

  @override
  State<_LineGraphCard> createState() => _LineGraphCardState();
}

class _LineGraphCardState extends State<_LineGraphCard> {
  late String _selectedTimePeriod;
  bool _isLoading = false;
  List<InsightsChartEntry> _chartEntries = [];

  @override
  void initState() {
    super.initState();
    _selectedTimePeriod = widget.selectedTimePeriod;
    _chartEntries = widget.chartEntries;
  }

  @override
  void didUpdateWidget(covariant _LineGraphCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTimePeriod != oldWidget.selectedTimePeriod) {
      _selectedTimePeriod = widget.selectedTimePeriod;
    }
    if (widget.chartEntries != oldWidget.chartEntries) {
      _chartEntries = widget.chartEntries;
    }
  }

  Future<void> _handleTimePeriodChange(String value) async {
    setState(() {
      _isLoading = true;
      _selectedTimePeriod = value;
    });
    final data = await widget.onTimePeriodSelected(
      value,
      int.tryParse(widget.propertyId ?? '0') ?? 0,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (data.isNotEmpty && data.first.chartsList != null) {
        _chartEntries = data.first.chartsList!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chartEntries.isEmpty) {
      return _buildInsightsCard(
        title: UtilityMethods.getLocalizedString("views"),
        child: Center(
            child: GenericTextWidget(
                UtilityMethods.getLocalizedString("no_data"))),
      );
    }
    final List<String> xLabels = _chartEntries.map((e) => e.label).toList();
    final List<FlSpot> viewsSpots = [];
    final List<FlSpot> uniqueViewsSpots = [];
    double maxY = 0;
    for (int i = 0; i < _chartEntries.length; i++) {
      final entry = _chartEntries[i];
      viewsSpots.add(FlSpot(i.toDouble(), entry.views.toDouble()));
      uniqueViewsSpots.add(FlSpot(i.toDouble(), entry.uniqueViews.toDouble()));
      if (entry.views > maxY) maxY = entry.views.toDouble();
      if (entry.uniqueViews > maxY) maxY = entry.uniqueViews.toDouble();
    }
    if (maxY < 5)
      maxY = 5;
    else
      maxY = (maxY * 1.2).ceilToDouble();

    final List<LineGraphSeries> seriesList = [
      LineGraphSeries(
        label: UtilityMethods.getLocalizedString("views"),
        color: AppThemePreferences.insightsVisitsColor,
        data: viewsSpots,
      ),
      LineGraphSeries(
        label: UtilityMethods.getLocalizedString("unique_views"),
        color: AppThemePreferences.insightsUniqueVisitsColor,
        data: uniqueViewsSpots,
      ),
    ];

    return _buildInsightsCard(
      title: UtilityMethods.getLocalizedString("visits"),
      child: Column(
        children: [
          GenericToggleButtonWidget(
            buttonHeight: 30,
            labels: INSIGHTS_LABEL_SORT_LIST,
            values: INSIGHTS_VALUE_SORT_LIST,
            onSelected: _handleTimePeriodChange,
            initialValue: _selectedTimePeriod,
            selectedColor: AppThemePreferences.appPrimaryColor,
            fillColor:
            AppThemePreferences.appPrimaryColor.withValues(alpha: 0.2),
            borderColor: AppThemePreferences.appPrimaryColor,
            selectedBorderColor: AppThemePreferences.appPrimaryColor,
          ),
          const SizedBox(height: 10),
          _isLoading
              ? const PanelLoadingWidget()
              : SizedBox(
            height: 220,
            child: GenericLineGraphWidget(
              legendIsClickable: true,
              seriesList: seriesList,
              xLabels: xLabels,
              minY: 0,
              maxY: maxY,
              title: UtilityMethods.getLocalizedString("visits"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard(
      {required String title, String? subText, required Widget child}) {
    return InsightCard(
      title: title,
      subText: subText,
      child: child,
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }
}

class _PaginatedPropertiesDropdown extends StatelessWidget {
  final List<dynamic> properties;
  final String? selectedPropertyId;
  final PropertySelectionCallback onPropertySelected;
  final String labelText;
  final String hintText;

  const _PaginatedPropertiesDropdown({
    required this.properties,
    required this.selectedPropertyId,
    required this.onPropertySelected,
    required this.labelText,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  String getSelectedPropertyTitle() {
    if (selectedPropertyId == null) return hintText;

    final selected = properties.firstWhere(
          (property) => property.id.toString() == selectedPropertyId,
      orElse: () => null,
    );

    return selected?.title ?? hintText;
  }

  Future<void> _navigateToPropertySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertySelectionScreen(
          currentlySelectedPropertyId: selectedPropertyId,
          initialProperties: properties,
          onPropertySelected: (propertyId, propertyTitle) {
            onPropertySelected(propertyId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Text(
            labelText,
            style: AppThemePreferences().appTheme.labelTextStyle,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateToPropertySelection(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: AppThemePreferences().appTheme.cardColor,
              borderRadius: BorderRadius.circular(AppThemePreferences.globalRoundedCornersRadius),
              border: Border.all(color: AppThemePreferences().appTheme.tagBorderColor!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    getSelectedPropertyTitle(),
                    style: AppThemePreferences().appTheme.bodyTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppThemePreferences().appTheme.bodyTextStyle!.color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PropertySelectionScreen extends StatefulWidget {
  final String? currentlySelectedPropertyId;
  final List<dynamic> initialProperties;
  final PropertySelectedCallback onPropertySelected;

  const PropertySelectionScreen({
    Key? key,
    this.currentlySelectedPropertyId,
    this.initialProperties = const [],
    required this.onPropertySelected,
  }) : super(key: key);

  @override
  State<PropertySelectionScreen> createState() => _PropertySelectionScreenState();
}

class _PropertySelectionScreenState extends State<PropertySelectionScreen> {
  final ApiManager _apiManager = ApiManager();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _properties = [];
  List<dynamic> _filteredProperties = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isSearching = false;

  int _currentPage = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _properties = widget.initialProperties;
    _filteredProperties = _properties;

    _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);

    if (_properties.isEmpty) {
      _loadProperties();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _hasMore &&
        !_isSearching) {
      _loadMoreProperties();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _searchQuery) {
      setState(() {
        _searchQuery = query;
        _isSearching = query.isNotEmpty;
      });

      if (query.isEmpty) {
        _filteredProperties = _properties;
      } else {
        _filteredProperties = _properties.where((property) {
          final title = property.title?.toString().toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();
      }
    }
  }

  Future<void> _loadProperties() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiManager.fetchAllUsersProperties(page: 1);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (response.success && response.internet) {
            _properties = response.result ?? [];
            _filteredProperties = _properties;
            _currentPage = 1;
            _hasMore = _properties.length >= 100;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreProperties() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final response = await _apiManager.fetchAllUsersProperties(page: nextPage);

      if (mounted) {
        if (response.success && response.internet) {
          final newProperties = response.result ?? [];
          setState(() {
            _properties.addAll(newProperties);
            if (!_isSearching) {
              _filteredProperties = _properties;
            }
            _currentPage = nextPage;
            _hasMore = newProperties.length >= 100;
          });
        }
      }
    } catch (e) {
      _showToast(context, "Error loading more properties: $e");
      print("Error loading more properties: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _handlePropertySelection(String propertyId, String propertyTitle) {
    widget.onPropertySelected(propertyId, propertyTitle);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("select_property"),
        automaticallyImplyLeading: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: _buildSearchBar(),
        ),
      ),
      body: _isLoading && _properties.isEmpty
          ? const LoadingIndicatorWidget()
          : _filteredProperties.isEmpty
          ? noResultFoundPage()
          : _buildPropertiesList(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CardWidget(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: UtilityMethods.getLocalizedString("search_properties"),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
  _showToast(BuildContext context, String msg) {
    ShowToastWidget(buildContext: context, text: msg, behavior: SnackBarBehavior.floating);
  }
  Widget _buildPropertiesList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _filteredProperties.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _filteredProperties.length) {
          return _buildLoadMoreIndicator();
        }

        final property = _filteredProperties[index];
        final propertyId = property.id.toString();
        final propertyTitle = property.title ?? UtilityMethods.getLocalizedString("unnamed_property");

        return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString(propertyTitle),
                  style: AppThemePreferences()
                      .appTheme
                      .subBody01TextStyle,
                ),
                decoration: decoration(),
              ),

              onTap: () => _handlePropertySelection(propertyId, propertyTitle),
            ),
          );
      },
    );
  }
  Decoration decoration(){
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: AppThemePreferences().appTheme.dividerColor!,
        ),
      ),
    );
  }
  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _isLoadingMore
            ? const SizedBox(
          width: 24,
          height: 24,
          child: BallBeatLoadingWidget(),
        )
            : _hasMore
            ? TextButton(
          onPressed: _loadMoreProperties,
          child: Text(UtilityMethods.getLocalizedString("load_more")),
        )
            : Container(),
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_properties_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_properties_match_search"),
    );
  }
}

class PanelLoadingWidget extends StatelessWidget {
  const PanelLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor!,
      highlightColor:
      AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DummyContainer(
                  width: 20,
                  height: 130,
                  decoration: BoxDecoration(
                    color:
                    AppThemePreferences.shimmerLoadingWidgetContainerColor,
                    borderRadius: BorderRadius.circular(
                        AppThemePreferences.globalRoundedCornersRadius),
                  ),
                ),
                DummyContainer(
                  width: 270,
                  height: 130,
                  decoration: BoxDecoration(
                    color:
                    AppThemePreferences.shimmerLoadingWidgetContainerColor,
                    borderRadius: BorderRadius.circular(
                        AppThemePreferences.globalRoundedCornersRadius),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            DummyContainer(
              width: 270,
              height: 20,
              decoration: BoxDecoration(
                color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
                borderRadius: BorderRadius.circular(
                    AppThemePreferences.globalRoundedCornersRadius),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DummyContainer extends StatelessWidget {
  final double width;
  final double height;
  final Decoration decoration;

  const DummyContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: width, height: height, decoration: decoration);
  }
}
