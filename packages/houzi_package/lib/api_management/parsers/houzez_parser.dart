import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houzi_package/api_management/api_sources/api_houzez.dart';
import 'package:houzi_package/api_management/interfaces/api_parser_interface.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/models/blog_models/blog_comments_data.dart';
import 'package:houzi_package/models/blog_models/blog_details_page_layout.dart';
import 'package:houzi_package/models/blog_models/blog_tags_data.dart';
import 'package:houzi_package/models/blog_models/blogs_categories_data.dart';
import 'package:houzi_package/models/custom_fields/custom_fields.dart';
import 'package:houzi_package/models/drawer/drawer.dart';
import 'package:houzi_package/models/filter_related/filter_page_config.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/models/graphs/line_chart.dart';
import 'package:houzi_package/models/home_related/home_config.dart';
import 'package:houzi_package/models/home_related/partner.dart';
import 'package:houzi_package/models/home_related/terms_with_icon.dart';
import 'package:houzi_package/models/insights_model/top_insights_meta_data.dart';
import 'package:houzi_package/models/insights_model/user_properties.dart';
import 'package:houzi_package/models/insights_model/views.dart';
import 'package:houzi_package/models/listing_related/add_update_listing.dart';
import 'package:houzi_package/models/listing_related/currency_rate_model.dart';
import 'package:houzi_package/models/listing_related/is_favorite.dart';
import 'package:houzi_package/models/messages/messages.dart';
import 'package:houzi_package/models/messages/threads.dart';
import 'package:houzi_package/models/navbar/navbar_item.dart';
import 'package:houzi_package/models/notifications/check_notifications.dart';
import 'package:houzi_package/models/notifications/notifications.dart';
import 'package:houzi_package/models/property_details/floor_plans.dart';
import 'package:houzi_package/models/property_details/property_detail_page_config.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/models/review_approval_model.dart';
import 'package:houzi_package/models/saved_search.dart';
import 'package:houzi_package/models/search/sort_first_by_item.dart';
import 'package:houzi_package/models/term.dart';
import 'package:houzi_package/models/user/approval_statues_list.dart';
import 'package:houzi_package/models/user/user.dart';
import 'package:houzi_package/models/user/user_approval_status.dart';
import 'package:houzi_package/models/user/user_login_info.dart';
import 'package:houzi_package/models/user/user_membership_package.dart';
import 'package:houzi_package/models/user/user_payment_status.dart';
import 'package:houzi_package/models/user_reviews_setting.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class HouzezParser implements ApiParser {
  @override
  dynamic parseApi(ApiRequest request, Response response) {
    return HouzezParser.parseApiFunc(request, response);
  }

  @override
  Article parseArticle(Map<String, dynamic> json) {
    return HouzezParser.parseArticleMap(json);
  }

  @override
  Term parseMetaDataMap(Map<String, dynamic> json) {
    return HouzezParser.parsePropertyMetaDataMap(json);
  }

  @override
  Agency parseAgencyInfo(Map<String, dynamic> json) {
    return HouzezParser.parseAgencyInformation(json);
  }

  @override
  Agent parseAgentInfo(Map<String, dynamic> json) {
    return HouzezParser.parseAgentInformation(json);
  }

  @override
  SavedSearch parseSavedSearch(Map<String, dynamic> json) {
    return HouzezParser.parseSavedSearchMap(json);
  }

  @override
  User parseUserInfo(Map<String, dynamic> json) {
    return HouzezParser.parseUserInfoMap(json);
  }

  @override
  Custom parseCustomFields(Map<String, dynamic> json) {
    return HouzezParser.parseCustomFieldsMap(json);
  }

  @override
  Map<String, dynamic> convertCustomFieldsToJson(Custom custom) {
    return HouzezParser.customFieldDataToJson(custom);
  }

  @override
  Messages parseAllMessagesResponse(Map<String, dynamic> json) {
    return HouzezParser.parseAllMessagesJson(json);
  }

  @override
  Threads parseAllThreadsResponse(Map<String, dynamic> json) {
    return HouzezParser.parseAllThreadsJson(json);
  }

  @override
  CheckNotifications parseCheckNotificationsResponse(
      Map<String, dynamic> json) {
    return HouzezParser.parseCheckNotificationsJson(json);
  }

  @override
  AllNotifications parseAllNotificationsResponse(Map<String, dynamic> json) {
    return HouzezParser.parseAllNotificationsJson(json);
  }

  @override
  BlogCommentsData parseBlogCommentsJson(Map<String, dynamic> json) {
    return HouzezParser.parseBlogComments(json);
  }

  @override
  BlogTagsData parseBlogTagsJson(Map<String, dynamic> json) {
    return HouzezParser.parseBlogTagsResponse(json);
  }

  @override
  BlogCategoriesData parseBlogCategoriesJson(Map<String, dynamic> json) {
    return HouzezParser.parseBlogCategories(json);
  }

  @override
  BlogArticlesData parseBlogArticlesJson(Map<String, dynamic> json) {
    return HouzezParser.parseBlogArticles(json);
  }

  @override
  UserMembershipPackage parseUserMembershipPackageResponse(
      Map<String, dynamic> json) {
    return HouzezParser.parseUserMembershipPackage(json);
  }

  @override
  Partner parsePartnerJson(Map<String, dynamic> json) {
    return HouzezParser.parsePartnerJsonFunc(json);
  }

  @override
  MembershipPlanDetails parseMembershipPlanDetailsJson(
      Map<String, dynamic> json) {
    return HouzezParser.parseMembershipPlanDetailsFunc(json);
  }

  @override
  BlogDetailsPageLayout parseBlogDetailsPageLayoutJson(
      Map<dynamic, dynamic> json) {
    return HouzezParser.parseBlogDetailsPageLayoutJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertBlogDetailsPageLayoutToJson(
      BlogDetailsPageLayout layout) {
    return HouzezParser.blogDetailsPageLayoutToJsonFunc(layout);
  }

  @override
  HouziFormItem parseFormItemJson(Map<String, dynamic> json) {
    return HouzezParser.parseFormItemJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertFormItemToJson(HouziFormItem formItem) {
    return HouzezParser.convertFormItemToJsonFunc(formItem);
  }

  @override
  HouziFormPage parseFormPageJson(Map<String, dynamic> json) {
    return HouzezParser.parseFormPageJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertFormPageToJson(HouziFormPage formPage) {
    return HouzezParser.convertFormPageToJsonFunc(formPage);
  }

  @override
  DrawerLayoutConfig parseDrawerLayoutConfigJson(Map<dynamic, dynamic> json) {
    return HouzezParser.parseDrawerLayoutConfigJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertDrawerLayoutConfigToJson(
      DrawerLayoutConfig config) {
    return HouzezParser.convertDrawerLayoutConfigToJsonFunc(config);
  }

  @override
  DrawerLayout parseDrawerLayoutItemJson(Map<String, dynamic> json) {
    return HouzezParser.parseDrawerLayoutItemJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertDrawerLayoutItemToJson(DrawerLayout layoutItem) {
    return HouzezParser.convertDrawerLayoutItemToJsonFunc(layoutItem);
  }

  @override
  FilterPageElement parseFilterPageElementJson(Map<String, dynamic> json) {
    return HouzezParser.parseFilterPageElementJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertFilterPageElementToMap(
      FilterPageElement filterPageElement) {
    return HouzezParser.convertFilterPageElementToMapFunc(filterPageElement);
  }

  @override
  HomeConfig parseHomeConfigJson(Map<dynamic, dynamic> json) {
    return HouzezParser.parseHomeConfigJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertHomeConfigToJson(HomeConfig item) {
    return HouzezParser.convertHomeConfigToJsonFunc(item);
  }

  @override
  TermsWithIcon parseTermsWithIconJson(Map<String, dynamic> json) {
    return HouzezParser.parseTermsWithIconJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertTermsWithIconToJson(TermsWithIcon item) {
    return HouzezParser.convertTermsWithIconToJsonFunc(item);
  }

  @override
  HomeLayout parseHomeLayoutJson(Map<String, dynamic> json) {
    return HouzezParser.parseHomeLayoutJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertHomeLayoutToJson(HomeLayout item) {
    return HouzezParser.convertHomeLayoutToJsonFunc(item);
  }

  @override
  NavBar parseNavBarJson(Map<dynamic, dynamic> json) {
    return HouzezParser.parseNavBarJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertNavBarToJson(NavBar item) {
    return HouzezParser.convertNavBarToJsonFunc(item);
  }

  @override
  NavbarItem parseNavbarItemJson(Map<String, dynamic> json) {
    return HouzezParser.parseNavbarItemJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertNavbarItemToJson(NavbarItem item) {
    return HouzezParser.convertNavbarItemToJsonFunc(item);
  }

  @override
  PropertyDetailPageLayout parsePropertyDetailPageLayoutJson(
      Map<dynamic, dynamic> json) {
    return HouzezParser.parsePropertyDetailPageLayoutJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertPropertyDetailPageLayoutToJson(
      PropertyDetailPageLayout item) {
    return HouzezParser.convertPropertyDetailPageLayoutToJsonFunc(item);
  }

  @override
  PropertyDetailPageLayoutElement parsePropertyDetailPageLayoutElementJson(
      Map<String, dynamic> json) {
    return HouzezParser.parsePropertyDetailPageLayoutElementJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertPropertyDetailPageLayoutElementToJson(
      PropertyDetailPageLayoutElement item) {
    return HouzezParser.convertPropertyDetailPageLayoutElementToJsonFunc(item);
  }

  @override
  SortFirstBy parseSortFirstByJson(Map<dynamic, dynamic> json) {
    return HouzezParser.parseSortFirstByJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertSortFirstByToJson(SortFirstBy item) {
    return HouzezParser.convertSortFirstByToJsonFunc(item);
  }

  @override
  SortFirstByItem parseSortFirstByItemJson(Map<String, dynamic> json) {
    return HouzezParser.parseSortFirstByItemJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertSortFirstByItemToJson(SortFirstByItem item) {
    return HouzezParser.convertSortFirstByItemToJsonFunc(item);
  }

  @override
  Agent parseAgentFromJson(Map<String, dynamic> json) {
    return HouzezParser.parseAgentFromJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertAgentToMap(Agent item) {
    return HouzezParser.convertAgentToMapFunc(item);
  }

  @override
  Agency parseAgencyJson(Map<String, dynamic> json) {
    return HouzezParser.parseAgencyJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertAgencyToMap(Agency item) {
    return HouzezParser.convertAgencyToMapFunc(item);
  }

  @override
  Term parseTermJson(Map<String, dynamic> json) {
    return HouzezParser.parseTermJsonFunc(json);
  }

  @override
  Views parseViewsJson(Map<String, dynamic> json) {
    return HouzezParser.parseViewsJsonFunc(json);
  }

  @override
  TopInsightsMetaData parseInsightsJson(Map<String, dynamic> json) {
    return HouzezParser.parseInsightJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertTermToMap(Term item) {
    return HouzezParser.convertTermToMapFunc(item);
  }
  /// Vews
  @override
  Map<String, dynamic> convertViewsToMap(Views item) {
    return HouzezParser.convertViewsToMapFunc(item);
  }
  /// Insight
  @override
  Map<String, dynamic> convertInsightToMap(TopInsightsMetaData item) {
    return HouzezParser.convertInsightsToMapFunc(item);
  }

  @override
  AddOrUpdateListing parseAddOrUpdateListingJson(Map<String, dynamic> json) {
    return HouzezParser.parseAddOrUpdateListingJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertAddOrUpdateListingToJson(
      AddOrUpdateListing item) {
    return HouzezParser.convertAddOrUpdateListingToJsonFunc(item);
  }

  @override
  UserLoginInfo parseUserLoginInfoJson(Map<String, dynamic> json) {
    return HouzezParser.parseUserLoginInfoJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertUserLoginInfoToJson(UserLoginInfo item) {
    return HouzezParser.convertUserLoginInfoToJsonFunc(item);
  }

  @override
  IsFavourite parseIsFavouriteJson(Map<String, dynamic> json) {
    return HouzezParser.parseIsFavouriteJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertIsFavouriteToJson(IsFavourite item) {
    return HouzezParser.convertIsFavouriteToJsonFunc(item);
  }

  @override
  UserPaymentStatus parseUserPaymentStatusJson(Map<String, dynamic> json) {
    return HouzezParser.parseUserPaymentStatusJsonFunc(json);
  }

  @override
  Map<String, dynamic> convertUserPaymentStatusToJson(UserPaymentStatus item) {
    return HouzezParser.convertUserPaymentStatusToJsonFunc(item);
  }

  @override
  ApiResponse<String> parseNonceResponse(Response response) {
    return HouzezParser.parseNonceResponseFunc(response);
  }

  @override
  ApiResponse<String> parseMakeListingFeaturedResponse(Response response) {
    return HouzezParser.parseMakeListingFeatured(response);
  }

  @override
  ApiResponse<String> parse500ApiResponse(Response response) {
    return HouzezParser.parse500ApiFunc(response);
  }

  @override
  ApiResponse<String> parseNormalApiResponse(Response response) {
    return HouzezParser.parseNormalApiFunc(response);
  }

  @override
  ApiResponse<String> parsePaymentResponse(Response response) {
    return HouzezParser.parsePaymentFunc(response);
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  static dynamic parseApiFunc(ApiRequest request, Response response) {
    String tag = request.tag;
    dynamic rawData;

    switch (tag) {
      case FeaturedListingTag:
      case LatestListingTag:
      case FilteredListingTag:
      case SimilarListingTag:
      case MultipleListingTag:
      case SingleListingTag:
      case SingleListingViaPermaLinkTag:
      case ListingByCityTag:
      case AllPropertiesListingTag:
      case MyListingTag:
      case FavoriteListingsTag:
      case ListingReviewsTag:
      case RealtorReviewsTag:
      case FetchAllReviewsTag:
      case AllUsersTag:
      case AllUserV2Tag:
      case MembershipPackagesTag:
        {
          List _listings = [];

          if (tag == MultipleListingTag ||
              tag == SingleListingTag ||
              tag == SingleListingViaPermaLinkTag ||
              tag == ListingByCityTag ||
              tag == ListingReviewsTag ||
              tag == FetchAllReviewsTag ||
              tag == RealtorReviewsTag ||
              tag == AllUsersTag ||
              // tag == AllUserV2Tag ||
              tag == MembershipPackagesTag) {
            rawData = response.data;
          } 
              
         

         else if (tag == AllUserV2Tag) {
            if (response.data is Map<String, dynamic>) {
              rawData = response.data['users'];
              HiveStorageManager.storeIsApprovalStatusEnabled(
                  response.data['approval_system_enabled']);
            }else{
              rawData = response.data['users'];

            }

          } else if (tag == AllPropertiesListingTag) {
            if (response.data["success"]) {
              rawData = response.data["result"];
            } else {
              rawData = response.data;
            }
          } else {
            rawData = response.data["result"];
          }

          if (tag == SingleListingTag || tag == SingleListingViaPermaLinkTag) {
            _listings.add(parseArticleMap(rawData));
          } else {
            _listings = rawData.map((m) => parseArticleMap(m)).toList();
          }

          if (tag == FilteredListingTag) {
            int? _count =
                response.data["count"] is int ? response.data["count"] : null;
            ({int? count, List listings}) parsedData =
                (count: _count, listings: _listings);
            return parsedData;
          }

          return _listings;
        }
      

      case TouchBaseInfoTag:
        {
          rawData = response.data;
          Map<String, dynamic> mapData = UtilityMethods.convertMap(rawData);
          getAndStorePropertyMetaData(mapData, rawData);
          return mapData;
        }
      case AllUsersPropertiesTag:
        {
          List data = [];
          rawData = response.data;

          if (rawData["properties"] is String) {
            rawData = json.decode(
                rawData["properties"]); 
          }

          if (rawData["properties"] is List) {
            data.addAll((rawData["properties"]
                    as List) 
                .map((item) =>
                    parseAndStoreInsightsUserPropertiesMap(item)) 
                .toList());
          }
          else if (rawData is Map<String, dynamic>) {
            data.add(parseAndStoreInsightsUserPropertiesMap(rawData));
          }
          return data;
        }
      case UsersInsightTag:
        {
          List data = [];
          rawData = response.data;
          Map<String, dynamic> mapData = UtilityMethods.convertMap(rawData);
          data.add(parseAndStoreInsightsUserPropertiesMap(mapData));
          return data;
        }
      case InsightPropertiesTag:
        {
          List data = [];
          rawData = response.data;
          Map<String, dynamic> mapData = UtilityMethods.convertMap(rawData);
          data.add(parseAndStoreInsightsUserPropertiesMap(mapData));
          return data;
        }
      case MultiCurrenciesTag: 
      {
          rawData = response.data;
         Map<String, dynamic> mapData = UtilityMethods.convertMap(rawData);
          getAndStorePropertyMetaData(mapData, rawData);
          return mapData;
      }
      case SingleAgencyTag:
        {
          List data = [];
          rawData = response.data;
          data.add(parseAgencyInformation(rawData));
          return data;
        }

      case SingleAgentTag:
        {
          List data = [];
          rawData = response.data;
          data.add(parseAgentInformation(rawData));
          return data;
        }

      case AgentsOfAgencyInfoTag:
      case AllAgentsTag:
      case SearchAgentsTag:
      case AllAgentsOfAnAgencyTag:
        {
          List data = [];
          rawData = response.data;
          var list = rawData.map((m) {
            return parseAgentInformation(m);
          }).toList();
          if (tag == AllAgentsTag || tag == SearchAgentsTag) {
            list = list.where((e) => e.hide != true);
          }
          data.addAll(list);
          return data;
        }

      case AllAgenciesTag:
      case SearchAgenciesTag:
        {
          List data = [];
          rawData = response.data;
          var list = rawData.map((m) => parseAgencyInformation(m)).toList();
          if (tag == AllAgenciesTag || tag == SearchAgenciesTag) {
            list = list.where((e) => e.hide != true);
          }
          data.addAll(list);
          return data;
        }
     
      case AddNewListingTag:
      case UpdateListingTag:
        {
          AddOrUpdateListing? data;
          rawData = response.data;
          data = parseAddOrUpdateListingJsonFunc(rawData);
          return data;
        }

      case LoginTag:
      case SocialSignOnTag:
        {
          if (response.statusCode == HttpStatus.ok) {
            rawData = response.data;
            UserLoginInfo? data;
            data = parseUserLoginInfoJsonFunc(rawData);
            return data;
          } else {
            ApiResponse<String> apiResponse = parseNormalApiFunc(response);
            return apiResponse;
          }
        }
      case UserApprovalStatusesListTag:
  {
    List<ApprovalStatuesList> data = [];

    dynamic rawData = response.data;
    HiveStorageManager.storeApprovalStatusesList(response.data);

    if (rawData is String) {
      List<dynamic> list = json.decode(rawData);
      data = list.map((item) => parseUserApprovalStatusesItem(item)).toList();
    } else if (rawData is List) {
      data = rawData.map((item) => parseUserApprovalStatusesItem(item)).toList();
    }
    return ApiResponse<List<ApprovalStatuesList>>(
      result: data,
      message: "Approval statuses parsed successfully",
      success: true, internet: true,
    );
  }
 

      
      case StatusOfPropertyTag:
        {
          Article? data;
          rawData = response.data;
          data = parseArticleMap(rawData);
          return data;
        }

      case TermDataTag:
        {
          List<dynamic> data = [];
          rawData = response.data;

          Uri uri = request.uri;
          Map<String, dynamic> params = uri.queryParameters;
          dynamic termData = params[HouzezTermStringKey];
          if (termData == null) {
            termData = params[HouzezTermListKey];
          }
          List<dynamic> tempList = [];
          if (termData is List) {
            for (var dataTypeItem in termData) {
              tempList = validateAndStoreTermData(rawData, dataTypeItem);
              if (tempList.isNotEmpty) {
                data.addAll(tempList);
              }
            }
          } else if (termData is String) {
            tempList = validateAndStoreTermData(rawData, termData);
            if (tempList.isNotEmpty) {
              data.addAll(tempList);
            }
          }
          return data;
        }

      case SavedSearchesListingTag:
        {
          List data = [];
          rawData = response.data["results"];
          data.addAll(rawData.map((m) => parseSavedSearchMap(m)).toList());
          return data;
        }

      case UserInfoTag:
        {
          List data = [];
          rawData = response.data;
          late User user;

          if (rawData is String) {
            Map<String, dynamic> map = json.decode(response.data);
            user = parseUserInfoMap(map);
          } else {
            user = parseUserInfoMap(rawData);
          }
          data.add(user);
          return data;
        }

      case IsFavoriteListingTag:
        {
          late IsFavourite data;
          rawData = response.data;
          data = parseIsFavouriteJsonFunc(rawData);
          return data;
        }
      case AddOrRemoveFromFavoritesTag:
{
  var rawData = response.data;
  String _result = "";

  if (rawData is String) {
    // Use a specific regex to find the exact JSON pattern you need
    RegExp jsonRegex = RegExp(r'\{"added":(true|false),"response":"(Added|Removed)"\}');
    Match? match = jsonRegex.firstMatch(rawData);
    
    if (match != null) {
      String extractedJson = match.group(0)!;
      try {
        Map<String, dynamic> map = json.decode(extractedJson);
        
        if (map.containsKey("added")) {
          if (map["added"] == true) {
            _result = AddedKey;
          } else if (map["added"] == false) {
            _result = RemovedKey;
          }
          
          return ApiResponse<String>(
            success: true,
            message: "",
            internet: true,
            result: _result,
          );
        }
      } catch (e) {
        return ApiResponse<String>(
          success: false,
          message: "Error parsing matched JSON: $e",
          internet: true,
          result: "",
        );
      }
    } else {
      // If the exact pattern isn't found, try to find any JSON with added field
      RegExp altJsonRegex = RegExp(r'\{[^}]*"added":(true|false)[^}]*\}');
      match = altJsonRegex.firstMatch(rawData);
      
      if (match != null) {
        String extractedJson = match.group(0)!;
        try {
          Map<String, dynamic> map = json.decode(extractedJson);
          
          if (map.containsKey("added")) {
            if (map["added"] == true) {
              _result = AddedKey;
            } else if (map["added"] == false) {
              _result = RemovedKey;
            }
            
            return ApiResponse<String>(
              success: true,
              message: "",
              internet: true,
              result: _result,
            );
          }
        } catch (e) {
          return ApiResponse<String>(
            success: false,
            message: "Error parsing alternative JSON: $e",
            internet: true,
            result: "",
          );
        }
      }
      
      return const ApiResponse<String>(
        success: false,
        message: "Could not find JSON with 'added' field",
        internet: true,
        result: "",
      );
    }
  } else if (rawData is Map<String, dynamic>) {
    // If the data is already parsed as a Map, process it directly
    if (rawData.containsKey("added")) {
      if (rawData["added"] == true) {
        _result = AddedKey;
      } else if (rawData["added"] == false) {
        _result = RemovedKey;
      }
      
      return ApiResponse<String>(
        success: true,
        message: "",
        internet: true,
        result: _result,
      );
    } else {
      return const ApiResponse<String>(
        success: false,
        message: "Missing 'added' key in Map response",
        internet: true,
        result: "",
      );
    }
  } else {
    return ApiResponse<String>(
      success: false,
      message: "Invalid response format: ${rawData.runtimeType}",
      internet: true,
      result: "",
    );
  }
}

      case UserPaymentStatusTag:
        {
          late UserPaymentStatus? data;
          rawData = response.data;
          data = parseUserPaymentStatusJsonFunc(rawData);
          return data;
        }
      case UserApprovalTag:
        {
          late UserApprovalStatus? data;
          rawData = response.data;
          Map<String, dynamic> jsonMap = jsonDecode(rawData);
          data = parseUserApprovalStatusJsonFunc(jsonMap);
          return ApiResponse(
            internet: true,
            result: data,
            success: data.success ?? false,
            message: data.message ?? "",
          );
        }
      case ReviewApprovalTag:
        {
          late ReviewApprovalModel? data;
          rawData = response.data;
          Map<String, dynamic> jsonMap = jsonDecode(rawData);
          data = parseReviewApprovalModelJsonFunc(jsonMap);
          return ApiResponse(
            internet: true,
            result: data,
            success: data.success ?? false,
            message: data.message ?? "",
          );
        }
      case AllPartnersTag:
        {
          List data = [];
          rawData = response.data;
          data = rawData.map((json) => parsePartnerJsonFunc(json)).toList();
          return data;
        }

      case UserMembershipPackageTag:
        {
          late UserMembershipPackage? data;
          rawData = response.data;
          data = parseUserMembershipPackage(rawData);
          return data;
        }

      case ProceedWithPaymentsTag:
        {
          ApiResponse<String> apiResponse = parsePaymentFunc(response);
          return apiResponse;
        }

      case MakePropertyFeaturedTag:
      case RemoveFromFeaturedTag:
        {
          ApiResponse<String> apiResponse = parseMakeListingFeatured(response);
          return apiResponse;
        }

      case ApproveOrDisapproveListingTag:
      case ToggleFeaturedTag:
      case SetSoldStatusTag:
      case SetExpireStatusTag:
      case SetPendingStatusTag:
      case AddBlogCommentTag:
      case DeleteNotificationsTag:
      case DeleteThreadTag:
      case StartThreadTag:
      case SendMessageTag:
        {
          ApiResponse<String> apiResponse = parseNormalApiFunc(response);
          return apiResponse;
        }

      case AllBlogsTag:
        {
          late BlogArticlesData? data;
          rawData = response.data;
          data = parseBlogArticles(rawData);
          return data;
        }

      case AllBlogCategoriesTag:
        {
          late BlogCategoriesData? data;
          rawData = response.data;
          data = parseBlogCategories(rawData);
          return data;
        }

      case AllBlogTagsTag:
        {
          late BlogTagsData? data;
          rawData = response.data;
          data = parseBlogTagsResponse(rawData);
          return data;
        }

      case BlogCommentsTag:
        {
          late BlogCommentsData? data;
          rawData = response.data;
          data = parseBlogComments(rawData);
          return data;
        }

      case AllNotificationsTag:
        {
          late AllNotifications? data;
          rawData = response.data;
          data = parseAllNotificationsJson(rawData);
          return data;
        }

      case CheckNotificationsTag:
        {
          late CheckNotifications? data;
          rawData = response.data;
          data = parseCheckNotificationsJson(rawData);
          return data;
        }

      case AllThreadsTag:
        {
          late Threads? data;
          rawData = response.data;
          data = parseAllThreadsJson(rawData);
          return data;
        }

      case AllMessagesTag:
        {
          late Messages? data;
          rawData = response.data;
          data = parseAllMessagesJson(rawData);
          return data;
        }

      case CreateNonceTag:
        {
          ApiResponse<String> apiResponse = parseNonceResponseFunc(response);
          return apiResponse;
        }

      default:
        {
          if (request.handle500) {
            ApiResponse<String> apiResponse = parse500ApiFunc(response);
            return apiResponse;
          }
        }
    }
  }

  static void getAndStorePropertyMetaData(
      Map<String, dynamic> touchBaseDataMap, dynamic rawData) {
    if (touchBaseDataMap.isNotEmpty) {
      dynamic dataHolder;
      List<dynamic> listDataHolder = [];

      // City Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyCityDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storeCitiesMetaData(listDataHolder);
      }

      // Property Type Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyTypeDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyTypesMetaData(listDataHolder);
      }

      // Property Type Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyTypeDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyTypesMetaData(listDataHolder);
        dataHolder = UtilityMethods.getParentAndChildCategorizedMap(
            metaDataList: listDataHolder);
        if (dataHolder.isNotEmpty) {
          HiveStorageManager.storePropertyTypesMapData(dataHolder);
        }
      }

      // Property Country Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyCountryDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyCountriesMetaData(listDataHolder);
      }

      // Property State Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyStateDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyStatesMetaData(listDataHolder);
      }

      // Property Area Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyAreaDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyAreaMetaData(listDataHolder);
      }

      // Property Label Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyLabelDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyLabelsMetaData(listDataHolder);
      }

      // Property Status Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyStatusDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyStatusMetaData(listDataHolder);
        dataHolder = UtilityMethods.getParentAndChildCategorizedMap(
            metaDataList: listDataHolder);
        if (dataHolder.isNotEmpty) {
          HiveStorageManager.storePropertyStatusMapData(dataHolder);
        }
      }

      // Property Features Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyFeatureDataType) ??
          [];
      listDataHolder = parseMetaDataList(dataHolder);
      if (listDataHolder.isNotEmpty) {
        HiveStorageManager.storePropertyFeaturesMetaData(listDataHolder);
      }

      // Schedule Time Slots Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: scheduleTimeSlotsKey);
      if (dataHolder != null) {
        HiveStorageManager.storeScheduleTimeSlotsInfoData(dataHolder);
      }
      // Check user is admin Meta Data
      dataHolder = UtilityMethods.getBooleanItemValueFromMap(
          inputMap: touchBaseDataMap, key: isUserAdminKey);
      if (dataHolder != null) {
        HiveStorageManager.storeIsUserAdmin(dataHolder);
      }

      // Check Admin User Review Meta Data
      dataHolder = UtilityMethods.getBooleanItemValueFromMap(
          inputMap: touchBaseDataMap, key: newRatingsApprovedByAdminKey);
      if (dataHolder != null) {
        HiveStorageManager.storeNewRatingsApprovedByAdminData(dataHolder);
      }
      // Supported Currencies For Currency Switcher Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
        inputMap: touchBaseDataMap, key: supportCurrenciesForCurrencySwitcherKey
      );
      listDataHolder = parseMetaDataList(dataHolder);

      if(listDataHolder.isNotEmpty){
        HiveStorageManager.storeSupportCurrenciesDataMaps;
      }

      // Currencies Exchange Rates Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
        inputMap: touchBaseDataMap, key: currenciesExchangeRatesKey
      );
      if(dataHolder != null){
        HiveStorageManager.storeExchangeCurrencyRate;
      }
     
      // Currrency Switcher - Currency Rates Meta Data
      dataHolder = UtilityMethods.getListWithObjectsFromMap(
        inputMap: touchBaseDataMap,
        key: exchangeRateCurrencyDataKey,
        ); 

      // print("Before data : $dataHolder");
      if(dataHolder != null){
        HiveStorageManager.storeExchangeCurrencyMetaData(dataHolder);
      }
      // Currency Switcher Enabled boolean
      dataHolder = UtilityMethods.getBooleanItemValueFromMap(
          inputMap: touchBaseDataMap, key: currencySwitchEnabledKey);
      if (dataHolder != null){
        HiveStorageManager.storeCurrencySwitcherEnabledStatus(dataHolder); 
      }


      // Base Currency Meta Data - For Currency Switcher
      dataHolder = UtilityMethods.getMapItemFromMap(
        inputMap: touchBaseDataMap, key: baseCurrrencyKey
      );
      if(dataHolder != null){
        HiveStorageManager.storeBaseCurrency(dataHolder);
        print("Base Currency : $dataHolder");
      }
      // Default Currency Meta Data - Default plain
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: defaultCurrencyKey);
      if (dataHolder != null) {
        HiveStorageManager.storeDefaultCurrencyInfoData(dataHolder);
      }
      // Multi Currency Enabled? Meta Data
      dataHolder = UtilityMethods.getBooleanItemValueFromMap(
          inputMap: touchBaseDataMap, key: multiCurrencyEnabledKey);
      if(dataHolder != null){
        HiveStorageManager.storeMultiCurrencyEnabledStatus(dataHolder);
      }
      // Multi Currency Meta Data
      dataHolder = UtilityMethods.getMapItemValueFromMap(
           inputMap: touchBaseDataMap, key: multiCurrencyKey);
       if (dataHolder != null) {
         HiveStorageManager.storeMultiCurrencyDataMaps(dataHolder);
       }
      dataHolder = UtilityMethods.getStringItemValueFromMap(
           inputMap: touchBaseDataMap, key: defaultMultiCurrency);
      if( dataHolder != null){
        HiveStorageManager.storeDefaultMultiCurrency(dataHolder);
      }
      // Enquiry Type Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: enquiryTypeKey);
      if (dataHolder != null) {
        HiveStorageManager.storeInquiryTypeInfoData(dataHolder);
      }

      // User Roles Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
          inputMap: touchBaseDataMap, key: userRolesKey);
      if (dataHolder != null) {
        HiveStorageManager.storeUserRoleListData(dataHolder);
      }

      // All User Roles Meta Data
      dataHolder = UtilityMethods.getListItemValueFromMap(
          inputMap: touchBaseDataMap, key: allUserRolesKey);
      if (dataHolder != null) {
        HiveStorageManager.storeAdminUserRoleListData(dataHolder);
      }
       
      // Property Reviews Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: propertyReviewsKey) ??
          "";
      if (dataHolder.isNotEmpty && dataHolder == "1") {
        SHOW_REVIEWS = true;
      } else {
        SHOW_REVIEWS = false;
      }

      // Currency Position Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: currencyPositionKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        CURRENCY_POSITION = dataHolder;
      }

      // Thousands Separator Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: thousandsSeparatorKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        THOUSAND_SEPARATOR = dataHolder;
      }

      // Decimal Point Separator Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: decimalPointSeparatorKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        DECIMAL_POINT_SEPARATOR = dataHolder;
      }

      // Add Property GDPR Enabled Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: addPropGDPREnabledKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        ADD_PROP_GDPR_ENABLED = dataHolder;
      }

      // Measurement Unit Global Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: measurementUnitGlobalKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        MEASUREMENT_UNIT_GLOBAL = dataHolder;
      }

      // Measurement Unit Text Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: measurementUnitTextKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        MEASUREMENT_UNIT_TEXT = dataHolder;
      }

      // Radius Unit Text Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: radiusUnitKey) ??
          "";
      if (dataHolder.isNotEmpty) {
        RADIUS_UNIT = dataHolder;
      }

      // Payment status Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap, key: paymentEnabledStatusKey) ??
          "";
      if (dataHolder != null && dataHolder.isNotEmpty) {
        TOUCH_BASE_PAYMENT_ENABLED_STATUS = dataHolder;
      }

      // Make Featured google play store product id
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap,
              key: googlePlayStoreFeaturedProductIdKey) ??
          "";
      if (dataHolder != null && dataHolder.isNotEmpty) {
        MAKE_FEATURED_ANDROID_PRODUCT_ID = dataHolder;
      }

      // Make Featured apple appstore product id
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap,
              key: appleAppStoreFeaturedProductIdKey) ??
          "";
      if (dataHolder != null && dataHolder.isNotEmpty) {
        MAKE_FEATURED_IOS_PRODUCT_ID = dataHolder;
      }

      // Per listing google play store product id
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap,
              key: googlePlayStorePerListingProductIdKey) ??
          "";
      if (dataHolder != null && dataHolder.isNotEmpty) {
        PER_LISTING_ANDROID_PRODUCT_ID = dataHolder;
      }

      // Per listing apple appstore product id
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: touchBaseDataMap,
              key: appleAppStorePerListingProductIdKey) ??
          "";
      if (dataHolder != null && dataHolder.isNotEmpty) {
        PER_LISTING_IOS_PRODUCT_ID = dataHolder;
      }

      // Enquiry type Text Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: enquiryTypeKey);
      if (dataHolder != null) {
        HiveStorageManager.storeInquiryTypeInfoData(dataHolder);
      }
      // Lead prefix Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: leadPrefixKey);
      if (dataHolder != null) {
        HiveStorageManager.storeLeadPrefixInfoData(dataHolder);
      }

      // Lead Source Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: leadSourceKey);
      if (dataHolder != null) {
        HiveStorageManager.storeLeadSourceInfoData(dataHolder);
      }

      // Deal Status Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: dealStatusKey);
      if (dataHolder != null) {
        HiveStorageManager.storeDealStatusInfoData(dataHolder);
      }

      // Deal Next Action Meta Data
      dataHolder = UtilityMethods.getStringItemValueFromMap(
          inputMap: touchBaseDataMap, key: dealNextActionKey);
      if (dataHolder != null) {
        HiveStorageManager.storeDealNextActionInfoData(dataHolder);
      }

      if (touchBaseDataMap.containsKey("custom_fields")) {
        var data = touchBaseDataMap["custom_fields"];
        if (data != null && data.isNotEmpty) {
          final Custom custom = parseCustomFieldsMap(rawData);
          HiveStorageManager.storeCustomFieldsDataMaps(
              customFieldDataToJson(custom));
        }
      }
    }
  }

  static List<dynamic> validateAndStoreTermData(
      Map<String, dynamic> metaDataMap, String dataTypeItem) {
    List<dynamic> metaDataList = [];
    if (metaDataMap.containsKey(dataTypeItem)) {
      var tempMetaData = metaDataMap[dataTypeItem];
      if (tempMetaData != null &&
          tempMetaData is Map &&
          tempMetaData.isNotEmpty) {
        if (tempMetaData.containsKey("errors")) {
          if (dataTypeItem == propertyAreaDataType) {
            SHOW_NEIGHBOURHOOD_FIELD = false;
          } else if (dataTypeItem == propertyStateDataType) {
            SHOW_STATE_COUNTY_FIELD = false;
          } else if (dataTypeItem == propertyCountryDataType) {
            SHOW_COUNTRY_NAME_FIELD = false;
          } else if (dataTypeItem == propertyCityDataType) {
            SHOW_LOCALITY_FIELD = false;
          }
        }
      } else if (tempMetaData != null &&
          tempMetaData is List &&
          tempMetaData.isNotEmpty) {
        List<dynamic> tempMetaDataList = [];
        tempMetaDataList =
            tempMetaData.map((m) => parsePropertyMetaDataMap(m)).toList();
        if (tempMetaDataList.isNotEmpty) {
          metaDataList.addAll(tempMetaDataList);
          if (dataTypeItem == propertyAreaDataType) {
            HiveStorageManager.storePropertyAreaMetaData(tempMetaDataList);
          } else if (dataTypeItem == propertyStateDataType) {
            HiveStorageManager.storePropertyStatesMetaData(tempMetaDataList);
          } else if (dataTypeItem == propertyCountryDataType) {
            HiveStorageManager.storePropertyCountriesMetaData(tempMetaDataList);
          } else if (dataTypeItem == propertyCityDataType) {
            HiveStorageManager.storeCitiesMetaData(tempMetaDataList);
          } else if (dataTypeItem == propertyFeatureDataType) {
            HiveStorageManager.storePropertyFeaturesMetaData(tempMetaDataList);
          } else if (dataTypeItem == propertyTypeDataType) {
            HiveStorageManager.storePropertyTypesMetaData(tempMetaDataList);
            Map<String, dynamic> tempDataMap = {};
            tempDataMap = UtilityMethods.getParentAndChildCategorizedMap(
                metaDataList: tempMetaDataList);
            HiveStorageManager.storePropertyTypesMapData(tempDataMap);
          } else if (dataTypeItem == propertyLabelDataType) {
            HiveStorageManager.storePropertyLabelsMetaData(tempMetaDataList);
          } else if (dataTypeItem == propertyStatusDataType) {
            HiveStorageManager.storePropertyStatusMetaData(tempMetaDataList);
            Map<String, dynamic> tempDataMap = {};
            tempDataMap = UtilityMethods.getParentAndChildCategorizedMap(
                metaDataList: tempMetaDataList);
            HiveStorageManager.storePropertyStatusMapData(tempDataMap);
          }
        }
      }
    }

    return metaDataList;
  }

  static List<dynamic> parseMetaDataList(List? inputList) {
    List parsedList = [];

    if (inputList != null && inputList.isNotEmpty) {
      parsedList = inputList.map((m) => parsePropertyMetaDataMap(m)).toList();
    }

    return parsedList;
  }

  static Address parseAddressMap(Map<String, dynamic> json) {
    String tempAddress = "";
    String tempLat = "";
    String tempLng = "";
    String tempCoordinates = "";
    String tempPostalCode = "";
    String tempCity = "";
    String tempCountry = "";
    String tempState = "";
    String tempArea = "";

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};

    tempAddress = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "address") ??
        "";
    tempLat =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "lat") ??
            "";
    tempLng =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "lng") ??
            "";

    Map tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_meta") ??
        {};

    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_map_address");
      tempAddress =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (tempAddress.isEmpty) {
        dataHolder = UtilityMethods.getItemValueFromMap(
            inputMap: mapDataHolder, key: "fave_property_address");
        tempAddress =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "houzez_geolocation_lat");
      tempLat = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "houzez_geolocation_long");
      tempLng = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_location");
      tempCoordinates =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_zip");
      tempPostalCode =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
    }

    tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_address") ??
        {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "property_city");
      tempCity = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "property_country");
      tempCountry =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "property_state");
      tempState =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "property_area");
      tempArea = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};

    return Address(
      city: tempCity,
      country: tempCountry,
      state: tempState,
      area: tempArea,
      address: tempAddress,
      coordinates: tempCoordinates,
      lat: tempLat,
      long: tempLng,
      postalCode: tempPostalCode,
    );
  }

  static Features parseFeaturesMap(Map<String, dynamic> json) {
    String tempPropertyArea = "";
    String tempPropertyAreaUnit = "";
    String tempLandArea = "";
    String tempLandAreaUnit = "";
    String tempRooms = "";
    String tempBedrooms = "";
    String tempBathrooms = "";
    String tempGarage = "";
    String tempGarageSize = "";
    String tempYearBuilt = "";
    String tempMultiUnitsListingIDs = "";

    List<String> featuresList = [];
    List<String> imageIdsList = [];
    List<dynamic> tempFeaturesList = [];
    List<dynamic> tempImagesIdList = [];
    List<dynamic> tempMultiUnitsList = [];
    List<dynamic> tempFloorPlansList = [];
    List<dynamic> tempAdditionalDetailsList = [];
    List<Map<String, dynamic>> tempMultiUnitsPlan = [];
    List<Map<String, dynamic>> tempFloorPlan = [];
    List<Map<String, dynamic>> attachments = [];
    List<Attachment> tempAttachments = [];
    List<dynamic>? propertyStatusList = [];
    List<dynamic>? propertyTypeList = [];
    List<dynamic>? propertyLabelList = [];

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};

    tempFeaturesList = UtilityMethods.getListItemValueFromMap(
            inputMap: json, key: "property_features") ??
        [];
    if (tempFeaturesList.isNotEmpty) {
      featuresList = List<String>.from(tempFeaturesList);
    }
    propertyStatusList = UtilityMethods.getListItemValueFromMap(
            inputMap: json, key: "property_status_text") ??
        [];
    propertyTypeList = UtilityMethods.getListItemValueFromMap(
            inputMap: json, key: "property_type_text") ??
        [];
    propertyLabelList = UtilityMethods.getListItemValueFromMap(
            inputMap: json, key: "property_label_text") ??
        [];

    dataHolder = UtilityMethods.getListItemValueFromMap(
            inputMap: json, key: "attachments") ??
        [];
    if (dataHolder.isNotEmpty) {
      for (var item in dataHolder) {
        if (item is Map &&
            UtilityMethods.isValidString(item[attachmentsUrl]) &&
            UtilityMethods.isValidString(item[attachmentsName]) &&
            UtilityMethods.isValidString(item[attachmentsSize])) {
          tempAttachments.add(
            Attachment(
              size: item[attachmentsSize],
              name: item[attachmentsName],
              url: item[attachmentsUrl],
            ),
          );
        }
      }
    }

    Map tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_meta") ??
        {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_size");
      tempPropertyArea =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_size_prefix");
      tempPropertyAreaUnit =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_land");
      tempLandArea =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_land_postfix");
      tempLandAreaUnit =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_bedrooms");
      tempBedrooms =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_rooms");
      tempRooms = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      
      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_bathrooms");
      tempBathrooms =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_garage");
      tempGarage =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_garage_size");
      tempGarageSize =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_year");
      tempYearBuilt =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_multi_units_ids");
      tempMultiUnitsListingIDs =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      tempImagesIdList = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "fave_property_images") ??
          [];
      if (tempImagesIdList.isNotEmpty) {
        tempImagesIdList
            .removeWhere((element) => element is! String || element == "null");
        if (tempImagesIdList.isNotEmpty) {
          imageIdsList = List<String>.from(tempImagesIdList);
        }
      }

      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "floor_plans") ??
          [];
      if (dataHolder.isNotEmpty && dataHolder[0] is Map) {
        tempFloorPlan = List<Map<String, dynamic>>.from(dataHolder);
        if (tempFloorPlan.isNotEmpty) {
          tempFloorPlansList = getParsedDataInList(
            inputList: tempFloorPlan,
            function: parseFloorPlansMap,
          );
        }
      }

      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "fave_multi_units") ??
          [];
      if (dataHolder.isNotEmpty && dataHolder[0] is Map) {
        tempMultiUnitsPlan = List<Map<String, dynamic>>.from(dataHolder);
        if (tempMultiUnitsPlan.isNotEmpty) {
          tempMultiUnitsList = getParsedDataInList(
            inputList: tempMultiUnitsPlan,
            function: parseMultiUnitsMap,
          );
        }
      }

      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "additional_features") ??
          [];
      if (dataHolder.isNotEmpty) {
        for (var item in dataHolder) {
          if (item is Map &&
              UtilityMethods.isValidString(item[faveAdditionalFeatureTitle]) &&
              UtilityMethods.isValidString(item[faveAdditionalFeatureValue])) {
            tempAdditionalDetailsList.add(AdditionalDetail(
              title: item[faveAdditionalFeatureTitle],
              value: item[faveAdditionalFeatureValue],
            ));
          }
        }
      }
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};
    tempFeaturesList = [];
    tempImagesIdList = [];
    tempFloorPlan = [];
    tempMultiUnitsPlan = [];

    return Features(
      featuresList: featuresList,
      propertyArea: tempPropertyArea,
      propertyAreaUnit: tempPropertyAreaUnit,
      landArea: tempLandArea,
      landAreaUnit: tempLandAreaUnit,
      rooms: tempRooms,
      bedrooms: tempBedrooms,
      bathrooms: tempBathrooms,
      garage: tempGarage,
      garageSize: tempGarageSize,
      yearBuilt: tempYearBuilt,
      floorPlansList: tempFloorPlansList,
      imagesIdList: imageIdsList,
      additionalDetailsList: tempAdditionalDetailsList,
      multiUnitsList: tempMultiUnitsList,
      multiUnitsListingIDs: tempMultiUnitsListingIDs,
      propertyLabelList: propertyLabelList,
      propertyStatusList: propertyStatusList,
      propertyTypeList: propertyTypeList,
      attachments: tempAttachments,
    );
  }

  static PropertyInfo parsePropertyInfoMap(Map<String, dynamic> json) {
    String tempPropertyType = "";
    String tempPropertyStatus = "";
    String tempPropertyLabel = "";
    String tempPrice = "";
    String tempPricePrefix = "";
    String tempPaymentStatus = "";
    String tempFirstPrice = "";
    String tempSecondPrice = "";
    String tempCurrency = "";
    String tempUniqueId = "";
    String tempPricePostfix = "";
    String tempPropertyVirtualTourLink = "";
    String tempAgentDisplayOption = "author_info";
    String tempAddressHideMap = "";
    String tempFeatured = "";
    String tempTotalRating = "";
    String tempPrivateNote = "";
     String tempCurrencySymbol = "";
    String tempDisclaimer = "";
    String tempPricePlaceholder = "";
    bool requiredLogin = false;
    bool tempIsFeatured = false;
    bool tempShowPricePlaceholder = false;
    List<String> tempAgentList = [];
    List<String> tempAgencyList = [];
    Map<String, String> customFieldsMap = {};
    Map<String, dynamic> customFieldsMapForEditing = {};
    Map<String, dynamic> tempAgentInfoMap = {};
    dynamic dataHelper;
    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_attr") ??
        {};

    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      tempPropertyType = UtilityMethods.getStringItemValueFromMap(
              inputMap: mapDataHolder, key: "property_type") ??
          "";
      tempPropertyStatus = UtilityMethods.getStringItemValueFromMap(
              inputMap: mapDataHolder, key: "property_status") ??
          "";
      tempPropertyLabel = UtilityMethods.getStringItemValueFromMap(
              inputMap: mapDataHolder, key: "property_label") ??
          "";
    } else {
      tempPropertyType = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "property_type") ??
          "";
    }

    tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_meta") ??
        {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_featured");
      tempFeatured =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (tempFeatured.isNotEmpty && tempFeatured == '1') {
        tempIsFeatured = true;
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_payment_status");
      if (dataHolder != null && dataHolder.isNotEmpty) {
        tempPaymentStatus =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_price");
      tempPrice =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_price_prefix");
      tempPricePrefix =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_sec_price");
      tempSecondPrice =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_currency_info");
      dataHelper    =
           UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
           tempCurrencySymbol = UtilityMethods.getValueFromSerializedPhp(item: dataHelper, key: "currency_symbol") ;

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_currency");
      tempCurrency =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_id");
      tempUniqueId =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_price_postfix");
      tempPricePostfix =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_virtual_tour");
      tempPropertyVirtualTourLink =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_map");
      tempAddressHideMap =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_private_note");
      tempPrivateNote =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_disclaimer");
      tempDisclaimer =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
              inputMap: mapDataHolder, key: "agent_info") ??
          {};
      if (dataHolder.isNotEmpty) {
        tempAgentInfoMap = UtilityMethods.convertMap(dataHolder);
      }

      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "fave_agents") ??
          [];
      if (dataHolder.isNotEmpty) {
        tempAgentList = List<String>.from(dataHolder)
            .toSet()
            .toList(); // To get the distinctive members only
      }

      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "fave_property_agency") ??
          [];
      if (dataHolder.isNotEmpty) {
        tempAgencyList = List<String>.from(dataHolder)
            .toSet()
            .toList(); // To get the distinctive members only
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_display_option");
      tempAgentDisplayOption =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (tempAgentDisplayOption.isEmpty) {
        tempAgentDisplayOption = "author_info";
      }
      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "houzez_total_rating");
      tempTotalRating =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_loggedintoview");
      String tempStr =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (tempStr.isNotEmpty && tempStr == "1") {
        requiredLogin = true;
      }
      tempStr = ""; // dis-allocating the variable

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_show_price_placeholder");
      tempStr = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (tempStr == "1") {
        tempShowPricePlaceholder = true;
      } else {
        tempShowPricePlaceholder = false;
      }
      tempStr = ""; // dis-allocating the variable

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_property_price_placeholder");
      tempPricePlaceholder =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      Map data = HiveStorageManager.readCustomFieldsDataMaps();

      if (data.isNotEmpty) {
        final Custom custom = parseCustomFieldsMap(data);
        var fieldList = [];
        var labelList = [];

        for (var data in custom.customFields!) {
          fieldList.add(data.fieldId);
          labelList.add(data.label);
        }

        for (int i = 0; i < fieldList.length; i++) {
          if (mapDataHolder.containsKey("fave_${fieldList[i]}")) {
            String key = "fave_${fieldList[i]}";
            var field = mapDataHolder[key];
            Map<String, dynamic> mapForEdit = {fieldList[i]: field};
            if (field is List) {
              field = field.join("\n");
            }
            Map<String, String> map = {labelList[i]: field};

            customFieldsMap.addAll(map);
            customFieldsMapForEditing.addAll(mapForEdit);
          }
        }
      }
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};
    tempFeatured = "";

    return PropertyInfo(
        isFeatured: tempIsFeatured,
        requiredLogin: requiredLogin,
        propertyType: tempPropertyType,
        propertyStatus: tempPropertyStatus,
        propertyLabel: tempPropertyLabel,
        priceCurrency: tempCurrencySymbol,
        uniqueId: tempUniqueId,
        price: tempPrice,
        firstPrice: tempFirstPrice,
        secondPrice: tempSecondPrice,
        pricePostfix: tempPricePostfix,
        propertyVirtualTourLink: tempPropertyVirtualTourLink,
        featured: tempFeatured,
        addressHideMap: tempAddressHideMap,
        agentInfo: tempAgentInfoMap,
        agencyList: tempAgencyList,
        agentList: tempAgentList,
        agentDisplayOption: tempAgentDisplayOption,
        houzezTotalRating: tempTotalRating,
        currency: tempCurrency,
        customFieldsMap: customFieldsMap,
        customFieldsMapForEditing: customFieldsMapForEditing,
        paymentStatus: tempPaymentStatus,
        privateNote: tempPrivateNote,
        disclaimer: tempDisclaimer,
        pricePrefix: tempPricePrefix,
        showPricePlaceholder: tempShowPricePlaceholder,
        pricePlaceholder: tempPricePlaceholder);
  }

  static Article parseArticleMap(Map<String, dynamic> json) {
    int? author;
    int catId = 0;
    int? tempId;
    int? tempFeaturedImageId;
    bool tempIsFav = false;
    String content = "";
    String tempStatus = "";
    String image = "";
    String tempVideoUrl = "";
    String avatar = "";
    String category = "";
    String date = "";
    String postDateGmt = "";
    String reviewActionLabel = "";
    String modifiedDate = "";
    String modifiedDateGmt = "";
    String tempLink = "";
    String tempGuid = "";
    String tempType = "";
    String tempTitle = "";
    String tempVirtualTourLink = "";
    String propertyStatus = "";
    String userDisplayName = "";
    String userName = "";
    String reviewPostType = "";
    String reviewStars = "";
    String reviewBy = "";
    String reviewTo = "";
    String reviewPropertyId = "";
    String description = "";
    String reviewLikes = "";
    String reviewDislikes = "";
    String tempCurrency = "";
    String tempCurrencySymbol = "";
    String tempCurrencyCode = "";
    String tempCurrencyPosition = "";
    dynamic dataGetter;
    dynamic dataHelper;
    List<String> listOfImages = [];
    Map<String, dynamic> avatarUrls = {};

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    if (json.containsKey("content")) {
      dataHolder = UtilityMethods.getMapItemValueFromMap(
              inputMap: json, key: "content") ??
          {};
      if (dataHolder.isNotEmpty) {
        content = UtilityMethods.getStringItemValueFromMap(
                inputMap: dataHolder, key: "rendered") ??
            "";
      }
    }
    if (json.containsKey("post_content")) {
      content = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_content") ??
          "";
    }
    if (content.isNotEmpty && !ENABLE_HTML_IN_DESCRIPTION) {
      content = UtilityMethods.cleanContent(content);
    }

    if (json.containsKey("author")) {
      author = UtilityMethods.getIntegerItemValueFromMap(
          inputMap: json, key: "author");
    }
    if (json.containsKey("post_author")) {
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_author") ??
          "";
      if (dataHolder.isNotEmpty) {
        author = int.tryParse(dataHolder);
      }
    }

    tempFeaturedImageId = UtilityMethods.getIntegerItemValueFromMap(
        inputMap: json, key: "featured_media");

    image = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "thumbnail") ??
        "";
        

    dataHolder = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "avatar_urls") ??
        {};
    if (dataHolder.isNotEmpty) {
      avatarUrls = UtilityMethods.convertMap(dataHolder);
    }

    

    description = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "description") ??
        "";
    if (description.isNotEmpty) {
      description = UtilityMethods.cleanContent(description);
    }

    dataHolder = UtilityMethods.getListItemValueFromMap(
            inputMap: json, key: "property_images") ??
        [];
    if (dataHolder.isNotEmpty) {
      dataHolder
          .removeWhere((element) => element is! String || element == "null");
      listOfImages = List<String>.from(dataHolder);
    }

    if (image.isEmpty && listOfImages.isNotEmpty) {
      // listOfImages.remove(image);
      image = listOfImages[0];
      // print(" with image: $image");
      // print("listOfImages: $listOfImages");
    } else if (listOfImages.isEmpty && image.isNotEmpty) {
      listOfImages.add(image);
      // print("listOfImages with thumbnail: $listOfImages");
    }

    tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_meta") ??
        {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_video_url");
      tempVideoUrl =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_virtual_tour");
      tempVirtualTourLink =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "_thumbnail_id");
      String tempMedia =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (tempMedia.isNotEmpty) {
        tempFeaturedImageId = int.tryParse(tempMedia);
      }
      tempMedia = ""; // dis-allocating the variable
    }

    tempMap =
        UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "meta") ??
            {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_post_type");
      reviewPostType =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_stars");
      reviewStars =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_by");
      reviewBy = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_to");
      reviewTo = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_property_id");
      reviewPropertyId =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_likes");
      reviewLikes =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "review_dislikes");
      reviewDislikes =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
    }

    if (json.containsKey("date")) {
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "date") ??
          "";
      if (dataHolder.isNotEmpty) {
        date = DateFormat('dd MMMM, yyyy', 'en')
            .format(DateTime.parse(dataHolder + "z"))
            .toString();
      }
    }

    if (json.containsKey("date_gmt")) {
      postDateGmt = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "date_gmt") ??
          "";
    }

    if (json.containsKey("modified")) {
      modifiedDate = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "modified") ??
          "";
    }

    if (json.containsKey("modified_gmt")) {
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "modified_gmt") ??
          "";
      if (dataHolder.isNotEmpty) {
        modifiedDateGmt = UtilityMethods.getTimeAgoFormat(
            time: dataHolder, locale: 'en_short');
      }
    }

    if (json.containsKey("post_date")) {
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_date") ??
          "";
      if (dataHolder.isNotEmpty) {
        date = UtilityMethods.getTimeAgoFormat(time: dataHolder);
      }
      // if(dataHolder.isNotEmpty){
      //   date = DateFormat('dd MMMM, yyyy', 'en_US').format(DateTime.parse(dataHolder + "z")).toString();
      // }
    }

    if (json.containsKey("post_date_gmt")) {
      postDateGmt = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_date_gmt") ??
          "";
      postDateGmt =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(postDateGmt));
    }

    if (json.containsKey("post_modified")) {
      modifiedDate = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_modified") ??
          "";
    }

    if (json.containsKey("post_modified_gmt")) {
      dataHolder = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_modified_gmt") ??
          "";
      if (dataHolder.isNotEmpty) {
        modifiedDateGmt = UtilityMethods.getTimeAgoFormat(time: dataHolder);
      }
    }

    if (json.containsKey("user_display_name")) {
      userDisplayName = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "user_display_name") ??
          "";
    }

    if (json.containsKey("currency_name")) {
      tempCurrency = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "currency_name") ??
          "";
    }
    if (json.containsKey("property_meta")) {
      final propertyMeta = json["property_meta"];

      final dataGetter = UtilityMethods.getItemValueFromMap(
          inputMap: propertyMeta, key: "fave_currency_info");
      final dataHelper =
          UtilityMethods.getStringValueFromDynamicItem(item: dataGetter);

      tempCurrencySymbol = UtilityMethods.getValueFromSerializedPhp(
          item: dataHelper, key: "currency_symbol");
      tempCurrencyCode = UtilityMethods.getValueFromSerializedPhp(
          item: dataHelper, key: "currency_code");
    }
    if (json.containsKey("currency_position")) {
      tempCurrencyPosition = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "currency_position") ??
          "";
    }

    if (json.containsKey("username")) {
      userName = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "username") ??
          "";
    }

    if (json.containsKey("title")) {
      dataHolder =
          UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "title") ??
              {};
      if (dataHolder.isNotEmpty) {
        tempTitle = UtilityMethods.getStringItemValueFromMap(
                inputMap: dataHolder, key: "rendered") ??
            "";
      }
    }

    if (json.containsKey("post_title")) {
      tempTitle = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_title") ??
          "";
    }

    if (json.containsKey("name")) {
      tempTitle = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "name") ??
          "";
    }

    if (json.containsKey("ID")) {
      tempId =
          UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "ID");
    }

    if (json.containsKey("id")) {
      tempId =
          UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "id");
    }
    if(json.containsKey("houzez_account_approved")){
      tempStatus = UtilityMethods.getIntStatusFromMap(
          inputMap: json, key: "houzez_account_approved") ?? "";

    }

    if (json.containsKey("property_id")) {
      tempId = UtilityMethods.getIntegerItemValueFromMap(
          inputMap: json, key: "property_id");
    }

    if (json.containsKey("type")) {
      tempType = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "type") ??
          "";
    }

    if (json.containsKey("post_type")) {
      tempType = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_type") ??
          "";
    }

    if (json.containsKey("status")) {
      propertyStatus = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "status") ??
          "";
    }

    if (json.containsKey("post_status")) {
      propertyStatus = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "post_status") ??
          "";
    }

    tempLink =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "link") ??
            "";
            reviewActionLabel = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "status_label") ??
        "";
    // if(dataHolder.isNotEmpty){
    //    = UtilityMethods.cleanContent(tempStatus);
    // }

    tempIsFav = UtilityMethods.getBooleanItemValueFromMap(
        inputMap: json, key: "is_fav");

    if (json.containsKey("post_status")) {
      if (json["guid"] is String) {
        tempGuid = UtilityMethods.getStringItemValueFromMap(
                inputMap: json, key: "guid") ??
            "";
      }
      if (json["guid"] is Map) {
        dataHolder = UtilityMethods.getMapItemValueFromMap(
                inputMap: json, key: "guid") ??
            {};
        if (dataHolder.isNotEmpty) {
          tempGuid = UtilityMethods.getStringItemValueFromMap(
                  inputMap: dataHolder, key: "rendered") ??
              "";
        }
      }
    }

    Article article;
    article = Article(
      id: tempId,
      title: UtilityMethods.cleanContent(tempTitle),
      content: content,
      image: image,
      imageList: listOfImages,
      video: tempVideoUrl,
      author: author,
      avatar: avatar,
      reviewActionLabel: reviewActionLabel,
      category: category,
      date: date,
      dateGMT: postDateGmt,
      link: tempLink,
      houzezAccountApproved: tempStatus ?? "",
      guid: UtilityMethods.cleanContent(tempGuid),
      catId: catId,
      virtualTourLink: tempVirtualTourLink,
      status: propertyStatus,
      isFav: tempIsFav,
      type: tempType,
      reviewBy: reviewBy,
      featuredImageId: tempFeaturedImageId,
      // reviewDislikes: reviewDislikes,
      // reviewLikes: reviewLikes,
      reviewPostType: reviewPostType,
      reviewPropertyId: reviewPropertyId,
      reviewStars: reviewStars,
      reviewTo: reviewTo,
      modifiedDate: modifiedDate,
      modifiedGmt: modifiedDateGmt,
      userDisplayName: userDisplayName,
      userName: userName,
      avatarUrls: avatarUrls,
      description: UtilityMethods.cleanContent(description),
       /// Newly added
      tempCurrency: tempCurrency,
      tempCurrencySymbol: tempCurrencySymbol,
      tempCurrencyCode: tempCurrencyCode,
      tempCurrencyPosition: tempCurrencyPosition,
    );

    Address address = parseAddressMap(json);
    PropertyInfo propertyInfo = parsePropertyInfoMap(json);
    Features features = parseFeaturesMap(json);
    Author authorInfo = parseAuthorInfoMap(json);

    if (json.containsKey("additional_details")) {
      MembershipPlanDetails membershipPlanDetails =
          parseMembershipPlanDetailsFunc(json['additional_details']);
      article.membershipPlanDetails = membershipPlanDetails;
    }
    article.propertyInfo = propertyInfo;
    article.address = address;
    article.features = features;
    article.otherFeatures!.addAll(json);
    article.internalFeaturesList!.addAll(features.featuresList!);
    article.authorInfo = authorInfo;

    Map<String, String> propDetails = <String, String>{};

    String _formattedDate = "";
    String createdDate = "";
    String _dateGmt = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "post_date_gmt") ??
        "";
    String _modifiedDateGmt = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "post_modified_gmt") ??
        "";

    if (_dateGmt.isNotEmpty) {
      createdDate = UtilityMethods.getFormattedDate(_dateGmt);
    }
    if (_modifiedDateGmt.isNotEmpty) {
      _formattedDate = UtilityMethods.getFormattedDate(_modifiedDateGmt);
    }

    if (createdDate.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_CREATED_DATE] = createdDate;
    }

    if (_formattedDate.isNotEmpty && createdDate != _formattedDate) {
      propDetails[PROPERTY_DETAILS_PROPERTY_LAST_UPDATED] = _formattedDate;
    }

    if (article.id != null) {
      propDetails[PROPERTY_DETAILS_PROPERTY_ID] = article.id.toString();
    }

    if (propertyInfo.showPricePlaceholder != null &&
        propertyInfo.showPricePlaceholder! &&
        propertyInfo.pricePlaceholder != null &&
        propertyInfo.pricePlaceholder!.isNotEmpty) {
      propDetails[PRICE] = propertyInfo.pricePlaceholder!;
    } else {
      if (propertyInfo.price != null && propertyInfo.price!.isNotEmpty) {
        if (propertyInfo.secondPrice != null &&
            propertyInfo.secondPrice!.isNotEmpty) {
          propDetails[FIRST_PRICE] = propertyInfo.price!;
          propDetails[SECOND_PRICE] = propertyInfo.secondPrice!;
          if (propertyInfo.pricePostfix!.isNotEmpty) {
            propDetails[SECOND_PRICE] =
                propertyInfo.secondPrice! + "/" + propertyInfo.pricePostfix!;
          }
        } else if (propertyInfo.secondPrice == null ||
            propertyInfo.secondPrice!.isEmpty) {
          propDetails[PRICE] = propertyInfo.price!;
          if (propertyInfo.pricePostfix!.isNotEmpty) {
            propDetails[PRICE] =
                propertyInfo.price! + "/" + propertyInfo.pricePostfix!;
          }
        }
      }
    }

    if (propertyInfo.propertyType != null &&
        propertyInfo.propertyType!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_TYPE] = propertyInfo.propertyType!;
    }

    if (propertyInfo.propertyStatus != null &&
        propertyInfo.propertyStatus!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_STATUS] =
          propertyInfo.propertyStatus!;
    }

    if (propertyInfo.uniqueId != null && propertyInfo.uniqueId!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_UNIQUE_ID] = propertyInfo.uniqueId!;
    }

    if (features.propertyArea != null && features.propertyArea!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_SIZE] = features.propertyArea!;
    }

    if (features.landArea != null && features.landArea!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_LAND_AREA] = features.landArea!;
      // propDetails['Property Size'] = features.landArea + " " + features.landAreaUnit;
    }

    if (features.bedrooms != null && features.bedrooms!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_BEDROOMS] = features.bedrooms!;
    }
    if(features.rooms != null && features.rooms!.isNotEmpty && SHOW_ROOMS_IN_PROPERTY_DETAILS) {
      propDetails[PROPERTY_DETAILS_PROPERTY_ROOMS] = features.rooms!;
    }

    if (features.bathrooms != null && features.bathrooms!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_BATHROOMS] = features.bathrooms!;
    }

    if (features.garage != null && features.garage!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_GARAGE] = features.garage!;
    }

    if (features.garageSize != null && features.garageSize!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_GARAGE_SIZE] = features.garageSize!;
    }

    if (features.yearBuilt != null && features.yearBuilt!.isNotEmpty) {
      propDetails[PROPERTY_DETAILS_PROPERTY_YEAR_BUILT] = features.yearBuilt!;
    }

    article.propertyDetailsMap = propDetails;

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};
    return article;
  }

  static Term parsePropertyMetaDataMap(Map<String, dynamic> json) {
    int? tempId;
    int? tempParent;
    int? tempTotalCount;
    String tempName = "";
    String tempSlug = "";
    String tempThumbnail = "";
    String tempFullImage = "";
    String taxonomy = "";
    String parentTerm = "";
    var unescape = HtmlUnescape();

    tempId = UtilityMethods.getIntegerItemValueFromMap(
        inputMap: json, key: "term_id");
    tempParent = UtilityMethods.getIntegerItemValueFromMap(
        inputMap: json, key: "parent");
    tempTotalCount =
        UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "count");
    tempName =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "name") ??
            "";
    if (tempName.isNotEmpty) {
      tempName = unescape.convert(tempName);
      try {
        tempName = Uri.decodeComponent(tempName);
      } catch (e) {}
    }
    tempSlug =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "slug") ??
            "";
    if (tempSlug.isNotEmpty) {
      tempSlug = unescape.convert(tempSlug);
      try {
        tempSlug = Uri.decodeComponent(tempSlug);
      } catch (e) {}
    }
    tempThumbnail = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "thumbnail") ??
        "";
    tempFullImage =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "full") ??
            "";
    taxonomy = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "taxonomy") ??
        "";
    parentTerm = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_parent_term") ??
        "";
    if (parentTerm.isNotEmpty) {
      parentTerm = unescape.convert(parentTerm);
      try {
        parentTerm = Uri.decodeComponent(parentTerm);
      } catch (e) {}
    }

    Term propertyMetaData = Term(
        id: tempId,
        name: tempName,
        slug: tempSlug,
        parent: tempParent,
        totalPropertiesCount: tempTotalCount,
        thumbnail: tempThumbnail,
        fullImage: tempFullImage,
        taxonomy: taxonomy,
        parentTerm: parentTerm);

    return propertyMetaData;
  }

  static Agency parseAgencyInformation(Map<String, dynamic> json) {
    int? tempId;
    String tempSlug = "";
    String tempType = "";
    String tempTitle = "";
    String tempContent = "";
    String tempThumbnail = "";
    String tempAgencyFaxNumber = "";
    String tempAgencyLicenseNumber = "";
    String tempAgencyPhoneNumber = "";
    String tempAgencyMobileNumber = "";
    String tempAgencyEmail = "";
    String tempAgencyAddress = "";
    String tempAgencyMapAddress = "";
    String tempAgencyLocation = "";
    String tempAgencyTaxNumber = "";
    String tempAgencyLink = "";
    String agencyWhatsappNumber = "";
    String tempTotalRating = "";
    bool hideAgency = false;
    bool agencyVerification = false;

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    tempId =
        UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "id");
    tempSlug =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "slug") ??
            "";
    tempType =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "type") ??
            "";
    tempAgencyLink =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "link") ??
            "";
    tempAgencyLink =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "link") ??
            "";
    tempThumbnail = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "thumbnail") ??
        "";
    dataHolder =
        UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "title") ??
            {};
    if (dataHolder.isNotEmpty) {
      tempTitle = UtilityMethods.getStringItemValueFromMap(
              inputMap: dataHolder, key: "rendered") ??
          "";
    }
    dataHolder =
        UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "content") ??
            {};
    if (dataHolder.isNotEmpty) {
      tempContent = UtilityMethods.getStringItemValueFromMap(
              inputMap: dataHolder, key: "rendered") ??
          "";
    }

    tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "agency_meta") ??
        {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_fax");
      tempAgencyFaxNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_licenses");
      tempAgencyLicenseNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_phone");
      tempAgencyPhoneNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_mobile");
      tempAgencyMobileNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_email");
      tempAgencyEmail =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_address");
      tempAgencyAddress =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_map_address");
      tempAgencyMapAddress =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_location");
      tempAgencyLocation =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_tax_no");
      tempAgencyTaxNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_whatsapp");
      agencyWhatsappNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "houzez_total_rating");
      tempTotalRating =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_visible");
      dataHolder =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      if (dataHolder == "1") {
        hideAgency = true;
      }
      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agency_verified");
      agencyVerification = UtilityMethods.getBooleanValueFromDynamicItem(item: dataHolder);
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};

    return Agency(
        id: tempId,
        slug: tempSlug,
        type: tempType,
        title: UtilityMethods.cleanContent(tempTitle),
        content: UtilityMethods.cleanContent(tempContent),
        thumbnail: tempThumbnail,
        agencyFaxNumber: tempAgencyFaxNumber,
        agencyLicenseNumber: tempAgencyLicenseNumber,
        agencyPhoneNumber: tempAgencyPhoneNumber,
        agencyMobileNumber: tempAgencyMobileNumber,
        email: tempAgencyEmail,
        agencyAddress: tempAgencyAddress,
        agencyMapAddress: tempAgencyMapAddress,
        agencyLocation: tempAgencyLocation,
        agencyTaxNumber: tempAgencyTaxNumber,
        agencyLink: tempAgencyLink,
        agencyWhatsappNumber: agencyWhatsappNumber,
        totalRating: tempTotalRating,
        hide: hideAgency,
        agencyVerification: agencyVerification
        );
  }

  static Agent parseAgentInformation(Map<String, dynamic> json) {
    int? tempId;
    String tempAgentId = "";
    String tempUserAgentId = "";
    String tempSlug = "";
    String tempType = "";
    String tempTitle = "";
    String tempContent = "";
    String tempThumbnail = "";
    String tempTotalRating = "";
    String tempAgentPosition = "";
    String tempAgentCompany = "";
    String tempAgentMobileNumber = "";
    String tempAgentOfficeNumber = "";
    String tempAgentPhoneNumber = "";
    String tempAgentFaxNumber = "";
    String tempAgentEmail = "";
    String tempAgentAddress = "";
    String tempAgentTaxNumber = "";
    String tempAgentLicenseNumber = "";
    String tempAgentServiceArea = "";
    String tempAgentSpecialties = "";
    String tempAgentLink = "";
    String agentWhatsappNumber = "";
    String agentLineId = "";
    String agentTelegram = "";
    String agentUserName = "";
    String tempAgentFirstName = "";
    String tempAgentLastName = "";
    List<String> tempAgentAgenciesList = [];
    bool hideAgent = false;
    bool tempAgentVerification = false;

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    tempId =
        UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "id");
    tempUserAgentId =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "ID") ??
            "";
    tempSlug =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "slug") ??
            "";
    agentUserName = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "user_login") ??
        "";
    tempAgentEmail = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "user_email") ??
        "";
    tempType =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "type") ??
            "";
    tempAgentLink =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "link") ??
            "";
    dataHolder =
        UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "title") ??
            {};
    if (dataHolder.isNotEmpty) {
      tempTitle = UtilityMethods.getStringItemValueFromMap(
              inputMap: dataHolder, key: "rendered") ??
          "";
    }
    if (json.containsKey("display_name") && tempTitle.isEmpty) {
      tempTitle = UtilityMethods.getStringItemValueFromMap(
              inputMap: json, key: "display_name") ??
          "";
    }
    dataHolder =
        UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "content") ??
            {};
    if (dataHolder.isNotEmpty) {
      tempContent = UtilityMethods.getStringItemValueFromMap(
              inputMap: dataHolder, key: "rendered") ??
          "";
    }
    tempThumbnail = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "thumbnail") ??
        "";

    tempMap = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "agent_meta") ??
        {};
    if (tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_position");
      tempAgentPosition =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      if (mapDataHolder.containsKey("fave_author_custom_picture") &&
          tempThumbnail.isEmpty) {
        dataHolder = UtilityMethods.getItemValueFromMap(
            inputMap: mapDataHolder, key: "fave_author_custom_picture");
        tempThumbnail =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_company");
      tempAgentCompany =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "first_name");
      tempAgentFirstName =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "last_name");
      tempAgentLastName =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_author_agent_id");
      tempAgentId =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_mobile");
      tempAgentMobileNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_office_num");
      tempAgentOfficeNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      if (mapDataHolder.containsKey("fave_author_mobile") &&
          tempAgentMobileNumber.isEmpty) {
        dataHolder = UtilityMethods.getItemValueFromMap(
            inputMap: mapDataHolder, key: "fave_author_mobile");
        tempAgentMobileNumber =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_author_phone");
      tempAgentPhoneNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_fax");
      tempAgentFaxNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      if (mapDataHolder.containsKey("fave_agent_email") &&
          tempAgentEmail.isEmpty) {
        dataHolder = UtilityMethods.getItemValueFromMap(
            inputMap: mapDataHolder, key: "fave_agent_email");
        tempAgentEmail =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      }

      dataHolder = UtilityMethods.getListItemValueFromMap(
              inputMap: mapDataHolder, key: "fave_agent_agencies") ??
          [];
      if (dataHolder.isNotEmpty) {
        tempAgentAgenciesList = List<String>.from(dataHolder);
      }

      if (mapDataHolder.containsKey("fave_author_agency_id") &&
          tempAgentAgenciesList.isEmpty) {
        dataHolder = UtilityMethods.getItemValueFromMap(
            inputMap: mapDataHolder, key: "fave_author_agency_id");
        String temp =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
        if (temp.isNotEmpty) {
          tempAgentAgenciesList = [temp];
        }
        temp = ""; //dis-allocating the variable
      }

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_address");
      tempAgentAddress =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_tax_no");
      tempAgentTaxNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_license");
      tempAgentLicenseNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_service_area");
      tempAgentServiceArea =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_specialties");
      tempAgentSpecialties =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "houzez_total_rating");
      tempTotalRating =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_whatsapp");
      agentWhatsappNumber =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_line_id");
      agentLineId =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_telegram");
      agentTelegram =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_visible");
      dataHolder =
          UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      dataHolder = UtilityMethods.getItemValueFromMap(
          inputMap: mapDataHolder, key: "fave_agent_verified");
      tempAgentVerification = UtilityMethods.getBooleanValueFromDynamicItem(
          item: dataHolder);
      
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};

    return Agent(
        id: tempId,
        slug: tempSlug,
        type: tempType,
        title: UtilityMethods.cleanContent(tempTitle),
        content: UtilityMethods.cleanContent(tempContent),
        thumbnail: tempThumbnail,
        totalRating: tempTotalRating,
        agentFaxNumber: tempAgentFaxNumber,
        agentLicenseNumber: tempAgentLicenseNumber,
        agentOfficeNumber: tempAgentOfficeNumber,
        agentMobileNumber: tempAgentMobileNumber,
        email: tempAgentEmail,
        agentAddress: tempAgentAddress,
        agentServiceArea: tempAgentServiceArea,
        agentSpecialties: tempAgentSpecialties,
        agentTaxNumber: tempAgentTaxNumber,
        agentAgencies: tempAgentAgenciesList,
        agentCompany: tempAgentCompany,
        agentPosition: tempAgentPosition,
        agentLink: tempAgentLink,
        agentWhatsappNumber: agentWhatsappNumber,
        lineApp: agentLineId,
        telegram: agentTelegram,
        agentPhoneNumber: tempAgentPhoneNumber,
        agentId: tempAgentId,
        userAgentId: tempUserAgentId,
        agentUserName: agentUserName,
        agentFirstName: tempAgentFirstName,
        agentLastName: tempAgentLastName,
        hide: hideAgent,
        agentVerification: tempAgentVerification
        );
  }

  static Author parseAuthorInfoMap(Map<String, dynamic> json) {
    int? tempId;
    bool tempIsSingle = false;
    bool tempIsVerified = false;
    String tempData = "";
    String tempEmail = "";
    String tempName = "";
    String tempPhone = "";
    String tempPhoneCall = "";
    String tempMobile = "";
    String tempMobileCall = "";
    String tempWhatsApp = "";
    String tempWhatsAppCall = "";
    String tempPicture = "";
    String tempLink = "";
    String tempType = "";
    String telegram = "";
    String lineId = "";

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map<String, dynamic> mapDataHolder01 = {};
    Map tempMap = {};

    dataHolder = UtilityMethods.getMapItemValueFromMap(
            inputMap: json, key: "property_meta") ??
        {};
    if (dataHolder.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(dataHolder);

      tempMap = UtilityMethods.getMapItemValueFromMap(
              inputMap: mapDataHolder, key: "agent_info") ??
          {};
      if (tempMap.isNotEmpty) {
        mapDataHolder01 = UtilityMethods.convertMap(tempMap);

        tempData = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_data") ??
            "";
        tempIsSingle = UtilityMethods.getBooleanItemValueFromMap(
            inputMap: mapDataHolder01, key: "is_single_agent");
        tempEmail = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_email") ??
            "";
        tempName = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_name") ??
            "";
        tempPhone = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_phone") ??
            "";
        tempPhoneCall = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_phone_call") ??
            "";
        tempMobile = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_mobile") ??
            "";
        tempMobileCall = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_mobile_call") ??
            "";
        tempWhatsApp = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_whatsapp") ??
            "";
        tempWhatsAppCall = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_whatsapp_call") ??
            "";
        tempPicture = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "picture") ??
            "";
        tempLink = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "link") ??
            "";
        tempType = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_type") ??
            "";
        tempId = UtilityMethods.getIntegerItemValueFromMap(
            inputMap: mapDataHolder01, key: "agent_id");
        tempId = UtilityMethods.getIntegerItemValueFromMap(
            inputMap: mapDataHolder01, key: "agent_id");
        telegram = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_telegram") ??
            "";
        lineId = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "agent_lineapp") ??
            "";
        tempIsVerified = UtilityMethods.getBooleanItemValueFromMap(
            inputMap: mapDataHolder01, key: "verified");
      }
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    mapDataHolder01 = {};
    tempMap = {};

    Author authorInfo = Author(
        id: tempId,
        isSingle: tempIsSingle,
        isVerified: tempIsVerified,
        data: tempData,
        email: tempEmail,
        name: tempName,
        phone: tempPhone,
        phoneCall: tempPhoneCall,
        mobile: tempMobile,
        mobileCall: tempMobileCall,
        whatsApp: tempWhatsApp,
        whatsAppCall: tempWhatsAppCall,
        picture: tempPicture,
        link: tempLink,
        type: tempType,
        telegram: telegram,
        lineApp: lineId);
    return authorInfo;
  }

  static FloorPlans parseFloorPlansMap(Map<String, dynamic> json) {
    String tempTitle = "";
    String tempRooms = "";
    String tempBathrooms = "";
    String tempPrice = "";
    String tempPricePostFix = "";
    String tempSize = "";
    String tempImage = "";
    String tempDescription = "";

    tempTitle = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_title") ??
        "";
    tempRooms = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_rooms") ??
        "";
    tempBathrooms = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_bathrooms") ??
        "";
    tempPrice = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_price") ??
        "";
    tempPricePostFix = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_price_postfix") ??
        "";
    tempSize = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_size") ??
        "";
    tempImage = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_image") ??
        "";
    tempDescription = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_plan_description") ??
        "";

    FloorPlans floorPlans = FloorPlans(
      title: tempTitle,
      rooms: tempRooms,
      bathrooms: tempBathrooms,
      price: tempPrice,
      pricePostFix: tempPricePostFix,
      size: tempSize,
      image: tempImage,
      description: tempDescription,
    );

    return floorPlans;
  }

  static MultiUnit parseMultiUnitsMap(Map<String, dynamic> json) {
    String faveMuTitle = "";
    String faveMuPrice = "";
    String faveMuPricePostfix = "";
    String faveMuBeds = "";
    String faveMuBaths = "";
    String faveMuSize = "";
    String faveMuSizePostfix = "";
    String faveMuType = "";
    String faveMuAvailabilityDate = "";

    faveMuTitle = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_title") ??
        "";
    faveMuPrice = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_price") ??
        "";
    faveMuPricePostfix = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_price_postfix") ??
        "";
    faveMuBeds = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_beds") ??
        "";
    faveMuBaths = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_baths") ??
        "";
    faveMuSize = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_size") ??
        "";
    faveMuSizePostfix = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_size_postfix") ??
        "";
    faveMuType = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_type") ??
        "";
    faveMuAvailabilityDate = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "fave_mu_availability_date") ??
        "";

    MultiUnit multiUnit = MultiUnit(
      availabilityDate: faveMuAvailabilityDate,
      bathrooms: faveMuBaths,
      bedrooms: faveMuBeds,
      price: faveMuPrice,
      pricePostfix: faveMuPricePostfix,
      size: faveMuSize,
      sizePostfix: faveMuSizePostfix,
      title: faveMuTitle,
      type: faveMuType,
    );

    return multiUnit;
  }

  static SavedSearch parseSavedSearchMap(Map<String, dynamic> json) {
    String id = "";
    String autherId = "";
    String query = "";
    String email = "";
    String url = "";
    String time = "";

    dynamic dataHolder;

    id = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "id") ??
        "";
    autherId = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "auther_id") ??
        "";
    query = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "query") ??
        "";
    email = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "email") ??
        "";
    url =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "url") ??
            "";
    dataHolder =
        UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ??
            "";
    if (dataHolder.isNotEmpty) {
      time = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    // Dis-allocating the variables
    dataHolder = null;

    return SavedSearch(
      id: id,
      autherId: autherId,
      email: email,
      query: query,
      time: time,
      url: url,
    );
  }
 
 static InsightsUserProperties parseAndStoreInsightsUserPropertiesMap(Map<String, dynamic> json){
    String? id = "";
    String title = "";
    String userId = "";
    String timePeriod = "";
    String totalProperties = "";
    String totalViews = "";
    String totalUniqueViews = "";
    String url = "";
    String thumbnail = "";
    List<Map<String, dynamic>> topProperties = [];
    Map<String, dynamic> charts = {}; 
    List<Map<String, dynamic>> trafficSources = [];
    List<Views> views = [];
    List<Views> uniqueViews = [];
    List<TopInsightsMetaData> countries = [];
    List<TopInsightsMetaData> platform = [];
    List<TopInsightsMetaData> device = [];
    List<TopInsightsMetaData> browser = [];
    bool success = false;
    Map<String, dynamic> property = {};
    String dataType = "";
    Map<String, dynamic> insights = {};
    String authorId = "";
    int totalViewsInt = 0;
    int uniqueViewsInt = 0;
    int perPage = 0;
    int page = 0;
    int totalPages = 0;
    int count = 0;
    Map<String, dynamic> topCountries = {};
    Map<String, dynamic> topReferrers = {};
    Map<String, dynamic> deviceBreakdownMap = {};
    String status = "";
    String lastUpdated = "";
    Map tempMap = {};
    dynamic dataHolder = "";
    Map<String, dynamic> mapDataHolder = {};
    Map<String, dynamic> mapDataHolder01 = {};
    List<InsightsChartEntry> chartsList = [];

    // --- Parse success ---
    dataHolder = UtilityMethods.getBooleanItemValueFromMap(inputMap: json, key: "success") ?? false;
    success = dataHolder;

    // --- Parse user_id ---
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "user_id") ?? "";
    if (dataHolder.isNotEmpty) {
      userId = dataHolder.toString();
    }

    // --- Parse time_period ---
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time_period") ?? "";
    if (dataHolder.isNotEmpty) {
      timePeriod = dataHolder.toString();
    }

    // --- Parse total_properties ---
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "total_properties") ?? "";
    if (dataHolder.isNotEmpty) {
      totalProperties = dataHolder.toString();
    }

    // --- Parse views ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "views") ?? [];
    var viewsList = parseViewsMetaDataList(dataHolder);
    if (viewsList.isNotEmpty) {
      views = viewsList.cast<Views>();
    }

    // --- Parse unique_views ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "unique_views") ?? [];
    var uniqueViewsList = parseViewsMetaDataList(dataHolder);
    if (uniqueViewsList.isNotEmpty) {
      uniqueViews = uniqueViewsList.cast<Views>();
    }

    // --- Parse top_countries ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "top_countries") ?? [];
    var countriesList = parseTopInsightsMetaDataList(dataHolder);
    if (countriesList.isNotEmpty) {
      countries = countriesList.cast<TopInsightsMetaData>();
    }

    // --- Parse devices ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "devices") ?? [];
    var deviceList = parseTopInsightsMetaDataList(dataHolder);
    if (deviceList.isNotEmpty) {
      device = deviceList.cast<TopInsightsMetaData>();
    }

    // --- Parse platforms ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "platforms") ?? [];
    var platformList = parseTopInsightsMetaDataList(dataHolder);
    if (platformList.isNotEmpty) {
      platform = platformList.cast<TopInsightsMetaData>();
    }

    // --- Parse browsers ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "browsers") ?? [];
    var browserList = parseTopInsightsMetaDataList(dataHolder);
    if (browserList.isNotEmpty) {
      browser = browserList.cast<TopInsightsMetaData>();
    }

    // --- Parse total_views ---
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "total_views") ?? "";
    if (dataHolder.isNotEmpty) {
      totalViews = dataHolder.toString();
    }

    // --- Parse total_unique_views ---
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "total_unique_views") ?? "";
    if (dataHolder.isNotEmpty) {
      totalUniqueViews = dataHolder.toString();
    }

    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "page") ?? "";
    if (dataHolder.isNotEmpty) {
      page = dataHolder;
    }

    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "per_page") ?? "";
    if (dataHolder.isNotEmpty) {
      perPage = dataHolder;
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "total_pages") ?? "";
    if (dataHolder.isNotEmpty) {
      totalPages = dataHolder;
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "count") ?? "";
    if (dataHolder.isNotEmpty) {
      count = dataHolder;
    }

    // --- Parse top_properties ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "top_properties") ?? [];
    if (dataHolder.isNotEmpty) {
      List<dynamic> tempList = List.from(dataHolder);
      for (var item in tempList) {
        if (item is Map<String, dynamic>) {
          Map<String, dynamic> propertyMap = {};
          var propertyId = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "id") ?? "";
          var propertyTitle = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "title") ?? "";
          var propertyViews = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "views") ?? "";
          var propertyUniqueViews = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "unique_views") ?? "";
          var propertyUrl = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "url") ?? "";
          propertyMap["id"] = propertyId.toString();
          propertyMap["title"] = propertyTitle.toString();
          propertyMap["views"] = propertyViews.toString();
          propertyMap["unique_views"] = propertyUniqueViews.toString();
          propertyMap["url"] = propertyUrl.toString();
          topProperties.add(propertyMap);
        }
      }
    }

    // --- Parse traffic_sources or referrals ---
    dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "traffic_sources") ??
                 UtilityMethods.getListItemValueFromMap(inputMap: json, key: "referrals") ?? [];
    if (dataHolder.isNotEmpty) {
      List<dynamic> tempList = List.from(dataHolder);
      for (var item in tempList) {
        if (item is Map<String, dynamic>) {
          Map<String, dynamic> sourceMap = {};
          var domain = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "domain") ?? "";
          var count = UtilityMethods.getStringItemValueFromMap(inputMap: item, key: "count") ?? "";
          var subrefs = UtilityMethods.getListItemValueFromMap(inputMap: item, key: "subrefs") ?? [];
          sourceMap["domain"] = domain.toString();
          sourceMap["count"] = count.toString();
          sourceMap["subrefs"] = subrefs;
          trafficSources.add(sourceMap);
        }
      }
    }

    // --- Parse id, title, url, thumbnail, status, last_updated ---
    dataHolder = UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "id");
    if (dataHolder != null && dataHolder.toString().isNotEmpty) {
      id = dataHolder.toString();
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "title") ?? "";
    if (dataHolder.isNotEmpty) {
      title = dataHolder.toString();
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "url") ?? "";
    if (dataHolder.isNotEmpty) {
      url = dataHolder.toString();
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "thumbnail") ?? "";
    if (dataHolder.isNotEmpty) {
      thumbnail = dataHolder.toString();
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "status") ?? "";
    if (dataHolder.isNotEmpty) {
      status = dataHolder.toString();
    }
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "last_updated") ?? "";
    if (dataHolder.isNotEmpty) {
      lastUpdated = dataHolder.toString();
    }

    // --- Parse property object (for second JSON structure) ---
    dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "property") ?? {};
    if (dataHolder != null && dataHolder.isNotEmpty) {
      property = Map<String, dynamic>.from(dataHolder);
      var propertyId = UtilityMethods.getIntegerItemValueFromMap(inputMap: property, key: "id");
      if (propertyId != null) {
        id = propertyId.toString();
      }
      var propertyTitle = UtilityMethods.getStringItemValueFromMap(inputMap: property, key: "title") ?? "";
      if (propertyTitle.isNotEmpty && title.isEmpty) {
        title = propertyTitle.toString();
      }
      var propertyStatus = UtilityMethods.getStringItemValueFromMap(inputMap: property, key: "status") ?? "";
      if (propertyStatus.isNotEmpty && status.isEmpty) {
        status = propertyStatus.toString();
      }
      var propertyUrl = UtilityMethods.getStringItemValueFromMap(inputMap: property, key: "url") ?? "";
      if (propertyUrl.isNotEmpty && url.isEmpty) {
        url = propertyUrl.toString();
      }
      var propertyAuthorId = UtilityMethods.getStringItemValueFromMap(inputMap: property, key: "author_id") ?? "";
      if (propertyAuthorId.isNotEmpty) {
        authorId = propertyAuthorId.toString();
      }
    }

    // --- Parse data_type ---
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "data_type") ?? "";
    if (dataHolder.isNotEmpty) {
      dataType = dataHolder.toString();
    }

    // --- Parse insights object ---
    dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "insights") ?? {};
    if (dataHolder.isNotEmpty) {
      insights = Map<String, dynamic>.from(dataHolder);
      var insightsTotalViews = UtilityMethods.getStringItemValueFromMap(inputMap: insights, key: "total_views") ?? "";
      if (insightsTotalViews.isNotEmpty) {
        totalViewsInt = int.tryParse(insightsTotalViews.toString()) ?? 0;
        if (totalViews.isEmpty) {
          totalViews = insightsTotalViews.toString();
        }
      }
      var insightsUniqueViews = UtilityMethods.getStringItemValueFromMap(inputMap: insights, key: "unique_views") ?? "";
      if (insightsUniqueViews.isNotEmpty) {
        uniqueViewsInt = int.tryParse(insightsUniqueViews.toString()) ?? 0;
        if (totalUniqueViews.isEmpty) {
          totalUniqueViews = insightsUniqueViews.toString();
        }
      }
      var insightsTopCountries = UtilityMethods.getMapItemValueFromMap(inputMap: insights, key: "top_countries") ?? {};
      if (insightsTopCountries.isNotEmpty) {
        topCountries = Map<String, dynamic>.from(insightsTopCountries);
      }
      var insightsTopReferrers = UtilityMethods.getMapItemValueFromMap(inputMap: insights, key: "top_referrers") ?? {};
      if (insightsTopReferrers.isNotEmpty) {
        topReferrers = Map<String, dynamic>.from(insightsTopReferrers);
      }
      var insightsDeviceBreakdown = UtilityMethods.getMapItemValueFromMap(inputMap: insights, key: "device_breakdown") ?? {};
      if (insightsDeviceBreakdown.isNotEmpty) {
        deviceBreakdownMap = Map<String, dynamic>.from(insightsDeviceBreakdown);
      }
      var insightsLastUpdated = UtilityMethods.getStringItemValueFromMap(inputMap: insights, key: "last_updated") ?? "";
      if (insightsLastUpdated.isNotEmpty && lastUpdated.isEmpty) {
        lastUpdated = insightsLastUpdated.toString();
      }
    }

    // --- Parse charts ---
    dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "charts") ?? {};
    if (dataHolder.isNotEmpty) {
      charts = Map<String, dynamic>.from(dataHolder);
      chartsList = parseInsightsChartEntries(charts);
    }

    return InsightsUserProperties(
      id: id,
      title: title,
      url: url,
      thumbnail: thumbnail,
      status: status,
      lastUpdated: lastUpdated,
      success: success,
      userId: userId,
      timePeriod: timePeriod,
      totalProperties: totalProperties,
      totalViews: totalViews,
      totalUniqueViews: totalUniqueViews,
      views: views,
      uniqueViews: uniqueViews,
      topProperties: topProperties,
      charts: charts,
      chartsList: chartsList,
      trafficSources: trafficSources,
      countries: countries,
      device: device,
      platform: platform,
      browser: browser,
      property: property,
      dataType: dataType,
      insights: insights,
      authorId: authorId,
      count: count,
      page: page,
      perPage: perPage,
      totalPages: totalPages,
      totalViewsInt: totalViewsInt,
      uniqueViewsInt: uniqueViewsInt,
      topCountries: topCountries,
      topReferrers: topReferrers,
      deviceBreakdownMap: deviceBreakdownMap,
    );
  }

  static List<dynamic> parseViewsMetaDataList(List? inputList) {
    List parsedList = [];

    if (inputList != null && inputList.isNotEmpty) {
      parsedList = inputList.map((m) => parseInsightViewsMetaDataMap(m)).toList();
    }

    return parsedList;
  }

  static List<dynamic> parseTopInsightsMetaDataList(List? inputList) {
    List parsedList = [];

    if (inputList != null && inputList.isNotEmpty) {
      parsedList = inputList.map((m) => parseTopInsightMetaDataMap(m)).toList();
    }

    return parsedList;
  }


  static Views parseInsightViewsMetaDataMap(Map<String, dynamic> json) {
    String tempPeriod = "";
    int? tempCount;
    int? tempPercentage;

    // Defensive: handle int, string, or double for count
    var countValue = json['count'];
    if (countValue is int) {
      tempCount = countValue;
    } else if (countValue is String) {
      tempCount = int.tryParse(countValue) ?? 0;
    } else if (countValue is double) {
      tempCount = countValue.round();
    } else {
      tempCount = 0;
    }

    // Defensive: handle int, string, or double for percentage
    var percentValue = json['percentage'];
    if (percentValue is int) {
      tempPercentage = percentValue;
    } else if (percentValue is String) {
      tempPercentage = int.tryParse(percentValue) ?? 0;
    } else if (percentValue is double) {
      tempPercentage = percentValue.round();
    } else {
      tempPercentage = 0;
    }

    tempPeriod = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "period") ?? "";

    Views viewsMetaData = Views(
        period: tempPeriod,
        count: tempCount,
        percentage: tempPercentage,
        );

    return viewsMetaData;
  }

  static TopInsightsMetaData parseTopInsightMetaDataMap(Map<String, dynamic> json) {
    String tempName = "";
    int? tempCount;
    // Defensive: handle int, string, or double for count
    var countValue = json['count'];
    if (countValue is int) {
      tempCount = countValue;
    } else if (countValue is String) {
      tempCount = int.tryParse(countValue) ?? 0;
    } else if (countValue is double) {
      tempCount = countValue.round();
    } else {
      tempCount = 0;
    }
    
    // Handle empty or null names
    tempName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "name") ?? "";
    if (tempName.isEmpty || tempName.trim().isEmpty) {
      tempName = "Unknown";
    }
    
    return TopInsightsMetaData(
      name: tempName,
      count: tempCount,
    );
  }

  static User parseUserInfoMap(Map<String, dynamic> json) {
    String id = "";
    String userLogin = "";
    String userNicename = "";
    String userEmail = "";
    String userUrl = "";
    String userStatus = "";
    String displayName = "";
    String profile = "";
    String username = "";
    String userTitle = "";
    String firstName = "";
    String lastName = "";
    String userMobile = "";
    String userWhatsapp = "";
    String userPhone = "";
    String description = "";
    String userlangs = "";
    String userCompany = "";
    String taxNumber = "";
    String faxNumber = "";
    String userAddress = "";
    String serviceAreas = "";
    String specialties = "";
    String license = "";
    String gdprAgreement = "";
    String roles = "";
    String facebook = "";
    String twitter = "";
    String instagram = "";
    String linkedin = "";
    String youtube = "";
    String pinterest = "";
    String vimeo = "";
    String skype = "";
    String website = "";
    String lineId = "";
    String telegram = "";
    String authorPictureId = "";
    List displayNameOptions = [];

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map<String, dynamic> mapDataHolder01 = {};
    Map tempMap = {};

    dataHolder = UtilityMethods.getStringItemValueFromMap(
            inputMap: json, key: "roles") ??
        [];
    roles = UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);

    dataHolder =
        UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "user") ??
            {};
    if (dataHolder.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(dataHolder);
    }

    if (mapDataHolder.isNotEmpty) {
      tempMap = UtilityMethods.getMapItemValueFromMap(
              inputMap: mapDataHolder, key: "data") ??
          {};
      if (tempMap.isNotEmpty) {
        mapDataHolder01 = UtilityMethods.convertMap(tempMap);

        id = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "ID") ??
            "";
        userLogin = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_login") ??
            "";
        userNicename = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_nicename") ??
            "";
        userEmail = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_email") ??
            "";
        userUrl = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_url") ??
            "";
        userStatus = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_status") ??
            "";
        displayName = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "display_name") ??
            "";
        profile = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "profile") ??
            "";
        username = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "username") ??
            "";
        userTitle = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_title") ??
            "";
        firstName = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "first_name") ??
            "";
        lastName = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "last_name") ??
            "";
        userMobile = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_mobile") ??
            "";
        userWhatsapp = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_whatsapp") ??
            "";
        userPhone = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_phone") ??
            "";
        dataHolder = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "description") ??
            "";
        if (dataHolder.isNotEmpty) {
          description = UtilityMethods.cleanContent(dataHolder);
        }
        userlangs = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "userlangs") ??
            "";
        userCompany = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_company") ??
            "";
        taxNumber = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "tax_number") ??
            "";
        faxNumber = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "fax_number") ??
            "";
        userAddress = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "user_address") ??
            "";
        serviceAreas = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "service_areas") ??
            "";
        specialties = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "specialties") ??
            "";
        license = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "license") ??
            "";
        gdprAgreement = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "gdpr_agreement") ??
            "";
        facebook = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "facebook") ??
            "";
        twitter = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "twitter") ??
            "";
        instagram = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "instagram") ??
            "";
        linkedin = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "linkedin") ??
            "";
        skype = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "userskype") ??
            "";
        pinterest = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "pinterest") ??
            "";
        youtube = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "youtube") ??
            "";
        vimeo = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "vimeo") ??
            "";
        website = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "website") ??
            "";
        lineId = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "line_id") ??
            "";
        telegram = UtilityMethods.getStringItemValueFromMap(
                inputMap: mapDataHolder01, key: "telegram") ??
            "";
        dataHolder = UtilityMethods.getIntegerItemValueFromMap(
            inputMap: mapDataHolder01, key: "author_picture_id");
        if (dataHolder != null) {
          authorPictureId = dataHolder.toString();
        }
        dataHolder = UtilityMethods.getListItemValueFromMap(
                inputMap: mapDataHolder01, key: "display_name_options") ??
            [];
        if (dataHolder.isNotEmpty) {
          displayNameOptions = List<String>.from(dataHolder);
        }
      }
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    mapDataHolder01 = {};
    tempMap = {};

    return User(
      id: id,
      lastName: lastName,
      firstName: firstName,
      displayName: displayName,
      description: description,
      faxNumber: faxNumber,
      gdprAgreement: gdprAgreement,
      license: license,
      profile: profile,
      roles: roles,
      serviceAreas: serviceAreas,
      specialties: specialties,
      taxNumber: taxNumber,
      userAddress: userAddress,
      userCompany: userCompany,
      userEmail: userEmail,
      userlangs: userlangs,
      userLogin: userLogin,
      userMobile: userMobile,
      username: username,
      userNicename: userNicename,
      userPhone: userPhone,
      userStatus: userStatus,
      userTitle: userTitle,
      userUrl: userUrl,
      userWhatsapp: userWhatsapp,
      displayNameOptions: displayNameOptions,
      facebook: facebook,
      instagram: instagram,
      linkedin: linkedin,
      twitter: twitter,
      pinterest: pinterest,
      skype: skype,
      vimeo: vimeo,
      website: website,
      lineId: lineId,
      telegram: telegram,
      youtube: youtube,
      pictureId: authorPictureId,
    );
  }

  static List<dynamic> getParsedDataInList(
      {required List<dynamic> inputList,
      required Function(Map<String, dynamic>) function}) {
    List<dynamic> outputList = inputList.map((item) => function(item)).toList();
    return outputList;
  }

  static ApiResponse<String> parseNonceResponseFunc(Response response) {
    if (response.statusCode == HttpStatus.ok) {
      if (response.data is Map) {
        Map? map = response.data;
        if (map != null && map.containsKey("success") && map["success"]) {
          if (map.containsKey("nonce")) {
            return ApiResponse<String>(
                internet: true,
                success: true,
                result: map["nonce"],
                message: "success");
          }
        }
      }
    } else {
      if (response.statusCode == 403 && response.data is Map) {
        Map? map = response.data;

        if (map != null && map.containsKey("reason") && map["reason"] != null) {
          UtilityMethods.printAttentionMessage(map["reason"]);
          return ApiResponse<String>(
              internet: true,
              success: false,
              result: "",
              message: map["reason"]);
        }
      }
    }
    return ApiResponse<String>(
        internet: true,
        success: false,
        result: "",
        message: response.statusMessage!);
  }

  static Partner parsePartnerJsonFunc(Map<String, dynamic> json) {
    String tempTitle = "";
    String tempLink = "";
    dynamic dataHolder;

    if (json.containsKey("title")) {
      dataHolder =
          UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "title") ??
              {};
      if (dataHolder.isNotEmpty) {
        tempTitle = UtilityMethods.getStringItemValueFromMap(
                inputMap: dataHolder, key: "rendered") ??
            "";
      }
    }
    if (json.containsKey("meta")) {
      dataHolder =
          UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "meta") ??
              {};
      if (dataHolder.isNotEmpty) {
        dataHolder = UtilityMethods.getItemValueFromMap(
            inputMap: dataHolder, key: "fave_partner_website");
        tempLink =
            UtilityMethods.getStringValueFromDynamicItem(item: dataHolder);
      }
    }
    Partner partner = Partner(
      title: UtilityMethods.cleanContent(tempTitle),
      id: UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "id"),
      date:
          UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "date"),
      dateGmt: UtilityMethods.getStringItemValueFromMap(
          inputMap: json, key: "date_gmt"),
      modified: UtilityMethods.getStringItemValueFromMap(
          inputMap: json, key: "modified"),
      modifiedGmt: UtilityMethods.getStringItemValueFromMap(
          inputMap: json, key: "modified_gmt"),
      slug:
          UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "slug"),
      status: UtilityMethods.getStringItemValueFromMap(
          inputMap: json, key: "status"),
      type:
          UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "type"),
      link: tempLink,
      featuredMedia: UtilityMethods.getIntegerItemValueFromMap(
          inputMap: json, key: "featured_media"),
      menuOrder: UtilityMethods.getIntegerItemValueFromMap(
          inputMap: json, key: "menu_order"),
      template: UtilityMethods.getStringItemValueFromMap(
          inputMap: json, key: "template"),
      featuredImageUrl: UtilityMethods.getStringItemValueFromMap(
          inputMap: json, key: "featured_image_url"),
    );

    // Dis-allocating the variables
    dataHolder = null;

    return partner;
  }

  static ApiResponse<String> parsePaymentFunc(Response response) {
    if (response.statusCode == HttpStatus.ok) {
      if (response.data is Map) {
        Map? map = response.data;
        if (map != null && map.containsKey("success") && map["success"]) {
          if (map.containsKey("message")) {
            return ApiResponse<String>(
                internet: true,
                success: true,
                result: map["message"],
                message: map["message"]);
          }
        }
      }
    } else {
      if (response.statusCode == 403 && response.data is Map) {
        Map? map = response.data;

        if (map != null && map.containsKey("reason") && map["reason"] != null) {
          UtilityMethods.printAttentionMessage(map["reason"]);
          return ApiResponse<String>(
              internet: true,
              success: false,
              result: "",
              message: map["reason"]);
        }
      }
    }
    return ApiResponse<String>(
        internet: true,
        success: false,
        result: "",
        message: response.statusMessage!);
  }

  static ApiResponse<String> parseNormalApiFunc(Response response) {
    String _message = "", _result = "";
    bool _success = false, _internet = true;
    Map? map;

    if (response.statusCode == HttpStatus.ok && response.data is Map) {
      map = response.data;
      if (map != null && map.containsKey("success") && map["success"] != null) {
        _success = map["success"] ?? false;
        if (_success && map.containsKey("message") && map["message"] != null) {
          _message = map["message"] ?? "";
        }
      }
    } else if (response.data is Map &&
        (response.statusCode == HttpStatus.forbidden ||
            response.statusCode == HttpStatus.badRequest ||
            response.statusCode == HttpStatus.unprocessableEntity ||
            response.statusCode == HttpStatus.unauthorized)) {
      map = response.data;

      if (map != null) {
        if (map.containsKey("reason") && map["reason"] != null) {
          _message = UtilityMethods.cleanContent(map["reason"]);
        } else if (map.containsKey("message") && map["message"] != null) {
          _message = UtilityMethods.cleanContent(map["message"]);
        } else {
          _message = response.statusMessage ?? "";
        }
        UtilityMethods.printAttentionMessage(_message);
      }
    }

    return ApiResponse<String>(
        success: _success,
        internet: _internet,
        result: _result,
        message: _message);
  }

  static ApiResponse<String> parse500ApiFunc(Response response) {
    final responseString = response.toString();
    Map<String, dynamic>? map = UtilityMethods.extractJson(responseString);

    if (map != null) {
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.internalServerError) {
        if (map.containsKey("success") && map["success"]) {
          String message = "";
          String result = "";
          if (map.containsKey("msg") && map["msg"] != null) {
            message = map["msg"] as String;
            result = map["msg"] as String;
          } else if (map.containsKey("message") && map["message"] != null) {
            message = map["message"] as String;
            result = map["message"] as String;
          } else if (map.containsKey("url") && map["url"] != null) {
            result = map["url"] as String;
          }

          return ApiResponse<String>(
              success: true, internet: true, result: result, message: message);
        } else if (map.containsKey("reason") && map["reason"] != null) {
          UtilityMethods.printAttentionMessage(map["reason"]);
          return ApiResponse<String>(
              success: false,
              internet: true,
              result: map["reason"] as String,
              message: map["reason"] as String);
        } else if (map.containsKey("added") && map["added"] != null) {
          String _result = "";
          if (map["added"] == true) {
            _result = AddedKey;
          } else if (map["added"] == false) {
            _result = RemovedKey;
          }
          return ApiResponse<String>(
              success: true, internet: true, result: _result, message: "");
        } else if (map.containsKey("remove_attachment")) {
          String _message = "";
          if (map["remove_attachment"] != null &&
              map["remove_attachment"] is Map) {
            _message = "Image removed successfully!";
          } else {
            _message = "No Image removed!";
          }
          return ApiResponse<String>(
              success: true, internet: true, result: "", message: _message);
        } else if (map.containsKey("msg") && map["msg"] != null) {
          String message = map["msg"] as String;
          return ApiResponse<String>(
              success: false,
              internet: true,
              result: message,
              message: message);
        } else if (map.containsKey("message") && map["message"] != null) {
          String message = map["message"] as String;
          return ApiResponse<String>(
              success: false,
              internet: true,
              result: message,
              message: message);
        }
      } else if (response.statusCode == HttpStatus.forbidden) {
        if (map.containsKey("reason") && map["reason"] != null) {
          UtilityMethods.printAttentionMessage(map["reason"]);
          return ApiResponse<String>(
              success: false,
              internet: true,
              result: "",
              message: map["reason"] as String);
        }
      }
    }

    return ApiResponse<String>(
        success: false,
        internet: true,
        result: "",
        message: response.statusMessage ?? "Unknown error");
  }

  static ApiResponse<String> parseMakeListingFeatured(Response response) {
    final responseString = response.toString();
    Map<String, dynamic>? map = UtilityMethods.extractJson(responseString);

    if (map != null) {
      if (response.statusCode == 500) {
        if (map.containsKey("success") && map["success"]) {
          if (map.containsKey("msg")) {
            return const ApiResponse<String>(
                success: true,
                internet: true,
                result: "success",
                message: "success");
          }
        } else {
          UtilityMethods.printAttentionMessage(
              "Error while making property featured");
          return const ApiResponse<String>(
              success: false,
              internet: true,
              result: "",
              message: "Error while making property featured");
        }
      }
    }

    return ApiResponse<String>(
        success: false,
        internet: true,
        result: "",
        message: response.statusMessage!);
  }

  static UserMembershipPackage parseUserMembershipPackage(
      Map<String, dynamic> json) {
    return UserMembershipPackage(
      success: json["success"],
      remainingListings: json["remaining_listings"],
      packFeaturedRemainingListings: json["pack_featured_remaining_listings"],
      packageId: json["package_id"],
      packagesPageLink: json["packages_page_link"],
      packTitle: json["pack_title"],
      packListings: json["pack_listings"],
      packUnlimitedListings: json["pack_unlimited_listings"],
      packFeaturedListings: json["pack_featured_listings"],
      packBillingPeriod: json["pack_billing_period"],
      packBillingFrequency: json["pack_billing_frequency"],
      packDate: json["pack_date"],
      expiredDate: json["expired_date"],
    );
  }

  static BlogArticlesData parseBlogArticles(Map<String, dynamic> json) {
    return BlogArticlesData(
      success: json["success"],
      count: json["count"],
      articlesList: json["result"] == null
          ? []
          : List<BlogArticle>.from(
              json["result"]!.map((x) => parseSingleBlogArticleJson(x))),
    );
  }

  static BlogArticle parseSingleBlogArticleJson(Map<String, dynamic> json) =>
      BlogArticle(
        id: json["ID"],
        postAuthor: json["post_author"] is int ? "${json["post_author"]}" :  json["post_author"],
        postDate: json["post_date"] == null
            ? null
            : DateTime.parse(json["post_date"]),
        postDateGmt: json["post_date_gmt"] == null
            ? null
            : DateTime.parse(json["post_date_gmt"]),
        postDateFormatted: json["post_date_gmt"] == null
            ? null
            : UtilityMethods.getTimeAgoFormat(time: json["post_date_gmt"]),
        postContent: json["post_content"],
        postTitle: json["post_title"],
        postExcerpt: json["post_excerpt"],
        postStatus: json["post_status"],
        commentStatus: json["comment_status"],
        pingStatus: json["ping_status"],
        postPassword: json["post_password"],
        postName: json["post_name"],
        toPing: json["to_ping"],
        pinged: json["pinged"],
        postModified: json["post_modified"] == null
            ? null
            : DateTime.parse(json["post_modified"]),
        postModifiedGmt: json["post_modified_gmt"] == null
            ? null
            : DateTime.parse(json["post_modified_gmt"]),
        postModifiedFormatted: json["post_modified_gmt"] == null
            ? null
            : UtilityMethods.getTimeAgoFormat(time: json["post_modified_gmt"]),
        postContentFiltered: json["post_content_filtered"],
        postParent: json["post_parent"],
        guid: json["guid"],
        menuOrder: json["menu_order"],
        postType: json["post_type"],
        postMimeType: json["post_mime_type"],
        commentCount: json["comment_count"] == null
            ? null
            : parseCommentCountJson(json["comment_count"]),
        filter: json["filter"],
        thumbnail: json["thumbnail"] is! String? ? null : json["thumbnail"],
        photo: json["photo"] is! String? ? null : json["photo"],
        meta: json["meta"] == null
            ? null
            : json["meta"] is Map
                ? parseBlogMetaJson(json["meta"])
                : null,
        author:
            json["author"] == null ? null : parseBlogAuthorJson(json["author"]),
        categories: json["categories"] == null
            ? []
            : List<BlogArticleCategory>.from(json["categories"]!
                .map((x) => parseBlogArticleCategoryJson(x))),
        tags: json["tags"] == null
            ? []
            : List<BlogArticleCategory>.from(
                json["tags"]!.map((x) => parseBlogArticleCategoryJson(x))),
      );

  static parseBlogAuthorJson(Map<String, dynamic> json) => BlogAuthor(
        id: json["id"] is int ? "${json["id"]}" :  json["id"],
        name: json["name"],
        avatar: json["avatar"],
      );

  static parseCommentCountJson(Map<String, dynamic> json) => CommentCount(
        approved: json["approved"],
        awaitingModeration: json["awaiting_moderation"],
        spam: json["spam"],
        trash: json["trash"],
        postTrashed: json["post-trashed"],
        all: json["all"],
        totalComments: json["total_comments"],
      );

  static parseBlogMetaJson(Map<String, dynamic> json) => BlogMeta(
        dpOriginal: json["_dp_original"] == null
            ? []
            : List<String>.from(json["_dp_original"]!.map((x) => x)),
        thumbnailId: json["_thumbnail_id"] == null
            ? []
            : List<String>.from(json["_thumbnail_id"]!.map((x) => x)),
        wxrImportHasAttachmentRefs:
            json["_wxr_import_has_attachment_refs"] == null
                ? []
                : List<String>.from(
                    json["_wxr_import_has_attachment_refs"]!.map((x) => x)),
        editLock: json["_edit_lock"] == null
            ? []
            : List<String>.from(json["_edit_lock"]!.map((x) => x)),
        editLast: json["_edit_last"] == null
            ? []
            : List<String>.from(json["_edit_last"]!.map((x) => x)),
        onesignalMetaBoxPresent: json["onesignal_meta_box_present"] == null
            ? []
            : List<String>.from(
                json["onesignal_meta_box_present"]!.map((x) => x)),
        onesignalSendNotification: json["onesignal_send_notification"] == null
            ? []
            : List<String>.from(
                json["onesignal_send_notification"]!.map((x) => x)),
        onesignalModifyTitleAndContent:
            json["onesignal_modify_title_and_content"] == null
                ? []
                : List<String>.from(
                    json["onesignal_modify_title_and_content"]!.map((x) => x)),
        onesignalNotificationCustomHeading:
            json["onesignal_notification_custom_heading"] == null
                ? []
                : List<dynamic>.from(
                    json["onesignal_notification_custom_heading"]!
                        .map((x) => x)),
        onesignalNotificationCustomContent:
            json["onesignal_notification_custom_content"] == null
                ? []
                : List<dynamic>.from(
                    json["onesignal_notification_custom_content"]!
                        .map((x) => x)),
        responseBody: json["response_body"] == null
            ? []
            : List<String>.from(json["response_body"]!.map((x) => x)),
        status: json["status"] == null
            ? []
            : List<String>.from(json["status"]!.map((x) => x)),
        recipients: json["recipients"] == null
            ? []
            : List<String>.from(json["recipients"]!.map((x) => x)),
        wpPageTemplate: json["_wp_page_template"] == null
            ? []
            : List<String>.from(json["_wp_page_template"]!.map((x) => x)),
        rsPageBgColor: json["rs_page_bg_color"] == null
            ? []
            : List<String>.from(json["rs_page_bg_color"]!.map((x) => x)),
        pingme: json["_pingme"] == null
            ? []
            : List<String>.from(json["_pingme"]!.map((x) => x)),
        encloseme: json["_encloseme"] == null
            ? []
            : List<String>.from(json["_encloseme"]!.map((x) => x)),
      );

  static parseBlogArticleCategoryJson(Map<String, dynamic> json) =>
      BlogArticleCategory(
        termId: json["term_id"],
        name: json["name"],
        slug: json["slug"],
        termGroup: json["term_group"],
        termTaxonomyId: json["term_taxonomy_id"],
        taxonomy: json["taxonomy"],
        description: json["description"],
        parent: json["parent"],
        count: json["count"],
        filter: json["filter"],
      );

  static BlogCategoriesData parseBlogCategories(Map<String, dynamic> json) {
    return BlogCategoriesData(
      success: json["success"],
      categoriesList: json["result"] == null
          ? []
          : List<BlogCategory>.from(
              json["result"]!.map((x) => parseSingleBlogCategoryJson(x))),
    );
  }

  static BlogCategory parseSingleBlogCategoryJson(Map<String, dynamic> json) =>
      BlogCategory(
        termId: json["term_id"],
        name: json["name"],
        slug: json["slug"],
        termGroup: json["term_group"],
        termTaxonomyId: json["term_taxonomy_id"],
        taxonomy: json["taxonomy"],
        description: json["description"],
        parent: json["parent"],
        count: json["count"],
        filter: json["filter"],
        catId: json["cat_ID"],
        categoryCount: json["category_count"],
        categoryDescription: json["category_description"],
        catName: json["cat_name"],
        categoryNicename: json["category_nicename"],
        categoryParent: json["category_parent"],
      );

  static BlogTagsData parseBlogTagsResponse(Map<String, dynamic> json) {
    return BlogTagsData(
      success: json["success"],
      tagsList: json["result"] == null
          ? []
          : List<BlogTag>.from(
              json["result"]!.map((x) => parseSingleBlogTagJson(x))),
    );
  }

  static BlogTag parseSingleBlogTagJson(Map<String, dynamic> json) => BlogTag(
        termId: json["term_id"],
        name: json["name"],
        slug: json["slug"],
        termGroup: json["term_group"],
        termTaxonomyId: json["term_taxonomy_id"],
        taxonomy: json["taxonomy"],
        description: json["description"],
        parent: json["parent"],
        count: json["count"],
        filter: json["filter"],
      );

  static BlogCommentsData parseBlogComments(Map<String, dynamic> json) {
    return BlogCommentsData(
      success: json["success"],
      count: json["count"],
      commentsList: json["result"] == null
          ? []
          : List<BlogComment>.from(
              json["result"]!.map((x) => parseSingleBlogCommentJson(x))),
    );
  }

  static BlogComment parseSingleBlogCommentJson(Map<String, dynamic> json) =>
      BlogComment(
        commentId: json["comment_ID"],
        commentPostId: json["comment_post_ID"],
        commentAuthor: json["comment_author"],
        commentAuthorEmail: json["comment_author_email"],
        commentAuthorUrl: json["comment_author_url"],
        commentAuthorIp: json["comment_author_IP"],
        commentDate: json["comment_date"] == null
            ? null
            : DateTime.parse(json["comment_date"]),
        commentDateGmt: json["comment_date_gmt"] == null
            ? null
            : DateTime.parse(json["comment_date_gmt"]),
        commentDateFormatted: json["comment_date_gmt"] == null
            ? null
            : UtilityMethods.getTimeAgoFormat(time: json["comment_date_gmt"]),
        commentContent: json["comment_content"],
        commentKarma: json["comment_karma"],
        commentApproved: json["comment_approved"],
        commentAgent: json["comment_agent"],
        commentType: json["comment_type"],
        commentParent: json["comment_parent"],
        userId: json["user_id"],
        commentAuthorAvatar: json["comment_author_avatar"],
      );

  static AllNotifications parseAllNotificationsJson(Map<String, dynamic> json) {
    AllNotifications allNotifications = AllNotifications(
      success: json["success"],
      notificationsList: json["result"] == null
          ? []
          : List<NotificationItem>.from(
              json["result"]!.map((item) => parseNotificationsItems(item))),
      total: json["total"],
    );

    return allNotifications;
  }

  static NotificationItem parseNotificationsItems(Map<String, dynamic> json) {
    return NotificationItem(
      id: json["ID"],
      title: HtmlUnescape().convert(json["title"]),
      description: HtmlUnescape().convert(json["description"]),
      type: json["type"],
      extraDataMap: json["extra_data"] == null
          ? null
          : parseNotificationsExtraDataMap(json["extra_data"]),
      userEmail: json["user_email"],
      date: json["date"],
      dateInTimeAgoFormat: UtilityMethods.getTimeAgoFormat(time: json["date"]),
    );
  }

  static Map parseNotificationsExtraDataMap(Map<String, dynamic> json) {
    ExtraData extraData = ExtraData(
      type: json["type"],
      searchUrl: json["search_url"],
      listingId: json["listing_id"] is int
          ? json["listing_id"]
          : json["listing_id"] is String
              ? int.parse(json['listing_id'])
              : null,
      listingTitle: json["listing_title"],
      listingUrl: json["listing_url"],
      reviewPostType: json["review_post_type"],
      threadId: json["thread_id"],
      propertyId: json["property_id"],
      propertyTitle: json["property_title"],
      senderId: json["sender_id"],
      senderDisplayName: json["sender_display_name"],
      senderPicture: json["sender_picture"],
      receiverId: json["receiver_id"],
      receiverDisplayName: json["receiver_display_name"],
      receiverPicture: json["receiver_picture"],
    );

    Map extraDataMap = {
      "type": extraData.type,
      "search_url": extraData.searchUrl,
      "listing_id": extraData.listingId,
      "listing_title": extraData.listingTitle,
      "listing_url": extraData.listingUrl,
      "review_post_type": extraData.reviewPostType,
      "thread_id": extraData.threadId,
      "property_id": extraData.propertyId,
      "property_title": extraData.propertyTitle,
      "sender_id": extraData.senderId,
      "sender_display_name": extraData.senderDisplayName,
      "sender_picture": extraData.senderPicture,
      "receiver_id": extraData.receiverId,
      "receiver_display_name": extraData.receiverDisplayName,
      "receiver_picture": extraData.receiverPicture,
    };

    return extraDataMap;
  }

  static CheckNotifications parseCheckNotificationsJson(
      Map<String, dynamic> json) {
    String lastChecked = json["last_checked_notification"] != null &&
            json["last_checked_notification"] is String
        ? json["last_checked_notification"]
        : "";
    return CheckNotifications(
      success: json["success"],
      hasNotification: json["has_notification"],
      numNotification: json["num_notification"],
      lastCheckedNotificationString:
          (lastChecked.isNotEmpty) ? lastChecked : null,
      lastCheckedNotificationDateTime:
          (lastChecked.isNotEmpty) ? DateTime.parse(lastChecked) : null,
    );
  }

  static Threads parseAllThreadsJson(Map<String, dynamic> json) {
    return Threads(
      success: json["success"],
      threadsList: json["results"] == null
          ? []
          : List<ThreadItem>.from(
              json["results"]!.map((item) => parseMessageThreadItem(item))),
    );
  }

  static ThreadItem parseMessageThreadItem(Map<String, dynamic> json) {
    return ThreadItem(
      threadId: json["thread_id"],
      lastMessage: json["last_message"],
      lastMessageAuthorId: json["last_message_author_id"],
      lastMessageAuthorFirstName: json["last_message_author_first_name"],
      lastMessageAuthorLastName: json["last_message_author_last_name"],
      lastMessageAuthorDisplayName: json["last_message_author_display_name"],
      lastMessageTime: json["last_message_time"],
      lastMessageTimeInDateTimeFormat: json["last_message_time"] == null
          ? null
          : DateTime.parse(json["last_message_time"]),
      lastMessageTimeInTimeAgoFormat: json["last_message_time"] == null
          ? null
          : UtilityMethods.getTimeAgoFormat(time: json["last_message_time"]),
      seen: json["seen"],
      time: json["time"],
      timeInDateTimeFormat:
          json["time"] == null ? null : DateTime.parse(json["time"]),
      timeInTimeAgoFormat: json["time"] == null
          ? null
          : UtilityMethods.getTimeAgoFormat(time: json["time"]),
      propertyId: json["property_id"],
      propertyTitle: json["property_title"],
      senderId: json["sender_id"],
      senderFirstName: json["sender_first_name"],
      senderLastName: json["sender_last_name"],
      senderDisplayName: json["sender_display_name"],
      senderPicture: json["sender_picture"],
      senderStatus:
          json["sender_status"] is String ? json["sender_status"] : 'Offline',
      receiverId: json["receiver_id"],
      receiverFirstName: json["receiver_first_name"],
      receiverLastName: json["receiver_last_name"],
      receiverDisplayName: json["receiver_display_name"],
      receiverPicture: json["receiver_picture"],
      receiverStatus: json["receiver_status"] is String
          ? json["receiver_status"]
          : 'Offline',
      senderDelete: json["sender_delete"],
      receiverDelete: json["receiver_delete"],
    );
  }

  static Messages parseAllMessagesJson(Map<String, dynamic> json) {
    return Messages(
      success: json["success"],
      senderStatus:
          json["sender_status"] is String ? json["sender_status"] : 'Offline',
      receiverStatus: json["receiver_status"] is String
          ? json["receiver_status"]
          : 'Offline',
      messagesList: json["results"] == null
          ? []
          : List<MessageItem>.from(
              json["results"]!.map((item) => parseThreadMessageItem(item))),
    );
  }

  static MessageItem parseThreadMessageItem(Map<String, dynamic> json) {
    return MessageItem(
      id: json["id"],
      createdBy: json["created_by"],
      threadId: json["thread_id"],
      message: HtmlUnescape().convert(json["message"]),
      attachments: json["attachments"],
      receiverDelete: json["receiver_delete"],
      senderDelete: json["sender_delete"],
      time: json["time"],
      timeInDateTimeFormat:
          json["time"] == null ? null : DateTime.parse(json["time"]),
      timeInTimeAgoFormat: json["time"] == null
          ? null
          : UtilityMethods.getTimeAgoFormat(time: json["time"]),
      messageTime: json["time"] == null
          ? null
          : DateFormat('hh:mm a').format(DateTime.parse(json["time"])),
      messageDate: json["time"] == null ? null : getDateFormat(json["time"]),
    );
  }

  static String getDateFormat(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    DateTime dt = DateTime(date.year, date.month, date.day);

    if (dt == today) {
      return "Today";
    } else if (dt == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('d MMMM yyyy').format(date);
    }
  }

  static Custom parseCustomFieldsMap(Map<dynamic, dynamic> json) {
    return Custom(
      customFields: json["custom_fields"] == null
          ? []
          : List<CustomField>.from(
              json["custom_fields"].map((item) => parseCustomFieldItem(item))),
    );
  }

  static CustomField parseCustomFieldItem(Map<dynamic, dynamic> json) {
    return CustomField(
      id: json["id"],
      label: json["label"],
      fieldId: json["field_id"],
      type: json["type"],
      options: json["options"],
      fvalues: json["fvalues"],
      isSearch: json["is_search"],
      searchCompare: json["search_compare"],
      placeholder: json["placeholder"],
    );
  }

  static Map<String, dynamic> customFieldDataToJson(Custom custom) {
    return {
      "custom_fields": List<dynamic>.from(
          custom.customFields!.map((item) => customFieldItemToJson(item))),
    };
  }

  static Map<String, dynamic> customFieldItemToJson(CustomField field) {
    return {
      "id": field.id,
      "label": field.label,
      "field_id": field.fieldId,
      "type": field.type,
      "options": field.options,
      "fvalues": field.fvalues,
      "is_search": field.isSearch,
      "search_compare": field.searchCompare,
      "placeholder": field.placeholder,
    };
  }

  static MembershipPlanDetails parseMembershipPlanDetailsFunc(
      Map<String, dynamic> json) {
    return MembershipPlanDetails(
      vcPostSettings: json['_vc_post_settings'] ?? "",
      billingTimeUnit: json['fave_billing_time_unit'] ?? "",
      billingUnit: json['fave_billing_unit'] ?? "",
      packageListings: json['fave_package_listings'] ?? "",
      unlimitedListings: json['fave_unlimited_listings'] ?? "0",
      packageFeaturedListings: json['fave_package_featured_listings'] ?? "",
      packagePrice: json['fave_package_price'] ?? "",
      packageStripeId: json['fave_package_stripe_id'] ?? "",
      packageVisible: json['fave_package_visible'] ?? "",
      packagePopular: json['fave_package_popular'] ?? "",
      unlimitedImages: json['fave_unlimited_images'] ?? "",
      editLock: json['_edit_lock'] ?? "",
      editLast: json['_edit_last'] ?? "",
      androidIAPProductId: json['android_iap_product_id'] ?? "",
      iosIAPProductId: json['ios_iap_product_id'] ?? "",
      rsPageBgColor: json['rs_page_bg_color'] ?? "",
    );
  }

  static BlogDetailsPageLayout parseBlogDetailsPageLayoutJsonFunc(
      Map<dynamic, dynamic> json) {
    return BlogDetailsPageLayout(
      blogDetailPageLayout: json["blog_detail_page_layout"] == null
          ? []
          : List<BlogDetailPageLayout>.from(json["blog_detail_page_layout"]!
              .map((item) => parseBlogDetailPageLayoutItem(item))),
    );
  }

  static BlogDetailPageLayout parseBlogDetailPageLayoutItem(
          Map<String, dynamic> json) =>
      BlogDetailPageLayout(
        widgetType: json["widget_type"],
        widgetTitle: json["widget_title"],
        widgetEnable: json["widget_enable"],
        widgetViewType: json["widget_view_type"],
      );

  static Map<String, dynamic> blogDetailsPageLayoutToJsonFunc(
          BlogDetailsPageLayout layout) =>
      {
        "blog_detail_page_layout": layout == null
            ? []
            : List<dynamic>.from(layout.blogDetailPageLayout!
                .map((item) => convertBlogLayoutItemToJson(item))),
      };

  static Map<String, dynamic> convertBlogLayoutItemToJson(
          BlogDetailPageLayout item) =>
      {
        "widget_type": item.widgetType,
        "widget_title": item.widgetTitle,
        "widget_enable": item.widgetEnable,
        "widget_view_type": item.widgetViewType,
      };

  static HouziFormItem parseFormItemJsonFunc(Map<String, dynamic> json) {
    return HouziFormItem(
      apiKey: json["api_key"],
      enable: json["enable"],
      allowedRoles: json["allowed_roles"] == null
          ? []
          : List<String>.from(json["allowed_roles"]!.map((item) => item)),
      sectionType: json["section_type"],
      termType: json["term_type"],
      title: json["title"],
      hint: json["hint"],
      additionalHint: json["additional_hint"],
      performValidation: json["performValidation"],
      validationType: json["validationType"],
      maxLines: json["maxLines"],
      keyboardType: UtilityMethods.getKeyboardType(json["keyboardType"]),
      fieldValues: json["field_values"] == null
          ? null
          : FieldValues.fromJson(json["field_values"]),
      // fieldValues: getKeyboardType(json["field_values"]),
    );
  }

  static Map<String, dynamic> convertFormItemToJsonFunc(
      HouziFormItem formItem) {
    return {
      "api_key": formItem.apiKey,
      "enable": formItem.enable,
      "allowed_roles": formItem.allowedRoles == null
          ? []
          : List<dynamic>.from(formItem.allowedRoles!.map((item) => item)),
      "section_type": formItem.sectionType,
      "term_type": formItem.termType,
      "title": formItem.title,
      "hint": formItem.hint,
      "additional_hint": formItem.additionalHint,
      "performValidation": formItem.performValidation,
      "validationType": formItem.validationType,
      "maxLines": formItem.maxLines,
      "keyboardType":
          UtilityMethods.getStringKeyboardType(formItem.keyboardType),
      "field_values": FieldValues.toJson(formItem.fieldValues),
    };
  }

  static HouziFormSectionFields parseSectionFieldsJsonFunc(
      Map<String, dynamic> json) {
    return HouziFormSectionFields(
      enable: json["enable"] ?? true,
      section: json["section"],
      fields: json["from_fields"] == null
          ? []
          : List<HouziFormItem>.from(
              json["from_fields"]!.map((item) => parseFormItemJsonFunc(item))),
    );
  }

  static Map<String, dynamic> convertSectionFieldsToJsonFunc(
      HouziFormSectionFields fields) {
    return {
      "enable": fields.enable,
      "section": fields.section,
      "from_fields": fields.fields == null
          ? []
          : List<dynamic>.from(
              fields.fields!.map((item) => convertFormItemToJsonFunc(item))),
    };
  }

  static HouziFormPage parseFormPageJsonFunc(Map<String, dynamic> json) {
    return HouziFormPage(
      enable: json["enable"] ?? true,
      title: json["title"],
      allowedRoles: json["allowed_roles"] == null
          ? []
          : List<String>.from(json["allowed_roles"]!.map((item) => item)),
      pageFields: json["page_fields"] == null
          ? []
          : List<HouziFormSectionFields>.from(json["page_fields"]!
              .map((item) => parseSectionFieldsJsonFunc(item))),
    );
  }

  static Map<String, dynamic> convertFormPageToJsonFunc(
      HouziFormPage formPage) {
    return {
      "enable": formPage.enable,
      "title": formPage.title,
      "allowed_roles": formPage.allowedRoles == null
          ? []
          : List<dynamic>.from(formPage.allowedRoles!.map((item) => item)),
      "page_fields": formPage.pageFields == null
          ? []
          : List<dynamic>.from(formPage.pageFields!
              .map((item) => convertSectionFieldsToJsonFunc(item))),
    };
  }

  static DrawerLayoutConfig parseDrawerLayoutConfigJsonFunc(
      Map<dynamic, dynamic> json) {
    return DrawerLayoutConfig(
      drawerLayout: List<DrawerLayout>.from(json["drawer_layout"]
          .map((item) => parseDrawerLayoutItemJsonFunc(item))),
    );
  }

  static Map<String, dynamic> convertDrawerLayoutConfigToJsonFunc(
      DrawerLayoutConfig config) {
    return {
      "drawer_layout": List<dynamic>.from(config.drawerLayout!
          .map((item) => convertDrawerLayoutItemToJsonFunc(item))),
    };
  }

  static DrawerLayout parseDrawerLayoutItemJsonFunc(
          Map<String, dynamic> json) =>
      DrawerLayout(
        sectionType: json["section_type"],
        title: json["title"],
        checkLogin: json["check_login"],
        enable: json["enable"],
        expansionTileChildren: json["expansion_tile_children"] == null
            ? null
            : List<ExpansionTileChild>.from(json["expansion_tile_children"]
                .map((item) => parseExpansionTileChildJsonFunc(item))),
        dataMap: json["data_map"],
      );

  static Map<String, dynamic> convertDrawerLayoutItemToJsonFunc(
          DrawerLayout layoutItem) =>
      {
        "section_type": layoutItem.sectionType,
        "title": layoutItem.title,
        "check_login": layoutItem.checkLogin,
        "enable": layoutItem.enable,
        "expansion_tile_children": layoutItem.expansionTileChildren == null
            ? null
            : List<dynamic>.from(layoutItem.expansionTileChildren!
                .map((item) => convertExpansionTileChildToJson(item))),
        "data_map": layoutItem.dataMap,
      };

  static ExpansionTileChild parseExpansionTileChildJsonFunc(
          Map<String, dynamic> json) =>
      ExpansionTileChild(
        sectionType: json["section_type"],
        title: json["title"],
        checkLogin: json["check_login"],
      );

  static Map<String, dynamic> convertExpansionTileChildToJson(
          ExpansionTileChild item) =>
      {
        "section_type": item.sectionType,
        "title": item.title,
        "check_login": item.checkLogin,
      };

  static FilterPageElement parseFilterPageElementJsonFunc(
      Map<String, dynamic> json) {
    return FilterPageElement(
      sectionType: json["section_type"],
      title: json["title"],
      dataType: json["data_type"],
      apiValue: json["api_value"],
      pickerType: json["picker_type"],
      showSearchByCity: json["show_search_by_city"],
      showSearchByLocation: json["show_search_by_location"],
      minValue: json["min_range_value"],
      maxValue: json["max_range_value"],
      pickerSubType: json["picker_sub_type"],
      divisions: json["div_range_value"] ?? "1000",
      options: json["options"],
      uniqueKey: json["unique_key"],
      queryType: json["query_type"],
      defaultRadius: json["default_radius"],
      locationPickerHierarchyList: json["location_hierarchy_list"] == null
          ? []
          : List<String>.from(
              json["location_hierarchy_list"]!.map((item) => item)),
    );
  }

  static Map<String, dynamic> convertFilterPageElementToMapFunc(
      FilterPageElement filterPageElement) {
    return {
      "section_type": filterPageElement.sectionType,
      "title": filterPageElement.title,
      "data_type": filterPageElement.dataType,
      "api_value": filterPageElement.apiValue,
      "picker_type": filterPageElement.pickerType,
      "show_search_by_city": filterPageElement.showSearchByCity,
      "show_search_by_location": filterPageElement.showSearchByLocation,
      "min_range_value": filterPageElement.minValue,
      "max_range_value": filterPageElement.maxValue,
      "picker_sub_type": filterPageElement.pickerSubType,
      "div_range_value": filterPageElement.divisions,
      "options": filterPageElement.options,
      "unique_key": filterPageElement.uniqueKey,
      "query_type": filterPageElement.queryType,
      "default_radius": filterPageElement.defaultRadius,
      "location_hierarchy_list":
          filterPageElement.locationPickerHierarchyList == null
              ? []
              : List<dynamic>.from(filterPageElement
                  .locationPickerHierarchyList!
                  .map((item) => item)),
    };
  }

  static HomeConfig parseHomeConfigJsonFunc(Map<dynamic, dynamic> json) {
    return HomeConfig(
      homeLayout: List<HomeLayout>.from(
          json["home_layout"].map((x) => parseHomeLayoutJsonFunc(x))),
    );
  }

  static Map<String, dynamic> convertHomeConfigToJsonFunc(HomeConfig item) => {
        "home_layout": List<dynamic>.from(
            item.homeLayout!.map((x) => convertHomeLayoutToJsonFunc(x))),
      };

  static HomeLayout parseHomeLayoutJsonFunc(Map<String, dynamic> json) {
    return HomeLayout(
      sectionType: json["section_type"],
      title: json["title"],
      layoutDesign: json["layout_design"],
      subType: json["sub_type"],
      subTypeValue: json["sub_type_value"],
      sectionListingView: json["section_listing_view"],
      showFeatured: json["show_featured"] ?? false,
      showNearby: json["show_nearby"] ?? false,
      subTypeList: json["sub_type_list"],
      subTypeValuesList: json["sub_type_value_list"],
      searchApiMap: json["search_api_map"] is Map<String, dynamic>
          ? json["search_api_map"]
          : {},
      searchRouteMap: json["search_route_map"] is Map<String, dynamic>
          ? json["search_route_map"]
          : {},
      termsWithIconLayout: json["terms_with_icon_layout"] == null
          ? []
          : (json["terms_with_icon_layout"])
              .map<TermsWithIcon>((item) => parseTermsWithIconJsonFunc(item))
              .toList(),
    );
  }

  static Map<String, dynamic> convertHomeLayoutToJsonFunc(HomeLayout item) => {
        "section_type": item.sectionType,
        "title": item.title,
        "layout_design": item.layoutDesign,
        "sub_type": item.subType,
        "sub_type_value": item.subTypeValue,
        "section_listing_view": item.sectionListingView,
        "show_featured": item.showFeatured,
        "show_nearby": item.showNearby,
        "sub_type_list": item.subTypeList,
        "sub_type_value_list": item.subTypeValuesList,
        "search_api_map": item.searchApiMap,
        "search_route_map": item.searchRouteMap,
        "terms_with_icon_layout": item.termsWithIconLayout == null
            ? []
            : item.termsWithIconLayout!
                .map<Map<String, dynamic>>(
                    (item) => convertTermsWithIconToJsonFunc(item))
                .toList(),
      };

  static TermsWithIcon parseTermsWithIconJsonFunc(Map<String, dynamic> json) {
    return TermsWithIcon(
      title: json["title"],
      icon: json["icon_data"],
      term: json["term"],
      subTerm: json["sub_term"],
      searchRouteMap: json["search_route_map"] is Map<String, dynamic>
          ? json["search_route_map"]
          : {},
    );
  }

  static Map<String, dynamic> convertTermsWithIconToJsonFunc(
          TermsWithIcon item) =>
      {
        "title": item.title,
        "term": item.term,
        "sub_term": item.subTerm,
        "icon_data": item.icon,
        "search_route_map": item.searchRouteMap,
      };

  static NavBar parseNavBarJsonFunc(Map<dynamic, dynamic> json) => NavBar(
        navbarLayout: json["bottom_navigation_bar_layout"] == null
            ? []
            : List<NavbarItem>.from(json["bottom_navigation_bar_layout"]!
                .map((x) => parseNavbarItemJsonFunc(x))),
      );

  static Map<String, dynamic> convertNavBarToJsonFunc(NavBar item) => {
        "bottom_navigation_bar_layout": item.navbarLayout == null
            ? []
            : List<dynamic>.from(
                item.navbarLayout!.map((x) => convertNavbarItemToJsonFunc(x))),
      };

  static NavbarItem parseNavbarItemJsonFunc(Map<String, dynamic> json) {
    return NavbarItem(
      sectionType: json["section_type"],
      title: json["title"],
      url: json["url"],
      checkLogin: json["check_login"],
      subTypeList: json["sub_type_list"] is List
          ? List<String>.from(json["sub_type_list"])
          : null,
      subTypeValuesList: json["sub_type_value_list"] is List
          ? List<String>.from(json["sub_type_value_list"])
          : null,
      iconDataJson: json["icon_data"],
      searchApiMap: json["search_api_map"] is Map<String, dynamic>
          ? json["search_api_map"]
          : {},
    );
  }

  static Map<String, dynamic> convertNavbarItemToJsonFunc(
          NavbarItem navbarItem) =>
      {
        'section_type': navbarItem.sectionType,
        'title': navbarItem.title,
        'url': navbarItem.url,
        'check_login': navbarItem.checkLogin,
        'sub_type_list': navbarItem.subTypeList,
        'sub_type_value_list': navbarItem.subTypeValuesList,
        "search_api_map": navbarItem.searchApiMap,
        "icon_data": navbarItem.iconDataJson,
      };

  static PropertyDetailPageLayout parsePropertyDetailPageLayoutJsonFunc(
          Map<dynamic, dynamic> json) =>
      PropertyDetailPageLayout(
        propertyDetailPageLayout: List<PropertyDetailPageLayoutElement>.from(
            json["property_detail_page_layout"]
                .map((x) => parsePropertyDetailPageLayoutElementJsonFunc(x))),
      );

  static Map<String, dynamic> convertPropertyDetailPageLayoutToJsonFunc(
          PropertyDetailPageLayout item) =>
      {
        "property_detail_page_layout": List<dynamic>.from(item
            .propertyDetailPageLayout!
            .map((x) => convertPropertyDetailPageLayoutElementToJsonFunc(x))),
      };

  static PropertyDetailPageLayoutElement
      parsePropertyDetailPageLayoutElementJsonFunc(Map<String, dynamic> json) =>
          PropertyDetailPageLayoutElement(
            widgetType: json["widget_type"],
            widgetTitle: json["widget_title"],
            widgetEnable: json["widget_enable"],
            widgetViewType: json["widget_view_type"],
          );

  static Map<String, dynamic> convertPropertyDetailPageLayoutElementToJsonFunc(
          PropertyDetailPageLayoutElement item) =>
      {
        "widget_type": item.widgetType,
        "widget_title": item.widgetTitle,
        "widget_enable": item.widgetEnable,
        "widget_view_type": item.widgetViewType,
      };

  static SortFirstBy parseSortFirstByJsonFunc(Map<dynamic, dynamic> json) =>
      SortFirstBy(
        sortFirstBy: json["sort_first_by"] == null
            ? []
            : List<SortFirstByItem>.from(json["sort_first_by"]!
                .map((x) => parseSortFirstByItemJsonFunc(x))),
      );

  static Map<String, dynamic> convertSortFirstByToJsonFunc(SortFirstBy item) =>
      {
        "sort_first_by": item.sortFirstBy == null
            ? []
            : List<dynamic>.from(item.sortFirstBy!
                .map((x) => convertSortFirstByItemToJsonFunc(x))),
      };

  static SortFirstByItem parseSortFirstByItemJsonFunc(
          Map<String, dynamic> json) =>
      SortFirstByItem(
        sectionType: json["section_type"],
        title: json["title"],
        defaultValue: json["default_value"],
        icon: json["icon_data"],
        term: json["term"],
        subTerm: json["sub_term"],
      );

  static Map<String, dynamic> convertSortFirstByItemToJsonFunc(
          SortFirstByItem item) =>
      {
        "section_type": item.sectionType,
        "title": item.title,
        "default_value": item.defaultValue,
        "icon_data": item.icon,
        "term": item.term,
        "sub_term": item.subTerm,
      };

  static Agent parseAgentFromJsonFunc(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      slug: json['slug'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      totalRating: json['totalRating'],
      thumbnail: json['thumbnail'],
      agentPosition: json['agentPosition'],
      agentCompany: json['agentCompany'],
      agentMobileNumber: json['agentMobileNumber'],
      agentOfficeNumber: json['agentOfficeNumber'],
      agentFaxNumber: json['agentFaxNumber'],
      email: json['email'],
      agentAddress: json['agentAddress'],
      agentTaxNumber: json['agentTaxNumber'],
      agentLicenseNumber: json['agentLicenseNumber'],
      agentAgencies: List<String>.from(json['agentAgencies']),
      agentServiceArea: json['agentServiceArea'],
      agentSpecialties: json['agentSpecialties'],
      telegram: json['telegram'],
      lineApp: json['lineApp'],
    );
  }

  static Map<String, dynamic> convertAgentToMapFunc(Agent agent) => {
        'id': agent.id,
        'slug': agent.slug,
        'type': agent.type,
        'title': agent.title,
        'content': agent.content,
        'totalRating': agent.totalRating,
        'thumbnail': agent.thumbnail,
        'agentPosition': agent.agentPosition,
        'agentCompany': agent.agentCompany,
        'agentMobileNumber': agent.agentMobileNumber,
        'agentOfficeNumber': agent.agentOfficeNumber,
        'agentFaxNumber': agent.agentFaxNumber,
        'email': agent.email,
        'agentAddress': agent.agentAddress,
        'agentTaxNumber': agent.agentTaxNumber,
        'agentLicenseNumber': agent.agentLicenseNumber,
        'agentAgencies': agent.agentAgencies,
        'agentServiceArea': agent.agentServiceArea,
        'agentSpecialties': agent.agentSpecialties,
        'telegram': agent.telegram,
        'lineApp': agent.lineApp,
      };

  static Agency parseAgencyJsonFunc(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      slug: json['slug'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      thumbnail: json['thumbnail'],
      agencyFaxNumber: json['agencyFaxNumber'],
      agencyLicenseNumber: json['agencyLicenseNumber'],
      agencyMobileNumber: json['agencyMobileNumber'],
      agencyPhoneNumber: json['agencyPhoneNumber'],
      email: json['email'],
      agencyAddress: json['agencyAddress'],
      agencyMapAddress: json['agencyMapAddress'],
      agencyLocation: json['agencyLocation'],
      agencyTaxNumber: json['agencyTaxNumber'],
      telegram: json['telegram'],
      lineApp: json['lineApp'],
    );
  }

  static Map<String, dynamic> convertAgencyToMapFunc(Agency agency) => {
        'id': agency.id,
        'slug': agency.slug,
        'type': agency.type,
        'title': agency.title,
        'content': agency.content,
        'thumbnail': agency.thumbnail,
        'agencyMobileNumber': agency.agencyMobileNumber,
        'agencyPhoneNumber': agency.agencyPhoneNumber,
        'agencyFaxNumber': agency.agencyFaxNumber,
        'email': agency.email,
        'agencyAddress': agency.agencyAddress,
        'agencyTaxNumber': agency.agencyTaxNumber,
        'agencyLicenseNumber': agency.agencyLicenseNumber,
        'agencyMapAddress': agency.agencyMapAddress,
        'agencyLocation': agency.agencyLocation,
        'telegram': agency.telegram,
        'lineApp': agency.lineApp,
      };

  static Term parseTermJsonFunc(Map<String, dynamic> json) {
    return Term(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      parent: json['parent'],
      thumbnail: json['thumbnail'],
      taxonomy: json['taxonomy'],
      fullImage: json['fullImage'],
      totalPropertiesCount: json['totalPropertiesCount'],
      parentTerm: json['fave_parent_term'],
    );
  }
  static Views parseViewsJsonFunc(Map<String, dynamic> json) {
    return Views(
      period: json['period'],
      count: json['count'],
      percentage: json['percentage'],
      );
  }
  static TopInsightsMetaData parseInsightJsonFunc(Map<String, dynamic> json) {
    return TopInsightsMetaData(
      name: json['name'],
      count: json['count'],
    );
  }

  static Map<String, dynamic> convertTermToMapFunc(Term item) => {
        'id': item.id,
        'name': item.name,
        'slug': item.slug,
        'parent': item.parent,
        'thumbnail': item.thumbnail,
        'fullImage': item.fullImage,
        'taxonomy': item.taxonomy,
        'totalPropertiesCount': item.totalPropertiesCount,
        'fave_parent_term': item.parentTerm,
      };

   static Map<String, dynamic> convertViewsToMapFunc(Views item) => {
        'period': item.period,
        'count': item.count,
        'percentage': item.percentage,
      };

   static Map<String, dynamic> convertInsightsToMapFunc(TopInsightsMetaData item) => {
        'name': item.name,
        'count': item.count,
      };

  static AddOrUpdateListing parseAddOrUpdateListingJsonFunc(
      Map<String, dynamic> json) {
    return AddOrUpdateListing(
      propId: json["prop_id"],
    );
  }

  static Map<String, dynamic> convertAddOrUpdateListingToJsonFunc(
          AddOrUpdateListing item) =>
      {
        "prop_id": item.propId,
      };
  static InsightsChartEntry fromJson(Map<String, dynamic> json) {
    return InsightsChartEntry(
      date: json['date'] ?? '',
      label: json['label'] ?? '',
      views: (json['views'] is String)
          ? int.tryParse(json['views']) ?? 0
          : (json['views'] ?? 0),
      uniqueViews: (json['unique_views'] is String)
          ? int.tryParse(json['unique_views']) ?? 0
          : (json['unique_views'] ?? 0),
    );
  }
  
  static List<InsightsChartEntry> parseInsightsChartEntries(Map<String, dynamic>? chartsMap) {
    if (chartsMap == null) return [];
    final List<InsightsChartEntry> entries = [];
    chartsMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        entries.add(fromJson(value));
      }
    });
    // Sort by date ascending if possible
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }


  static UserLoginInfo parseUserLoginInfoJsonFunc(Map<String, dynamic> json) =>
      UserLoginInfo(
        token: json["token"],
        userEmail: json["user_email"],
        userNiceName: json["user_nicename"],
        userDisplayName: json["user_display_name"],
        userId: json["user_id"],
        userRole: json["user_role"] == null
            ? []
            : List<String>.from(json["user_role"]!.map((x) => x)),
        avatar: json["avatar"],
      );

  static Map<String, dynamic> convertUserLoginInfoToJsonFunc(
          UserLoginInfo item) =>
      {
        "token": item.token,
        "user_email": item.userEmail,
        "user_nicename": item.userNiceName,
        "user_display_name": item.userDisplayName,
        "user_id": item.userId,
        "user_role": item.userRole == null
            ? []
            : List<dynamic>.from(item.userRole!.map((x) => x)),
        "avatar": item.avatar,
      };

  static IsFavourite parseIsFavouriteJsonFunc(Map<String, dynamic> json) =>
      IsFavourite(
        success: json["success"],
        isFav: json["is_fav"],
      );

  static Map<String, dynamic> convertIsFavouriteToJsonFunc(IsFavourite item) =>
      {
        "success": item.success,
        "is_fav": item.isFav,
      };

  static UserPaymentStatus parseUserPaymentStatusJsonFunc(
          Map<String, dynamic> json) =>
      UserPaymentStatus(
        enablePaidSubmission: json["enable_paid_submission"],
        remainingListings: json["remaining_listings"],
        featuredRemainingListings: json["featured_remaining_listings"],
        paymentPage: json["payment_page"],
        userHasMembership: json["user_has_membership"],
        userHadFreePackage: json["user_had_free_package"],
      );
  
  static UserApprovalStatus parseUserApprovalStatusJsonFunc(
          Map<String, dynamic> json) =>
      UserApprovalStatus(
        userId: json["user_id"],
        message: json["message"],
        newStatus: json["new_status"],
        success: json["success"],
      );
  static ReviewApprovalModel parseReviewApprovalModelJsonFunc(
          Map<String, dynamic> json) =>
      ReviewApprovalModel(
        reviewId: json["review_id"],
        message: json["message"],
        action: json["action"],
        success: json["success"],
      );
  static ApprovalStatuesList parseUserApprovalStatusesItem(dynamic json) {
  return ApprovalStatuesList(
    description: json["description"] as String? ?? '',
    label: json["label"] as String? ?? '',
    status: json["status"] as String? ?? '',
    isActionable: json["is_actionable"] as bool? ?? false,
    status_code: json["status_code"] as int? ?? 0,
  );
}
  

  static Map<String, dynamic> convertUserPaymentStatusToJsonFunc(
          UserPaymentStatus item) =>
      {
        "enable_paid_submission": item.enablePaidSubmission,
        "remaining_listings": item.remainingListings,
        "featured_remaining_listings": item.featuredRemainingListings,
        "payment_page": item.paymentPage,
        "user_has_membership": item.userHasMembership,
        "user_had_free_package": item.userHadFreePackage,
      };
}
