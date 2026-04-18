import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_api_utilities/crm_api_utilities.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_interfaces/crm_api_parser_interface.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_interfaces/crm_api_interface.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_parsers/crm_houzez_parser.dart';

const String HOUZEZ_ACTIVITIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/activities";
const String HOUZEZ_INQUIRIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/all-enquiries";
const String HOUZEZ_INQUIRY_MATCHED_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/enquiry-matched-listing";
const String HOUZEZ_LEAD_INQUIRIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/lead-details";
const String HOUZEZ_LEAD_VIEWED_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/lead-listing-viewed";
const String HOUZEZ_INQUIRY_NOTES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/enquiry-notes";
const String HOUZEZ_LEADS_NOTES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/lead-notes";
const String JWT_Authentication_PATH = "/wp-json/houzez-mobile-api/v1/signin";
const String HOUZEZ_SOCIAL_LOGIN_PATH = "/wp-json/houzez-mobile-api/v1/social-sign-on";
const String HOUZEZ_DEALS_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/deals";
const String HOUZEZ_LEADS_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/leads";
const String HOUZEZ_ADD_DEALS_PATH = "/wp-json/houzez-mobile-api/v1/add-deal";
const String HOUZEZ_DELETE_DEALS_PATH = "/wp-json/houzez-mobile-api/v1/delete-deal";
const String HOUZEZ_ADD_INQUIRY_PATH = "/wp-json/houzez-mobile-api/v1/add-crm-enquiry";
const String HOUZEZ_ADD_CRM_NOTES_PATH = "/wp-json/houzez-mobile-api/v1/add-note";
const String HOUZEZ_SEND_CRM_EMAIL_PATH = "/wp-json/houzez-mobile-api/v1/send-matched-listing-email";
const String HOUZEZ_DELETE_INQUIRY_PATH = "/wp-json/houzez-mobile-api/v1/delete-crm-enquiry";
const String HOUZEZ_DELETE_CRM_NOTES_PATH = "/wp-json/houzez-mobile-api/v1/delete-note";
const String HOUZEZ_DELETE_LEADS_PATH = "/wp-json/houzez-mobile-api/v1/delete-lead";
const String HOUZEZ_LEAD_SAVED_SEARCHES_PATH = "/wp-json/houzez-mobile-api/v1/lead-saved-searches";
const String HOUZEZ_ADD_LEADS_PATH = "/wp-json/houzez-mobile-api/v1/add-lead";
const String HOUZEZ_UPDATE_DEAL_DETAIL_PATH = "/wp-json/houzez-mobile-api/v1/update-deal-data";
const String HOUZEZ_CREATE_NONCE_PATH = "/wp-json/houzez-mobile-api/v1/create-nonce";

const String HouzezCpageKey = 'cpage';
const String HouzezUserIdKey = 'user_id';
const String HouzezPerPageKey = 'per_page';
const String HouzezEnquiryIdKey = 'enquiry-id';
const String HouzezPropPageKey = 'prop_page';
const String HouzezLeadIdKey = 'lead-id';
const String HouzezTabKey = 'tab';
const String HouzezIdsKey = 'ids';
const String HouzezLeadId01Key = 'lead_id';
const String HouzezDealIdKey = 'deal_id';

const String HouzezCreateNonceKey = "nonce_name";

const String HouzezDealDeleteNonceName = "delete_deal_nonce";
const String HouzezLeadDeleteNonceName = "delete_lead_nonce";
const String HouzezAddNoteNonceName = "note_add_nonce";

const String HouzezInquiryLeadIdKey = "lead_id";
const String HouzezInquiryTypeKey = "enquiry_type";
const String HouzezInquiryPropertyTypeKey = "e_meta[property_type]";
const String HouzezInquiryMinPriceKey = "e_meta[min-price]";
const String HouzezInquiryPriceKey = "e_meta[price]";
const String HouzezInquiryMinBedsKey = "e_meta[min-beds]";
const String HouzezInquiryBedsKey = "e_meta[beds]";
const String HouzezInquiryMinBathsKey = "e_meta[min-baths]";
const String HouzezInquiryBathsKey = "e_meta[baths]";
const String HouzezInquiryMinAreaKey = "e_meta[min-area]";
const String HouzezInquiryAreaSizeKey = "e_meta[area-size]";
const String HouzezInquiryCountryKey = "e_meta[country]";
const String HouzezInquiryStateKey = "e_meta[state]";
const String HouzezInquiryCityKey = "e_meta[city]";
const String HouzezInquiryAreaKey = "e_meta[area]";
const String HouzezInquiryZipCodeKey = "e_meta[zipcode]";
const String HouzezPrivateNoteKey = "private_note";
const String HouzezInquiryMessageKey = "message";
const String HouzezInquiryFirstNameKey = "first_name";
const String HouzezInquiryLastNameKey = "last_name";
const String HouzezInquiryEmailKey = "email";
const String HouzezInquiryGdprKey = "gdpr_agreement";
const String HouzezInquiryMobileKey = "mobile";
const String HouzezUpdateInquiryIdKey = "enquiry_id";
const String HouzezInquiryActionKey = "action";
const String HouzezInquiryActionAddNewKey = "crm_add_new_enquiry";

const String HouzezAddLeadEmailKey = "email";
const String HouzezAddLeadPrefixKey = "prefix";
const String HouzezAddLeadFirstNameKey = "first_name";
const String HouzezAddLeadLastNameKey = "last_name";
const String HouzezAddLeadNameKey = "name";
const String HouzezAddLeadMobileKey = "mobile";
const String HouzezAddLeadHomePhoneKey = "home_phone";
const String HouzezAddLeadWorkPhoneKey = "work_phone";
const String HouzezAddLeadUserTypeKey = "user_type";
const String HouzezAddLeadAddressKey = "address";
const String HouzezAddLeadCountryKey = "country";
const String HouzezAddLeadCityKey = "city";
const String HouzezAddLeadStateKey = "state";
const String HouzezAddLeadZipKey = "zip";
const String HouzezAddLeadSourceKey = "source";
const String HouzezAddLeadFacebookKey = "facebook";
const String HouzezAddLeadTwitterKey = "twitter";
const String HouzezAddLeadLinkedInKey = "linkedin";
const String HouzezAddLeadPrivateNoteKey = "private_note";
const String HouzezAddLeadIdKey = "lead_id";

const String HouzezDealDetailTitleKey = "title";
const String HouzezDealDetailIdKey = "dealId";
const String HouzezDealDetailDisplayNameKey = "displayName";
const String HouzezDealDetailAgentNameKey = "agentName";
const String HouzezDealDetailActionDueDateKey = "actionDueDate";
const String HouzezDealDetailValueKey = "dealValue";
const String HouzezDealDetailEmailKey = "email";
const String HouzezDealDetailLastContactDateKey = "lastContactDate";
const String HouzezDealDetailNextActionKey = "nextAction";
const String HouzezDealDetailPhoneKey = "phone";
const String HouzezDealDetailStatusKey = "status";
const String HouzezDealAgentIdKey = "agentId";
const String HouzezDealContactNameIdKey = "contactDisplayName";

const String HouzezNonceVariable = "security";

const String HouzezNoteKey = "note";
const String HouzezBelongToKey = "belong_to";
const String HouzezNoteTypeKey = "note_type";
const String HouzezEnquiryKey = "enquiry";
const String HouzezLeadKey = "lead";
const String HouzezNoteIdKey = "note_id";
const String HouzezFetchInquiryKey = "inquiry";
const String HouzezFetchLeadKey = "leads";

const String HouzezDealSetNextActionKey = "crm_set_deal_next_action";
const String HouzezDealSetStatusKey = "crm_set_deal_status";
const String HouzezDealSetActionDueDateKey = "crm_set_action_due";
const String HouzezDealSetLastContactDateKey = "crm_set_last_contact_date";
const String HouzezDealUpdateIdKey = "deal_id";
const String HouzezDealUpdatePurposeKey = "purpose";
const String HouzezDealUpdateDataKey = "deal_data";
const String HouzezActionDueTypeKey = "actionDue";
const String HouzezLastContactTypeKey = "lastContact";

const String HouzezEmailToKey = "email_to";


const Map<String, String> AddInquiryKeyMapping = {
  INQUIRY_LEAD_ID: HouzezInquiryLeadIdKey,
  INQUIRY_ENQUIRY_TYPE: HouzezInquiryTypeKey,
  INQUIRY_PROPERTY_TYPE: HouzezInquiryPropertyTypeKey,
  INQUIRY_MIN_PRICE: HouzezInquiryMinPriceKey,
  INQUIRY_PRICE: HouzezInquiryPriceKey,
  INQUIRY_MIN_BEDS: HouzezInquiryMinBedsKey,
  INQUIRY_BEDS: HouzezInquiryBedsKey,
  INQUIRY_MIN_BATHS: HouzezInquiryMinBathsKey,
  INQUIRY_BATHS: HouzezInquiryBathsKey,
  INQUIRY_MIN_AREA: HouzezInquiryMinAreaKey,
  INQUIRY_AREA_SIZE: HouzezInquiryAreaSizeKey,
  INQUIRY_COUNTRY: HouzezInquiryCountryKey,
  INQUIRY_STATE: HouzezInquiryStateKey,
  INQUIRY_CITY: HouzezInquiryCityKey,
  INQUIRY_AREA: HouzezInquiryAreaKey,
  INQUIRY_ZIP_CODE: HouzezInquiryZipCodeKey,
  PRIVATE_NOTE: HouzezPrivateNoteKey,
  INQUIRY_MSG: HouzezInquiryMessageKey,
  INQUIRY_FIRST_NAME: HouzezInquiryFirstNameKey,
  INQUIRY_LAST_NAME: HouzezInquiryLastNameKey,
  INQUIRY_EMAIL: HouzezInquiryEmailKey,
  INQUIRY_GDPR: HouzezInquiryGdprKey,
  INQUIRY_MOBILE: HouzezInquiryMobileKey,
  UPDATE_INQUIRY_ID: HouzezUpdateInquiryIdKey,
  INQUIRY_ACTION: HouzezInquiryActionKey,
  INQUIRY_ACTION_ADD_NEW: HouzezInquiryActionAddNewKey,
};

const Map<String, String> AddLeadKeyMapping = {
  addLeadEmail: HouzezAddLeadEmailKey,
  addLeadPrefix: HouzezAddLeadPrefixKey,
  addLeadFirstName: HouzezAddLeadFirstNameKey,
  addLeadLastName: HouzezAddLeadLastNameKey,
  addLeadName: HouzezAddLeadNameKey,
  addLeadMobile: HouzezAddLeadMobileKey,
  addLeadHomePhone: HouzezAddLeadHomePhoneKey,
  addLeadWorkPhone: HouzezAddLeadWorkPhoneKey,
  addLeadUserType: HouzezAddLeadUserTypeKey,
  addLeadAddress: HouzezAddLeadAddressKey,
  addLeadCountry: HouzezAddLeadCountryKey,
  addLeadCity: HouzezAddLeadCityKey,
  addLeadState: HouzezAddLeadStateKey,
  addLeadZip: HouzezAddLeadZipKey,
  addLeadSource: HouzezAddLeadSourceKey,
  addLeadFacebook: HouzezAddLeadFacebookKey,
  addLeadTwitter: HouzezAddLeadTwitterKey,
  addLeadLinkedIn: HouzezAddLeadLinkedInKey,
  addLeadPrivateNote: HouzezAddLeadPrivateNoteKey,
  addLeadId: HouzezAddLeadIdKey,
};

const Map<String, String> AddDealKeyMapping = {
  DEAL_DETAIL_TITLE: HouzezDealDetailTitleKey,
  DEAL_DETAIL_ID: HouzezDealDetailIdKey,
  DEAL_DETAIL_DISPLAY_NAME: HouzezDealDetailDisplayNameKey,
  DEAL_DETAIL_AGENT_NAME: HouzezDealDetailAgentNameKey,
  DEAL_DETAIL_ACTION_DUE_DATE: HouzezDealDetailActionDueDateKey,
  DEAL_DETAIL_VALUE: HouzezDealDetailValueKey,
  DEAL_DETAIL_EMAIL: HouzezDealDetailEmailKey,
  DEAL_DETAIL_LAST_CONTACT_DATE: HouzezDealDetailLastContactDateKey,
  DEAL_DETAIL_NEXT_ACTION: HouzezDealDetailNextActionKey,
  DEAL_DETAIL_PHONE: HouzezDealDetailPhoneKey,
  DEAL_DETAIL_STATUS: HouzezDealDetailStatusKey,
  DEAL_AGENT_ID: HouzezDealAgentIdKey,
  DEAL_CONTACT_NAME_ID: HouzezDealContactNameIdKey
};

const Map<String, String> AddNotesKeyMapping = {
  NOTE: HouzezNoteKey,
  BELONG_TO: HouzezBelongToKey,
  NOTE_TYPE: HouzezNoteTypeKey,
  ENQUIRY: HouzezEnquiryKey,
  LEAD: HouzezLeadKey,
  NOTE_ID: HouzezNoteIdKey,
  FETCH_INQUIRY: HouzezFetchInquiryKey,
  FETCH_LEAD: HouzezFetchLeadKey
};

const Map<String, String> UpdateDealDetailsKeyMapping = {
  DEAL_SET_NEXT_ACTION: HouzezDealSetNextActionKey,
  DEAL_SET_STATUS: HouzezDealSetStatusKey,
  DEAL_SET_ACTION_DUE_DATE: HouzezDealSetActionDueDateKey,
  DEAL_SET_LAST_CONTACT_DATE: HouzezDealSetLastContactDateKey,
  DEAL_UPDATE_ID: HouzezDealUpdateIdKey,
  DEAL_UPDATE_PURPOSE: HouzezDealUpdatePurposeKey,
  DEAL_UPDATE_DATA: HouzezDealUpdateDataKey,
  ACTION_DUE_TYPE: HouzezActionDueTypeKey,
  LAST_CONTACT_TYPE: HouzezLastContactTypeKey,
};







class CRMApiHouzez implements CRMWebsiteApiServices {

  CRMApiUtilities crmApiUtilities = CRMApiUtilities();

  @override
  CRMApiParser getParser() {
    return CRMHouzezParser();
  }

  @override
  ApiRequest provideActivitiesFromBoardApi(int page, int perPage,int userId) {
    Map<String, dynamic> _params = {
      HouzezUserIdKey: "$userId",
      HouzezCpageKey: "$page",
      HouzezPerPageKey: "$perPage",
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideInquiriesFromBoardApi(int page, int perPage) {
    Map<String, dynamic> _params = {
      HouzezCpageKey: "$page",
      HouzezPerPageKey: "$perPage",
    };
    
    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_INQUIRIES_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideInquiryDetailMatchedFromBoardApi(String enquiryId, int propPage) {
    Map<String, dynamic> _params = {
      HouzezEnquiryIdKey: enquiryId,
      HouzezPropPageKey: "$propPage",
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_INQUIRY_MATCHED_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideLeadsInquiriesFromBoardApi(String leadId, int propPage) {
    Map<String, dynamic> _params = {
      HouzezLeadIdKey: leadId,
      HouzezPropPageKey: "$propPage",
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_LEAD_INQUIRIES_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideLeadsViewedFromBoardApi(String leadId, int propPage) {
    Map<String, dynamic> _params = {
      HouzezLeadIdKey: leadId,
      HouzezCpageKey: "$propPage",
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_LEAD_VIEWED_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideInquiryDetailNotesFromBoardApi(String enquiryId) {
    Map<String, dynamic> _params = {
      HouzezEnquiryIdKey: enquiryId,
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_INQUIRY_NOTES_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideLeadsDetailNotesFromBoardApi(String leadId) {
    Map<String, dynamic> _params = {
      HouzezLeadIdKey: leadId,
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_LEADS_NOTES_FROM_BOARD_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideLeadsFromActivityApi(int page, int userId) {
    Map<String, dynamic> _params = {
      HouzezUserIdKey: "$userId",
      HouzezCpageKey: "${1}",
    };
    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
      params: _params,
    );
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDealsFromActivityApi(int page, int userId) {
    Map<String, dynamic> _params = {
      HouzezUserIdKey: "$userId",
      HouzezCpageKey: "${1}",
    };
    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
      params: _params,
    );
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDealsFromBoardApi(int page,int perPage, String tab) {
    Map<String, dynamic> _params = {
      HouzezTabKey: tab,
      HouzezCpageKey: "$page",
      HouzezPerPageKey: "$perPage",
    };
    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_DEALS_FROM_BOARD_PATH,
      params: _params,
    );
    
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAddDealResponseApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {};

    AddDealKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ADD_DEALS_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }
  @override
  ApiRequest provideLeadsFromBoardApi(int page,int perPage) {
    Map<String, dynamic> _params = {
      HouzezCpageKey: "$page",
      HouzezPerPageKey: "$perPage",
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_LEADS_FROM_BOARD_PATH,
      params: _params,
    );
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDeleteDealApi(int id, String nonce) {
    Map<String, dynamic> _formParams= {
      HouzezDealIdKey: "$id",
      HouzezNonceVariable: nonce
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_DELETE_DEALS_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideAddInquiryApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {};

    // Populate _formParams with known keys
    AddInquiryKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ADD_INQUIRY_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAddCRMNotesApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezNonceVariable : nonce,
    };

    AddNotesKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ADD_CRM_NOTES_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideSendCRMEmailApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezIdsKey : params[IDS],
      HouzezEmailToKey : params[EMAIL_TO],
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_SEND_CRM_EMAIL_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideDeleteCRMNotesApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezNoteIdKey : params[NOTE_ID],
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_DELETE_CRM_NOTES_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideDeleteInquiryApi(int id) {
    Map<String, dynamic> _formParams = {
      HouzezIdsKey: "$id",
    };
    
    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_DELETE_INQUIRY_PATH,

    );
    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideDeleteLeadApi(id, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezLeadId01Key: "$id",
      HouzezNonceVariable: nonce
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_DELETE_LEADS_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideDealsAndLeadsFromActivityApi() {
    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
    );
    return ApiRequest(uri: uri);
  }
  
  @override
  ApiRequest provideAddLeadApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {};

    AddLeadKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_ADD_LEADS_PATH,
    );
    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideUpdateDealDetailsApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {};

    UpdateDealDetailsKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_UPDATE_DEAL_DETAIL_PATH,
    );
    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideCreateNonceApi(String nonceName) {
    Map<String, dynamic> _formParams = {
      HouzezCreateNonceKey : nonceName
    };

    Uri uri = crmApiUtilities.getUri(
      unEncodedPath: HOUZEZ_CREATE_NONCE_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  String provideAddNoteNonceKey() {
    return HouzezAddNoteNonceName;
  }

  @override
  String provideDealDeleteNonceKey() {
    return HouzezDealDeleteNonceName;
  }

  @override
  String provideLeadDeleteNonceKey() {
    return HouzezLeadDeleteNonceName;
  }
}