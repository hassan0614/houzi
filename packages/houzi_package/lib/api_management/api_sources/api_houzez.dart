import 'package:dio/dio.dart';
import 'package:houzi_package/api_management/api_utilities/api_utilities.dart';
import 'package:houzi_package/api_management/interfaces/api_interface.dart';
import 'package:houzi_package/api_management/interfaces/api_parser_interface.dart';
import 'package:houzi_package/api_management/parsers/houzez_parser.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_request.dart';
/// 
/// 
/// API ROUTES:
/// 
/// 
// const String HOUZEZ_ALL_PROPERTIES_PATH = "/wp-json/wp/v2/$REST_API_PROPERTIES_ROUTE";
String HOUZEZ_ALL_PROPERTIES_PATH = "/wp-json/wp/v2/$REST_API_PROPERTIES_ROUTE";
const String HOUZEZ_NEW_ALL_PROPERTIES_PATH = "/wp-json/houzez-mobile-api/v1/all-properties";
const String HOUZEZ_SIMILAR_PROPERTIES_PATH = "/wp-json/houzez-mobile-api/v1/similar-properties";
const String HOUZEZ_MULTIPLE_PROPERTIES_PATH = "/wp-json/wp/v2/properties";
const String HOUZEZ_PROPERTY_TYPES_META_DATA_PATH = "/wp-json/wp/v2/property_type";
const String HOUZEZ_PROPERTY_CITIES_META_DATA_PATH = "/wp-json/wp/v2/property_city";
const String HOUZEZ_SEARCH_PROPERTIES_PATH = "/wp-json/houzez-mobile-api/v1/search-properties";
const String HOUZEZ_META_DATA_PATH = "/wp-json/houzez-mobile-api/v1/touch-base";
// const String HOUZEZ_SEARCH_AGENCIES_PATH = "/wp-json/wp/v2/$REST_API_AGENCY_ROUTE";
String HOUZEZ_SEARCH_AGENCIES_PATH = "/wp-json/wp/v2/$REST_API_AGENCY_ROUTE";
// const String HOUZEZ_SEARCH_AGENTS_PATH = "/wp-json/wp/v2/$REST_API_AGENT_ROUTE";
String HOUZEZ_SEARCH_AGENTS_PATH = "/wp-json/wp/v2/$REST_API_AGENT_ROUTE";
const String HOUZEZ_CONTACT_PROPERTY_REALTOR_PATH = "/wp-json/houzez-mobile-api/v1/contact-property-agent";
const String HOUZEZ_CONTACT_REALTOR_PATH = "/wp-json/houzez-mobile-api/v1/contact-realtor";
const String HOUZEZ_CONTACT_DEVELOPER_PATH = "/wp-json/contact-us/v1/send-message";
const String HOUZEZ_SCHEDULE_A_TOUR_PATH = "/wp-json/houzez-mobile-api/v1/schedule-tour";
const String HOUZEZ_SAVE_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/save-property";
// const String HOUZEZ_ADD_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/add-property";
const String HOUZEZ_SAVE_PROPERTY_IMAGES_PATH = "/wp-json/houzez-mobile-api/v1/save-property-image";
const String SIGNIN_USER_PATH = "/wp-json/houzez-mobile-api/v1/signin";
const String HOUZEZ_SOCIAL_LOGIN_PATH = "/wp-json/houzez-mobile-api/v1/social-sign-on";
// const String JWT_Authentication_PATH = "/wp-json/jwt-auth/v1/token";
const String SIGNUP_API_LINK_PATH = "/wp-json/houzez-mobile-api/v1/signup";
const String FORGET_PASSWORD_API_LINK_PATH = "/wp-json/houzez-mobile-api/v1/reset-password";
const String HOUZEZ_SINGLE_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/property";
const String HOUZEZ_MY_PROPERTIES_PATH = "/wp-json/houzez-mobile-api/v1/my-properties";
// const String HOUZEZ_USERS_PROPERTIES_PATH = "/wp-json/wp/v2/properties";
const String HOUZEZ_USERS_DELETE_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/delete-property";
const String HOUZEZ_TERM_DATA_PATH = "/wp-json/houzez-mobile-api/v1/get-terms";
const String HOUZEZ_ADD_REMOVE_FROM_FAV_PATH = "/wp-json/houzez-mobile-api/v1/like-property";
const String HOUZEZ_FAV_PROPERTIES_PATH = "/wp-json/houzez-mobile-api/v1/favorite-properties";
const String HOUZEZ_UPDATE_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/update-property";
const String HOUZEZ_UPDATE_IMAGE_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/upload-property-image";
const String HOUZEZ_DELETE_PROPERTY_IMAGE_PATH = "/wp-json/houzez-mobile-api/v1/delete-property-image";
const String HOUZEZ_ADD_SAVED_SEARCH_PATH = "/wp-json/houzez-mobile-api/v1/save-search";
const String HOUZEZ_SAVED_SEARCHES_PATH = "/wp-json/houzez-mobile-api/v1/saved-searches";
const String HOUZEZ_LEAD_SAVED_SEARCHES_PATH = "/wp-json/houzez-mobile-api/v1/lead-saved-searches";
const String HOUZEZ_DELETE_SAVED_SEARCH_PATH = "/wp-json/houzez-mobile-api/v1/delete-saved-search";
const String HOUZEZ_SAVED_SEARCH_ARTICLE_PATH = "/wp-json/houzez-mobile-api/v1/view-saved-search";
const String HOUZEZ_ADD_REVIEW_ARTICLE_PATH = "/wp-json/houzez-mobile-api/v1/add-review";
const String HOUZEZ_REPORT_CONTENT_PATH = "/wp-json/houzez-mobile-api/v1/report-content";
const String HOUZEZ_ARTICLE_REVIEWS_PATH = "/wp-json/wp/v2/houzez_reviews";
const String HOUZEZ_USER_INFO_PATH = "/wp-json/houzez-mobile-api/v1/profile";
const String HOUZEZ_UPDATE_USER_PROFILE_PATH = "/wp-json/houzez-mobile-api/v1/update-profile";
const String HOUZEZ_UPDATE_USER_PROFILE_IMAGE_PATH = "/wp-json/houzez-mobile-api/v1/update-profile-photo";
const String HOUZEZ_FIX_PROFILE_IMAGE_PATH = "/wp-json/houzez-mobile-api/v1/fix-profile-pic";
const String HOUZEZ_SEARCH_AGENTS_PROFILE_IMAGE_PATH = "/wp-json/houzez-mobile-api/v1/update-profile-photo";
const String HOUZEZ_IS_FAV_PROPERTY = "/wp-json/houzez-mobile-api/v1/is-fav-property";
const String HOUZEZ_UPDATE_USER_PASSWORD_PROPERTY = "/wp-json/houzez-mobile-api/v1/update-password";
const String HOUZEZ_DELETE_USER_ACCOUNT_PROPERTY = "/wp-json/houzez-mobile-api/v1/delete-user-account";
const String HOUZEZ_SINGLE_ARTICLE_PERMA_LINK_PATH = "/wp-json/houzez-mobile-api/v1/property-by-permalink";
const String HOUZEZ_ADD_REQUEST_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/add-property-request";
const String HOUZEZ_AGENCY_ALL_AGENTS_PATH = "/wp-json/houzez-mobile-api/v1/agency-all-agents";
const String HOUZEZ_AGENCY_ADD_AGENT_PATH = "/wp-json/houzez-mobile-api/v1/add-new-agent";
const String HOUZEZ_AGENCY_EDIT_AGENT_PATH = "/wp-json/houzez-mobile-api/v1/edit-an-agent";
const String HOUZEZ_AGENCY_DELETE_AGENT_PATH = "/wp-json/houzez-mobile-api/v1/delete-an-agent";
const String HOUZEZ_USER_APPROVAL_STATUS_PATH = "/wp-json/houzez-mobile-api/v1/user-approval";
const String HOUZEZ_REVIEWS_APPROVE_PATH = "/wp-json/houzez-reviews/v1/approve/";
const String HOUZEZ_REVIEWS_REJECT_PATH = "/wp-json/houzez-reviews/v1/reject/";
const String HOUZEZ_REVIEWS_TRASH_PATH = "/wp-json/houzez-reviews/v1/trash/";
const String HOUZEZ_REVIEWS_SETTING_PATH = "/wp-json/houzez-mobile-api/v1/review-settings";
const String HOUZEZ_ADS_PATH = "/wp-json/wp/v2/ads";
const String HOUZEZ_ALL_USERS_PATH = "/wp-json/wp/v2/users";
const String HOUZEZ_ALL_USERS_PROPERTIES_PATH = "/wp-json/houzez-insights/v1/user-properties";
const String HOUZEZ_PROPERTIES_INSIGHTS_PATH = "/wp-json/houzez-insights/v1/property-insights";
const String HOUZEZ_USERS_INSIGHTS_PATH = "/wp-json/houzez-insights/v1/user-insights";
const String HOUZEZ_ALL_USERS_PATH_V2 = "/wp-json/houzez-mobile-api/v1/fetch-users";
const String HOUZEZ_USER_PAYMENT_STATUS_PATH = "/wp-json/houzez-mobile-api/v1/user-payment-status";
const String HOUZEZ_CREATE_NONCE_PATH = "/wp-json/houzez-mobile-api/v1/create-nonce";
const String HOUZEZ_USERS_APPROVAL_STATUS_LIST_PATH = "/wp-json/houzez-mobile-api/v1/user-statuses";
// const String HOUZEZ_PRINT_PDF_PROPERTY_PATH = "/wp-json/houzez-mobile-api/v1/print-pdf-property";
const String HOUZEZ_PRINT_PDF_PROPERTY_PATH = "/print-property-pdf";
const String HOUZEZ_PARTNER_PATH = "/wp-json/wp/v2/houzez_partner";
const String HOUZEZ_MEMBERSHIP_PLAN_PATH = "/wp-json/wp/v2/houzez_packages";
const String HOUZEZ_PROCEED_WITH_PAYMENT_PATH = "/wp-json/houzez-mobile-api/v1/proceed-with-payment";
const String HOUZEZ_MAKE_PROPERTY_FEATURED_PATH = "/wp-json/houzez-mobile-api/v1/make-property-featured";
const String HOUZEZ_REMOVE_FROM_FEATURED_PATH = "/wp-json/houzez-mobile-api/v1/remove-from-featured";
const String HOUZEZ_USER_MEMBERSHIP_CURRENT_PACKAGE_PATH = "/wp-json/houzez-mobile-api/v1/user-current-package";
const String HOUZEZ_APPROVE_DISAPPROVE_PATH = "/wp-json/houzez-mobile-api/v1/admin-approve-disapprove";
const String HOUZEZ_TOGGLE_FEATURED_PATH = "/wp-json/houzez-mobile-api/v1/toggle-featured";
const String HOUZEZ_SOLD_LISTING_PATH = "/wp-json/houzez-mobile-api/v1/sold-listing";
const String HOUZEZ_EXPIRE_LISTING_PATH = "/wp-json/houzez-mobile-api/v1/expire-listing";
const String HOUZEZ_PENDING_LISTING_PATH = "/wp-json/houzez-mobile-api/v1/pending-listing";
const String ADMIN_ADD_USER_API_LINK_PATH = "/wp-json/houzez-mobile-api/v1/add-user";
const String ALL_NOTIFICATIONS_PATH = "/wp-json/houzez-mobile-api/v1/all-notifications";
const String CHECK_NOTIFICATIONS_PATH = "/wp-json/houzez-mobile-api/v1/check-notifications";
const String DELETE_NOTIFICATIONS_PATH = "/wp-json/houzez-mobile-api/v1/delete-notification";
const String HOUZEZ_ALL_REVIEWS_PATH = "/wp-json/wp/v2/get-reviews";
/// 
/// Blogs related
/// 
const String HOUZEZ_BLOGS_SEARCH_API_PATH = "/wp-json/houzez-mobile-api/v1/search-articles";
const String HOUZEZ_BLOGS_ALL_CATEGORIES_API_PATH = "/wp-json/houzez-mobile-api/v1/all-categories";
const String HOUZEZ_BLOGS_ALL_TAGS_API_PATH = "/wp-json/houzez-mobile-api/v1/all-tags";
const String HOUZEZ_BLOGS_ALL_COMMENTS_API_PATH = "/wp-json/houzez-mobile-api/v1/article-comments";
const String HOUZEZ_BLOGS_ADD_COMMENT_API_PATH = "/wp-json/houzez-mobile-api/v1/add-comment";
/// 
/// Messages related
/// 
const String HOUZEZ_ALL_MESSAGE_THREADS_API_PATH = "/wp-json/houzez-mobile-api/v1/all_threads";
const String HOUZEZ_DELETE_MESSAGE_THREAD_API_PATH = "/wp-json/houzez-mobile-api/v1/delete_thread";
const String HOUZEZ_START_MESSAGE_THREAD_API_PATH = "/wp-json/houzez-mobile-api/v1/start_thread";
const String HOUZEZ_ALL_THREAD_MESSAGES_API_PATH = "/wp-json/houzez-mobile-api/v1/all_messages";
const String HOUZEZ_SEND_MESSAGE_API_PATH = "/wp-json/houzez-mobile-api/v1/send_message";
/// 
/// 
/// API KEYS:
/// 
///
/// [COMMON KEYS]
const String HouzezPageKey = "page";
const String HouzezPerPageKey = "per_page";
const String HouzezPropertyIdKey = "property_id";
const String HouzezIdKey = "id";
const String HouzezVisibilityOnlyKey = "visible_only";
///
/// for [HOUZEZ REVIEWS KEYS]
const String HouzezEntityTypeKey = "entity_type";
///
/// For [LATEST PROPERTIES KEYS]
const String HouzezAgentAgencyInfoKey = "agent_agency_info";
///
/// For [HOUZEZ FEATURED PROPERTIES KEY]
const HouzezFaveFeaturedKey = "fave_featured";
const HouzezFeaturedKey = "featured";
///
/// For [HOUZEZ MULTIPLE PROPERTIES KEY]
const HouzezIncludeKey = "include";
///
/// For [HOUZEZ SINGLE PROPERTIES KEY]
const HouzezSingleListingEditingKey = "editing";
///
/// For [HOUZEZ PERMA-LINK PROPERTIES KEY]
const HouzezPermaLinkListingKey = "perm";
///
/// For [HOUZEZ AGENTS OF AGENCY KEY]
const HouzezAgentsOfAgencyKey = "fave_agent_agencies";
///
/// For [HOUZEZ TERMS KEYS]
const HouzezCityTermKey = "property_city";
const HouzezTypeTermKey = "property_type";
///
/// For [HOUZEZ FORGET PASSWORD API LINK KEYS]
const String HouzezForgetPasswordUserLogin = "user_login";
/// 
/// For [HOUZEZ ALL PROPERTIES KEYS]
const String HouzezStatusKey = "status";
///
/// For [HOUZEZ USERS DELETE PROPERTY KEYS]
const String HouzezPropertyDeleteId = "prop_id";
/// 
/// For [HOUZEZ ADD REMOVE FROM FAV KEYS]
const String HouzezPropertyFavListingId = "listing_id";
///
/// For [HOUZEZ AGENCY DELETE AGENT KEYS]
const HouzezDeleteAgentId = "agent_id";
/// 
/// For [HOUZEZ ADD REVIEW ARTICLE KEYS]
const String HouzezReviewTitle = 'review_title';
const String HouzezReviewStars = 'review_stars';
const String HouzezReviewKey = 'review';
const String HouzezReviewPostType = 'review_post_type';
const String HouzezReviewListingId = 'listing_id';
const String HouzezReviewListingTitle = 'listing_title';
const String HouzezReviewPermaLink = 'permalink';
/// 
/// For [HOUZEZ CONTACT DEVELOPER KEYS]
/// 
const String HouzezContactDeveloperSource = 'source';
const String HouzezContactDeveloperName = 'name';
const String HouzezContactDeveloperEmail = 'email';
const String HouzezContactDeveloperMessage = 'message';
const String HouzezContactDeveloperWebsite = 'website';
/// 
/// For [HOUZEZ SCHEDULE A TOUR KEYS]
/// 
const String HouzezScheduleATourAgentId = "agent_id";
const String HouzezScheduleATourAgentEmail = "target_email";
const String HouzezScheduleATourPhone = "phone";
const String HouzezScheduleATourName = "name";
const String HouzezScheduleATourEmail = "email";
const String HouzezScheduleATourMessage = "message";
const String HouzezScheduleATourPropertyId = "listing_id";
const String HouzezScheduleATourPropertyTitle = "property_title";
const String HouzezScheduleATourPropertyPermalink = "property_permalink";
const String HouzezScheduleATourTourType = "schedule_tour_type";
const String HouzezScheduleATourTime = "schedule_time";
const String HouzezScheduleATourDate = "schedule_date";
/// 
/// For [HOUZEZ CONTACT REALTOR KEYS]
/// 
const HouzezContactRealtorAgentId = "agent_id";
const HouzezContactRealtorTargetEmail = "target_email";
const HouzezNameKey = "name";
const HouzezEmailKey = "email";
const HouzezContactRealtorMobile = "mobile";
const HouzezMessageKey = "message";
const HouzezContactRealtorUserType = "user_type";
const HouzezContactRealtorAgentType = "agent_type";
const HouzezContactRealtorPropertyId = "property_id";
const HouzezContactRealtorPrivacyPolicyKey = "privacy_policy";
const HouzezListingIdKey = "listing_id";
const HouzezContactRealtorPropertyTitle = "property_title";
const HouzezContactRealtorPropertyPermalink = "property_permalink";
const HouzezContactRealtorSourceLink = "source_link";
const HouzezSourceKey = "source";
const HouzezWebsiteKey = "website";
const HouzezPhoneKey = "phone";
const HouzezReviewAgentIdKey = "review_agent_id";
const HouzezReviewAgencyIdKey = "review_agency_id";
const HouzezReviewAuthorIdKey = "review_author_id";
const String HouzezAgentRoleKey = 'houzez_agent';
const String HouzezAgencyRoleKey = 'houzez_agency';

///
/// For [HOUZEZ SCHEDULE A TOUR KEYS]
///
const String HouzezScheduleTourTypeKey = "schedule_tour_type";
const String HouzezScheduleTimeKey = "schedule_time";
const String HouzezScheduleDateKey = "schedule_date";
///
/// For [HOUZEZ SEARCH PROPERTIES KEYS]
/// 
const String HouzezSearchResultCurrentPage = "page";
const String HouzezSearchResultPerPage = "per_page";
const String HouzezSearchResultBedrooms = "bedrooms";
const String HouzezSearchResultBathrooms = "bathrooms";
const String HouzezSearchResultBedsBathsCriteria = "beds_baths_criteria";
const String HouzezSearchResultStatus = "status[]";
const String HouzezSearchResultType = "type[]";
const String HouzezSearchResultLabel = "label";
const String HouzezSearchResultLocation = "location[]";
const String HouzezSearchResultArea = "area[]";
const String HouzezSearchResultKeyword = "keyword";
const String HouzezSearchResultCountry = "country";
const String HouzezSearchResultState = "state";
const String HouzezSearchResultFeatures = "features[]";
const String HouzezSearchResultMaxArea = "max_area";
const String HouzezSearchResultMinArea = "min_area";
const String HouzezSearchResultMinPrice = "min_price";
const String HouzezSearchResultMaxPrice = "max_price";
const String HouzezSearchResultCustomFields = "custom_fields_values";
const String HouzezSearchResultFeatured = "featured";
const String HouzezSearchResultLat = 'search_lat';
const String HouzezSearchResultRadius = 'search_radius';
const String HouzezSearchResultLng = 'search_long';
const String HouzezSearchResultUseRadius = 'use_radius';
const String HouzezSearchResultSearchLocation = 'search_location';
const String HouzezSearchResultAgent = "fave_agents";
const String HouzezSearchResultAgency = "fave_property_agency";
const String HouzezSearchResultAuthor = "author_id";
const String HouzezSearchResultMetaKeyFilters = "meta_key_filters";
const String HouzezSearchResultKeywordFilters = "keyword_filters";
const String HouzezSearchResultCountryQueryType = "country_query_type";
const String HouzezSearchResultStateQueryType = "state_query_type";
const String HouzezSearchResultAreaQueryType = "area_query_type";
const String HouzezSearchResultStatusQueryType = "status_query_type";
const String HouzezSearchResultTypeQueryType = "type_query_type";
const String HouzezSearchResultLabelQueryType = "label_query_type";
const String HouzezSearchResultFeaturesQueryType = "features_query_type";

/// Add property data Map keys
const String HouzezAddNewListingActionKey = 'action';
const String HouzezAddNewListingAddPropertyActionKey = 'add_property';
const String HouzezAddNewListingUpdatePropertyActionKey = 'update_property';
const String HouzezUserIdKey = 'user_id';
const String HouzezAddNewListingTitleKey = 'prop_title';
const String HouzezAddNewListingDescriptionKey = 'prop_des';
const String HouzezAddNewListingTypeKey = 'prop_type[]';
const String HouzezAddNewListingStatusKey = 'prop_status[]';
const String HouzezAddNewListingMultiCurrencyDataKey = 'multi_currencies';
const String HouzezAddNewListingLabelsKey = 'prop_labels[]';
const String HouzezAddNewListingPriceKey = 'prop_price';
const String HouzezAddNewListingPricePostfixKey = 'prop_label';
const String HouzezAddNewListingPricePrefixKey = 'prop_price_prefix';
const String HouzezAddNewListingSecondPriceKey = 'prop_sec_price';
const String HouzezAddNewListingCurrencyKey = 'currency';
const String HouzezAddNewListingVideoUrlKey = 'prop_video_url';
const String HouzezAddNewListingBedroomsKey = 'prop_beds';
const String HouzezAddNewListingBathroomsKey = 'prop_baths';
const String HouzezAddNewListingSizeKey = 'prop_size';
const String HouzezAddNewListingSizePrefixKey = 'prop_size_prefix';
const String HouzezAddNewListingLandAreaKey = 'prop_land_area';
const String HouzezAddNewListingLandAreaPrefixKey = 'prop_land_area_prefix';
const String HouzezAddNewListingGarageKey = 'prop_garage';
const String HouzezAddNewListingGarageSizeKey = 'prop_garage_size';
const String HouzezAddNewListingYearBuiltKey = 'prop_year_built';
const String HouzezAddNewListingFeaturesListKey = 'prop_features[]';
const String HouzezAddNewListingMapAddressKey = 'property_map_address';
const String HouzezAddNewListingCountryKey = 'country';
const String HouzezAddNewListingStateOrCountyKey = 'administrative_area_level_1';
const String HouzezAddNewListingCityKey = 'locality';
const String HouzezAddNewListingAreaKey = 'neighborhood';
const String HouzezAddNewListingPostalCodeKey = 'postal_code';
const String HouzezAddNewListingLatitudeKey = 'lat';
const String HouzezAddNewListingLongitudeKey = 'lng';
const String HouzezAddNewListingVirtualTourKey = 'virtual_tour';
const String HouzezAddNewListingFloorPlansEnableKey = 'floorPlans_enable';
const String HouzezAddNewListingFloorPlansKey = 'floor_plans';
const String HouzezAddNewListingMultiUnitsKey = 'multiUnits';
const String HouzezAddNewListingFaveMultiUnitsKey = 'fave_multi_units';
const String HouzezAddNewListingFavePropertyMapKey = 'fave_property_map';
const String HouzezAddNewListingPropertyIdKey = 'property_id';
const String HouzezAddNewListingUserHasNoMembershipKey = 'user_submit_has_no_membership';
const String HouzezAddNewListingImagesIdsKey = 'propperty_image_ids[]';
const String HouzezAddNewListingFeaturedImageIdKey = 'featured_image_id';
const String HouzezAddNewListingFeaturedImageLocalIndex = 'featured_image_index';
const String HouzezAddNewListingFaveAgentDisplayOptionKey = 'fave_agent_display_option';
const String HouzezAddNewListingFaveAgentsKey = 'fave_agents[]';
const String HouzezAddNewListingFaveAgencyKey = 'fave_property_agency[]';
const String HouzezAddNewListingUploadStatusKey = 'add_property_upload_status';
const String HouzezAddNewListingUploadInProgressKey = 'in_progress';
const String HouzezAddNewListingUploadStatusPendingKey = 'pending';
const String HouzezAddNewListingAdditionalFeaturesKey = 'additional_features';
const String HouzezAddNewListingFaveMultiUnitsIdsKey = 'fave_multi_units_ids';
const String HouzezAddNewListingPropertyFeaturedKey = 'prop_featured';
const String HouzezAddNewListingLoginRequiredKey = 'login-required';
const String HouzezAddNewListingPricePlaceHolderKey = 'prop_price_placeholder';
const String HouzezAddNewListingShowPricePlaceHolderKey = 'show_price_placeholder';
const String HouzezAddNewListingPrivateNoteKey = 'fave_private_note';
const String HouzezAddNewListingDisclaimerKey = 'fave_property_disclaimer';
const String HouzezAddNewListingPendingImagesListKey = 'pending_images_list';
const String HouzezAddNewListingFeaturedImagesLocalIdKey = 'featured_image_local_id';
const String HouzezAddNewListingLocalIdKey= 'property_local_id';
const String HouzezAddNewListingLoggedInKey = 'property_logged_in';
const String HouzezAddNewListingNonceKey = 'addPropertyNonce';
const String HouzezAddNewListingImageNonceKey = 'addPropertyImageNonce';

const String HouzezListingsImagesUploadKey = "property_upload_file";
const String HouzezPOSTKey = "POST";
const String HouzezUserNameKey = 'username';
const String HouzezPasswordKey = 'password';
const String HouzezUserEmailKey = 'useremail';
const String HouzezTermConditionKey = 'term_condition';
const String HouzezRoleKey = 'role';
const String HouzezPhoneNumberKey = 'phone_number';
const String HouzezFirstNameKey = 'first_name';
const String HouzezLastNameKey = 'last_name';
const String HouzezRegisterPasswordKey = 'register_pass';
const String HouzezRetypeRegisterPasswordKey = 'register_pass_retype';
const String HouzezUserLoginKey = 'user_login';
const String HouzezAuthorKey = 'author';
const String HouzezTermStringKey = 'term';
const String HouzezTermListKey = 'term[]';
const String HouzezParentSlugKey = 'parent_slug';
const String HouzezSearchKey = 'search';
const String HouzezCPageKey = "cpage";
const String HouzezPostAuthorKey = "post_author";
const String HouzezThumbIdKey = 'thumb_id';
const String HouzezLeadIdKey = "lead-id";
const String HouzezReasonKey = "reason";
const String HouzezContentIdKey = "content_id";
const String HouzezContentTypeKey = "content_type";
const String HouzezReviewPropertyIdKey = 'review_property_id';
const String HouzezAgentCityKey = 'agent_city';
const String HouzezAgentCategoryKey = 'agent_category';

const String HouzezHeaderAuthorizationKey = 'Authorization';
const String HouzezHeaderBearerKey = 'Bearer';

const String HouzezImagePathKey = 'imagepath';
const String HouzezFileDataNameKey = 'houzez_file_data_name';

const String HouzezSaveSearchBedroomsKey = "bedrooms";
const String HouzezSaveSearchBathroomsKey = "bathrooms";
const String HouzezSaveSearchMinAreaKey = "min-area";
const String HouzezSaveSearchMaxAreaKey = "max-area";
const String HouzezSaveSearchMinPriceKey = "min-price";
const String HouzezSaveSearchMaxPriceKey = "max-price";
const String HouzezSaveSearchGarageKey = "garage";
const String HouzezSaveSearchYearBuiltKey = "year-built";

const String HouzezUserProfileNameKey = "username";
const String HouzezUserProfileEmailKey = "useremail";
const String HouzezUserProfileWhatsAppKey = "whatsapp";
const String HouzezUserProfileTitleKey = "title";
const String HouzezUserProfileFirstNameKey = "firstname";
const String HouzezUserProfileLastNameKey = "lastname";
const String HouzezUserProfileMobileKey = "usermobile";
const String HouzezUserProfilePhoneKey = "userphone";
const String HouzezUserProfileDescriptionKey = "bio";
const String HouzezUserProfileLanguageKey = "userlangs";
const String HouzezUserProfileCompanyKey = "user_company";
const String HouzezUserProfileTaxNumberKey = "tax_number";
const String HouzezUserProfileFaxNumberKey = "fax_number";
const String HouzezUserProfileAddressKey = "user_address";
const String HouzezUserProfileServiceAreaKey = "service_areas";
const String HouzezUserProfileSpecialitiesKey = "specialties";
const String HouzezUserProfileLicenseKey = "license";
const String HouzezUserProfileDisplayNameKey = "display_name";
const String HouzezUserProfileFacebookKey = "facebook";
const String HouzezUserProfileTwitterKey = "twitter";
const String HouzezUserProfileLinkedInKey = "linkedin";
const String HouzezUserProfileIntagramKey = "instagram";
const String HouzezUserProfileYouTubeKey = "youtube";
const String HouzezUserProfilePinterestKey = "pinterest";
const String HouzezUserProfileVimeoKey = "vimeo";
const String HouzezUserProfileSkypeKey = "skype";
const String HouzezUserProfileWebsiteKey = "website";
const String HouzezUserProfileLineIdKey = "line_id";
const String HouzezUserProfileTelegramKey = "telegram";
const String HouzezUserProfileAuthorPictureKey = "author_picture_id";

const HouzezSocialSignOnEmailKey = "email";
const HouzezSocialSignOnUserIdKey = "user_id";
const HouzezSocialSignOnPlatformKey = "source";
const HouzezSocialSignOnDisplayNameKey = "display_name";
const HouzezSocialSignOnProfileUrlKey = "profile_url";
const HouzezSocialSignOnUserNameKey = "username";

/// Update Password Related
const HouzezNewPasswordKey = "newpass";
const HouzezConfirmPasswordKey = "confirmpass";

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
const String HouzezInquiryPrivateNoteKey = "private_note";
const String HouzezInquiryMessageKey = "message";
const String HouzezInquiryFirstNameKey = "first_name";
const String HouzezInquiryLastNameKey = "last_name";
const String HouzezInquiryEmailKey = "email";
const String HouzezInquiryGdprKey = "gdpr_agreement";
const String HouzezInquiryMobileKey = "mobile";
const String HouzezUpdateInquiryIdKey = "enquiry_id";
const String HouzezInquiryActionKey = "action";
const String HouzezInquiryActionAddNewKey = "crm_add_new_enquiry";

const String HouzezAgentUserNameKey = "aa_username";
const String HouzezAgentEmailKey = "aa_email";
const String HouzezAgentFirstNameKey = "aa_firstname";
const String HouzezAgentLastNameKey = "aa_lastname";
const String HouzezAgentPasswordKey = "aa_password";
const String HouzezAgentSendEmailKey = "aa_notification";
const String HouzezAgencyUserIdKey = "agency_user_id";

const String HouzezAgencyIdKey = "agency_id";
const String HouzezAgentIdKey = "agent_id";

const String HouzezUserApprovalIdKey = "user_id";
const String HouzezUserApprovalActionKey = "action";
const String HouzezUserApprovalStatusKey = "approval_status";

const String HouzezReviewApprovalIdKey = "review_id";
const String HouzezReviewApprovalActionKey = "action";
const String HouzezReviewApprovalStatusKey = "approval_status";

const String HouzezPrintPropertyPDFKey = 'propid';

const String HouzezGoogleMapsKey = "Google_MAPS";
const String HouzezAppleMapsKey = "APPLE_MAPS";

const String HouzezActionKey = "action";

const String HouzezCreateNonceKey = "nonce_name";

const String HouzezContactRealtorNonceName = "contact_realtor_nonce";
const String HouzezAddAgentNonceName = "houzez_agency_agent_ajax_nonce";
const String HouzezEditAgentNonceName = "houzez_agency_agent_ajax_nonce";
const String HouzezDeleteAgentNonceName = "agent_delete_nonce";
const String HouzezScheduleTourNonceName = "schedule-contact-form-nonce";
const String HouzezContactPropertyRealtorNonceName = "property_agent_contact_nonce";
const String HouzezDealDeleteNonceName = "delete_deal_nonce";
const String HouzezLeadDeleteNonceName = "delete_lead_nonce";
const String HouzezAddNoteNonceName = "note_add_nonce";
const String HouzezAddPropertyNonceName = "add_property_nonce";
const String HouzezUpdatePropertyNonceName = "add_property_nonce";
const String HouzezAddImageNonceName = "verify_gallery_nonce";
const String HouzezDeleteImageNonceName = "verify_gallery_nonce";
const String HouzezAddReviewNonceName = "review-nonce";
const String HouzezReportContentNonceName = "report-nonce";
const String HouzezSaveSearchNonceName = "houzez-save-search-nounce";
const String HouzezSignUpNonceName = "houzez_register_nonce";
const String HouzezResetPasswordNonceName = "fave_resetpassword_nonce";
const String HouzezUpdatePasswordNonceName = "houzez_pass_ajax_nonce";
const String HouzezUpdateProfileNonceName = "houzez_profile_ajax_nonce";
const String HouzezUpdateProfileImageNonceName = "houzez_upload_nonce";
const String HouzezSignInNonceName = "login_nonce";
const String HouzezAddCommentNonceName = "comment_nonce";
const String HouzezStartMessageThreadNonceName = "property_agent_contact_nonce";
const String HouzezSendMessageNonceName = "start-thread-message-form-nonce";

const String HouzezContactRealtorNonceVariable = "contact_realtor_ajax";
const String HouzezAddAgentNonceVariable = "houzez-security-agency-agent";
const String HouzezEditAgentNonceVariable = "houzez-security-agency-agent";
const String HouzezDeleteAgentNonceVariable = "agent_delete_security";
const String HouzezScheduleTourNonceVariable = "schedule_contact_form_ajax";
const String HouzezContactPropertyAgentNonceVariable = "property_agent_contact_security";
const String HouzezDealDeleteNonceVariable = "security";
const String HouzezLeadDeleteNonceVariable = "security";
const String HouzezAddNoteNonceVariable = "security";
const String HouzezAddPropertyNonceVariable = "verify_add_prop_nonce";
const String HouzezUpdatePropertyNonceVariable = "verify_add_prop_nonce";
const String HouzezAddImageNonceVariable = "verify_nonce";
const String HouzezDeleteImageNonceVariable = "removeNonce";
const String HouzezAddReviewNonceVariable = "review-security";
const String HouzezReportContentNonceVariable = "report-security";
const String HouzezSaveSearchNonceVariable = "houzez_save_search_ajax";
const String HouzezSignUpNonceVariable = "houzez_register_security";
const String HouzezResetPasswordNonceVariable = "security";
const String HouzezUpdatePasswordNonceVariable = "houzez-security-pass";
const String HouzezUpdateProfileNonceVariable = "houzez-security-profile";
const String HouzezUpdateProfileImageNonceVariable = "verify_nonce";
const String HouzezSignInNonceVariable = "login_security";
const String HouzezAddCommentNonceVariable = "comment-security";
const String HouzezStartMessageThreadVariable = "start_thread_form_ajax";
const String HouzezSendMessageVariable = "start_thread_message_form_ajax";

const String HouzezInAppPurchaseKey = 'iap';
const String HouzezInAppPurchaseResponseKey = 'iap_response';
const String HouzezInAppPurchasePackageIdKey = 'pack_id';
const String HouzezInAppPurchasePropertyIdKey = 'prop_id';
const String HouzezInAppPurchasePropertyFeaturedKey = 'is_prop_featured';

const String HouzezMakeFeaturedListingPropertyIdKey = 'propid';
const String HouzezMakeFeaturedListingPropertyTypeKey = 'prop_type';

const String HouzezRemoveFromFeaturedPropertyIdKey = 'propid';

const String HouzezOrderKey = 'order';
const String HouzezOrderByKey = 'orderby';
const String HouzezPostIdKey = "post_id";

const String HouzezCommentContentKey = 'comment_content';
const String HouzezCommentPostIdKey = 'comment_post_ID';
const String HouzezCommentIsUpdateKey = 'is_update';
const String HouzezCommentIdKey = 'comment_ID';
const String HouzezCommentParentIdKey = 'comment_parent';
const String HouzezCommentAuthorEmailKey = 'comment_author_email';
const String HouzezCommentAuthorNameKey = 'comment_author';

const String HouzezNotificationIdKey = "notification_id";
const String HouzezNotificationUserEmailKey = "notification_user_email";

const String HouzezThreadIdKey = "thread_id";
const String HouzezSenderIdKey = "sender_id";
const String HouzezReceiverIdKey = "receiver_id";
const String HouzezSeenKey = "seen";

const String HouzezApproveStatusKey = 'approve';
const String HouzezDisApproveStatusKey = 'disapproved';
const String HouzezMarkFeaturedKey = 'houzez_mark_featured';
const String HouzezRemoveFeaturedKey = 'houzez_remove_featured';
const String HouzezMarkAsSoldKey = 'houzez_mark_as_sold';
const String HouzezExpiredListingKey = 'houzez_expire_listing';

const String HouzezTimePeriodKey = "time_period";
const String HouzezDataTypeKey = "data_type";

const String HouzezTimePeriodLastDay = "lastday";
const String HouzezTimePeriodLastWeek = "lastweek";
const String HouzezTimePeriodLastMonth = "lastmonth";
const String HouzezTimePeriodLastYear = "lastyear";
const List<String> allowedTimePeriodsKey = [
  HouzezTimePeriodLastDay,
  HouzezTimePeriodLastWeek,
  HouzezTimePeriodLastMonth,
  HouzezTimePeriodLastYear,
];
const String HouezOverviewDataTypeKey = 'overview';
const String HouzezViewsDataTypeKey = 'views';
const String HouzezTrafficDataTypeKey = 'traffic';
const String HouzezGeoDataTypeKey = 'geo';
const String HouzezDevicesDataTypeKey = 'devices';

const allowedDataTypeKeys = [
  HouezOverviewDataTypeKey,
  HouzezViewsDataTypeKey,
  HouzezTrafficDataTypeKey,
  HouzezGeoDataTypeKey,
  HouzezDevicesDataTypeKey,
];


const Map<String, String> AddUpdateListingKeyMapping = {
  ADD_PROPERTY_ACTION: HouzezAddNewListingActionKey,
  ADD_PROPERTY_ACTION_ADD: HouzezAddNewListingAddPropertyActionKey,
  ADD_PROPERTY_ACTION_UPDATE: HouzezAddNewListingUpdatePropertyActionKey,
  ADD_PROPERTY_USER_ID: HouzezUserIdKey,
  ADD_PROPERTY_TITLE: HouzezAddNewListingTitleKey,
  ADD_PROPERTY_DESCRIPTION: HouzezAddNewListingDescriptionKey,
  ADD_PROPERTY_TYPE: HouzezAddNewListingTypeKey,
  ADD_PROPERTY_STATUS: HouzezAddNewListingStatusKey,
  ADD_PROPERTY_LABELS: HouzezAddNewListingLabelsKey,
  ADD_PROPERTY_PRICE: HouzezAddNewListingPriceKey,
  ADD_PROPERTY_PRICE_POSTFIX: HouzezAddNewListingPricePostfixKey,
  ADD_PROPERTY_PRICE_PREFIX: HouzezAddNewListingPricePrefixKey,
  ADD_PROPERTY_SECOND_PRICE: HouzezAddNewListingSecondPriceKey,
  ADD_PROPERTY_CURRENCY: HouzezAddNewListingCurrencyKey,
  ADD_PROPERTY_VIDEO_URL: HouzezAddNewListingVideoUrlKey,
  ADD_PROPERTY_BEDROOMS: HouzezAddNewListingBedroomsKey,
  ADD_PROPERTY_BATHROOMS: HouzezAddNewListingBathroomsKey,
  ADD_PROPERTY_SIZE: HouzezAddNewListingSizeKey,
  ADD_PROPERTY_SIZE_PREFIX: HouzezAddNewListingSizePrefixKey,
  ADD_PROPERTY_LAND_AREA: HouzezAddNewListingLandAreaKey,
  ADD_PROPERTY_LAND_AREA_PREFIX: HouzezAddNewListingLandAreaPrefixKey,
  ADD_PROPERTY_GARAGE: HouzezAddNewListingGarageKey,
  ADD_PROPERTY_GARAGE_SIZE: HouzezAddNewListingGarageSizeKey,
  ADD_PROPERTY_YEAR_BUILT: HouzezAddNewListingYearBuiltKey,
  ADD_PROPERTY_FEATURES_LIST: HouzezAddNewListingFeaturesListKey,
  ADD_PROPERTY_MAP_ADDRESS: HouzezAddNewListingMapAddressKey,
  ADD_PROPERTY_COUNTRY: HouzezAddNewListingCountryKey,
  ADD_PROPERTY_STATE_OR_COUNTY: HouzezAddNewListingStateOrCountyKey,
  ADD_PROPERTY_CITY: HouzezAddNewListingCityKey,
  ADD_PROPERTY_AREA: HouzezAddNewListingAreaKey,
  ADD_PROPERTY_POSTAL_CODE: HouzezAddNewListingPostalCodeKey,
  ADD_PROPERTY_LATITUDE: HouzezAddNewListingLatitudeKey,
  ADD_PROPERTY_LONGITUDE: HouzezAddNewListingLongitudeKey,
  ADD_PROPERTY_VIRTUAL_TOUR: HouzezAddNewListingVirtualTourKey,
  ADD_PROPERTY_FLOOR_PLANS_ENABLE: HouzezAddNewListingFloorPlansEnableKey,
  ADD_PROPERTY_FLOOR_PLANS: HouzezAddNewListingFloorPlansKey,
  ADD_PROPERTY_MULTI_UNITS: HouzezAddNewListingMultiUnitsKey,
  ADD_PROPERTY_FAVE_MULTI_UNITS: HouzezAddNewListingFaveMultiUnitsKey,
  ADD_PROPERTY_FAVE_PROPERTY_MAP: HouzezAddNewListingFavePropertyMapKey,
  ADD_PROPERTY_PROPERTY_ID: HouzezAddNewListingPropertyIdKey,
  ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP: HouzezAddNewListingUserHasNoMembershipKey,
  ADD_PROPERTY_IMAGE_IDS: HouzezAddNewListingImagesIdsKey,
  ADD_PROPERTY_FEATURED_IMAGE_ID: HouzezAddNewListingFeaturedImageIdKey,
  ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX: HouzezAddNewListingFeaturedImageLocalIndex,
  ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION: HouzezAddNewListingFaveAgentDisplayOptionKey,
  ADD_PROPERTY_FAVE_AGENT: HouzezAddNewListingFaveAgentsKey,
  ADD_PROPERTY_FAVE_AGENCY: HouzezAddNewListingFaveAgencyKey,
  ADD_PROPERTY_UPLOAD_STATUS: HouzezAddNewListingUploadStatusKey,
  ADD_PROPERTY_UPLOAD_STATUS_IN_PROGRESS: HouzezAddNewListingUploadInProgressKey,
  ADD_PROPERTY_UPLOAD_STATUS_PENDING: HouzezAddNewListingUploadStatusPendingKey,
  ADD_PROPERTY_ADDITIONAL_FEATURES: HouzezAddNewListingAdditionalFeaturesKey,
  ADD_PROPERTY_FAVE_MULTI_UNITS_IDS: HouzezAddNewListingFaveMultiUnitsIdsKey,
  ADD_PROPERTY_PROPERTY_FEATURED: HouzezAddNewListingPropertyFeaturedKey,
  ADD_PROPERTY_LOGGED_IN_REQUIRED: HouzezAddNewListingLoginRequiredKey,
  ADD_PROPERTY_PRICE_PLACEHOLDER: HouzezAddNewListingPricePlaceHolderKey,
  ADD_PROPERTY_SHOW_PRICE_PLACEHOLDER: HouzezAddNewListingShowPricePlaceHolderKey,
  ADD_PROPERTY_PRIVATE_NOTE: HouzezAddNewListingPrivateNoteKey,
  ADD_PROPERTY_DISCLAIMER: HouzezAddNewListingDisclaimerKey,
  ADD_PROPERTY_PENDING_IMAGES_LIST: HouzezAddNewListingPendingImagesListKey,
  ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID: HouzezAddNewListingFeaturedImagesLocalIdKey,
  ADD_PROPERTY_LOCAL_ID: HouzezAddNewListingLocalIdKey,
  ADD_PROPERTY_LOGGED_IN: HouzezAddNewListingLoggedInKey,
  ADD_PROPERTY_NONCE: HouzezAddNewListingNonceKey,
  ADD_PROPERTY_IMAGE_NONCE: HouzezAddNewListingImageNonceKey,
};

const Map<String, String> SaveSearchesKeyMapping = {
  SAVE_SEARCH_MIN_PRICE : HouzezSaveSearchMinPriceKey,
  SAVE_SEARCH_MAX_PRICE : HouzezSaveSearchMaxPriceKey,
  SAVE_SEARCH_MIN_AREA : HouzezSaveSearchMinAreaKey,
  SAVE_SEARCH_MAX_AREA : HouzezSaveSearchMaxAreaKey,
  SAVE_SEARCH_BEDROOMS : HouzezSaveSearchBedroomsKey,
  SAVE_SEARCH_BATHROOMS : HouzezSaveSearchBathroomsKey,
  SAVE_SEARCH_GARAGE : HouzezSaveSearchGarageKey,
  SAVE_SEARCH_YAER_BUILT : HouzezSaveSearchYearBuiltKey,
};

const Map<String, String> SearchKeyMapping = {
  SEARCH_RESULTS_CURRENT_PAGE: HouzezSearchResultCurrentPage,
  SEARCH_RESULTS_PER_PAGE: HouzezSearchResultPerPage,
  SEARCH_RESULTS_BEDROOMS: HouzezSearchResultBedrooms,
  SEARCH_RESULTS_BATHROOMS: HouzezSearchResultBathrooms,
  SEARCH_RESULTS_BEDS_BATHS_CRITERIA: HouzezSearchResultBedsBathsCriteria,
  SEARCH_RESULTS_STATUS: HouzezSearchResultStatus,
  SEARCH_RESULTS_TYPE: HouzezSearchResultType,
  SEARCH_RESULTS_LABEL: HouzezSearchResultLabel,
  SEARCH_RESULTS_LOCATION: HouzezSearchResultLocation,
  SEARCH_RESULTS_AREA: HouzezSearchResultArea,
  SEARCH_RESULTS_KEYWORD: HouzezSearchResultKeyword,
  SEARCH_RESULTS_COUNTRY: HouzezSearchResultCountry,
  SEARCH_RESULTS_STATE: HouzezSearchResultState,
  SEARCH_RESULTS_FEATURES: HouzezSearchResultFeatures,
  SEARCH_RESULTS_MAX_AREA: HouzezSearchResultMaxArea,
  SEARCH_RESULTS_MIN_AREA: HouzezSearchResultMinArea,
  SEARCH_RESULTS_MIN_PRICE: HouzezSearchResultMinPrice,
  SEARCH_RESULTS_MAX_PRICE: HouzezSearchResultMaxPrice,
  LATITUDE: HouzezSearchResultLat,
  RADIUS: HouzezSearchResultRadius,
  LONGITUDE: HouzezSearchResultLng,
  USE_RADIUS: HouzezSearchResultUseRadius,
  SEARCH_LOCATION: HouzezSearchResultSearchLocation,
  SEARCH_RESULTS_FEATURED: HouzezSearchResultFeatured,
  REALTOR_SEARCH_AGENT: HouzezSearchResultAgent,
  REALTOR_SEARCH_AGENCY: HouzezSearchResultAgency,
  metaKeyFiltersKey: HouzezSearchResultMetaKeyFilters,
  keywordFiltersKey: HouzezSearchResultKeywordFilters,
  PROPERTY_COUNTRY_QUERY_TYPE: HouzezSearchResultCountryQueryType,
  PROPERTY_STATE_QUERY_TYPE: HouzezSearchResultStateQueryType,
  PROPERTY_AREA_QUERY_TYPE: HouzezSearchResultAreaQueryType,
  PROPERTY_STATUS_QUERY_TYPE: HouzezSearchResultStatusQueryType,
  PROPERTY_TYPE_QUERY_TYPE: HouzezSearchResultTypeQueryType,
  PROPERTY_LABEL_QUERY_TYPE: HouzezSearchResultLabelQueryType,
  PROPERTY_FEATURES_QUERY_TYPE: HouzezSearchResultFeaturesQueryType,
  AUTHOR_ID: HouzezSearchResultAuthor,
};

const Map<String, String> ReportContentKeyMapping = {
  MessageKey : HouzezMessageKey,
  NameKey : HouzezNameKey,
  EmailKey : HouzezEmailKey,
  PhoneKey : HouzezPhoneKey,
  ReasonKey : HouzezReasonKey,
  ContentIdKey : HouzezContentIdKey,
  ContentTypeKey : HouzezContentTypeKey,
};

const Map<String, String> UserProfileKeyMapping = {
  USER_NAME : HouzezUserProfileNameKey,
  USER_EMAIL: HouzezUserProfileEmailKey,
  USER_WHATSAPP: HouzezUserProfileWhatsAppKey,
  USER_TITLE: HouzezUserProfileTitleKey,
  FIRST_NAME: HouzezUserProfileFirstNameKey,
  LAST_NAME: HouzezUserProfileLastNameKey,
  USER_MOBILE: HouzezUserProfileMobileKey,
  USER_PHONE: HouzezUserProfilePhoneKey,
  DESCRIPTION: HouzezUserProfileDescriptionKey,
  USER_LANGS: HouzezUserProfileLanguageKey,
  USER_COMPANY: HouzezUserProfileCompanyKey,
  TAX_NUMBER: HouzezUserProfileTaxNumberKey,
  FAX_NUMBER: HouzezUserProfileFaxNumberKey,
  USER_ADDRESS: HouzezUserProfileAddressKey,
  SERVICE_AREA: HouzezUserProfileServiceAreaKey,
  SPECIALITIES: HouzezUserProfileSpecialitiesKey,
  LICENSE: HouzezUserProfileLicenseKey,
  DISPLAY_NAME: HouzezUserProfileDisplayNameKey,
  FACEBOOK: HouzezUserProfileFacebookKey,
  TWITTER: HouzezUserProfileTwitterKey,
  LINKEDIN: HouzezUserProfileLinkedInKey,
  INSTAGRAM: HouzezUserProfileIntagramKey,
  YOUTUBE: HouzezUserProfileYouTubeKey,
  PINTEREST: HouzezUserProfilePinterestKey,
  VIMEO: HouzezUserProfileVimeoKey,
  SKYPE: HouzezUserProfileSkypeKey,
  WEBSITE: HouzezUserProfileWebsiteKey,
  LINE_ID: HouzezUserProfileLineIdKey,
  TELEGRAM: HouzezUserProfileTelegramKey,
  PICTURE_ID: HouzezUserProfileAuthorPictureKey,
};

const Map<String, String> SocialSignOnKeyMapping = {
  USER_SOCIAL_EMAIL: HouzezSocialSignOnEmailKey,
  USER_SOCIAL_ID: HouzezSocialSignOnUserIdKey,
  USER_SOCIAL_PLATFORM: HouzezSocialSignOnPlatformKey,
  USER_SOCIAL_DISPLAY_NAME: HouzezSocialSignOnDisplayNameKey,
  USER_SOCIAL_PROFILE_URL: HouzezSocialSignOnProfileUrlKey,
  USER_SOCIAL_USER_NAME: HouzezSocialSignOnUserNameKey,
};

const Map<String, String> RequestPropertyKeyMapping = {
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
  PRIVATE_NOTE: HouzezInquiryPrivateNoteKey,
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

const Map<String, String> AddEditAgentKeyMapping = {
  agentUserName: HouzezAgentUserNameKey,
  agentEmail: HouzezAgentEmailKey,
  agentFirstName: HouzezAgentFirstNameKey,
  agentLastName: HouzezAgentLastNameKey,
  agentCategory: HouzezAgentCategoryKey,
  agentCity: HouzezAgentCityKey,
  agentPassword: HouzezAgentPasswordKey,
  agentSendEmail: HouzezAgentSendEmailKey,
  agencyUserId: HouzezAgencyUserIdKey,
};

const Map<String, String> AddCommentKeyMapping = {
  COMMENT_CONTENT: HouzezCommentContentKey,
  COMMENT_POST_ID: HouzezCommentPostIdKey,
  COMMENT_IS_UPDATE: HouzezCommentIsUpdateKey,
  COMMENT_ID: HouzezCommentIdKey,
  COMMENT_PARENT_ID: HouzezCommentParentIdKey,
  COMMENT_AUTHOR_EMAIL: HouzezCommentAuthorEmailKey,
  COMMENT_AUTHOR_NAME: HouzezCommentAuthorNameKey,
};




class ApiHouzez implements WebsiteApiServices {
  
  ApiUtilities appUtility = ApiUtilities();

  @override
  ApiParser getParser() {
    return HouzezParser();
  }
  
  @override
  ApiRequest featuredPropertiesApi({int? page, int? perPage}) {
    Map<String, dynamic> _formParams = {
      HouzezFeaturedKey : "1",
      HouzezPageKey : page != null ? "$page" : DefaultPage,
      HouzezPerPageKey : perPage != null ? "$perPage" : "$FeaturedPropertiesPerPageListings",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_PROPERTIES_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest latestPropertiesApi({int? page, int? perPage}) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page != null ? "$page" : DefaultPage,
      HouzezPerPageKey : perPage != null ? "$perPage" : "$LatestPropertiesPerPageListings",
      HouzezAgentAgencyInfoKey : "yes",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_PROPERTIES_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest filteredPropertiesApi({Map<String, dynamic>? params}) {
    Map<String, dynamic> _formParams = {};
    if (params != null) {

      SearchKeyMapping.forEach((localKey, houzezKey) {
        if (params.containsKey(localKey)) {
          _formParams[houzezKey] = params[localKey];
        }
      });

      Map<String, dynamic> customFieldsMap = Map.fromEntries(
          params.entries.where((entry) => entry.key.startsWith("custom_fields_values["))
      );
      if (customFieldsMap.isNotEmpty) {
        _formParams.addAll(customFieldsMap);
      }
    }

    var uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_PROPERTIES_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest similarPropertiesApi(int propertyId) {
    Map<String, dynamic> _params = {
      HouzezPropertyIdKey: '$propertyId'
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SIMILAR_PROPERTIES_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest multiplePropertiesApi(String propertiesId) {
    Map<String, dynamic> _params = {
      HouzezIncludeKey : propertiesId
    };

    Uri tempUri = appUtility.getUri(
        unEncodedPath: "$HOUZEZ_MULTIPLE_PROPERTIES_PATH",
        params: _params
    );

    String str = tempUri.toString();
    str = UtilityMethods.parseHtmlString(str);
    if (str.contains("%3F")) {
      str = str.replaceAll("%3F", "?");
    }
    if (str.contains("%2C")) {
      str = str.replaceAll("%2C", ",");
    }

    Uri uri = Uri.parse(str);

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest singlePropertyApi(int id, {bool forEditing = false}) {
    Map<String, dynamic> _params = {};

    if (forEditing) {
      _params = {
        HouzezSingleListingEditingKey : '$forEditing',
        HouzezIdKey : '$id',
      };
    } else {
      _params = {HouzezIdKey : '$id'};
    }

    Uri uri = appUtility.getUri(
        unEncodedPath: HOUZEZ_SINGLE_PROPERTY_PATH,
        params: _params
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest singleArticleViaPermaLinkApi(String permaLink) {
    Map<String, dynamic> _params = {
      HouzezPermaLinkListingKey : permaLink
    };

    Uri tempUri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SINGLE_ARTICLE_PERMA_LINK_PATH,
      params: _params,
    );

    String str = tempUri.toString();
    str = UtilityMethods.parseHtmlString(str);
    if (str.contains("%3A")) {
      str = str.replaceAll("%3A", ":");
    }
    if (str.contains("%2F")) {
      str = str.replaceAll("%2F", "/");
    }

    Uri uri = Uri.parse(str);

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest touchBaseApi() {
    Uri uri = appUtility.getUri(
        unEncodedPath: HOUZEZ_META_DATA_PATH
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideSingleAgencyApi(int id) {
    Uri uri = appUtility.getUri(
      unEncodedPath: "$HOUZEZ_SEARCH_AGENCIES_PATH/$id",
    );
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideSingleAgentApi(int id) {
    Uri uri = appUtility.getUri(
      unEncodedPath: "$HOUZEZ_SEARCH_AGENTS_PATH/$id",
    );
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAgentsOfAgencyApi(int agencyId) {
    Map<String, dynamic> _params = {
      HouzezAgentsOfAgencyKey : "$agencyId",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_AGENTS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAllAgentsApi(int page, int perPage, bool? visibilityOnly) {
    Map<String, dynamic> _params = {
      HouzezPageKey : '$page',
      HouzezPerPageKey : '$perPage',
    };
if (visibilityOnly != null) {
    _params[HouzezVisibilityOnlyKey] = visibilityOnly.toString();
  }
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_AGENTS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAllAgenciesApi(int page, int perPage, bool? visibilityOnly) {
    Map<String, dynamic> _params = {
      HouzezPageKey : '$page',
      HouzezPerPageKey : '$perPage',
    };
  if (visibilityOnly != null) {
    _params[HouzezVisibilityOnlyKey] = visibilityOnly.toString();
  }
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_AGENCIES_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideListingsByCityApi(int id, int page, int perPage) {
    Map<String, dynamic> _params = {
      HouzezCityTermKey : "$id",
      HouzezPageKey : '$page',
      HouzezPerPageKey : '$perPage',
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_PROPERTIES_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideContactRealtorApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezContactRealtorNonceVariable] = nonce;

    if (params.containsKey(MobileKey)) {
      _formParams[HouzezContactRealtorMobile] = params[MobileKey];
    }

    if (params.containsKey(UserTypeKey)) {
      _formParams[HouzezContactRealtorUserType] = params[UserTypeKey];
    }

    if (params.containsKey(AgentTypeKey)) {
      _formParams[HouzezContactRealtorAgentType] = params[AgentTypeKey];
    }

    if (params.containsKey(AgentIdKey)) {
      _formParams[HouzezContactRealtorAgentId] = params[AgentIdKey];
    }

    if (params.containsKey(EmailKey)) {
      _formParams[HouzezEmailKey] = params[EmailKey];
    }

    if (params.containsKey(NameKey)) {
      _formParams[HouzezNameKey] = params[NameKey];
    }

    if (params.containsKey(MessageKey)) {
      _formParams[HouzezMessageKey] = params[MessageKey];
    }
    //attempt - make it backward compatible.
    if (params.containsKey(TargetEmailKey)) {
      _formParams[HouzezContactRealtorTargetEmail] = params[TargetEmailKey];
    }

    _formParams[HouzezContactRealtorPrivacyPolicyKey] = "1";

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_CONTACT_REALTOR_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }
  @override
  ApiRequest provideContactPropertyRealtorApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezContactPropertyAgentNonceVariable] = nonce;

    if (params.containsKey(AgentIdKey)) {
      _formParams[HouzezContactRealtorAgentId] = params[AgentIdKey];
    }

    if (params.containsKey(TargetEmailKey)) {
      _formParams[HouzezContactRealtorTargetEmail] = params[TargetEmailKey];
    }

    if (params.containsKey(NameKey)) {
      _formParams[HouzezNameKey] = params[NameKey];
    }

    if (params.containsKey(EmailKey)) {
      _formParams[HouzezEmailKey] = params[EmailKey];
    }

    if (params.containsKey(MobileKey)) {
      _formParams[HouzezContactRealtorMobile] = params[MobileKey];
    }

    if (params.containsKey(MessageKey)) {
      _formParams[HouzezMessageKey] = params[MessageKey];
    }

    if (params.containsKey(UserTypeKey)) {
      _formParams[HouzezContactRealtorUserType] = params[UserTypeKey];
    }

    if (params.containsKey(AgentTypeKey)) {
      _formParams[HouzezContactRealtorAgentType] = params[AgentTypeKey];
    }

    if (params.containsKey(PropertyIdKey)) {
      _formParams[HouzezContactRealtorPropertyId] = params[PropertyIdKey];
    }

    if (params.containsKey(ListingIdKey)) {
      _formParams[HouzezListingIdKey] = params[ListingIdKey];
    }

    if (params.containsKey(PropertyTitleKey)) {
      _formParams[HouzezContactRealtorPropertyTitle] = params[PropertyTitleKey];
    }

    if (params.containsKey(PermaLinkKey)) {
      _formParams[HouzezContactRealtorPropertyPermalink] = params[PermaLinkKey];
    }

    if (params.containsKey(SourceLinkKey)) {
      _formParams[HouzezContactRealtorSourceLink] = params[SourceLinkKey];
    }

    if (params.containsKey(SourceKey)) {
      _formParams[HouzezSourceKey] = params[SourceKey];
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_CONTACT_PROPERTY_REALTOR_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }
  @override


  @override
  ApiRequest provideContactDeveloperApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {};

    if (params.containsKey(SourceKey)) {
      _formParams[HouzezSourceKey] = params[SourceKey];
    }

    if (params.containsKey(NameKey)) {
      _formParams[HouzezNameKey] = params[NameKey];
    }

    if (params.containsKey(EmailKey)) {
      _formParams[HouzezEmailKey] = params[EmailKey];
    }

    if (params.containsKey(MessageKey)) {
      _formParams[HouzezMessageKey] = params[MessageKey];
    }

    if (params.containsKey(WebsiteKey)) {
      _formParams[HouzezWebsiteKey] = params[WebsiteKey];
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_CONTACT_DEVELOPER_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideScheduleATourApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezScheduleTourNonceVariable] = nonce;

    if (params.containsKey(AgentIdKey)) {
      _formParams[HouzezContactRealtorAgentId] = params[AgentIdKey];
    }

    if (params.containsKey(TargetEmailKey)) {
      _formParams[HouzezContactRealtorTargetEmail] = params[TargetEmailKey];
    }

    if (params.containsKey(NameKey)) {
      _formParams[HouzezNameKey] = params[NameKey];
    }

    if (params.containsKey(EmailKey)) {
      _formParams[HouzezEmailKey] = params[EmailKey];
    }

    if (params.containsKey(MessageKey)) {
      _formParams[HouzezMessageKey] = params[MessageKey];
    }

    if (params.containsKey(PhoneKey)) {
      _formParams[HouzezPhoneKey] = params[PhoneKey];
    }

    if (params.containsKey(ListingIdKey)) {
      _formParams[HouzezListingIdKey] = params[ListingIdKey];
    }

    if (params.containsKey(PropertyTitleKey)) {
      _formParams[HouzezContactRealtorPropertyTitle] = params[PropertyTitleKey];
    }

    if (params.containsKey(PermaLinkKey)) {
      _formParams[HouzezContactRealtorPropertyPermalink] = params[PermaLinkKey];
    }

    if (params.containsKey(ScheduleTourTypeKey)) {
      _formParams[HouzezScheduleTourTypeKey] = params[ScheduleTourTypeKey];
    }

    if (params.containsKey(ScheduleTimeKey)) {
      _formParams[HouzezScheduleTimeKey] = params[ScheduleTimeKey];
    }

    if (params.containsKey(ScheduleDateKey)) {
      _formParams[HouzezScheduleDateKey] = params[ScheduleDateKey];
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SCHEDULE_A_TOUR_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAddNewListingApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezAddPropertyNonceVariable] = nonce;

    // Populate _formParams with known keys
    AddUpdateListingKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    // Identify remaining unknown key-value pairs in params
    // For adding the custom fields data etc.
    Set<String> knownKeys = AddUpdateListingKeyMapping.values.toSet();
    Map<String, dynamic> unknownEntries = {};

    params.forEach((key, value) {
      if (!knownKeys.contains(key)) {
        unknownEntries[key] = value;
      }
    });

    // Adding unknown keys to the _formParams
    if (unknownEntries.isNotEmpty) {
      _formParams.addAll(unknownEntries);
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SAVE_PROPERTY_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideUpdateListingApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezUpdatePropertyNonceVariable] = nonce;

    // Populate _formParams with known keys
    AddUpdateListingKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    // Identify remaining unknown key-value pairs in params
    // For adding the custom fields data
    Set<String> knownKeys = AddUpdateListingKeyMapping.values.toSet();
    Map<String, dynamic> unknownEntries = {};

    params.forEach((key, value) {
      if (!knownKeys.contains(key)) {
        unknownEntries[key] = value;
      }
    });

    // Adding unknown keys to the _formParams
    if (unknownEntries.isNotEmpty) {
      _formParams.addAll(unknownEntries);
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_UPDATE_PROPERTY_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideUploadListingImagesApi({required String userToken, required String userId, required String nonce}) {

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SAVE_PROPERTY_IMAGES_PATH,
    );

    Map<String, String> _headers = {HouzezHeaderAuthorizationKey: "$HouzezHeaderBearerKey $userToken"};
    Map<String, String> _fields = {HouzezUserIdKey: userId, HouzezAddImageNonceVariable : nonce};
    String _fileField = HouzezListingsImagesUploadKey;
    String _httpRequestMethod = HouzezPOSTKey;

    return ApiRequest(uri: uri, headers: _headers, fields: _fields, fileField: _fileField, httpRequestMethod: _httpRequestMethod);
  }

  @override
  ApiRequest provideLoginApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezSignInNonceVariable : nonce,
      HouzezUserNameKey : params[USER_NAME],
      HouzezPasswordKey : params[PASSWORD],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: SIGNIN_USER_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideSignUpApi(Map<String,dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezSignUpNonceVariable : nonce,
      HouzezUserNameKey : params[UserNameKey],
      HouzezUserEmailKey : params[UserEmailKey],
      HouzezTermConditionKey : params[TermConditionKey],
      HouzezRoleKey : params[RoleKey],
    };

    if (params.containsKey(PhoneNumberKey)) {
      _formParams[HouzezPhoneNumberKey] = params[PhoneNumberKey];
    }

    if (params.containsKey(FirstNameKey)) {
      _formParams[HouzezFirstNameKey] = params[FirstNameKey];
    }

    if (params.containsKey(LastNameKey)) {
      _formParams[HouzezLastNameKey] = params[LastNameKey];
    }

    if (params.containsKey(RegisterPasswordKey)) {
      _formParams[HouzezRegisterPasswordKey] = params[RegisterPasswordKey];
    }

    if (params.containsKey(RetypeRegisterPasswordKey)) {
      _formParams[HouzezRetypeRegisterPasswordKey] = params[RetypeRegisterPasswordKey];
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: SIGNUP_API_LINK_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAdminUserSignUpApi(Map<String, dynamic> params, String userToken, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezSignUpNonceVariable : nonce,
      HouzezUserNameKey : params[UserNameKey],
      HouzezUserEmailKey : params[UserEmailKey],
      HouzezTermConditionKey : params[TermConditionKey],
      HouzezRoleKey : params[RoleKey],
      HouzezRegisterPasswordKey : params[RegisterPasswordKey],
      HouzezRetypeRegisterPasswordKey : params[RetypeRegisterPasswordKey],
    };

    Map<String, String> _headerMap = {
      HouzezHeaderAuthorizationKey : "$HouzezHeaderBearerKey $userToken",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: ADMIN_ADD_USER_API_LINK_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, headers: _headerMap, handle500: true);
  }

  @override
  ApiRequest provideForgotPasswordApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezResetPasswordNonceVariable : nonce,
      HouzezUserLoginKey : params[UserLoginKey]
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: FORGET_PASSWORD_API_LINK_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAllPropertiesApi(String status, int page, int perPage, int? userId) {
    Map<String, dynamic> _params = {
      HouzezPageKey : "$page",
      HouzezPerPageKey: "$perPage",
      HouzezStatusKey: status,
    };
    if (userId != null) {
      _params[HouzezAuthorKey] = "$userId";
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_NEW_ALL_PROPERTIES_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideMyListingsApi(String status, int page, int perPage) {
    Map<String, dynamic> _params = {
      HouzezPageKey : "$page",
      HouzezPerPageKey: "$perPage",
      HouzezStatusKey: status,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_MY_PROPERTIES_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideStatusOfListingApi(Map<String, dynamic> params, int id) {
    Map<String, dynamic> _formParams = {
      HouzezStatusKey : params[StatusKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: '$HOUZEZ_ALL_PROPERTIES_PATH/$id',
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideDeleteListingApi(int id) {
    Map<String, dynamic> _params = {
      HouzezPropertyDeleteId: "$id",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_USERS_DELETE_PROPERTY_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideTermDataApi(dynamic termData,{String? parentSlug}) {
    Map<String, dynamic> _params = {};
    if (termData is String) {
      _params = {HouzezTermStringKey: termData};
    } else if (termData is List){
      _params = {HouzezTermListKey: termData};
    }
    if (parentSlug != null && parentSlug.isNotEmpty) {
      _params[HouzezParentSlugKey] = parentSlug;
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_TERM_DATA_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAddOrRemoveFavoritesApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezListingIdKey : params[ListingIdKey]
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ADD_REMOVE_FROM_FAV_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideSearchAgenciesApi(int page, int perPage, String search) {
    Map<String, dynamic> _params = {
      HouzezSearchKey : search,
      HouzezPageKey : "$page",
      HouzezPerPageKey : "$perPage",
      HouzezVisibilityOnlyKey: true.toString(),
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_AGENCIES_PATH,
      params: _params,
    );
    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideFavoriteListingsApi(int page, int perPage, String userId) {
    Map<String, dynamic> _params = {
      HouzezPostAuthorKey: userId,
      HouzezCPageKey: "$page",
      HouzezPerPageKey : "$perPage",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_FAV_PROPERTIES_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDeleteImageApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezDeleteImageNonceVariable : nonce,
      HouzezThumbIdKey : params[ThumbIdKey],
      HouzezPropertyDeleteId : params[UPDATE_PROPERTY_ID],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_DELETE_PROPERTY_IMAGE_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideSaveSearchApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezSaveSearchNonceVariable] = nonce;

    SaveSearchesKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    SearchKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    // Identify remaining unknown key-value pairs in params
    Set<String> knownKeys = SearchKeyMapping.values.toSet();
    Map<String, dynamic> unknownEntries = {};

    params.forEach((key, value) {
      if (!knownKeys.contains(key)) {
        unknownEntries[key] = value;
      }
    });

    // Adding unknown keys to the _formParams
    if (unknownEntries.isNotEmpty) {
      _formParams.addAll(unknownEntries);
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ADD_SAVED_SEARCH_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideSavedSearchesListingApi(int page, int perPage, {String? leadId, bool fetchLeadSavedSearches = false}) {
    String path = "";
    Map<String, dynamic> _params = {};

    if (fetchLeadSavedSearches && leadId != null && leadId.isNotEmpty) {
      path = HOUZEZ_LEAD_SAVED_SEARCHES_PATH;
      _params[HouzezLeadIdKey] = leadId;
      _params[HouzezCPageKey] = "$page";
    } else {
      path = HOUZEZ_SAVED_SEARCHES_PATH;
      _params[HouzezPerPageKey] = "$perPage";
      _params[HouzezCPageKey] = "$page";
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: path,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDeleteSavedSearchApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezIdKey : params[IdKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_DELETE_SAVED_SEARCH_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAddReviewApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezAddReviewNonceVariable : nonce,
      HouzezReviewTitle : params[REVIEW_TITLE],
      HouzezReviewStars : params[REVIEW_STARS],
      HouzezReviewKey : params[REVIEW],
      HouzezReviewPostType : params[REVIEW_POST_TYPE],
      HouzezReviewListingId :params[REVIEW_LISTING_ID],
      HouzezReviewListingTitle :params[REVIEW_LISTING_TITLE],
      HouzezReviewPermaLink : params[REVIEW_PERMA_LINK],
    };

    print(_formParams);

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ADD_REVIEW_ARTICLE_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideReportContentApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezReportContentNonceVariable] = nonce;

    ReportContentKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_REPORT_CONTENT_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideListingReviewsApi(int id, String page, String perPage) {
    Map<String, dynamic> _params = {
      HouzezReviewPropertyIdKey : "$id",
      HouzezPerPageKey: perPage,
      HouzezPageKey: page,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ARTICLE_REVIEWS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideRealtorReviewsApi(int id, String page, String perPage, String type) {
    String realtorId = "";
    if (type == HouzezAgentRoleKey) {
      realtorId = HouzezReviewAgentIdKey;
    } else if (type == HouzezAgencyRoleKey) {
      realtorId = HouzezReviewAgencyIdKey;
    } else {
      realtorId = HouzezReviewAuthorIdKey;
    }

    Map<String, dynamic> _params = {
      realtorId: "$id",
      HouzezPerPageKey: perPage,
      HouzezPageKey: page,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ARTICLE_REVIEWS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideUserInfoApi() {
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_USER_INFO_PATH,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideUpdateUserProfileApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {};

    _formParams[HouzezUpdateProfileNonceVariable] = nonce;

    UserProfileKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_UPDATE_USER_PROFILE_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideFixProfileImageApi() {
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_FIX_PROFILE_IMAGE_PATH,
    );

    return ApiRequest(uri: uri, handle500: true);
  }

  @override
  Future<ApiRequest> provideUpdateUserProfileImageApi(Map<String, dynamic> params, String nonce) async {
    String path = params[HouzezImagePathKey];
    String fileName = path.split('/').last;

    FormData _formData = FormData.fromMap({
      HouzezFileDataNameKey : await MultipartFile.fromFile(path, filename: fileName),
      HouzezUpdateProfileImageNonceVariable: nonce
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_UPDATE_USER_PROFILE_IMAGE_PATH,
    );

    return ApiRequest(uri: uri, formData: _formData, handle500: true);
  }

  @override
  ApiRequest provideSearchAgentsApi(int page, int perPage, String search, String agentCity, String agentCategory) {
    Map<String, dynamic> _params = {
      HouzezSearchKey: search,
      HouzezPerPageKey: "$perPage",
      HouzezPageKey: "$page",
      HouzezVisibilityOnlyKey: true.toString(),
    };

    if (agentCity.isNotEmpty) {
      _params[HouzezAgentCityKey] = agentCity;
    }
    if (agentCategory.isNotEmpty) {
      _params[HouzezAgentCategoryKey] = agentCategory;
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SEARCH_AGENTS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideIsFavoriteApi(String listingId) {
    Map<String, dynamic> _params = {
      HouzezListingIdKey: listingId,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_IS_FAV_PROPERTY,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideSocialSingOnApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezSignInNonceVariable : nonce,
    };

    SocialSignOnKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SOCIAL_LOGIN_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideDeleteUserAccountApi() {
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_DELETE_USER_ACCOUNT_PROPERTY,
    );

    return ApiRequest(uri: uri, handle500: true);
  }

  @override
  ApiRequest provideUpdateUserPasswordApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezUpdatePasswordNonceVariable : nonce,
      HouzezNewPasswordKey : params[NEW_PASSWORD_KEY],
      HouzezConfirmPasswordKey : params[CONFIRM_PASSWORD_KEY],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_UPDATE_USER_PASSWORD_PROPERTY,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideRequestPropertyApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {};

    RequestPropertyKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ADD_REQUEST_PROPERTY_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAddAgentApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezAddAgentNonceVariable : nonce,
    };

    AddEditAgentKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_AGENCY_ADD_AGENT_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideEditAgentApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezEditAgentNonceVariable : nonce,
    };

    AddEditAgentKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_AGENCY_EDIT_AGENT_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAllAgentOfAnAgencyApi(int agencyId) {
    Map<String, dynamic> _params = {
      HouzezAgencyIdKey : "$agencyId",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_AGENCY_ALL_AGENTS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDeleteAnAgentApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezDeleteAgentNonceVariable : nonce,
      HouzezAgentIdKey : params[AgentIdKey]
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_AGENCY_DELETE_AGENT_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideAllUsersApi(int page, int perPage, String search) {
    Map<String, dynamic> _params = {
      HouzezSearchKey: search,
      HouzezPerPageKey: "$perPage",
      HouzezPageKey: "$page",
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_USERS_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideUserApprovalApi(int userID, String action) {
    Map<String, dynamic> _params = {
      HouzezUserApprovalIdKey : "$userID",
      HouzezUserApprovalActionKey : action
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_USER_APPROVAL_STATUS_PATH,
      params: _params
    );

    return ApiRequest(uri: uri, formParams: _params, handle500: true);
  }

  @override
  ApiRequest provideAllUsersApiV2(
      int page, int perPage, String search, String? approvalStatus) {
    Map<String, dynamic> _params = {
      HouzezSearchKey: search,
      HouzezPerPageKey: "$perPage",
      HouzezPageKey: "$page",
    };
    if (approvalStatus != null && approvalStatus.isNotEmpty) {
      _params[HouzezUserApprovalStatusKey] = approvalStatus;
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_USERS_PATH_V2,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAllUsersProperties({int page = 1, int perPage = 100}) {
   Map<String, dynamic> _params = {
      HouzezPerPageKey: "$perPage",
      HouzezPageKey: "$page",
    };
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_USERS_PROPERTIES_PATH,
      params: _params
    );

    return ApiRequest(uri: uri);
  }

@override
ApiRequest provideUsersInsights({
  String? timePeriod,
  int? propertyId,
}) {
  String path = "";
  Map<String, dynamic> queryParams = {};

  if (propertyId != null) {
      path = "$HOUZEZ_USERS_INSIGHTS_PATH";
      queryParams[HouzezPropertyIdKey] = propertyId.toString();
      timePeriod ??= HouzezTimePeriodLastDay;
      queryParams[HouzezTimePeriodKey] = timePeriod.toString();

    } else {
      path = HOUZEZ_USERS_INSIGHTS_PATH;
      timePeriod ??= HouzezTimePeriodLastDay;
      queryParams[HouzezTimePeriodKey] = timePeriod.toString();
    }
  print(path);
  Uri uri = appUtility.getUri(
    unEncodedPath: path,
    params: queryParams,
  );
  return ApiRequest(uri: uri);
}

  @override
  ApiRequest providePropertyInsights(
      {int? propertyId,
      String? timePeriod,
      String? dataType}) {
  String path = "";



    Map<String, dynamic> _params = {};

    if (propertyId != null) {
      path = "$HOUZEZ_PROPERTIES_INSIGHTS_PATH/$propertyId";
      _params[HouzezDataTypeKey] = dataType.toString();
      _params[HouzezTimePeriodKey] = timePeriod.toString();

    } else {
      path = HOUZEZ_PROPERTIES_INSIGHTS_PATH;
    }
    Uri uri = appUtility.getUri(
      unEncodedPath: path,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideApprovalStatusListApi() {
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_USERS_APPROVAL_STATUS_LIST_PATH,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideUserPaymentStatusApi() {
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_USER_PAYMENT_STATUS_PATH,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest providePrintPropertyPDFApi(Map<String, dynamic> params) {
    Map<String, dynamic> _params = {
      HouzezPrintPropertyPDFKey : params[PrintPropertyPDFKey]
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_PRINT_PDF_PROPERTY_PATH,
      params: _params
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAllPartnersApi() {
    Uri uri = appUtility.getUri(
        unEncodedPath: HOUZEZ_PARTNER_PATH,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDirectionsApi(String platform, String latitude, String longitude) {
    String url = "";

    if (platform == HouzezAppleMapsKey) {
      url = "https://maps.apple.com/?daddr=$latitude,$longitude"
          "&dirflg=d";
    } else {
      url = "https://www.google.com/maps/dir/?api=1"
          "&destination=$latitude,$longitude"
          "&mode=driving";
      // "&dir_action=navigate"; // for starting navigation
    }

    Uri uri = Uri.parse(url);

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideMembershipPackagesApi(String page, String perPage) {
    Map<String, dynamic> _params = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_MEMBERSHIP_PLAN_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideUserMembershipPackageApi() {
    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_USER_MEMBERSHIP_CURRENT_PACKAGE_PATH,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideProceedWithPaymentsApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezInAppPurchaseKey : params[InAppPurchaseKey],
      HouzezInAppPurchaseResponseKey : params[InAppPurchaseResponseKey],
      HouzezInAppPurchasePackageIdKey : params[InAppPurchasePackageIdKey],
      HouzezInAppPurchasePropertyIdKey : params[InAppPurchasePropertyIdKey],
      HouzezInAppPurchasePropertyFeaturedKey : params[InAppPurchasePropertyFeaturedKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_PROCEED_WITH_PAYMENT_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideMakePropertyFeaturedApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezMakeFeaturedListingPropertyIdKey : params[MakeFeaturedListingPropertyIdKey],
      HouzezMakeFeaturedListingPropertyTypeKey : params[MakeFeaturedListingPropertyTypeKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_MAKE_PROPERTY_FEATURED_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideRemoveFromFeaturedApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezRemoveFromFeaturedPropertyIdKey : params[RemoveFromFeaturedPropertyIdKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_REMOVE_FROM_FEATURED_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams, handle500: true);
  }

  @override
  ApiRequest provideApproveOrDisapproveListingApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {

    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_APPROVE_DISAPPROVE_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideToggleFeaturedApi(int propertyId, bool setFeatured) {
    Map<String, dynamic> _formParams = {
      HouzezListingIdKey : propertyId,
      HouzezActionKey : setFeatured
          ? HouzezMarkFeaturedKey
          : HouzezRemoveFeaturedKey,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_TOGGLE_FEATURED_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideSetSoldStatusApi(int propertyId) {
    Map<String, dynamic> _formParams = {
      HouzezListingIdKey : propertyId,
      HouzezActionKey : HouzezMarkAsSoldKey,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_SOLD_LISTING_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideSetExpiredStatusApi(int propertyId) {
    Map<String, dynamic> _formParams = {
      HouzezListingIdKey : propertyId,
      HouzezActionKey : HouzezExpiredListingKey,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_EXPIRE_LISTING_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideSetPendingStatusApi(Map<String, dynamic> params) {
    Map<String, dynamic> _formParams = {
      HouzezListingIdKey : params[ListingIdKey],
      HouzezActionKey : params[ActionKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_PENDING_LISTING_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideAllBlogsApi(String page, String perPage) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_BLOGS_SEARCH_API_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

   @override
  ApiRequest provideInsightsApi(String page, String perPage) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_BLOGS_SEARCH_API_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideAllReviewsApi(String page, String perPage, String? entityType, String? search, String? status) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage,
      HouzezEntityTypeKey : entityType,
      HouzezSearchKey : search,
      HouzezStatusKey : status

    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_REVIEWS_PATH,
      params: _formParams,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }
  @override
  ApiRequest provideReviewsApprovalApi(int reviewID, bool isApprove) {
    final encodedPath = isApprove ? HOUZEZ_REVIEWS_APPROVE_PATH : HOUZEZ_REVIEWS_REJECT_PATH; 
    Uri uri = appUtility.getUri(
      unEncodedPath: "$encodedPath$reviewID",
      // params: _params
    );

    return ApiRequest(uri: uri, handle500: true);
  }
  
  @override
  ApiRequest provideReviewMoveToTrashApi(int reviewID) {
    Uri uri = appUtility.getUri(
      unEncodedPath: "$HOUZEZ_REVIEWS_TRASH_PATH$reviewID",
      // params: _params
    );

    return ApiRequest(uri: uri, handle500: true);
  }
  

  @override
  ApiRequest provideReviewSettingApi() {
    // Map<String, dynamic> _params = {
    //   HouzezReviewApprovalIdKey : "$reviewID",
    //   HouzezReviewApprovalActionKey : action
    // };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_REVIEWS_SETTING_PATH,
      // params: _params
    );

    return ApiRequest(uri: uri,  handle500: true);
  }

  @override
  ApiRequest provideAllBlogCategoriesApi(String orderBy, String order) {
    Map<String, dynamic> _params = {
      HouzezOrderByKey : orderBy,
      HouzezOrderKey : order,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_BLOGS_ALL_CATEGORIES_API_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAllBlogTagsApi(String orderBy, String order) {
    Map<String, dynamic> _params = {
      HouzezOrderByKey : orderBy,
      HouzezOrderKey : order,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_BLOGS_ALL_TAGS_API_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideBlogCommentsApi(String page, String perPage, String postId) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage,
      HouzezPostIdKey : postId,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_BLOGS_ALL_COMMENTS_API_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideAddBlogCommentApi(Map<String, dynamic> params, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezAddCommentNonceVariable : nonce
    };

    AddCommentKeyMapping.forEach((localKey, houzezKey) {
      if (params.containsKey(localKey)) {
        _formParams[houzezKey] = params[localKey];
      }
    });

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_BLOGS_ADD_COMMENT_API_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  ApiRequest provideAllNotificationsApi(String page, String perPage) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: ALL_NOTIFICATIONS_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  ApiRequest provideCheckNotificationsApi(String page, String perPage) {
    Map<String, dynamic> _formParams = {
      HouzezPageKey : page,
      HouzezPerPageKey : perPage
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: CHECK_NOTIFICATIONS_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  ApiRequest provideDeleteNotificationApi(String notificationId, String userEmail) {
    Map<String, dynamic> _formParams = {
      HouzezNotificationIdKey: notificationId,
      HouzezNotificationUserEmailKey: userEmail,
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: DELETE_NOTIFICATIONS_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideAllThreadsApi(int page, int perPage, int? propertyId) {
    Map<String, dynamic> queryParams = {
      HouzezPageKey: "$page",
      HouzezPerPageKey: "$perPage",
    };
    if (propertyId != null) {
      queryParams[HouzezPropertyIdKey] = "$propertyId";
    }

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_MESSAGE_THREADS_API_PATH,
      params: queryParams,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideAllMessagesApi(Map<String, dynamic> params) {
    Map<String, dynamic> _params = {
      HouzezPageKey : params[ThreadPageKey],
      HouzezPerPageKey : params[ThreadPerPageKey],
      HouzezSeenKey : params[SeenKey],
      HouzezThreadIdKey : params[ThreadIdKey],
      HouzezSenderIdKey : params[SenderIdKey],
      HouzezReceiverIdKey : params[ReceiverIdKey],
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_ALL_THREAD_MESSAGES_API_PATH,
      params: _params,
    );

    return ApiRequest(uri: uri);
  }

  @override
  ApiRequest provideDeleteThreadApi(String threadId, String senderId, String receiverId) {
    Map<String, dynamic> _formParams = {
      HouzezThreadIdKey : threadId,
      HouzezSenderIdKey : senderId,
      HouzezReceiverIdKey : receiverId,
    };

    Uri uri = appUtility.getUri(unEncodedPath: HOUZEZ_DELETE_MESSAGE_THREAD_API_PATH);

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideStartThreadApi(int propertyId, String message, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezStartMessageThreadVariable : nonce,
      HouzezPropertyIdKey : "$propertyId",
      HouzezMessageKey : message,
    };

    Uri uri = appUtility.getUri(unEncodedPath: HOUZEZ_START_MESSAGE_THREAD_API_PATH);

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  ApiRequest provideSendMessagesApi(String threadId, String message, String nonce) {
    Map<String, dynamic> _formParams = {
      HouzezSendMessageVariable : nonce,
      HouzezThreadIdKey : threadId,
      HouzezMessageKey : message,
    };

    Uri uri = appUtility.getUri(unEncodedPath: HOUZEZ_SEND_MESSAGE_API_PATH);

    return ApiRequest(uri: uri, formParams: _formParams);
  }

    ////////////////////////////////////////////////////////////////////////////
   //                    **** NONCE RELATED SECTION ****                     //
  ////////////////////////////////////////////////////////////////////////////

  @override
  ApiRequest provideCreateNonceApi(String nonceName) {
    Map<String, dynamic> _formParams = {
      HouzezCreateNonceKey : nonceName
    };

    Uri uri = appUtility.getUri(
      unEncodedPath: HOUZEZ_CREATE_NONCE_PATH,
    );

    return ApiRequest(uri: uri, formParams: _formParams);
  }

  @override
  String provideAddAgentNonceKey() {
    return HouzezAddAgentNonceName;
  }

  @override
  String provideAddCommentNonceKey() {
    return HouzezAddCommentNonceName;
  }

  @override
  String provideAddImageNonceKey() {
    return HouzezAddImageNonceName;
  }

  @override
  String provideAddPropertyNonceKey() {
    return HouzezAddPropertyNonceName;
  }

  @override

  String provideAddReviewNonceKey() {
    return HouzezAddReviewNonceName;
  }

  @override
  String provideContactPropertyRealtorNonceKey() {
    return HouzezContactPropertyRealtorNonceName;
  }
  @override
  String provideContactRealtorNonceKey() {
    return HouzezContactRealtorNonceName;
  }


  @override
  String provideDeleteAgentNonceKey() {
    return HouzezDeleteAgentNonceName;
  }

  @override
  String provideDeleteImageNonceKey() {
    return HouzezDeleteImageNonceName;
  }

  @override
  String provideEditAgentNonceKey() {
    return HouzezEditAgentNonceName;
  }

  @override
  String provideReportContentNonceKey() {
    return HouzezReportContentNonceName;
  }

  @override
  String provideResetPasswordNonceKey() {
    return HouzezResetPasswordNonceName;
  }

  @override
  String provideSaveSearchNonceKey() {
    return HouzezSaveSearchNonceName;
  }

  @override
  String provideScheduleATourNonceKey() {
    return HouzezScheduleTourNonceName;
  }

  @override
  String provideSendMessageNonceKey() {
    return HouzezSendMessageNonceName;
  }

  @override
  String provideSignInNonceKey() {
    return HouzezSignInNonceName;
  }

  @override
  String provideSignUpNonceKey() {
    return HouzezSignUpNonceName;
  }

  @override
  String provideStartThreadNonceKey() {
    return HouzezStartMessageThreadNonceName;
  }

  @override
  String provideUpdatePasswordNonceKey() {
    return HouzezUpdatePasswordNonceName;
  }

  @override
  String provideUpdateProfileImageNonceKey() {
    return HouzezUpdateProfileImageNonceName;
  }

  @override
  String provideUpdateProfileNonceKey() {
    return HouzezUpdateProfileNonceName;
  }

  @override
  String provideUpdatePropertyNonceKey() {
    return HouzezUpdatePropertyNonceName;
  }
}