import 'package:houzi_package/models/insights_model/top_insights_meta_data.dart';
import 'package:houzi_package/models/insights_model/views.dart';
import 'package:houzi_package/models/graphs/line_chart.dart';

class InsightsUserProperties {
  final String? id;
  final String? userId;
  final bool? success;
  final String? timePeriod;
  final String? totalProperties;
  final String? totalViews;
  final String? totalUniqueViews;
  
  final String? title;
  final String? url;
  final String? status;
  final String? lastUpdated;
  final String? thumbnail;
  final List<Views>? views;
  final List<Views>? uniqueViews;
  
  // Additional fields for the complete JSON structure
  final List<Map<String, dynamic>>? topProperties;
  final Map<String, dynamic>? charts;
  final List<Map<String, dynamic>>? trafficSources;
  final List<TopInsightsMetaData>? countries;
  final List<TopInsightsMetaData>? device;
  final  List<TopInsightsMetaData>? platform;
  final  List<TopInsightsMetaData>? browser;
  final int? perPage;
  final int? page;
  final int? totalPages;
  final int? count;
  // Additional fields for second JSON structure (property-specific insights)
  final Map<String, dynamic>? property;
  final String? dataType;
  final Map<String, dynamic>? insights;
  final String? authorId;
  final int? totalViewsInt;
  final int? uniqueViewsInt;
  final Map<String, dynamic>? topCountries;
  final Map<String, dynamic>? topReferrers;
  final Map<String, dynamic>? deviceBreakdownMap;
  final List<InsightsChartEntry>? chartsList;

  InsightsUserProperties({
    this.id,
    this.title,
    this.url,
    this.status,
    this.lastUpdated,
    this.thumbnail,
    this.views,
    this.success,
    this.uniqueViews,
    this.timePeriod,
    this.totalProperties,
    this.totalViews,
    this.totalUniqueViews,
    this.userId,
    // New parameters
    this.topProperties,
    this.charts,
    this.trafficSources,
    // Additional parameters for second JSON structure
    this.property,
    this.dataType,
    this.insights,
    this.authorId,
    this.totalViewsInt,
    this.uniqueViewsInt,
    this.topCountries,
    this.perPage,
    this.page,
    this.count,
    this.totalPages,
    this.topReferrers,
    this.deviceBreakdownMap,
    this.countries,
    this.device,
    this.platform,
    this.browser,
    this.chartsList,
  });
}