import 'package:dio/dio.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';

abstract class CRMApiParser {

  dynamic parseApi(ApiRequest request, Response response);

  CRMActivity parseActivities(Map<String, dynamic> json);

  CRMInquiries parseInquiries(Map<String, dynamic> json);

  CRMLeadsFromActivity parseLeads(Map<String, dynamic> json);

  CRMDealsFromActivity parseDeals(Map<String, dynamic> json);

  CRMDealsAndLeads parseDealsAndLeadsFromBoard(Map<String, dynamic> json);

  CRMDealsAndLeadsFromActivity parseDealsAndLeadsFromActivity(Map<String, dynamic> json);

  CRMNotes parseInquiryNotes(Map<String, dynamic> json);

  ApiResponse<String> parseNonceResponse(Response response);
}