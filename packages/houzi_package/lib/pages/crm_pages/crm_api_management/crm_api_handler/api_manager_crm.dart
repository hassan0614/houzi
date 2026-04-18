import 'dart:core'; 
import 'dart:io';

import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/user/user_login_info.dart';

import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_api_sources/crm_api_houzez.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_api_utilities/crm_api_utilities.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_interfaces/crm_api_interface.dart';

class ApiMangerCRM extends ApiManager {

  final CRMApiUtilities crmApiUtilities = CRMApiUtilities();
  final CRMWebsiteApiServices crmWebsiteApiServices = CRMApiHouzez();

  /// /////////////////////////////////////////////////////////////////////////
  ///                         CRM Activities                               ///
  /// ///////////////////////////////////////////////////////////////////////

  Future<ApiResponse<List>> fetchActivitiesFromBoard(int page, int perPage, int userId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> activities = [];

    ApiRequest request = crmWebsiteApiServices.provideActivitiesFromBoardApi(page, perPage, userId);
    request.tag = CRMActivitiesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMActivitiesTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok || 
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      activities = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        activities = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: activities);
  }

  Future<ApiResponse<List>> fetchLeadsFromActivity(int page, int userId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> leads = [];

    ApiRequest request = crmWebsiteApiServices.provideLeadsFromActivityApi(page,userId);
    request.tag = CRMLeadsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMLeadsTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      leads = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        leads = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: leads);
  }

  Future<ApiResponse<List>> fetchDealsFromActivity(int page, int userId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> deals = [];

    ApiRequest request = crmWebsiteApiServices.provideDealsFromActivityApi(page, userId);
    request.tag = CRMActivityDealsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMActivityDealsTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      deals = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        deals = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: deals);
  }

  Future<ApiResponse<List>> fetchDealsAndLeadsFromActivity() async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> deals = [];

    ApiRequest request = crmWebsiteApiServices.provideDealsAndLeadsFromActivityApi();
    request.tag = CRMBoardLeadsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMBoardLeadsTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      deals = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        deals = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: deals);
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///                         CRM Inquiries                               ///
  /// ///////////////////////////////////////////////////////////////////////


  Future<ApiResponse<List>> fetchInquiriesFromBoard(int page, int perPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> inquiries = [];

    ApiRequest request = crmWebsiteApiServices.provideInquiriesFromBoardApi(page, perPage);
    request.tag = CRMInquiriesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      tag: CRMInquiriesTag,
      handle500: request.handle500,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      inquiries = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        inquiries = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: inquiries);
  }

  Future<ApiResponse<List>> fetchInquiryDetailMatchedFromBoard(String enquiryId, int propPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> matched = [];

    ApiRequest request = crmWebsiteApiServices.provideInquiryDetailMatchedFromBoardApi(enquiryId, propPage);
    request.tag = CRMInquiryMatchedTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMInquiryMatchedTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      final results = response.data["matched"];
      matched.addAll(results.map((m) => webApiServices.getParser().parseArticle(m)).toList());
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        matched = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: matched);
  }

  Future<ApiResponse<List>> fetchInquiryDetailNotesFromBoard(String enquiryId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> matched = [];

    ApiRequest request = crmWebsiteApiServices.provideInquiryDetailNotesFromBoardApi(enquiryId);
    request.tag = CRMInquiryNotesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMInquiryNotesTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      matched = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        matched = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: matched);
  }

  Future<ApiResponse<String>> addInquiry(Map<String, dynamic> params) async {
    ApiRequest request = crmWebsiteApiServices.provideAddInquiryApi(params);
    request.tag = CRMAddInquiryTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMAddInquiryTag,
    );

    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> deleteInquiry(int id) async {
    String message = "";
    bool success = false, internet = true;

    ApiRequest request = crmWebsiteApiServices.provideDeleteInquiryApi(id);
    request.tag = CRMDeleteInquiryTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMDeleteInquiryTag,
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
    return ApiResponse(success: success, message: message, internet: internet, result: "");
  }


  /// /////////////////////////////////////////////////////////////////////////
  ///                         CRM Leads                                    ///
  /// ///////////////////////////////////////////////////////////////////////

  
  Future<ApiResponse<List>> fetchLeadsFromBoard(int page, int perPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> dealsList = [];

    ApiRequest request = crmWebsiteApiServices.provideLeadsFromBoardApi(page, perPage);
    request.tag = CRMGetLeadsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMGetLeadsTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      dealsList = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        dealsList = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: dealsList);
  }

  Future<ApiResponse<List>> fetchLeadsInquiriesFromBoard(String leadId, int propPage, {fetchLeadDetail = false}) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> leadsInquiries = [];

    ApiRequest request = crmWebsiteApiServices.provideLeadsInquiriesFromBoardApi(leadId, propPage);
    request.tag = CRMLeadInquiriesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMLeadInquiriesTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.notModified)) {
      success = true;

      if (fetchLeadDetail) {
        request.tag = CRMLeadDetailsTag;
        leadsInquiries = crmWebsiteApiServices.getParser().parseApi(request, response);
      } else {
        leadsInquiries = crmWebsiteApiServices.getParser().parseApi(request, response);
      }
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        leadsInquiries = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: leadsInquiries);
  }

  Future<ApiResponse<List>> fetchLeadsViewedFromBoard(String leadId, int propPage) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> leadsViewedList = [];

    ApiRequest request = crmWebsiteApiServices.provideLeadsViewedFromBoardApi(leadId, propPage);
    request.tag = CRMLeadViewedTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMLeadViewedTag,
    );

    if (response.data != null && response.data.isNotEmpty &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      success = true;
      leadsViewedList = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        leadsViewedList = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: leadsViewedList);
  }

  Future<ApiResponse<List>> fetchLeadsDetailNotesFromBoard(String leadId) async {
    String message = "";
    bool success = false, internet = true;
    List<dynamic> matched = [];

    ApiRequest request = crmWebsiteApiServices.provideLeadsDetailNotesFromBoardApi(leadId);
    request.tag = CRMLeadNotesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMLeadNotesTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok || 
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      matched = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
        matched = [response];
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: matched);
  }

  Future<ApiResponse<String>> addLead(Map<String, dynamic> params) async {
    ApiRequest request = crmWebsiteApiServices.provideAddLeadApi(params);
    request.tag = CRMAddLeadTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMAddLeadTag,
    );
    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///                         CRM Deals                                    ///
  /// ///////////////////////////////////////////////////////////////////////

  
  Future<ApiResponse<Map<String, dynamic>>> fetchDealsFromBoard(int page, int perPage, String tab) async {
    String message = "";
    bool success = false, internet = true;
    Map<String, dynamic> map = {};

    ApiRequest request = crmWebsiteApiServices.provideDealsFromBoardApi(page, perPage, tab);
    request.tag = CRMGetDealsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      handle500: request.handle500,
      tag: CRMGetDealsTag,
    );

    if (response.data != null && (response.statusCode == HttpStatus.ok || 
        response.statusCode == HttpStatus.notModified)) {
      success = true;
      map = crmWebsiteApiServices.getParser().parseApi(request, response);
    } else {
      success = false;
      if (response.statusCode == null) {
        internet = false;
      } else {
        message = response.statusMessage ?? "";
      }
    }
    return ApiResponse(success: success, message: message, internet: internet, result: map);
  }

  Future<ApiResponse<String>> addDeal(Map<String, dynamic> params) async {
    ApiRequest request = crmWebsiteApiServices.provideAddDealResponseApi(params);
    request.tag = CRMAddDealTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri, 
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMAddDealTag,
    );
    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> deleteDeal(int id, String nonce) async {
    String message = "";
    bool success = false, internet = true;

    ApiRequest request = crmWebsiteApiServices.provideDeleteDealApi(id, nonce);
    request.tag = CRMDeleteDealsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMDeleteDealsTag,
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
    return ApiResponse(success: success, message: message, internet: internet, result: "");
  }

  Future<ApiResponse<String>> updateDealDetails(Map<String, dynamic> params) async {
    ApiRequest request = crmWebsiteApiServices.provideUpdateDealDetailsApi(params);
    request.tag = CRMUpdateDealDetailsTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMUpdateDealDetailsTag,
    );
    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///                         Additional Webservices                       ///
  /// ///////////////////////////////////////////////////////////////////////
  
  Future<ApiResponse<String>> addCRMNotes(Map<String, dynamic> params, String nonce) async {
    ApiRequest request = crmWebsiteApiServices.provideAddCRMNotesApi(params, nonce);
    request.tag = CRMAddInquiryNotesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMAddInquiryNotesTag,
    );
    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> sendCRMEmail(Map<String, dynamic> params) async {
    ApiRequest request = crmWebsiteApiServices.provideSendCRMEmailApi(params);
    request.tag = CRMSendEmailTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMSendEmailTag,
    );
    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> deleteCRMNotes(Map<String, dynamic> params) async {
    ApiRequest request = crmWebsiteApiServices.provideDeleteCRMNotesApi(params);
    request.tag = CRMDeleteNotesTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMDeleteNotesTag,
    );

    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseApi(request, response);
    return apiResponse;
  }

  Future<ApiResponse<String>> deleteLead(int id, String nonce) async {
    String message = "";
    bool success = false, internet = true;

    ApiRequest request = crmWebsiteApiServices.provideDeleteLeadApi(id, nonce);
    request.tag = CRMDeleteLeadTag;

    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri,
      type: POST,
      formParams: request.formParams,
      handle500: request.handle500,
      tag: CRMDeleteLeadTag,
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
    return ApiResponse(success: success, message: message, internet: internet, result: "");
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///                         CRM Nonce Webservices                        ///
  /// ///////////////////////////////////////////////////////////////////////

  Future<ApiResponse<String>> crmCreateNonce(String nonceName) async {
    ApiRequest request = crmWebsiteApiServices.provideCreateNonceApi(nonceName);
    
    final response = await crmApiUtilities.doRequestOnRoute(
      request.uri, 
      type: POST, 
      formParams: request.formParams, 
      tag: "Create Nonce", 
      handle403: false,
      handle500: request.handle500,
    );
    
    ApiResponse<String> apiResponse = crmWebsiteApiServices.getParser().parseNonceResponse(response);
    return apiResponse;
  }
  
  Future<ApiResponse<String>> fetchDealDeleteNonceResponse() async {
    String key = crmWebsiteApiServices.provideDealDeleteNonceKey();
    ApiResponse<String> response = await crmCreateNonce(key);
    return response;
  }

  Future<ApiResponse<String>> fetchLeadDeleteNonceResponse() async {
    String key = crmWebsiteApiServices.provideLeadDeleteNonceKey();
    ApiResponse<String> response = await crmCreateNonce(key);
    return response;
  }

  Future<ApiResponse<String>> fetchAddNoteNonceResponse() async {
    String key = crmWebsiteApiServices.provideAddNoteNonceKey();
    ApiResponse<String> response = await crmCreateNonce(key);
    return response;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///                         ApiManger Webservices                        ///
  /// ///////////////////////////////////////////////////////////////////////

  Future<ApiResponse<List>> fetchSavedSearch(int page, int perPage, {String? leadId, bool fetchLeadSavedSearches = false}) async {
    ApiResponse<List> response = await super.fetchSavedSearchesListing(page, perPage,leadId: leadId,fetchLeadSavedSearches: fetchLeadSavedSearches);
    return response;
  }

  @override
  Future<ApiResponse<List>> fetchAllAgents(int page, int perPage,  bool? visibilityOnly) async {
    ApiResponse<List> response = await super.fetchAllAgents(page, perPage, visibilityOnly);
    return response;
  }

  @override
  Future<ApiResponse<List>> fetchTermData(dynamic termData, {String? parentSlug}) async {
    ApiResponse<List> response = await super.fetchTermData(termData, parentSlug: parentSlug);
    return response;
  }
  Future<ApiResponse<UserLoginInfo?>> socialSignOnCRM(Map<String, dynamic> params, String nonce) async {
    ApiResponse<UserLoginInfo?> response = await super.socialSignOn(params, nonce);
    return response;
  }

  Future<ApiResponse<UserLoginInfo?>> loginCRM(Map<String, dynamic> params, String nonce) async {
    ApiResponse<UserLoginInfo?> response = await super.login(params, nonce);
    return response;
  }

  Future<ApiResponse<String>> fetchSignInNonceResponse() {
    return super.fetchSignInNonceResponse();
  }

  Map<String, dynamic> convertUserLoginInfoToJson(UserLoginInfo info) {
    return super.convertUserLoginInfoToJson(info);
  }
}