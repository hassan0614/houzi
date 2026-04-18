import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_interfaces/crm_api_parser_interface.dart';
import 'package:houzi_package/models/api/api_request.dart';

abstract class CRMWebsiteApiServices {

  ApiRequest provideActivitiesFromBoardApi(int page, int perPage, int userId);

  ApiRequest provideInquiriesFromBoardApi(int page, int perPage);

  ApiRequest provideLeadsFromActivityApi(int page, int userId);

  ApiRequest provideDealsFromActivityApi(int page, int userId);

  ApiRequest provideDealsFromBoardApi(int page, int perPage, String tab);

  ApiRequest provideLeadsFromBoardApi(int page, int perPage);

  ApiRequest provideAddDealResponseApi(Map<String, dynamic> params);

  ApiRequest provideDeleteDealApi(int id, String nonce);

  ApiRequest provideDeleteInquiryApi(int id);

  ApiRequest provideAddInquiryApi(Map<String, dynamic> params);

  ApiRequest provideDeleteLeadApi(id, String nonce);

  ApiRequest provideDealsAndLeadsFromActivityApi();

  ApiRequest provideAddLeadApi(Map<String, dynamic> params);

  ApiRequest provideInquiryDetailMatchedFromBoardApi(String enquiryId, int propPage);

  ApiRequest provideInquiryDetailNotesFromBoardApi(String enquiryId);

  ApiRequest provideAddCRMNotesApi(Map<String, dynamic> params, String nonce);

  ApiRequest provideDeleteCRMNotesApi(Map<String, dynamic> params);

  ApiRequest provideSendCRMEmailApi(Map<String, dynamic> params);

  ApiRequest provideLeadsDetailNotesFromBoardApi(String leadId);

  ApiRequest provideLeadsInquiriesFromBoardApi(String leadId, int propPage);

  ApiRequest provideLeadsViewedFromBoardApi(String leadId, int propPage);

  ApiRequest provideUpdateDealDetailsApi(Map<String, dynamic> params);

  ApiRequest provideCreateNonceApi(String nonceName);

  String provideDealDeleteNonceKey();

  String provideLeadDeleteNonceKey();

  String provideAddNoteNonceKey();

  CRMApiParser getParser();
}
