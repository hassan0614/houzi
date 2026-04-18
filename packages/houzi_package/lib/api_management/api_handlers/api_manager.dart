import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houzi_package/api_management/api_sources/api_houzez.dart';
import 'package:houzi_package/api_management/api_utilities/api_utilities.dart';
import 'package:houzi_package/api_management/interfaces/api_interface.dart';
import 'package:houzi_package/common/constants.dart';
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
import 'package:houzi_package/models/home_related/home_config.dart';
import 'package:houzi_package/models/home_related/terms_with_icon.dart';
import 'package:houzi_package/models/insights_model/top_insights_meta_data.dart';
import 'package:houzi_package/models/insights_model/views.dart';
import 'package:houzi_package/models/listing_related/add_update_listing.dart';
import 'package:houzi_package/models/listing_related/is_favorite.dart';
import 'package:houzi_package/models/messages/messages.dart';
import 'package:houzi_package/models/messages/threads.dart';
import 'package:houzi_package/models/navbar/navbar_item.dart';
import 'package:houzi_package/models/notifications/check_notifications.dart';
import 'package:houzi_package/models/notifications/notifications.dart';
import 'package:houzi_package/models/property_details/property_detail_page_config.dart';
import 'package:houzi_package/models/search/sort_first_by_item.dart';
import 'package:houzi_package/models/term.dart';
import 'package:houzi_package/models/user/user_login_info.dart';
import 'package:houzi_package/models/user/user_membership_package.dart';
import 'package:houzi_package/models/user/user_payment_status.dart';

class ApiManager {
  // final WebsiteApiServices webApiServices = ApiEPL();
  final WebsiteApiServices webApiServices = ApiHouzez();

  final ApiUtilities apiUtilities = ApiUtilities();

  Future<ApiResponse<List>> fetchFeaturedArticles(
      {int? page, int? perPage}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> featuredArticles = [];

    ApiRequest request =
        webApiServices.featuredPropertiesApi(page: page, perPage: perPage);
    request.tag = FeaturedListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: FeaturedListingTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      featuredArticles = webApiServices.getParser().parseApi(request, response);

      if ((featuredArticles.isNotEmpty) &&
          ((featuredArticles[0] == null) ||
              (featuredArticles[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        featuredArticles = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: featuredArticles);
  }

  Future<ApiResponse<List>> fetchLatestArticles(
      {int? page, int? perPage}) async {
    List<dynamic> latestArticles = [];
    String message = "";
    bool success = false, internet = true;

    ApiRequest request =
        webApiServices.latestPropertiesApi(page: page, perPage: perPage);
    request.tag = LatestListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: LatestListingTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      latestArticles = webApiServices.getParser().parseApi(request, response);

      if ((latestArticles.isNotEmpty) &&
          ((latestArticles[0] == null) ||
              (latestArticles[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        latestArticles = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: latestArticles);
  }

  Future<ApiResponse<List>> fetchFilteredArticles(
      {required Map<String, dynamic> params}) async {
    List<dynamic> filteredArticles = [];
    int? count;
    String message = "";
    bool success = false, internet = true;

    ApiRequest request = webApiServices.filteredPropertiesApi(params: params);
    request.tag = FilteredListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: FilteredListingTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      ({int? count, List listings}) parsedData =
          webApiServices.getParser().parseApi(request, response);
      count = parsedData.count;
      filteredArticles = parsedData.listings;

      if ((filteredArticles.isNotEmpty) &&
          ((filteredArticles[0] == null) ||
              (filteredArticles[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: filteredArticles,
        count: count);
  }

  Future<ApiResponse<List>> fetchSimilarArticles(int propertyId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> similarArticles = [];

    ApiRequest request = webApiServices.similarPropertiesApi(propertyId);
    request.tag = SimilarListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: SimilarListingTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      similarArticles = webApiServices.getParser().parseApi(request, response);

      if ((similarArticles.isNotEmpty) &&
          ((similarArticles[0] == null) ||
              (similarArticles[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        similarArticles = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: similarArticles);
  }

  Future<ApiResponse<List>> fetchMultipleArticles(String propertiesId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> multipleArticles = [];

    ApiRequest request = webApiServices.multiplePropertiesApi(propertiesId);
    request.tag = MultipleListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: MultipleListingTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      multipleArticles = webApiServices.getParser().parseApi(request, response);

      if ((multipleArticles.isNotEmpty) &&
          ((multipleArticles[0] == null) ||
              (multipleArticles[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        multipleArticles = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: multipleArticles);
  }

  Future<ApiResponse<List>> fetchSingleArticle(int id,
      {bool forEditing = false}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> singleArticle = [];

    ApiRequest request =
        webApiServices.singlePropertyApi(id, forEditing: forEditing);
    request.tag = SingleListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: SingleListingTag,
    );

    if (response.data != null &&
        response.data is Map &&
        ((response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified))) {
      success = true;
      singleArticle = webApiServices.getParser().parseApi(request, response);

      if ((singleArticle.isNotEmpty) &&
          ((singleArticle[0] == null) ||
              (singleArticle[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        singleArticle = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: singleArticle);
  }

  Future<ApiResponse<List>> fetchSingleArticleViaPermaLink(
      String permaLink) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> singleArticle = [];

    ApiRequest request = webApiServices.singleArticleViaPermaLinkApi(permaLink);
    request.tag = SingleListingViaPermaLinkTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: SingleListingViaPermaLinkTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      singleArticle = webApiServices.getParser().parseApi(request, response);

      if ((singleArticle.isNotEmpty) &&
          ((singleArticle[0] == null) ||
              (singleArticle[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        singleArticle = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: singleArticle);
  }

  Future<ApiResponse<Map<String,dynamic>>> fetchMultiCurrencies() async {
    String message = "";
    bool success = false, internet = true;
    Map<String,dynamic> multiCurrencies = {};

    ApiRequest request = webApiServices.touchBaseApi();
    request.tag = MultiCurrenciesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      tag: MultiCurrenciesTag,
      handle500: request.handle500,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      multiCurrencies = webApiServices.getParser().parseApi(request, response);
      print("Multicurencies: $multiCurrencies");

    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        multiCurrencies["response"] = response;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: multiCurrencies);
  }




  Future<ApiResponse<Map<String, dynamic>>> touchBase() async {
    String message = "";
    bool success = false, internet = true;
    Map<String, dynamic> touchBaseData = {};

    ApiRequest request = webApiServices.touchBaseApi();
    request.tag = TouchBaseInfoTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      tag: TouchBaseInfoTag,
      handle500: request.handle500,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      touchBaseData = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        touchBaseData["response"] = response;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: touchBaseData);
  }

  Future<ApiResponse<List>> singleAgency(int id) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> singleAgencyDetails = [];

    ApiRequest request = webApiServices.provideSingleAgencyApi(id);
    request.tag = SingleAgencyTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      tag: SingleAgencyTag,
      handle500: request.handle500,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      singleAgencyDetails =
          webApiServices.getParser().parseApi(request, response);

      if ((singleAgencyDetails.isNotEmpty) &&
          ((singleAgencyDetails[0] == null) ||
              (singleAgencyDetails[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        singleAgencyDetails = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: singleAgencyDetails);
  }

  Future<ApiResponse<List>> singleAgent(int id) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> singleAgentDetails = [];

    ApiRequest request = webApiServices.provideSingleAgentApi(id);
    request.tag = SingleAgentTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      tag: SingleAgentTag,
      handle500: request.handle500,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      singleAgentDetails =
          webApiServices.getParser().parseApi(request, response);

      if ((singleAgentDetails.isNotEmpty) &&
          ((singleAgentDetails[0] == null) ||
              (singleAgentDetails[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        singleAgentDetails = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: singleAgentDetails);
  }

  Future<ApiResponse<List>> fetchAgentOfAnAgency(int id) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> agentsOfAgency = [];

    ApiRequest request = webApiServices.provideAgentsOfAgencyApi(id);
    request.tag = AgentsOfAgencyInfoTag;

    final response = await apiUtilities.doRequestOnRoute(request.uri,
        tag: AgentsOfAgencyInfoTag);

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      agentsOfAgency = webApiServices.getParser().parseApi(request, response);

      if ((agentsOfAgency.isNotEmpty) &&
          ((agentsOfAgency[0] == null) ||
              (agentsOfAgency[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        agentsOfAgency = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: agentsOfAgency);
  }

  Future<ApiResponse<List>> fetchAllAgents(int page, int perPage, bool? visibilityOnly) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> allAgents = [];

    ApiRequest request = webApiServices.provideAllAgentsApi(page, perPage, visibilityOnly );
    request.tag = AllAgentsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      tag: AllAgentsTag,
      handle500: request.handle500,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      allAgents = webApiServices.getParser().parseApi(request, response);

      if ((allAgents.isNotEmpty) &&
          ((allAgents[0] == null) || (allAgents[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        allAgents = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: allAgents);
  }

  Future<ApiResponse<List>> fetchAllAgencies(int page, int perPage, bool? visibilityOnly) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> allAgencies = [];

    ApiRequest request = webApiServices.provideAllAgenciesApi(page, perPage, visibilityOnly);
    request.tag = AllAgenciesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      tag: AllAgenciesTag,
      handle500: request.handle500,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      allAgencies = webApiServices.getParser().parseApi(request, response);

      if ((allAgencies.isNotEmpty) &&
          ((allAgencies[0] == null) ||
              (allAgencies[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        allAgencies = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: allAgencies);
  }

  Future<ApiResponse<List>> fetchListingsByCity(
      int id, int page, int perPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> listings = [];

    ApiRequest request =
        webApiServices.provideListingsByCityApi(id, page, perPage);
    request.tag = ListingByCityTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: ListingByCityTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      listings = webApiServices.getParser().parseApi(request, response);

      if ((listings.isNotEmpty) &&
          ((listings[0] == null) || (listings[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        listings = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: listings);
  }

  Future<ApiResponse<String>> contactPropertyRealtor(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request =
        webApiServices.provideContactPropertyRealtorApi(params, nonce);
    request.tag = ContactRealtorTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: ContactRealtorTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> contactRealtor(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideContactRealtorApi(params, nonce);
    request.tag = ContactRealtorTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: ContactRealtorTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> contactDeveloper(
      Map<String, dynamic> params) async {
    String message = "", result = "";
    bool success = false, internet = true;

    ApiRequest request = webApiServices.provideContactDeveloperApi(params);
    request.tag = ContactDeveloperTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: ContactDeveloperTag,
    );

    if (response.statusCode == HttpStatus.ok) {
      success = true;
      message = "message_sent_successfully";
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = "message_failed_to_send";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: result);
  }

  Future<ApiResponse<String>> scheduleATour(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideScheduleATourApi(params, nonce);
    request.tag = ScheduleATourTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: ScheduleATourTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<AddOrUpdateListing?>> addNewListing(
      Map<String, dynamic> params, String nonce) async {
    String message = "";
    bool success = false, internet = true;
    AddOrUpdateListing? addNewListing;

    ApiRequest request = webApiServices.provideAddNewListingApi(params, nonce);
    request.tag = AddNewListingTag;

    final response = await apiUtilities.doRequestOnRoute(request.uri,
        type: POST,
        formParams: request.formParams,
        handle500: request.handle500,
        tag: AddNewListingTag);

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok)) {
      success = true;
      addNewListing = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: addNewListing);
  }

  Future<ApiResponse<AddOrUpdateListing?>> updateListing(
      Map<String, dynamic> params, String nonce) async {
    String message = "";
    bool success = false, internet = true;
    AddOrUpdateListing? updateListing;

    ApiRequest request = webApiServices.provideUpdateListingApi(params, nonce);
    request.tag = UpdateListingTag;

    final response = await apiUtilities.doRequestOnRoute(request.uri,
        type: POST,
        formParams: request.formParams,
        handle500: request.handle500,
        tag: UpdateListingTag);

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok)) {
      success = true;
      updateListing = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: updateListing);
  }

  ApiRequest uploadListingImagesApi(
      {required String userToken,
      required String userId,
      required String nonce}) {
    ApiRequest request = webApiServices.provideUploadListingImagesApi(
        userToken: userToken, userId: userId, nonce: nonce);
    return request;
  }

  Future<ApiResponse<UserLoginInfo?>> login(
      Map<String, dynamic> params, String nonce) async {
    String message = "";
    bool success = false, internet = true;
    UserLoginInfo? userLoginInfo;

    ApiRequest request = webApiServices.provideLoginApi(params, nonce);
    request.tag = LoginTag;

    Dio dio = Dio();
    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      dio: dio,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      handle403: false,
      tag: LoginTag,
    );

    if (response.data != null && response.data is Map) {
      if (response.statusCode == HttpStatus.ok) {
        success = true;
        userLoginInfo = webApiServices.getParser().parseApi(request, response);
      } else {
        ApiResponse<String> apiResponse =
            webApiServices.getParser().parseApi(request, response);
        message = apiResponse.message;
        success = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: userLoginInfo);
  }

  Future<ApiResponse<String>> signUp(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideSignUpApi(params, nonce);
    request.tag = SignUpTag;

    Dio dio = Dio();
    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      dio: dio,
      type: POST,
      formParams: request.formParams,
      handle403: false,
      handle500: request.handle500,
      tag: SignUpTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> adminUserSignUp(
      Map<String, dynamic> params, String userToken, String nonce) async {
    ApiRequest request =
        webApiServices.provideAdminUserSignUpApi(params, userToken, nonce);
    request.tag = AdminUserSignUpTag;

    late Dio dio;
    Map<String, dynamic> headerMap = request.headers ?? {};

    if (headerMap.isNotEmpty) {
      dio = Dio()..options.headers = headerMap;
    } else {
      dio = Dio();
    }

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      dio: dio,
      type: POST,
      formParams: request.formParams,
      handle403: false,
      handle500: request.handle500,
      tag: AdminUserSignUpTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> forgotPassword(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideForgotPasswordApi(params, nonce);
    request.tag = ForgotPasswordTag;

    Dio dio = Dio();

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      dio: dio,
      type: POST,
      formParams: request.formParams,
      handle403: false,
      handle500: request.handle500,
      tag: ForgotPasswordTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> allPropertiesListing(
      String status, int page, int perPage, int? userId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> listings = [];

    ApiRequest request =
        webApiServices.provideAllPropertiesApi(status, page, perPage, userId);
    request.tag = AllPropertiesListingTag;

    final response = await apiUtilities.doRequestOnRoute(request.uri,
        tag: AllPropertiesListingTag, handle500: request.handle500);

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      listings = webApiServices.getParser().parseApi(request, response);

      if ((listings.isNotEmpty) &&
          ((listings[0] == null) || (listings[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        listings = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: listings);
  }

  Future<ApiResponse<List>> myListings(
      String status, int page, int perPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> listings = [];

    ApiRequest request =
        webApiServices.provideMyListingsApi(status, page, perPage);
    request.tag = MyListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      forceExcludeCache: true,
      handle500: request.handle500,
      tag: MyListingTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      listings = webApiServices.getParser().parseApi(request, response);

      if ((listings.isNotEmpty) &&
          ((listings[0] == null) || (listings[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        listings = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: listings);
  }

  Future<ApiResponse<Article?>> statusOfProperty(
      Map<String, dynamic> params, int id) async {
    String message = "";
    bool success = false, internet = true;
    Article? article;

    ApiRequest request = webApiServices.provideStatusOfListingApi(params, id);
    request.tag = StatusOfPropertyTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: StatusOfPropertyTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok)) {
      success = true;
      article = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: article);
  }

  Future<ApiResponse> deleteListing(int id) async {
    String message = "";
    bool success = false, internet = true;

    ApiRequest request = webApiServices.provideDeleteListingApi(id);
    request.tag = DeleteListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      forceExcludeCache: true,
      tag: DeleteListingTag,
    );

    if (response.statusCode == HttpStatus.ok) {
      success = true;
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: "");
  }

  Future<ApiResponse<List>> fetchTermData(dynamic termData, {String? parentSlug}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> metaDataList = [];

    ApiRequest request = webApiServices.provideTermDataApi(termData, parentSlug: parentSlug,);
    request.tag = TermDataTag;

    final response = await apiUtilities.doRequestOnRoute(request.uri,
        tag: TermDataTag, handle500: request.handle500);
    // print("**************Response: $response");
    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      metaDataList = webApiServices.getParser().parseApi(request, response);

      if ((metaDataList.isNotEmpty) &&
          ((metaDataList[0] == null) ||
              (metaDataList[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        metaDataList = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: metaDataList);
  }

  Future<ApiResponse<String>> addOrRemoveFavorites(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideAddOrRemoveFavoritesApi(params);
    request.tag = AddOrRemoveFromFavoritesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: AddOrRemoveFromFavoritesTag,
    );
    print("Response: $response");
    print("request body: $request");
    print("request uri: ${request.uri}");
    print("request formParams: ${request.formParams}");
    print("request headers: ${request.headers}");
    print("request tag: ${request.tag}");
    print("request handle500: ${request.handle500}");

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> searchAgencies(
      int page, int perPage, String search) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> agenciesList = [];

    ApiRequest request =
        webApiServices.provideSearchAgenciesApi(page, perPage, search);
    request.tag = SearchAgenciesTag;

    final response = await apiUtilities.doRequestOnRoute(request.uri,
        tag: SearchAgenciesTag, handle500: request.handle500);

    if (response.data != null &&
        // response.data is Map && -- Error Causing
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      agenciesList = webApiServices.getParser().parseApi(request, response);

      if ((agenciesList.isNotEmpty) &&
          ((agenciesList[0] == null) ||
              (agenciesList[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        agenciesList = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: agenciesList);
  }

  Future<ApiResponse<List>> favoriteListings(
      int page, int perPage, String userId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> listings = [];

    ApiRequest request =
        webApiServices.provideFavoriteListingsApi(page, perPage, userId);
    request.tag = FavoriteListingsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      useCache: false,
      handle403: true,
      forceExcludeCache: true,
      handle500: request.handle500,
      tag: FavoriteListingsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      listings = webApiServices.getParser().parseApi(request, response);

      if ((listings.isNotEmpty) &&
          ((listings[0] == null) || (listings[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        listings = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: listings);
  }

  Future<ApiResponse<String>> deleteImage(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideDeleteImageApi(params, nonce);
    request.tag = DeleteImageTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: DeleteImageTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> saveSearch(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideSaveSearchApi(params, nonce);
    request.tag = SaveSearchTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: SaveSearchTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> fetchSavedSearchesListing(int page, int perPage,
      {String? leadId, bool fetchLeadSavedSearches = false}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> listing = [];

    ApiRequest request = webApiServices.provideSavedSearchesListingApi(
        page, perPage,
        leadId: leadId, fetchLeadSavedSearches: fetchLeadSavedSearches);
    request.tag = SavedSearchesListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      useCache: false,
      forceExcludeCache: true,
      handle500: request.handle500,
      tag: SavedSearchesListingTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      listing = webApiServices.getParser().parseApi(request, response);

      if ((listing.isNotEmpty) &&
          ((listing[0] == null) || (listing[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        listing = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: listing);
  }

  Future<ApiResponse<String>> deleteSavedSearch(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideDeleteSavedSearchApi(params);
    request.tag = DeleteSavedSearchTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: DeleteSavedSearchTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> addReview(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideAddReviewApi(params, nonce);
    request.tag = AddReviewTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: AddReviewTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> reportContent(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideReportContentApi(params, nonce);
    request.tag = ReportContentTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle403: false,
      handle500: request.handle500,
      tag: ReportContentTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> listingReviews(
      int id, String page, String perPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> reviews = [];

    ApiRequest request =
        webApiServices.provideListingReviewsApi(id, page, perPage);
    request.tag = ListingReviewsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: ListingReviewsTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      reviews = webApiServices.getParser().parseApi(request, response);

      if ((reviews.isNotEmpty) &&
          ((reviews[0] == null) || (reviews[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        reviews = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: reviews);
  }

  Future<ApiResponse> fetchAllReviews(
    String page,
    String perPage,
    String? type,
    String? search,
    {String? status}
  ) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> reviews = [];

    ApiRequest request = webApiServices.provideAllReviewsApi(
      page,
      perPage,
      type!,
      search!,
      status ?? ""
    );
    request.tag = FetchAllReviewsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: FetchAllReviewsTag,
    );
  

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      reviews = webApiServices.getParser().parseApi(request, response);
      if ((reviews.isNotEmpty) &&
          ((reviews[0] == null) || (reviews[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        reviews = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: reviews);
  }

  Future<ApiResponse> processReviewApproval(int reviewID, bool isApprove) async {
    ApiRequest request = webApiServices.provideReviewsApprovalApi(reviewID, isApprove);
    request.tag =
        ReviewApprovalTag; 

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle403: true, 
      handle500: request.handle500,
      tag: ReviewApprovalTag, 
    );

    ApiResponse apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse> putReviewsToTrash(int reviewID) async {
    ApiRequest request = webApiServices.provideReviewMoveToTrashApi(reviewID);
    request.tag =
        ReviewApprovalTag; 

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle403: true, 
      handle500: request.handle500,
      tag: ReviewApprovalTag, 
    );

    ApiResponse apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> realtorReviews(
      int id, String page, String perPage, String type) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> reviews = [];

    ApiRequest request =
        webApiServices.provideRealtorReviewsApi(id, page, perPage, type);
    request.tag = RealtorReviewsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: RealtorReviewsTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      reviews = webApiServices.getParser().parseApi(request, response);

      if ((reviews.isNotEmpty) &&
          ((reviews[0] == null) || (reviews[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        reviews = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: reviews);
  }

  Future<ApiResponse<List>> userInfo() async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> userInfo = [];

    ApiRequest request = webApiServices.provideUserInfoApi();
    request.tag = UserInfoTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      forceExcludeCache: true,
      handle500: request.handle500,
      tag: UserInfoTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      userInfo = webApiServices.getParser().parseApi(request, response);

      if ((userInfo.isNotEmpty) &&
          ((userInfo[0] == null) || (userInfo[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = true;
      if (response.statusCode == null) {
        internet = false;
        userInfo = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: userInfo);
  }

  Future<ApiResponse<String>> updateUserProfile(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request =
        webApiServices.provideUpdateUserProfileApi(params, nonce);
    request.tag = UpdateUserProfileTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: UpdateUserProfileTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> fixProfileImage() async {
    ApiRequest request = webApiServices.provideFixProfileImageApi();
    request.tag = FixProfileImageTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      handle500: request.handle500,
      tag: FixProfileImageTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> updateUserProfileImage(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request =
        await webApiServices.provideUpdateUserProfileImageApi(params, nonce);
    request.tag = UpdateUserProfileImageTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formData: request.formData,
      handle500: request.handle500,
      tag: UpdateUserProfileImageTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> searchAgents(int page, int perPage, String search,
      String agentCity, String agentCategory) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> agents = [];

    ApiRequest request = webApiServices.provideSearchAgentsApi(
        page, perPage, search, agentCity, agentCategory);
    request.tag = SearchAgentsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: SearchAgentsTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      agents = webApiServices.getParser().parseApi(request, response);

      if ((agents.isNotEmpty) &&
          ((agents[0] == null) || (agents[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        agents = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: agents);
  }

  Future<ApiResponse<bool>> isFavorite(String listingId) async {
    String message = "";
    bool success = false, internet = true;
    bool isFav = false;

    ApiRequest request = webApiServices.provideIsFavoriteApi(listingId);
    request.tag = IsFavoriteListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      forceExcludeCache: true,
      handle500: request.handle500,
      tag: IsFavoriteListingTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      IsFavourite isFavourite =
          webApiServices.getParser().parseApi(request, response);
      isFav = isFavourite.isFav ?? false;
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: isFav);
  }

  Future<ApiResponse<UserLoginInfo?>> socialSignOn(
      Map<String, dynamic> params, String nonce) async {
    String message = "";
    bool success = false, internet = true;
    UserLoginInfo? userLoginInfo;

    ApiRequest request = webApiServices.provideSocialSingOnApi(params, nonce);
    request.tag = SocialSignOnTag;

    Dio dio = Dio();
    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      dio: dio,
      type: POST,
      formParams: request.formParams,
      handle403: false,
      handle500: request.handle500,
      tag: SocialSignOnTag,
    );

    if (response.data != null && response.data is Map) {
      if (response.statusCode == HttpStatus.ok) {
        success = true;
        userLoginInfo = webApiServices.getParser().parseApi(request, response);
      } else {
        ApiResponse<String> apiResponse =
            webApiServices.getParser().parseApi(request, response);
        message = apiResponse.message;
        success = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: userLoginInfo);
  }

  Future<ApiResponse<String>> deleteUserAccount() async {
    ApiRequest request = webApiServices.provideDeleteUserAccountApi();
    request.tag = DeleteUserAccountTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      handle500: request.handle500,
      tag: DeleteUserAccountTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> updateUserPassword(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request =
        webApiServices.provideUpdateUserPasswordApi(params, nonce);
    request.tag = UpdatePasswordTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: UpdatePasswordTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> requestProperty(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideRequestPropertyApi(params);
    request.tag = RequestPropertyTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: RequestPropertyTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> addAgent(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideAddAgentApi(params, nonce);
    request.tag = AddAgentTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: AddAgentTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> editAgent(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideEditAgentApi(params, nonce);
    request.tag = EditAgentTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: EditAgentTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> allAgentOfAnAgency(int agencyId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> agents = [];

    ApiRequest request = webApiServices.provideAllAgentOfAnAgencyApi(agencyId);
    request.tag = AllAgentsOfAnAgencyTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      forceExcludeCache: true,
      handle500: request.handle500,
      tag: AllAgentsOfAnAgencyTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      agents = webApiServices.getParser().parseApi(request, response);

      if ((agents.isNotEmpty) &&
          ((agents[0] == null) || (agents[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        agents = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: agents);
  }

  Future<ApiResponse<String>> deleteAnAgent(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideDeleteAnAgentApi(params, nonce);
    request.tag = DeleteAnAgentTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: DeleteAnAgentTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<List>> fetchAllUsers(
      int page, int perPage, String search) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> users = [];

    ApiRequest request =
        webApiServices.provideAllUsersApi(page, perPage, search);
    request.tag = AllUsersTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: AllUsersTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      users = webApiServices.getParser().parseApi(request, response);

      if ((users.isNotEmpty) &&
          ((users[0] == null) || (users[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        users = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: users);
  }

  Future<ApiResponse<List>> fetchAllUsersProperties({int page = 1, int perPage = 100}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> insightsProperties = [];

    ApiRequest request =
        webApiServices.provideAllUsersProperties(page: page, perPage: perPage);
    request.tag = AllUsersPropertiesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: AllUsersPropertiesTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      insightsProperties = webApiServices.getParser().parseApi(request, response);

      if ((insightsProperties.isNotEmpty) &&
          ((insightsProperties[0] == null) || (insightsProperties[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        insightsProperties = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: insightsProperties);
  }

  Future<ApiResponse<List>> fetchInsightsProperties({int? id, String? dataType, String? timePeriod}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> insightsProperties = [];

    ApiRequest request =
        webApiServices.providePropertyInsights(propertyId: id,dataType: dataType,timePeriod: timePeriod);
    request.tag = InsightPropertiesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: InsightPropertiesTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      insightsProperties = webApiServices.getParser().parseApi(request, response);
    print("Response: $insightsProperties\n\nCheck response for all insights properties");

      if ((insightsProperties.isNotEmpty) &&
          ((insightsProperties[0] == null) || (insightsProperties[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        insightsProperties = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: insightsProperties);
  }

  Future<ApiResponse<List>> fetchUserInsights( {String? timePeriod, int? propertyId}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> insightsProperties = [];

  ApiRequest request =
        webApiServices.provideUsersInsights(timePeriod: timePeriod, propertyId: propertyId);
    request.tag = UsersInsightTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: UsersInsightTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      insightsProperties = webApiServices.getParser().parseApi(request, response);

      if ((insightsProperties.isNotEmpty) &&
          ((insightsProperties[0] == null) || (insightsProperties[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        insightsProperties = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: insightsProperties);
  }

  Future<ApiResponse<List>> fetchAllUsersV2(
      int page, int perPage, String search, String? approvalStatus
      ) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> users = [];

    ApiRequest request =
        webApiServices.provideAllUsersApiV2(
          page, perPage, search, approvalStatus!
          );
    request.tag = AllUserV2Tag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: AllUserV2Tag,
    );
    // print("Response: $response");

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      users = webApiServices.getParser().parseApi(request, response);
      // print("Users: $users");
      // print("Users length: ${users.length}");

      if ((users.isNotEmpty) &&
          ((users[0] == null) || (users[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        users = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: users);
  }

  Future<ApiResponse> fetchListForUserApprovalStatuses() async {
    ApiRequest request = webApiServices.provideApprovalStatusListApi();
    request.tag = UserApprovalStatusesListTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: UserApprovalStatusesListTag,
    );
      ApiResponse apiResponse =
          webApiServices.getParser().parseApi(request, response);
          // print("Response: $response");
      return apiResponse;
  }

  // Future<ApiResponse> fetchReviewApprovalSettions() async {
  //   ApiRequest request = webApiServices.provideReviewSettingApi();
  //   request.tag = UserReviewsSettingTag;

  //   final response = await apiUtilities.doRequestOnRoute(
  //     request.uri,
  //     handle500: request.handle500,
  //     tag: UserReviewsSettingTag,
  //   );
  //     ApiResponse apiResponse =
  //         webApiServices.getParser().parseApi(request, response);
  //         print("Response: $response");
  //     return apiResponse;
  // }

  Future<ApiResponse> processUserApproval(int userID, String action) async {
    ApiRequest request = webApiServices.provideUserApprovalApi(userID, action);
    request.tag =
        UserApprovalTag; 

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle403: true, 
      handle500: request.handle500,
      tag: UserApprovalTag, 
    );

    ApiResponse apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<UserPaymentStatus?>> userPaymentStatus() async {
    String message = "";
    bool success = false, internet = true;
    UserPaymentStatus? status;

    ApiRequest request = webApiServices.provideUserPaymentStatusApi();
    request.tag = UserPaymentStatusTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      handle500: request.handle500,
      tag: UserPaymentStatusTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      status = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: status);
  }

  ApiRequest printPropertyPDFApi(Map<String, dynamic> params) {
    ApiRequest request = webApiServices.providePrintPropertyPDFApi(params);
    return request;
  }

  Future<ApiResponse<List>> allPartners() async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> partners = [];

    ApiRequest request = webApiServices.provideAllPartnersApi();
    request.tag = AllPartnersTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: AllPartnersTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      partners = webApiServices.getParser().parseApi(request, response);

      if ((partners.isNotEmpty) &&
          ((partners[0] == null) || (partners[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        partners = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: partners);
  }

  ApiRequest provideDirectionsApi(
      {required String platform,
      required String destinationLatitude,
      required String destinationLongitude}) {
    ApiRequest request = webApiServices.provideDirectionsApi(
        platform, destinationLatitude, destinationLongitude);
    return request;
  }

  Future<ApiResponse<List>> fetchMembershipPackages(
      String page, String perPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> packages = [];

    ApiRequest request =
        webApiServices.provideMembershipPackagesApi(page, perPage);
    request.tag = MembershipPackagesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: MembershipPackagesTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      packages = webApiServices.getParser().parseApi(request, response);

      if ((packages.isNotEmpty) &&
          ((packages[0] == null) || (packages[0].runtimeType == Response))) {
        internet = false;
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        packages = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: packages);
  }

  Future<ApiResponse<UserMembershipPackage?>>
      fetchUserMembershipPackage() async {
    String message = "";
    bool success = false, internet = true;
    UserMembershipPackage? package;

    ApiRequest request = webApiServices.provideUserMembershipPackageApi();
    request.tag = UserMembershipPackageTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      handle500: request.handle500,
      tag: UserMembershipPackageTag,
    );

    if (response.data != null &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      package = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: package);
  }

  Future<ApiResponse<String>> proceedWithPayments(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideProceedWithPaymentsApi(params);
    request.tag = ProceedWithPaymentsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle403: false,
      handle500: request.handle500,
      tag: ProceedWithPaymentsTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> makePropertyFeatured(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideMakePropertyFeaturedApi(params);
    request.tag = MakePropertyFeaturedTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: MakePropertyFeaturedTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> removeFromFeatured(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideRemoveFromFeaturedApi(params);
    request.tag = RemoveFromFeaturedTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: RemoveFromFeaturedTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> approveOrDisapproveAListing(
      Map<String, dynamic> params) async {
    ApiRequest request =
        webApiServices.provideApproveOrDisapproveListingApi(params);
    request.tag = ApproveOrDisapproveListingTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: ApproveOrDisapproveListingTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> toggleFeatured(
      int propertyId, bool setFeatured) async {
    ApiRequest request =
        webApiServices.provideToggleFeaturedApi(propertyId, setFeatured);
    request.tag = ToggleFeaturedTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: ToggleFeaturedTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> setSoldStatus(int propertyId) async {
    ApiRequest request = webApiServices.provideSetSoldStatusApi(propertyId);
    request.tag = SetSoldStatusTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: SetSoldStatusTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> setExpiredStatus(int propertyId) async {
    ApiRequest request = webApiServices.provideSetExpiredStatusApi(propertyId);
    request.tag = SetExpireStatusTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: SetExpireStatusTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> setPendingStatus(
      Map<String, dynamic> params) async {
    ApiRequest request = webApiServices.provideSetPendingStatusApi(params);
    request.tag = SetPendingStatusTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: SetPendingStatusTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<BlogArticlesData?>> fetchBlogs(
      String page, String perPage) async {
    String message = "";
    bool success = false, internet = true;
    BlogArticlesData? data;

    ApiRequest request = webApiServices.provideAllBlogsApi(page, perPage);
    request.tag = AllBlogsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: AllBlogsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      data = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: data);
  }

  Future<ApiResponse<BlogCategoriesData?>> fetchAllBlogCategories(
      String orderBy, String order) async {
    String message = "";
    bool success = false, internet = true;
    BlogCategoriesData? categories;

    ApiRequest request =
        webApiServices.provideAllBlogCategoriesApi(orderBy, order);
    request.tag = AllBlogCategoriesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: AllBlogCategoriesTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      categories = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: categories);
  }

  Future<ApiResponse<BlogTagsData?>> fetchAllBlogTags(
      String orderBy, String order) async {
    String message = "";
    bool success = false, internet = true;
    BlogTagsData? data;

    ApiRequest request = webApiServices.provideAllBlogTagsApi(orderBy, order);
    request.tag = AllBlogTagsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: AllBlogTagsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      data = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: data);
  }

  Future<ApiResponse<BlogCommentsData?>> fetchBlogComments(
      String page, String perPage, String postId) async {
    String message = "";
    bool success = false, internet = true;
    BlogCommentsData? data;

    ApiRequest request =
        webApiServices.provideBlogCommentsApi(page, perPage, postId);
    request.tag = BlogCommentsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: BlogCommentsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      data = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success, message: message, internet: internet, result: data);
  }

  Future<ApiResponse<String>> addBlogComment(
      Map<String, dynamic> params, String nonce) async {
    ApiRequest request = webApiServices.provideAddBlogCommentApi(params, nonce);
    request.tag = AddBlogCommentTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: AddBlogCommentTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<AllNotifications?>> fetchAllNotifications(
      String page, String perPage) async {
    String message = "";
    bool success = false, internet = true;
    AllNotifications? notifications;

    ApiRequest request =
        webApiServices.provideAllNotificationsApi(page, perPage);
    request.tag = AllNotificationsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: AllNotificationsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      notifications = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: notifications);
  }

  Future<ApiResponse<CheckNotifications?>> checkNewNotifications(
      String page, String perPage) async {
    String message = "";
    bool success = false, internet = true;
    CheckNotifications? checkNotifications;

    ApiRequest request =
        webApiServices.provideCheckNotificationsApi(page, perPage);
    request.tag = CheckNotificationsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CheckNotificationsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      checkNotifications =
          webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: checkNotifications);
  }

  Future<ApiResponse<String>> deleteNotification(
      String notificationId, String userEmail) async {
    ApiRequest request =
        webApiServices.provideDeleteNotificationApi(notificationId, userEmail);
    request.tag = DeleteNotificationsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      forceExcludeCache: true,
      useCache: false,
      handle500: request.handle500,
      tag: DeleteNotificationsTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<Threads?>> fetchAllThreads(
      int page, int perPage, int? propertyId) async {
    String message = "";
    bool success = false, internet = true;
    Threads? threads;

    ApiRequest request =
        webApiServices.provideAllThreadsApi(page, perPage, propertyId);
    request.tag = AllThreadsTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      forceExcludeCache: true,
      useCache: false,
      handle500: request.handle500,
      tag: AllThreadsTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      threads = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: threads);
  }

  Future<ApiResponse<Messages?>> fetchAllMessages(
      Map<String, dynamic> params) async {
    String message = "";
    bool success = false, internet = true;
    Messages? messages;

    ApiRequest request = webApiServices.provideAllMessagesApi(params);
    request.tag = AllMessagesTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      forceExcludeCache: true,
      useCache: false,
      handle500: request.handle500,
      tag: AllMessagesTag,
    );

    if (response.data != null &&
        response.data is Map &&
        (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.notModified)) {
      success = true;
      messages = webApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }

    return ApiResponse(
        success: success,
        message: message,
        internet: internet,
        result: messages);
  }

  Future<ApiResponse<String>> deleteThread(
      String threadId, String senderId, String receiverId) async {
    ApiRequest request =
        webApiServices.provideDeleteThreadApi(threadId, senderId, receiverId);
    request.tag = DeleteThreadTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      forceExcludeCache: true,
      useCache: false,
      handle500: request.handle500,
      tag: DeleteThreadTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> startThread(
      int propertyId, String message, String nonce) async {
    ApiRequest request =
        webApiServices.provideStartThreadApi(propertyId, message, nonce);
    request.tag = StartThreadTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: StartThreadTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> sendMessage(
      String threadId, String message, String nonce) async {
    ApiRequest request =
        webApiServices.provideSendMessagesApi(threadId, message, nonce);
    request.tag = SendMessageTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: SendMessageTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  ////////////////////////////////////////////////////////////////////////////
  //                    **** NONCE RELATED SECTION ****                     //
  ////////////////////////////////////////////////////////////////////////////

  Future<ApiResponse<String>> createNonce(String nonceName,
      {bool isNonce = false}) async {
    ApiRequest request = webApiServices.provideCreateNonceApi(nonceName);
    request.tag = CreateNonceTag;

    final response = await apiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle403: true,
      isNonce: isNonce,
      tag: CreateNonceTag,
    );

    ApiResponse<String> apiResponse =
        webApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> addAgentNonce() async {
    String nonceKey = webApiServices.provideAddAgentNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchEditAgentNonceResponse() async {
    String nonceKey = webApiServices.provideEditAgentNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchDeleteAgentNonceResponse() async {
    String nonceKey = webApiServices.provideDeleteAgentNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchScheduleATourNonceResponse() async {
    String nonceKey = webApiServices.provideScheduleATourNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchContactPropertyRealtorNonceResponse() async {
    String nonceKey = webApiServices.provideContactPropertyRealtorNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchContactRealtorNonceResponse() async {
    String nonceKey = webApiServices.provideContactRealtorNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchAddPropertyNonceResponse() async {
    String nonceKey = webApiServices.provideAddPropertyNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchUpdatePropertyNonceResponse() async {
    String nonceKey = webApiServices.provideUpdatePropertyNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchAddImageNonceResponse() async {
    String nonceKey = webApiServices.provideAddImageNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchDeleteImageNonceResponse() async {
    String nonceKey = webApiServices.provideDeleteImageNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchAddReviewNonceResponse() async {
    String nonceKey = webApiServices.provideAddReviewNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchSaveSearchNonceResponse() async {
    String nonceKey = webApiServices.provideSaveSearchNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchSignUpNonceResponse() async {
    String nonceKey = webApiServices.provideSignUpNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchResetPasswordNonceResponse() async {
    String nonceKey = webApiServices.provideResetPasswordNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchUpdatePasswordNonceResponse() async {
    String nonceKey = webApiServices.provideUpdatePasswordNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchUpdateProfileNonceResponse() async {
    String nonceKey = webApiServices.provideUpdateProfileNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchUpdateProfileImageNonceResponse() async {
    String nonceKey = webApiServices.provideUpdateProfileImageNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchSignInNonceResponse() async {
    String nonceKey = webApiServices.provideSignInNonceKey();
    ApiResponse<String> apiResponse =
        await createNonce(nonceKey, isNonce: true);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchReportContentNonceResponse() async {
    String nonceKey = webApiServices.provideReportContentNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchAddCommentNonceResponse() async {
    String nonceKey = webApiServices.provideAddCommentNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchSendMessageNonceResponse() async {
    String nonceKey = webApiServices.provideSendMessageNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  Future<ApiResponse<String>> fetchStartThreadNonceResponse() async {
    String nonceKey = webApiServices.provideStartThreadNonceKey();
    ApiResponse<String> apiResponse = await createNonce(nonceKey);
    return apiResponse;
  }

  ////////////////////////////////////////////////////////////////////////////
  //                    **** PARSING RELATED SECTION ****                   //
  ////////////////////////////////////////////////////////////////////////////

  Custom getCustomFieldsData(Map<String, dynamic> json) {
    return webApiServices.getParser().parseCustomFields(json);
  }

  BlogDetailsPageLayout getBlogDetailsPageLayout(Map json) {
    return webApiServices.getParser().parseBlogDetailsPageLayoutJson(json);
  }

  Map convertBlogDetailsPageLayoutToMap(BlogDetailsPageLayout layout) {
    return webApiServices
        .getParser()
        .convertBlogDetailsPageLayoutToJson(layout);
  }

  HouziFormPage parseFormPageJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseFormPageJson(json);
  }

  HouziFormItem parseFormItemJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseFormItemJson(json);
  }

  DrawerLayoutConfig parseDrawerLayoutConfigJson(Map<dynamic, dynamic> json) {
    return webApiServices.getParser().parseDrawerLayoutConfigJson(json);
  }

  Map<String, dynamic> convertDrawerLayoutConfigToJson(
      DrawerLayoutConfig config) {
    return webApiServices.getParser().convertDrawerLayoutConfigToJson(config);
  }

  Map<String, dynamic> convertDrawerLayoutItemToJson(layoutItem) {
    return webApiServices.getParser().convertDrawerLayoutItemToJson(layoutItem);
  }

  FilterPageElement parseFilterPageElementJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseFilterPageElementJson(json);
  }

  Map<String, dynamic> convertFilterPageElementToMap(
      FilterPageElement filterPageElement) {
    return webApiServices
        .getParser()
        .convertFilterPageElementToMap(filterPageElement);
  }

  HomeConfig parseHomeConfigJson(Map<dynamic, dynamic> json) {
    return webApiServices.getParser().parseHomeConfigJson(json);
  }

  Map<String, dynamic> convertHomeConfigToJson(HomeConfig item) {
    return webApiServices.getParser().convertHomeConfigToJson(item);
  }

  TermsWithIcon parseTermsWithIconJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseTermsWithIconJson(json);
  }

  Map<String, dynamic> convertTermsWithIconToJson(TermsWithIcon item) {
    return webApiServices.getParser().convertTermsWithIconToJson(item);
  }

  HomeLayout parseHomeLayoutJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseHomeLayoutJson(json);
  }

  Map<String, dynamic> convertHomeLayoutToJson(HomeLayout item) {
    return webApiServices.getParser().convertHomeLayoutToJson(item);
  }

  NavBar parseNavBarJson(Map<dynamic, dynamic> json) {
    return webApiServices.getParser().parseNavBarJson(json);
  }

  Map<String, dynamic> convertNavBarToJson(NavBar item) {
    return webApiServices.getParser().convertNavBarToJson(item);
  }

  PropertyDetailPageLayout parsePropertyDetailPageLayoutJson(
      Map<dynamic, dynamic> json) {
    return webApiServices.getParser().parsePropertyDetailPageLayoutJson(json);
  }

  Map<String, dynamic> convertPropertyDetailPageLayoutToJson(
      PropertyDetailPageLayout item) {
    return webApiServices
        .getParser()
        .convertPropertyDetailPageLayoutToJson(item);
  }

  PropertyDetailPageLayoutElement parsePropertyDetailPageLayoutElementJson(
      Map<String, dynamic> json) {
    return webApiServices
        .getParser()
        .parsePropertyDetailPageLayoutElementJson(json);
  }

  Map<String, dynamic> convertPropertyDetailPageLayoutElementToJson(
      PropertyDetailPageLayoutElement item) {
    return webApiServices
        .getParser()
        .convertPropertyDetailPageLayoutElementToJson(item);
  }

  SortFirstBy parseSortFirstByJson(Map<dynamic, dynamic> json) {
    return webApiServices.getParser().parseSortFirstByJson(json);
  }

  Map<String, dynamic> convertSortFirstByToJson(SortFirstBy item) {
    return webApiServices.getParser().convertSortFirstByToJson(item);
  }

  Term parseTermJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseTermJson(json);
  }

  Views parseViewsJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseViewsJson(json);
  }
  TopInsightsMetaData parseInsightsJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseInsightsJson(json);
  }

  Map<String, dynamic> convertTermToMap(Term item) {
    return webApiServices.getParser().convertTermToMap(item);
  }

  Map<String, dynamic> convertViewsToMap(Views item) {
    return webApiServices.getParser().convertViewsToMap(item);
  }

  Map<String, dynamic> convertInsightToMap(TopInsightsMetaData item) {
    return webApiServices.getParser().convertInsightToMap(item);
  }

  UserLoginInfo parseUserLoginInfoJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseUserLoginInfoJson(json);
  }

  Map<String, dynamic> convertUserLoginInfoToJson(UserLoginInfo item) {
    return webApiServices.getParser().convertUserLoginInfoToJson(item);
  }

  UserPaymentStatus parseUserPaymentStatusJson(Map<String, dynamic> json) {
    return webApiServices.getParser().parseUserPaymentStatusJson(json);
  }

  Map<String, dynamic> convertUserPaymentStatusToJson(UserPaymentStatus item) {
    return webApiServices.getParser().convertUserPaymentStatusToJson(item);
  }
}
