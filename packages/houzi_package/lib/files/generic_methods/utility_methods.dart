import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/icons/cupertino_icons.dart';
import 'package:houzi_package/files/icons/material_icons.dart';
import 'package:houzi_package/models/blog_models/blog_details_page_layout.dart';
import 'package:houzi_package/models/messages/threads.dart';
import 'package:houzi_package/models/listing_related/currency_rate_model.dart';
import 'package:houzi_package/models/search/sort_first_by_item.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/models/navbar/navbar_item.dart';
import 'package:houzi_package/models/user/user_payment_status.dart';
import 'package:houzi_package/pages/add_property_v2/add_property_v2.dart';
import 'package:houzi_package/pages/in_app_purchase/membership_plan_page.dart';
import 'package:houzi_package/pages/in_app_purchase/payment_page.dart';
import 'package:houzi_package/pages/quick_add_property/quick_add_property.dart';
import 'package:houzi_package/pages/quick_add_property/quick_add_property_v2.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/l10n/string_extension.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/drawer/drawer.dart';
import 'package:houzi_package/models/home_related/home_config.dart';
import 'package:houzi_package/models/property_details/property_detail_page_config.dart';
import 'package:houzi_package/models/term.dart';
import 'package:houzi_package/pages/app_settings_pages/about.dart';
import 'package:houzi_package/pages/app_settings_pages/dark_mode_setting.dart';
import 'package:houzi_package/pages/app_settings_pages/language_settings.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/pages/property_details_page.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:houzi_package/pages/app_settings_pages/web_page.dart';

class UtilityMethods{
  
  CurrencyRatesModel selectCurrency = HiveStorageManager.readSelectedCurrency()!;

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initTrackingPermissionAndInitializeMobileAds(AppTrackingPermissionCallback trackingCallback) async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (trackingCallback != null) {
      trackingCallback(status:'$status');
    }
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      //await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      //await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
      if (trackingCallback != null) {
        trackingCallback(status:'$status');
      }
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("AppTrackingTransparency status: $status and UUID: $uuid");
    await MobileAds.instance.initialize();
  }

  static bool validateURL(String? url){
    if(url == null || url.isEmpty){
      return false;
    }
    bool isURLValid = Uri.parse(url).isAbsolute;
    return isURLValid;
  }

  static String getLocalizedString(String key,{List? inputWords}){
    if (inputWords == null) {
      String translated = key.localisedString([]) ?? key;
      if (translated == "null") {
        return key;
      }
      return key.localisedString([]) ?? key;
    } else {
      String translated = key.localisedString(inputWords) ?? key;
      if (translated == "null") {
        return key;
      }
      return key.localisedString(inputWords) ?? key;
    }
  }

  static bool isRTL(BuildContext context) {
    return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  static String toTitleCase(String inputString){
    return inputString.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => toCapitalized(str)).join(" ");
  }

  static String toCapitalized(String inputString) {
    return inputString.isNotEmpty ?'${inputString[0].toUpperCase()}${inputString.substring(1)}':'';
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  static String makePriceCompact(
  String inputPrice,
  String pricePrefix,
  String? currencySymbol, {
  bool priceOnly = false,
}) {
  CompactPriceFormatterHook compactPriceFormatterHook = HooksConfigurations.compactPriceFormatter;
  String? price = compactPriceFormatterHook(inputPrice);
  if (price != null) {
    return price;
  } else {
    String compactPrice = '';
    String postfix = '';
    String additionalCharacter = '';
    String defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? "\$";
    final selectCurrency = HiveStorageManager.readSelectedCurrency();

    String selectedSymbol = selectCurrency?.symbol ?? currencySymbol ?? defaultCurrency;


    RegExp pattern = RegExp(r"\b(\d+(\.\d+)?)(M|K)\b");
    if (pattern.hasMatch(inputPrice)) {
      return inputPrice;
    }

    // Remove currency symbols from input
    if (inputPrice.contains(defaultCurrency)) {
      inputPrice = inputPrice.replaceAll(defaultCurrency, '');
    } else if (currencySymbol != null && inputPrice.contains(currencySymbol)) {
      inputPrice = inputPrice.replaceAll(currencySymbol, '');
    } else if (selectCurrency != null && inputPrice.contains(selectCurrency.symbol)) {
      inputPrice = inputPrice.replaceAll(selectCurrency.symbol, '');
    }

    // Clean up input price
    inputPrice = inputPrice.replaceAll(',', '');

    if (inputPrice.contains('/')) {
      List<String> parts = inputPrice.split('/');
      inputPrice = parts[0];
      postfix = parts.length > 1 ? parts[1] : '';
    }

    if (inputPrice.contains('.')) {
      var priceDouble = double.tryParse(inputPrice);
      if (priceDouble == null) return inputPrice;
      inputPrice = priceDouble.toStringAsFixed(0);
    }

    if (inputPrice.contains('+')) {
      inputPrice = inputPrice.split('+')[0];
      additionalCharacter = "+";
    }

    if (inputPrice.contains('|')) {
      inputPrice = inputPrice.split('|')[0];
    }

    // Final price parse
    var priceDouble = double.tryParse(inputPrice);
    if (priceDouble == null) return inputPrice;

    // Multiply with selectedCurrency rate if available
    if (selectCurrency != null && selectCurrency.rate != null && selectCurrency.rate != 1.0) {
      priceDouble *= selectCurrency.rate;
    }

    compactPrice = NumberFormat.compact().format(priceDouble);

    if (priceOnly) {
      return compactPrice;
    }

    // Set currency symbol position
    compactPrice = setCurrencyPosition(compactPrice, selectedSymbol, defaultCurrency);

    if (postfix.isNotEmpty) {
      compactPrice = '$compactPrice/$postfix';
    }

    if (pricePrefix.isNotEmpty) {
      compactPrice = '$pricePrefix $compactPrice';
    }

    if (additionalCharacter.isNotEmpty) {
      compactPrice = '$compactPrice$additionalCharacter';
    }

    return compactPrice;
  }
}



  static String formatPrice(
  String inputPrice,
  String pricePrefix,
  String? currencySymbol,
  CurrencyRatesModel? selectCurrency,
) {
  String compactPrice = '';
  String postfix = '';
  String additionalCharacter = '';
  String defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? "\$";

  // Use selected currency symbol if available, else fallback
  String selectedSymbol = selectCurrency?.symbol ?? currencySymbol ?? defaultCurrency;

  RegExp pattern = RegExp(r"\b(\d+(\.\d+)?)(M|K)\b");
  if (pattern.hasMatch(inputPrice)) {
    return inputPrice;
  }

  // Remove any known currency symbols from input
  if (inputPrice.contains(defaultCurrency)) {
    inputPrice = inputPrice.replaceAll(defaultCurrency, '');
  }
  if (currencySymbol != null && inputPrice.contains(currencySymbol)) {
    inputPrice = inputPrice.replaceAll(currencySymbol, '');
  }
  if (selectCurrency != null && inputPrice.contains(selectCurrency.symbol)) {
    inputPrice = inputPrice.replaceAll(selectCurrency.symbol, '');
  }

  // Clean formatting characters
  inputPrice = inputPrice.replaceAll(',', '');
  if (inputPrice.contains('/')) {
    List<String> parts = inputPrice.split('/');
    inputPrice = parts[0];
    postfix = parts.length > 1 ? parts[1] : '';
  }

  if (inputPrice.contains('+')) {
    inputPrice = inputPrice.split('+')[0];
    additionalCharacter = "+";
  }

  if (inputPrice.contains('|')) {
    inputPrice = inputPrice.split('|')[0];
  }

  // Round decimal if exists
  if (inputPrice.contains('.')) {
    double? priceDouble = double.tryParse(inputPrice);
    if (priceDouble == null) return inputPrice;
    inputPrice = priceDouble.toStringAsFixed(0);
  }

  // Convert to double and apply conversion rate if applicable
  double? tempPrice = double.tryParse(inputPrice);
  if (tempPrice == null) return inputPrice;

  if (selectCurrency != null && selectCurrency.rate != null && selectCurrency.rate != 1.0) {
    tempPrice *= selectCurrency.rate;
  }

  compactPrice = getNumberFormat().format(tempPrice.round());

  // Set currency symbol based on selection
  compactPrice = setCurrencyPosition(compactPrice, selectedSymbol, defaultCurrency);

  // Append postfix, prefix, additional symbols
  if (postfix.isNotEmpty) {
    compactPrice = '$compactPrice/$postfix';
  }
  if (pricePrefix.isNotEmpty) {
    compactPrice = '$pricePrefix $compactPrice';
  }
  if (additionalCharacter.isNotEmpty) {
    compactPrice = '$compactPrice$additionalCharacter';
  }

  return compactPrice;
}


    // Function to get currency names from stored exchange rate data
Map<String, String> getCurrencyNamesMap(dynamic exchangeRateData) {
  Map<String, String> currencyNamesMap = {};
  
  if (exchangeRateData != null) {
    if (exchangeRateData is Map) {
      exchangeRateData.forEach((currencyCode, currencyDetails) {
        if (currencyDetails is Map && currencyDetails.containsKey('name')) {
          currencyNamesMap[currencyCode] = currencyDetails['name'].toString();
        }
      });
    }
    // If the data might be in serialized format
    else if (exchangeRateData is String) {
      try {
        final Map<String, dynamic> parsedData = jsonDecode(exchangeRateData);
        parsedData.forEach((currencyCode, currencyDetails) {
          if (currencyDetails is Map && currencyDetails.containsKey('name')) {
            currencyNamesMap[currencyCode] = currencyDetails['name'].toString();
          }
        });
      } catch (e) {
        print('Error parsing exchange rate data: $e');
      }
    }
  }
  
  return currencyNamesMap;
}

// Function to get a list of currency codes
List<String> getCurrencyCodes(dynamic exchangeRateData) {
  return getCurrencyNamesMap(exchangeRateData).keys.toList();
}

// Function to get a list of currency names
List<String> getCurrencyNames(dynamic exchangeRateData) {
  return getCurrencyNamesMap(exchangeRateData).values.toList();
}

// Function to get currency name by code
String getCurrencyNameByCode(dynamic exchangeRateData, String currencyCode) {
  final map = getCurrencyNamesMap(exchangeRateData);
  return map[currencyCode] ?? '';
}

// Function to retrieve data from Hive and extract currency information
Future<Map<String, String>> getStoredCurrencyNames() async {
  final exchangeRateData = await HiveStorageManager.readExchangeCurrencyMetaData();
  return getCurrencyNamesMap(exchangeRateData);
}





    static String priceFormatter(String propertyPrice, String firstPrice, String pricePrefix, String currencySymbol,) {
    PriceFormatterHook priceFormatterHook = HooksConfigurations.priceFormat;
    final  selectCurrency = HiveStorageManager.readSelectedCurrency();

    String? price = priceFormatterHook(propertyPrice, firstPrice);
    if (price != null) {
      return price;
    } else {
      String _propertyPrice = "";
      String _firstPrice = "";
      String _finalPrice = "";
      dynamic Function(dynamic) exchangeMetaData = HiveStorageManager.readExchangeCurrencyRate; 
      if (_propertyPrice != null && propertyPrice.isNotEmpty) {
        _propertyPrice = propertyPrice;
        _propertyPrice = formatPrice(_propertyPrice, pricePrefix, currencySymbol, selectCurrency);
      }
      if (firstPrice != null && firstPrice.isNotEmpty) {
        _firstPrice = firstPrice;
        _firstPrice = formatPrice(_firstPrice, pricePrefix, currencySymbol, selectCurrency);
      }

      _finalPrice = _firstPrice != null && _firstPrice.isNotEmpty
          ? _firstPrice
          : _propertyPrice;

      return _finalPrice;
    }

  }

  static int getCleanPriceForSorting(String propertyPrice) {
    int price = int.tryParse(propertyPrice.replaceAll(RegExp(r'[^\d]+'), '')) ?? 0;
    return price;
  }

  static String setCurrencyPosition(String price, String currencySymbol, String defaultCurrency){
    if (CURRENCY_POSITION == "after" ) {
      if(currencySymbol.isNotEmpty){
      return price = "$price $currencySymbol";
      } else {
        return price = "$price $defaultCurrency";
      }
    } else {
      if(currencySymbol.isNotEmpty){
      return price = "$currencySymbol$price";
      
      } else {
      return price = "$defaultCurrency$price";
       
      }
    }
  }

   static String getValueFromSerializedPhp({
   required dynamic item,
   required String key,
 }) {
   String serialized = '';
   if (item != null) {
     if (item is List && item.isNotEmpty && item[0] is String) {
       serialized = item[0];
     } else if (item is String) {
       serialized = item;
     }
   }
 
   if (serialized.isNotEmpty) {
     final pattern = RegExp(r'"' + RegExp.escape(key) + r'";s:\d+:"((?:[^"]|\\")*)"');
     final match = pattern.firstMatch(serialized);
     if (match != null) {
       return match.group(1) ?? "";
     }
   }
 
   return "";
 }
 static String? getValueFromSerializedMap({
   required Map inputMap,
   required String nestedKey,
   required String targetKey,
   required String key,
 
 }) {
   final meta = inputMap[key];
   if (meta is Map && meta[nestedKey] is List) {
     final serialized = meta[nestedKey][0];
     if (serialized is String) {
       final regex = RegExp(r's:\d+:"' + RegExp.escape(targetKey) + r'";s:\d+:"([^"]+)"');
       final match = regex.firstMatch(serialized);
       return match?.group(1);
     }
   }
   return null;
 }
  static NumberFormat getNumberFormat(){
    NumberFormat? numberFormat;
    if(THOUSAND_SEPARATOR == ",") {
      numberFormat =  NumberFormat("#$THOUSAND_SEPARATOR###$DECIMAL_POINT_SEPARATOR##");
    } else if(THOUSAND_SEPARATOR == ".") {
      numberFormat = NumberFormat.currency(locale: 'eu',customPattern: '#$DECIMAL_POINT_SEPARATOR###', decimalDigits: 0);

    } else if(THOUSAND_SEPARATOR == " ") {
      numberFormat = NumberFormat.currency(locale: 'fr',customPattern: '#,###', decimalDigits: 0);
    }
    return numberFormat!;
  }


  static void navigateToRoute({
    required context,
    required WidgetBuilder builder
  }){
    Route pageRoute = MaterialPageRoute(builder: builder);
    Navigator.push(context, pageRoute);

  }

  static void navigateToRouteByReplacement({
    required context,
    required WidgetBuilder builder
  }){
    Route pageRoute = MaterialPageRoute(builder: builder);
    Navigator.pushReplacement(context, pageRoute);
  }

  static void navigateToRouteByPushAndRemoveUntil({
    required context,
    required WidgetBuilder builder
  }){
    Route pageRoute = MaterialPageRoute(builder: builder);
    Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
    // Navigator.of(context).pushAndRemoveUntil(pageRoute, (Route<dynamic> route) => false);
  }



  static void navigateToSearchResultScreen({
    required BuildContext context,
    Map<String, dynamic>? dataInitializationMap,
    Map<String, dynamic>? searchRelatedData,
    final NavigateToSearchResultScreenListener? navigateToSearchResultScreenListener,
  }){
    builder(context) => SearchResult(
      dataInitializationMap: dataInitializationMap ?? {},
      searchRelatedData: searchRelatedData ?? {},
      searchPageListener: (Map<String, dynamic> map, String closeOption){
        if(closeOption == CLOSE){
          Navigator.of(context).pop();
          navigateToSearchResultScreenListener!(filterDataMap: HiveStorageManager.readFilterDataInfo());
        }
      },
    );
    UtilityMethods.navigateToRoute(context: context, builder: builder);
  }

  static List<int> getIdsForFeatures(List<dynamic> propertyFeaturesList,
      List<dynamic> propertyFeaturesListFromArticle) {
    List<int> featuresList = [];
    if ((propertyFeaturesList == null || propertyFeaturesList.isEmpty) &&
        (propertyFeaturesListFromArticle == null ||
            propertyFeaturesListFromArticle.isEmpty)) {
      return featuresList;
    } else {
      for (int i = 0; i < propertyFeaturesList.length; i++) {
        String tempName = propertyFeaturesList[i].name;
        int tempId = propertyFeaturesList[i].id;
        for (int i = 0; i < propertyFeaturesListFromArticle.length; i++) {
          if (propertyFeaturesListFromArticle[i] == tempName) {
            featuresList.add(tempId);
          }
        }
      }
    }
    return featuresList;
  }

  static Map<String, dynamic> iconMap = {
    "Bedrooms": Icons.king_bed_outlined,
    "Bathrooms": Icons.bathtub_outlined,
    "Garage": Icons.garage_outlined,
    "Rooms": Icons.meeting_room_outlined,
    "Gym": Icons.fitness_center_outlined,
    "Property Size": Icons.square_foot_outlined,
    "Year Built": Icons.calendar_today,
    "Air Conditioning": Icons.ac_unit_outlined,
    "Broadband": Icons.router_outlined,
    "WiFi": Icons.router_outlined,
    "Intercom": Icons.phone_in_talk_outlined,
    "Pay Tv": Icons.tv_outlined,
    "TV Cable": Icons.tv_outlined,
    "Pool": Icons.pool_outlined,
    "Swimming Pool": Icons.pool_outlined,
    "Security System": Icons.security_outlined,
    "Microwave": Icons.microwave,
    "Refrigerator": Icons.kitchen,
    "Washer": Icons.local_laundry_service,
    "Elevator": Icons.elevator,
    "Sliding Doors": Icons.door_sliding,
    "Security": Icons.security_outlined,
    "Fitted Kitchen": Icons.kitchen,
    "Guest Washroom": Icons.bathroom,
    "Laundry": Icons.local_laundry_service,
    "Washing Machine": Icons.local_laundry_service,
    "Bar": Icons.local_bar,
    "Fence": Icons.fence,
    "Heat Extractor": Icons.heat_pump,
    "Stove": Icons.date_range,
    "Lawn": Icons.grass,
    "Automated Gate": Icons.door_sliding,
    "Balcony": Icons.balcony,
    "Parking": Icons.garage_rounded,
    "for-rent": Icons.vpn_key_outlined,
    "for-sale": Icons.real_estate_agent_outlined,
    "commercial": Icons.storefront_outlined,
    "residential": Icons.apartment_outlined,
    "farmhouse": Icons.gite,
    "Window Coverings": Icons.roller_shades,
  };

  static String decodeUrlAndHtml(String encodedString) {
    // URL decode
    String urlDecodedString = Uri.decodeComponent(encodedString);

    // HTML decode
    var unescape = HtmlUnescape();
    String htmlDecodedString = unescape.convert(urlDecodedString);

    return htmlDecodedString;
  }

  static String cleanContent(String content, {bool decodeComponent = false}) {
    try {
      /// Only [decodeComponent = true] for URI clean
      if (content.contains("<p>")) {
        content = content.replaceAll("<p>", "").trim();
      }
      if (content.contains("</p>")) {
        content = content.replaceAll("</p>", "").trim();
      }
      var unescape = HtmlUnescape();
      content = unescape.convert(content).toString();
      if (content.contains("\\<.*?\\>")) {
        content = content.replaceAll("\\<.*?\\>", "").trim();
      }
      if (content.contains("+")) {
        content = content.replaceAll("+", " ").trim();
      }
      content = parseHtmlString(content,decodeComponent: decodeComponent);
      return content;
    } catch (e) {
      return content;
    }
  }

  static String parseHtmlString(String htmlString, {bool decodeComponent = false}) {
    try {
      final document = parse(htmlString);
      String parsedString = parse(document.body!.text).documentElement!.text;

      if (parsedString.contains("%3A")) {
        parsedString = parsedString.replaceAll("%3A", ":");
      }
      if (parsedString.contains("%2F")) {
        parsedString = parsedString.replaceAll("%2F", "/");
      }
      if (decodeComponent) {
        parsedString = Uri.decodeComponent(parsedString);
        return parsedString;
      }
      return parsedString;
    } catch (e) {
      return htmlString;
    }
  }

  static String chkRoleValueAndConvertToOption(String roleValue) {
    if (roleValue == ROLE_ADMINISTRATOR) {
      return ROLE_ADMINISTRATOR_CAPITAL;
    } else if (roleValue == USER_ROLE_AGENT_VALUE) {
      return USER_ROLE_AGENT_OPTION;
    } else if (roleValue == USER_ROLE_AGENCY_VALUE) {
      return USER_ROLE_AGENCY_OPTION;
    } else if (roleValue == USER_ROLE_OWNER_VALUE) {
      return USER_ROLE_OWNER_OPTION;
    } else if (roleValue == USER_ROLE_BUYER_VALUE) {
      return USER_ROLE_BUYER_OPTION;
    } else if (roleValue == USER_ROLE_SELLER_VALUE) {
      return USER_ROLE_SELLER_OPTION;
    } else if (roleValue == USER_ROLE_MANAGER_VALUE) {
      return USER_ROLE_MANAGER_OPTION;
    } else {
      return "";
    }
  }

  static String getSearchKey(subType) {
    if (subType == propertyTypeDataType) {
      return SEARCH_RESULTS_TYPE;
    } else if (subType == propertyStatusDataType) {
      return SEARCH_RESULTS_STATUS;
    } else if (subType == propertyFeatureDataType) {
      return SEARCH_RESULTS_FEATURES;
    } else if (subType == propertyLabelDataType) {
      return SEARCH_RESULTS_LABEL;
    } else if (subType == propertyStateDataType) {
      return SEARCH_RESULTS_STATE;
    } else if (subType == propertyAreaDataType) {
      return SEARCH_RESULTS_AREA;
    } else if (subType == propertyCityDataType) {
      return SEARCH_RESULTS_LOCATION;
    }

    return subType;
  }

  static String getSearchItemNameFilterKey(subType) {
    if (subType == propertyTypeDataType) {
      return PROPERTY_TYPE;
    } else if (subType == propertyStatusDataType) {
      return PROPERTY_STATUS;
    } else if (subType == propertyFeatureDataType) {
      return PROPERTY_FEATURES;
    } else if (subType == propertyLabelDataType) {
      return PROPERTY_LABEL;
    } else if (subType == propertyStateDataType) {
      return PROPERTY_STATE;
    } else if (subType == propertyAreaDataType) {
      return PROPERTY_AREA;
    } else if (subType == propertyCityDataType) {
      return CITY;
    } else if (subType == propertyCountryDataType) {
      return PROPERTY_COUNTRY;
    }

    return subType;
  }

  static String getSearchItemSlugFilterKey(subType) {
    if (subType == propertyTypeDataType) {
      return PROPERTY_TYPE_SLUG;
    } else if (subType == propertyStatusDataType) {
      return PROPERTY_STATUS_SLUG;
    } else if (subType == propertyFeatureDataType) {
      return PROPERTY_FEATURES_SLUG;
    } else if (subType == propertyLabelDataType) {
      return PROPERTY_LABEL_SLUG;
    } else if (subType == propertyStateDataType) {
      return PROPERTY_STATE_SLUG;
    } else if (subType == propertyAreaDataType) {
      return PROPERTY_AREA_SLUG;
    } else if (subType == propertyCityDataType) {
      return CITY_SLUG;
    } else if (subType == propertyCountryDataType) {
      return PROPERTY_COUNTRY_SLUG;
    }

    return subType;
  }

  static List getSubTypeItemRelatedList(String subtype, List subTypeValuesList) {
    List subTypeItemRelatedSlugsList = [];
    List subTypeItemRelatedNameList = [];
    List dataList = getPropertyMetaDataList(dataType: subtype) ?? [];
    if(dataList.isNotEmpty){
      for(var item in subTypeValuesList){
        if(item != allString && item != userSelectedString){
          var tempItem = dataList.firstWhereOrNull((element) => element.slug == item);
          if(tempItem != null){
            subTypeItemRelatedSlugsList.add(item);
            subTypeItemRelatedNameList.add(tempItem.name);
          }
        }
      }
    }

    return [subTypeItemRelatedSlugsList, subTypeItemRelatedNameList];
  }

  static Map<String, dynamic> convertMap(Map<dynamic, dynamic> inputMap){
    Map<String, dynamic> convertedMap =  <String, dynamic>{};
    if(inputMap.isNotEmpty){
      for (dynamic type in inputMap.keys) {
        convertedMap[type.toString()] = inputMap[type];
      }
    }
    return convertedMap;
  }

  static MaterialColor getMaterialColor(String hexValue){
    int? colorValue;

    if(hexValue.contains("#")){
      colorValue = int.parse(hexValue.substring(1), radix: 16);
    }

    Map<int, Color> colorCodes = {
      50: Color(colorValue!).withAlpha((255.0 * 0.1).round()),
      100: Color(colorValue).withAlpha((255.0 * 0.2).round()),
      200: Color(colorValue).withAlpha((255.0 * 0.3).round()),
      300: Color(colorValue).withAlpha((255.0 * 0.4).round()),
      400: Color(colorValue).withAlpha((255.0 * 0.5).round()),
      500: Color(colorValue).withAlpha((255.0 * 0.6).round()),
      600: Color(colorValue).withAlpha((255.0 * 0.7).round()),
      700: Color(colorValue).withAlpha((255.0 * 0.8).round()),
      800: Color(colorValue).withAlpha((255.0 * 0.9).round()),
      900: Color(colorValue).withAlpha((255.0 * 1.0).round()),
    };

    MaterialColor materialColor = MaterialColor(colorValue, colorCodes);
    return materialColor;
  }

  static Color getColorFromString(String hexValue){
    int? colorValue;
    if(hexValue.contains("#")){
      colorValue = int.parse(hexValue.substring(1), radix: 16);
    }
    return Color(colorValue!);
  }

  static IconData fromJsonToIconData(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    String name = map['name'] ?? "blur_on";
    String fontFamily = map['fontFamily'];
    if (fontFamily == "MaterialIcons") {
      return materialIcons[name] ?? Icons.blur_on;
    } else if (fontFamily == 'CupertinoIcons') {
      return cupertinoIcons[name] ?? Icons.blur_on;
    } else {
      return Icons.blur_on;
    }
  }

  static String getPlacesApiLockedCountriesFormattedString(String countriesString){
    String formattedString = '';
    if(countriesString != null && countriesString.isNotEmpty){
      if(countriesString.contains(",")){
        List tempList = countriesString.split(",");
        if(tempList.length > 1){
          for(int i = 0; i < (tempList.length); i++){
            if(tempList[i].isNotEmpty){
              formattedString = formattedString + "country:" + tempList[i];
              if((tempList.length) != (i+1)){
                formattedString = formattedString + "|";
              }
            }
          }
        }else{
          if(tempList[0].isNotEmpty){
            formattedString = formattedString + "country:" + tempList[0];
          }
        }
      }else{
        formattedString = formattedString + "country:" + countriesString;
      }
    }

    formattedString = formattedString.replaceAll(" ", "");

    return formattedString;
  }

  static userLogOut({
    required context,
    required WidgetBuilder builder
}){
    Provider.of<UserLoggedProvider>(context,listen: false).loggedOut();
    HiveStorageManager.deleteUserLoginInfoData();
    HiveStorageManager.deleteUserPaymentStatus();
    GeneralNotifier().publishChange(GeneralNotifier.USER_LOGGED_OUT);
    UtilityMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: builder);
  }

  static bool checkRTLDirectionality(Locale locale) {
    return Bidi.isRtlLanguage(locale.languageCode);
  }

  static saveHomeConfigFile(Map appConfigurationsData) {
    ApiManager api = ApiManager();
    HomeConfig config = api.parseHomeConfigJson(appConfigurationsData);
    Map configMap = api.convertHomeConfigToJson(config);
    HiveStorageManager.storeHomeConfigListData(configMap);
  }

  static List<dynamic> readHomeConfigFile() {
    return HiveStorageManager.readHomeConfigListData();
  }

  static saveBottomNavigationBarConfigFile(Map appConfigurationsData) {
    ApiManager api = ApiManager();
    NavBar config = api.parseNavBarJson(appConfigurationsData);
    Map configMap = api.convertNavBarToJson(config);
    HiveStorageManager.storeNavbarConfigData(configMap);
  }

  static List<NavbarItem> readBottomNavigationBarConfigFile() {
    return HiveStorageManager.readNavbarConfigData();
  }

  static saveDrawerConfigFile(Map appConfigurationsData) {
    ApiManager api = ApiManager();
    DrawerLayoutConfig config = api.parseDrawerLayoutConfigJson(appConfigurationsData);
    Map configMap = api.convertDrawerLayoutConfigToJson(config);
    HiveStorageManager.storeDrawerConfigListData(configMap);
  }

  static List<dynamic> readDrawerConfigFile(){
    return HiveStorageManager.readDrawerConfigListData();
  }

  static saveFilterPageConfigFile(Map appConfigurationsData) {
    List<dynamic> filterPageConfigElementsList = appConfigurationsData[searchPageLayoutConfiguration];
    HiveStorageManager.storeFilterConfigListData(json.encode(filterPageConfigElementsList));
  }

  static savePropertyDetailPageConfigFile(Map appConfigurationsData) {
    ApiManager api = ApiManager();
    PropertyDetailPageLayout config = api.parsePropertyDetailPageLayoutJson(appConfigurationsData);
    Map configMap = api.convertPropertyDetailPageLayoutToJson(config);
    HiveStorageManager.storePropertyDetailConfigListData(configMap);
  }

  static saveAddPropertyConfigFile(Map appConfigurationsData) {
    List<dynamic> addPropertyConfigList = appConfigurationsData[addPropertyLayoutApiConfiguration] ?? [];
    if (addPropertyConfigList.isNotEmpty) {
      HiveStorageManager.storeAddPropertyConfigurations(json.encode(addPropertyConfigList));
    }
  }

  static saveQuickAddPropertyConfigFile(Map appConfigurationsData) {
    List<dynamic> configList = appConfigurationsData[quickAddPropertyLayoutApiConfiguration] ?? [];
    if (configList.isNotEmpty) {
      HiveStorageManager.storeQuickAddPropertyConfigurations(json.encode(configList));
    }
  }

  static saveBlogDetailPageConfigFile(Map appConfigurationsData) {
    ApiManager api = ApiManager();
    BlogDetailsPageLayout blogDetailPageLayout = api.getBlogDetailsPageLayout(appConfigurationsData);
    List<BlogDetailPageLayout> configList = blogDetailPageLayout.blogDetailPageLayout ?? [];

    if (configList.isNotEmpty) {
      Map layoutMap = api.convertBlogDetailsPageLayoutToMap(blogDetailPageLayout);
      String layoutJson = json.encode(layoutMap);
      HiveStorageManager.storeBlogDetailConfigListData(layoutJson);
    }
  }

  static List<HouziFormPage> readAddPropertyConfigFile() {
    ApiManager api = ApiManager();
    List<HouziFormPage> addPropertyConfigList = [];

    String addPropertyConfigData = HiveStorageManager.readAddPropertyConfigurations() ?? "";
    if (addPropertyConfigData.isNotEmpty) {
      List<dynamic> tempList = jsonDecode(addPropertyConfigData) ?? [];
      if (tempList.isNotEmpty) {
        addPropertyConfigList = List<HouziFormPage>.from(tempList.map(
                (pageItemJson) => api.parseFormPageJson(pageItemJson)));
      }
    }
    return addPropertyConfigList;
  }

  static saveSortFirstByConfigFile(Map appConfigurationsData) {
    ApiManager api = ApiManager();
    SortFirstBy config = api.parseSortFirstByJson(appConfigurationsData);
    Map configMap = api.convertSortFirstByToJson(config);
    HiveStorageManager.storeSortFirstByConfigData(configMap);
  }

  static List<SortFirstByItem> readSortFirstByConfigFile() {
    return HiveStorageManager.readSortFirstByConfigData();
  }

  static storeOrUpdateRecentSearches(Map dataMap){
    List recentSearchesList = [];
    recentSearchesList = HiveStorageManager.readRecentSearchesInfo() ?? [];

    /// Save only 10 recent searches
    if(recentSearchesList != null && recentSearchesList.length > 10){
      recentSearchesList.removeLast();
    }

    if (recentSearchesList == null || recentSearchesList.isEmpty) {
      if(dataMap != null){
        recentSearchesList.add(dataMap);
      }
    } else {
      recentSearchesList.insert(0, dataMap);
    }

    HiveStorageManager.storeRecentSearchesInfo(infoList: recentSearchesList);
    GeneralNotifier().publishChange(GeneralNotifier.RECENT_DATA_UPDATE);
  }

  static updateTouchBaseDataAndConfigurations(Map<String, dynamic> touchBaseDataMap){
    String? stringValueHolder;
    /// Store TouchBase Data Map in Hive
    HiveStorageManager.storePropertyMetaData(touchBaseDataMap);
    GeneralNotifier().publishChange(GeneralNotifier.FILTER_DATA_LOADING_COMPLETE);

    enableOrDisableFields(touchBaseDataMap);

    /// Store Houzez Version in Hive
    stringValueHolder = getStringItemValueFromMap(
      inputMap: touchBaseDataMap,
      key: HOUZEZ_VERSION_KEY,
    );
    if(stringValueHolder != null){
      HiveStorageManager.storeHouzezVersion(stringValueHolder);
    }

    /// Update Config in Hive
    if (ENABLE_API_CONFIG) {
      Map? mapValueHolder;
      Map<String, dynamic> newConfigMap = {};

      if (FETCH_DEV_API_CONFIG &&
          touchBaseDataMap.containsKey(DEV_MOBILE_APP_CONFIG_KEY)) {
        mapValueHolder = getMapItemValueFromMap(
          inputMap: touchBaseDataMap,
          key: DEV_MOBILE_APP_CONFIG_KEY,
        );
      } else {
        mapValueHolder = getMapItemValueFromMap(
          inputMap: touchBaseDataMap,
          key: MOBILE_APP_CONFIG_KEY,
        );
      }

      if (mapValueHolder != null && mapValueHolder.isNotEmpty) {
        newConfigMap = convertMap(mapValueHolder);
      }

      if (newConfigMap.isNotEmpty) {
        String? oldConfigJson = HiveStorageManager.readAppConfigurations();

        if (oldConfigJson == null || oldConfigJson.isEmpty) {
          updateAppConfigurationsInStorage(newConfigMap);
        } else {
          int? oldConfigVersion;
          int? newConfigVersion;
          Map<String, dynamic> oldConfigMap = convertMap(jsonDecode(oldConfigJson));
          // Get Old Config version
          oldConfigVersion = getIntegerItemValueFromMap(
            inputMap: oldConfigMap,
            key: versionApiConfiguration,
          );
          // Get New Config version
          newConfigVersion = getIntegerItemValueFromMap(
            inputMap: newConfigMap,
            key: versionApiConfiguration,
          );
          // check condition for updating App Configurations
          if (oldConfigVersion != null &&
              newConfigVersion != null &&
              oldConfigVersion != newConfigVersion) {
            updateAppConfigurationsInStorage(newConfigMap);
          }
        }
      } else {
        //if api config are enable, but remote config aren't available.
        //it should still ask for tracking permission if ads are enabled.
        if (SHOW_ADS) {
          UtilityMethods.initTrackingPermissionAndInitializeMobileAds(({status}) { });
        }
      }
    }
  }

  static enableOrDisableFields(Map touchBaseDataMap) {
    /// Enable/Disable Register PhoneNumber on SignUp
    if (touchBaseDataMap.containsKey(SIGNUP_REGISTER_MOBILE_KEY) &&
        touchBaseDataMap[SIGNUP_REGISTER_MOBILE_KEY] != null) {
      if (touchBaseDataMap[SIGNUP_REGISTER_MOBILE_KEY] == "1") {
        SHOW_SIGNUP_ENTER_PHONE_FIELD = true;
      } else {
        SHOW_SIGNUP_ENTER_PHONE_FIELD = false;
      }
    }

    /// Enable/Disable Register First Name on SignUp
    if (touchBaseDataMap.containsKey(SIGNUP_REGISTER_FIRST_NAME_KEY) &&
        touchBaseDataMap[SIGNUP_REGISTER_FIRST_NAME_KEY] != null) {
      if (touchBaseDataMap[SIGNUP_REGISTER_FIRST_NAME_KEY] == "1") {
        SHOW_SIGNUP_ENTER_FIRST_NAME_FIELD = true;
      } else {
        SHOW_SIGNUP_ENTER_FIRST_NAME_FIELD = false;
      }
    }

    /// Enable/Disable Register Last Name on SignUp
    if (touchBaseDataMap.containsKey(SIGNUP_REGISTER_LAST_NAME_KEY) &&
        touchBaseDataMap[SIGNUP_REGISTER_LAST_NAME_KEY] != null) {
      if (touchBaseDataMap[SIGNUP_REGISTER_LAST_NAME_KEY] == "1") {
        SHOW_SIGNUP_ENTER_LAST_NAME_FIELD = true;
      } else {
        SHOW_SIGNUP_ENTER_LAST_NAME_FIELD = false;
      }
    }

    /// Enable/Disable Password Field on SignUp
    if (touchBaseDataMap.containsKey(SIGNUP_ENABLE_PASSWORD_KEY) &&
        touchBaseDataMap[SIGNUP_ENABLE_PASSWORD_KEY] != null) {
      if (touchBaseDataMap[SIGNUP_ENABLE_PASSWORD_KEY] == "yes") {
        SHOW_SIGNUP_PASSWORD_FIELD = true;
      } else {
        SHOW_SIGNUP_PASSWORD_FIELD = false;
      }
    }

    /// Show/hide Notification Bell widget
    if (touchBaseDataMap.containsKey(showNotificationConfiguration) &&
        touchBaseDataMap[showNotificationConfiguration] != null &&
        touchBaseDataMap[showNotificationConfiguration] is bool &&
        touchBaseDataMap[showNotificationConfiguration] == true) {
      SHOW_NOTIFICATIONS = true;
    } else {
      SHOW_NOTIFICATIONS = false;
    }

    /// Show/hide Messages
    if (touchBaseDataMap.containsKey(showMessagesConfiguration) &&
        touchBaseDataMap[showMessagesConfiguration] != null &&
        touchBaseDataMap[showMessagesConfiguration] is String &&
        touchBaseDataMap[showMessagesConfiguration] == "1") {
      SHOW_MESSAGES = true;
    } else {
      SHOW_MESSAGES = false;
    }

    /// Set the maximum property images uploads
    if (touchBaseDataMap.containsKey(maxPropertyImagesConfiguration) &&
        touchBaseDataMap[maxPropertyImagesConfiguration] != null &&
        touchBaseDataMap[maxPropertyImagesConfiguration] is String &&
        touchBaseDataMap[maxPropertyImagesConfiguration].isNotEmpty) {
      MAX_PROP_IMAGES_UPLOAD = touchBaseDataMap[maxPropertyImagesConfiguration];
    } else {
      MAX_PROP_IMAGES_UPLOAD = "50";
    }
  }

  static updateAppConfigurationsInStorage(Map<String, dynamic> newConfigMap){
    List? listValueHolder;
    int? integerValueHolder;
    bool booleanValueHolder = false;

    // Store New Config File
    HiveStorageManager.storeAppConfigurations(jsonEncode(newConfigMap));
    
    // Get & Store New Config Version
    integerValueHolder = getIntegerItemValueFromMap(
      inputMap: newConfigMap,
      key: versionApiConfiguration,
    );
    if(integerValueHolder != null){
      HiveStorageManager.storeHouziVersion(integerValueHolder);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: homePageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      saveHomeConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: drawerMenuLayoutConfiguration,
    );
    if (listValueHolder != null) {
      saveDrawerConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: searchPageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      saveFilterPageConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: propertyDetailsPageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      savePropertyDetailPageConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: addPropertyLayoutApiConfiguration,
    );
    if (listValueHolder != null) {
      saveAddPropertyConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: bottomNavBarLayoutConfiguration,
    );
    if (listValueHolder != null) {
      saveBottomNavigationBarConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: SORT_FIRST_BY_CONFIG,
    );
    if (listValueHolder != null) {
      saveSortFirstByConfigFile(newConfigMap);
    }

    listValueHolder = getListItemValueFromMap(
      inputMap: newConfigMap,
      key: blogDetailsPageLayoutConfiguration,
    );
    if (listValueHolder != null) {
      saveBlogDetailPageConfigFile(newConfigMap);
    }

    integerValueHolder = getIntegerItemValueFromMap(
      inputMap: newConfigMap,
      key: totalSearchTypeOptionsApiConfiguration,
    );
    if (integerValueHolder != null) {
      defaultSearchTypeSwitchOptions = integerValueHolder;
    }

    /// Show/Hide Request Demo on Profile
    booleanValueHolder = getBooleanItemValueFromMap(
      inputMap: newConfigMap,
      key: SHOW_REQUEST_DEMO_KEY,
    );
    SHOW_REQUEST_DEMO = booleanValueHolder;

    /// Show/Hide Add Property on Profile
    booleanValueHolder = getBooleanItemValueFromMap(
      inputMap: newConfigMap,
      key: SHOW_ADD_PROPERTY_KEY,
    );
    SHOW_ADD_PROPERTY = booleanValueHolder;

    /// Show/Hide Theme Related Options on Settings
    booleanValueHolder = getBooleanItemValueFromMap(
      inputMap: newConfigMap,
      key: SHOW_THEME_RELTAED_SETTINGS_KEY,
    );
    SHOW_THEME_RELATED_SETTINGS = booleanValueHolder;

    /// Read Default Home Config
    if (newConfigMap.containsKey(defaultHomeApiConfiguration) &&
        newConfigMap[defaultHomeApiConfiguration] != null) {
      final DefaultHomePageHook defaultHomePageHook = HooksConfigurations.defaultHomePage;
      String newHome = defaultHomePageHook();
      if (newHome.isEmpty) {
        newHome = newConfigMap[defaultHomeApiConfiguration] ?? "";
      }
      if (newHome.isNotEmpty) {
        String? oldHome = HiveStorageManager.readSelectedHomeOption();
        if (oldHome == null || oldHome.isEmpty || oldHome != newHome) {
          HiveStorageManager.storeSelectedHomeOption(newHome);
          GeneralNotifier().publishChange(GeneralNotifier.HOME_DESIGN_MODIFIED);
        }
      }
    }

    GeneralNotifier().publishChange(GeneralNotifier.APP_CONFIGURATIONS_UPDATED);
    if (SHOW_ADS) {
      UtilityMethods.initTrackingPermissionAndInitializeMobileAds(({status}) { });
    }
  }



  static List? getPropertyMetaDataList({required String dataType}){
    List dataTypeList = [];
    if(dataType == propertyTypeDataType){
      dataTypeList = HiveStorageManager.readPropertyTypesMetaData() ?? [];
    }else if(dataType == propertyCityDataType){
      dataTypeList = HiveStorageManager.readCitiesMetaData() ?? [];
    }else if(dataType == propertyLabelDataType){
      dataTypeList = HiveStorageManager.readPropertyLabelsMetaData() ?? [];
    }else if(dataType == propertyStatusDataType){
      dataTypeList = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    }else if(dataType == propertyAreaDataType){
      dataTypeList = HiveStorageManager.readPropertyAreaMetaData() ?? [];
    }else if(dataType == propertyFeatureDataType){
      dataTypeList = HiveStorageManager.readPropertyFeaturesMetaData() ?? [];
    }else if(dataType == propertyStateDataType){
      dataTypeList = HiveStorageManager.readPropertyStatesMetaData() ?? [];
    }else if(dataType == propertyCountryDataType){
      dataTypeList = HiveStorageManager.readPropertyCountriesMetaData() ?? [];
    }

    return dataTypeList;
  }

  static storePropertyMetaDataList({
    required String dataType,
    required List<dynamic> metaDataList,
    Map? metaDataMap,
  }){
    if(dataType == propertyTypeDataType){
      HiveStorageManager.storePropertyTypesMetaData(metaDataList);
      if(metaDataMap != null && metaDataMap.isNotEmpty) {
        HiveStorageManager.storePropertyTypesMapData(metaDataMap);
      }
    }else if(dataType == propertyCityDataType){
      HiveStorageManager.storeCitiesMetaData(metaDataList);
    }else if(dataType == propertyLabelDataType){
      HiveStorageManager.storePropertyLabelsMetaData(metaDataList);
    }else if(dataType == propertyStatusDataType){
      HiveStorageManager.storePropertyStatusMetaData(metaDataList);
      if(metaDataMap != null && metaDataMap.isNotEmpty) {
        HiveStorageManager.storePropertyStatusMapData(metaDataMap);
      }
    }else if(dataType == propertyAreaDataType){
      HiveStorageManager.storePropertyAreaMetaData(metaDataList);
    }else if(dataType == propertyFeatureDataType){
      HiveStorageManager.storePropertyFeaturesMetaData(metaDataList);
    }else if(dataType == propertyStateDataType){
      HiveStorageManager.storePropertyStatesMetaData(metaDataList);
    }else if(dataType == propertyCountryDataType){
      HiveStorageManager.storePropertyCountriesMetaData(metaDataList);
    }
  }

  static String getPropertyMetaDataItemNameWithSlug({
    required String dataType,
    required String slug,
  }){
    List dataList = getPropertyMetaDataList(dataType: dataType) ?? [];
    if(dataList.isNotEmpty) {
      Term? item = dataList.firstWhereOrNull((element) => (element is Term && element.slug == slug));

      if (item != null) {
        return item.name ?? "";
      }
    }
    return "";
  }

  static Term? getPropertyMetaDataObjectWithSlug({
    required String dataType,
    required String slug,
  }){

    List? dataList = getPropertyMetaDataList(dataType: dataType);
    if(dataList != null && dataList.isNotEmpty) {
      Term? item = dataList.firstWhereOrNull((element) => (element is Term && element.slug == slug));
      if (item != null) {
        return item;
      }
    }
    return null;
  }

  static Term? getPropertyMetaDataObjectWithId({
    required String dataType,
    required int id,
  }){
    List? dataList = getPropertyMetaDataList(dataType: dataType) ?? [];
    if(dataList != null && dataList.isNotEmpty) {
      Term? item = dataList.firstWhereOrNull((element) => (element is Term && element.id == id));

      if (item != null) {
        return item;
      }
    }
    return null;
  }

  static Term? getPropertyMetaDataObjectWithItemName({
    required String dataType,
    required String name,
  }){
    List dataList = getPropertyMetaDataList(dataType: dataType) ?? [];
    if(dataList != null && dataList.isNotEmpty) {
      Term? item = dataList.firstWhereOrNull((element) => (element is Term && element.name == name));

      if (item != null) {
        return item;
      }
    }
    return null;
  }

  static Map<String, dynamic> getParentAndChildCategorizedMap({required List<dynamic> metaDataList}) {
    List<dynamic> parentCategoryList = [];
    List<dynamic> subCategoryList = [];
    Map<String, dynamic> categorizedDataMap = {};

    /// Get Parent Categories List
    for(var item in metaDataList){
      if (item.parent == 0) {
        parentCategoryList.add(item);
      }
    }

    // print("metaDataList[0].name: ${metaDataList[0].name}");
    //
    // print("Length of metaDataList: ${metaDataList.length}");
    // print("Length of parentCategoryList: ${parentCategoryList.length}");

    /// Get sub Categories List if there is any...
    if (parentCategoryList.length != metaDataList.length) {
      /// Get sub Categories List against each parent
      for(var parentElement in parentCategoryList){
        for(var dataElement in metaDataList){
          if (parentElement.id == dataElement.parent) {
            subCategoryList.add(dataElement);
          }
        }
        categorizedDataMap[parentElement.name] = subCategoryList;
        subCategoryList = [];
      }
    }

    return categorizedDataMap;
  }

  static String getStaticMapUrl({
    required String lat,
    required String lng,
    double? zoomValue = 16,
    double? width = 400,
    double? height = 100,
    String? markerColor = "red",
  }){
    return 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=$lat,$lng&'
        'zoom=${zoomValue!.toInt()}&'
        'size=${width!.toInt()}x${height!.toInt()}&'
        'markers=color:$markerColor%7C$lat,$lng&'
        'key=$GOOGLE_MAP_API_KEY';
  }

  static MaterialPageRoute FilterPageRoute({Map<String, dynamic>? dataMap}){
    MaterialPageRoute filterPageRoute = MaterialPageRoute(
        builder: (context) => FilterPage(
          mapInitializeData: dataMap!,
          filterPageListener: (Map<String, dynamic> dataMap, String closeOption) {
            if (closeOption == DONE) {
              Navigator.pop(context);
            } else if(closeOption == CLOSE){
              Navigator.pop(context);
            }
          },
        ),
    );
    return filterPageRoute;
  }

  static MaterialPageRoute SearchPageRoute({
    Map<String, dynamic>? dataInitMap,
    Map<String, dynamic>? searchRelatedMap,
  }){
    MaterialPageRoute searchPageRoute = MaterialPageRoute(
      builder: (context) => SearchResult(
        dataInitializationMap: dataInitMap,
        searchRelatedData: searchRelatedMap,
        searchPageListener: (Map<String, dynamic> map, String closeOption){
          if(closeOption == CLOSE){
            Navigator.of(context).pop();
          }
        },
      ),
    );
    return searchPageRoute;
  }

  static MaterialPageRoute AboutPageRoute(){
    MaterialPageRoute? pageRoute;
    SHOW_DEMO_CONFIGURATIONS ? pageRoute = MaterialPageRoute(builder: (context) => About()) : 
    pageRoute = MaterialPageRoute(builder: (context) =>
        WebPage(COMPANY_URL, UtilityMethods.getLocalizedString("about")));
    return pageRoute;
  }

  static MaterialPageRoute DarkModeSettingsPageRoute(){
    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context) => DarkModeSettings());
    return pageRoute;
  }

  static MaterialPageRoute LanguageSettingsPageRoute(){
    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context) => LanguageSettings());
    return pageRoute;
  }

  static MaterialPageRoute PrivacyPolicyPageRoute(){
    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context) =>
        WebPage(APP_PRIVACY_URL, UtilityMethods.getLocalizedString("privacy_policy")));
    return pageRoute;
  }

  static MaterialPageRoute TermsAndConditionsPageRoute(){
    MaterialPageRoute pageRoute = MaterialPageRoute(builder: (context) =>
        WebPage(APP_TERMS_URL, UtilityMethods.getLocalizedString("terms_and_conditions")));
    return pageRoute;
  }

  static GenericPageRouter({
    required buildContext,
    required String routeKeyword,
    Map<String, dynamic>? dataMap,
  }) {
    Route? pageRoute;

    if (routeKeyword == FILTER_SCREEN_ROUTE_TAG) {
      Map<String, dynamic>? filterDataMap = {};
      if (dataMap != null &&
          dataMap.containsKey(FILTER_PAGE_SCREEN_DATA_MAP_KEY) &&
          dataMap[FILTER_PAGE_SCREEN_DATA_MAP_KEY] != null) {
        filterDataMap = dataMap[FILTER_PAGE_SCREEN_DATA_MAP_KEY];
      }
      pageRoute = FilterPageRoute(dataMap: filterDataMap);
    } else if (routeKeyword == SEARCH_SCREEN_ROUTE_TAG) {
      Map<String, dynamic>? searchPageDataInitMap = {};
      Map<String, dynamic>? searchPageRelatedDataMap = {};

      // if(dataMap != null){
      //   if(dataMap.containsKey(SEARCH_PAGE_SCREEN_DATA_INIT_MAP_KEY) &&
      //       dataMap[SEARCH_PAGE_SCREEN_DATA_INIT_MAP_KEY] != null){
      //     searchPageDataInitMap = dataMap[SEARCH_PAGE_SCREEN_DATA_INIT_MAP_KEY];
      //   }
      //   if(dataMap.containsKey(SEARCH_PAGE_SCREEN_RELATED_DATA_MAP_KEY) &&
      //       dataMap[SEARCH_PAGE_SCREEN_RELATED_DATA_MAP_KEY] != null){
      //     searchPageRelatedDataMap = dataMap[SEARCH_PAGE_SCREEN_RELATED_DATA_MAP_KEY];
      //   }
      // }
      pageRoute = SearchPageRoute(
        dataInitMap: searchPageDataInitMap,
        searchRelatedMap: searchPageRelatedDataMap,
      );
    } else if (routeKeyword == ABOUT_SCREEN_ROUTE_TAG) {
      pageRoute = AboutPageRoute();
    } else if (routeKeyword == THEME_SETTING_SCREEN_ROUTE_TAG) {
      pageRoute = DarkModeSettingsPageRoute();
    } else if (routeKeyword == LANGUAGE_SETTING_SCREEN_ROUTE_TAG) {
      pageRoute = LanguageSettingsPageRoute();
    } else if (routeKeyword == PRIVACY_POLICY_SCREEN_ROUTE_TAG) {
      pageRoute = PrivacyPolicyPageRoute();
    } else if (routeKeyword == TERMS_AND_CONDITIONS_SCREEN_ROUTE_TAG) {
      pageRoute = TermsAndConditionsPageRoute();
    }

    if (pageRoute != null) {
      Navigator.push(buildContext, pageRoute);
    } else {
      print("GENERIC_METHODS[GenericPageRouter()] => No Page Route found...");
    }
  }
  /// check if the string contains only numbers
  static bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  /// check if the string contains only characters
  static bool isText(String str) {
    RegExp text = RegExp(r'^-?[A-Za-z]+$');
    return text.hasMatch(str);
  }

  static Future<bool> locationPermissionsHandling(bool permissionStatus) async {
    bool permissionGranted = permissionStatus;
    if (permissionGranted) {
      return true;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      permissionGranted = true;
    }
    else if (permission == LocationPermission.deniedForever) {
      permissionGranted = false;
    } else {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        permissionGranted = true;
      } else {
        permissionGranted = false;
      }
    }

    return permissionGranted;
  }

  static Future<Map<String, dynamic>> getMapForNearByProperties() async {
    Position position = await getCurrentPosition(locationAccuracy: LocationAccuracy.high);
    Map<String, dynamic> dataMap = {
      LATITUDE: position.latitude.toString(),
      LONGITUDE: position.longitude.toString(),
      RADIUS: "20",
      SEARCH_LOCATION: true,
      USE_RADIUS: "on",
    };
    return dataMap;
  }
  static Map<String, dynamic>? getMapItemFromMap({
    required Map inputMap,
    required String key,
  }) {
    if (inputMap.containsKey(key) &&
        inputMap[key] != null &&
        inputMap[key] is Map) {
      return Map<String, dynamic>.from(inputMap[key]);
    }
    return null;
  }


  static Future <Position> getCurrentPosition({
    LocationAccuracy locationAccuracy = LocationAccuracy.best,
  }) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracy);
    return position;
  }

  static navigateToPropertyDetailPage({
    required BuildContext context,
    int? propertyID,
    Article? article,
    String? heroId,
    String? permaLink,
  }) {
    navigateToRoute(
      context: context,
      builder: (context) => PropertyDetailsPage(
        article: article,
        propertyID: propertyID,
        heroId: heroId,
        permaLink: permaLink,
        thumbnail: (article != null) ? (article.image ?? "") : "",
      ),
    );
  }

  static navigateToLoginPage(BuildContext context, bool fromBottomNavigator) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserSignIn(
          (String closeOption) {
            if (closeOption == CLOSE) {
              Navigator.pop(context);
            }
          },
          fromBottomNavigator: fromBottomNavigator,
        ),
      ),
    );
  }

  static Widget navigateToAddPropertyPage({bool navigateToQuickAdd = false}) {
    UserPaymentStatus? userPaymentStatus = HiveStorageManager.readUserPaymentStatus();
    if (userPaymentStatus != null) {
      /// If either the touch-base or the user payment status with the
      /// enable_paid_submission set to anything other than "no," it
      /// indicates that the payment method mechanism is active.

      String enablePaidSubmission = userPaymentStatus.enablePaidSubmission ?? "";
      String userRemainingListing = userPaymentStatus.remainingListings ?? "";

      if (TOUCH_BASE_PAYMENT_ENABLED_STATUS != freeListing || (enablePaidSubmission != freeListing)) {
        int remainingListing =  0;
        if (userRemainingListing.isNotEmpty) {
          remainingListing = int.tryParse(userRemainingListing) ?? 0;
        }
        /// Property listing is free only to make it featured is on payment.
        /// Navigate to Add Property
        ///
        /// Listing a property is completely free, but if you want to give it
        /// more visibility and make it stand out, you have the option to
        /// feature it for a small fee in Properties Page.
        /// Simply click on "Add Property" to get started.
        ///
        /// Just for the understanding of the payment mechanism
        /// following condition is written i.e "userPaymentStatusMap[enablePaidSubmissionKey] == freePaidListing"
        /// to add all three mechanism.
        ///
        if (enablePaidSubmission == freePaidListing) {
          // Navigate to Add property page
        }

        /// Property listing is not free.
        /// First check remainingListingKey is greater than 0.
        /// If greater than 0 than navigate to add property
        /// else navigate to Payment page.
        else if (enablePaidSubmission == perListing) {
          if (remainingListing <= 0) {
            // Navigate to payment page
            return PaymentPage(productIds: [perListing],isMembership: false,);
          }
        }

        /// Membership mechanism is the combination of property listing and
        /// set property featured. There is 3 different plans of membership
        else if (enablePaidSubmission == membership) {
          /// First check user has membership or not. If userHasMembership
          /// then check remainingListing is greater than 0.
          /// If less than 0 than navigate to Payment page
          /// else navigate to Add property

          bool hasMembership = userPaymentStatus.userHasMembership ?? false;
          if (remainingListing != -1 && (!hasMembership || remainingListing <= 0)) {
            return MembershipPlanPage();
          }
          // if(remainingListing != -1) {
          //   if (!hasMembership || (remainingListing <= 0)) {
          //     // Navigate to Membership Plan page
          //     return MembershipPlanPage();
          //   }
          // }

        }
      }
    }

    // Navigate to Add property page
    if (navigateToQuickAdd) {
      String addPropertyConfigData = HiveStorageManager.readQuickAddPropertyConfigurations() ?? "";
      if (addPropertyConfigData.isEmpty) {
        return QuickAddProperty();
      }
      return QuickAddPropertyV2();
    }
    return AddPropertyV2();

    // Map userPaymentStatusMap = HiveStorageManager.readUserPaymentStatus();
    // if (userPaymentStatusMap.isNotEmpty) {
    //   /// If either the touch-base or the user payment status with the
    //   /// enable_paid_submission set to anything other than "no," it
    //   /// indicates that the payment method mechanism is active.
    //   if (TOUCH_BASE_PAYMENT_ENABLED_STATUS != freeListing ||
    //       (userPaymentStatusMap.isNotEmpty && userPaymentStatusMap[enablePaidSubmissionKey] != freeListing)) {
    //     /// Property listing is free only to make it featured is on payment.
    //     /// Navigate to Add Property
    //     ///
    //     /// Listing a property is completely free, but if you want to give it
    //     /// more visibility and make it stand out, you have the option to
    //     /// feature it for a small fee in Properties Page.
    //     /// Simply click on "Add Property" to get started.
    //     ///
    //     if (userPaymentStatusMap[enablePaidSubmissionKey] == freePaidListing) {
    //       // Navigate to Add property page
    //       return AddPropertyV2();
    //     }
    //
    //     /// Property listing is not free.
    //     /// First check remainingListingKey is greater than 0.
    //     /// If greater than 0 than navigate to add property
    //     /// else navigate to Payment page.
    //     else if (userPaymentStatusMap[enablePaidSubmissionKey] == perListing) {
    //       int? remainingListing = int.tryParse(userPaymentStatusMap[remainingListingKey]);
    //       if (remainingListing != null && remainingListing < 0) {
    //         // Navigate to payment page
    //         return PaymentPage();
    //       } else {
    //         return AddPropertyV2();
    //         // Navigate to Add property page
    //       }
    //     }
    //
    //
    //     /// Membership mechanism is the combination of property listing and
    //     /// set property featured. There is 3 different plans of membership
    //     else if (userPaymentStatusMap[enablePaidSubmissionKey] == membership) {
    //       /// First check user has membership or not. If userHasMembershipKey
    //       /// then check remainingListingKey is greater than 0.
    //       /// If greater than 0 than navigate to add property
    //       /// else navigate to Payment page.
    //
    //       if (userPaymentStatusMap[userHasMembershipKey]) {
    //         int? remainingListing = int.tryParse(userPaymentStatusMap[remainingListingKey]);
    //         if (remainingListing != null && remainingListing < 0) {
    //           return MembershipPlanPage();
    //           // Navigate to membership plan page
    //         } else {
    //           // Navigate to Add property page
    //           return AddPropertyV2();
    //         }
    //       } else {
    //         // Navigate to membership plan page
    //         return MembershipPlanPage();
    //
    //       }
    //
    //     } else {
    //       // Navigate to Add property page
    //       return AddPropertyV2();
    //
    //     }
    //
    //
    //   } else {
    //     /// Both the touch-base or the user payment status with the
    //     /// enable_paid_submission set to "no," it indicates that the
    //     /// payment method mechanism is not active.
    //     // Navigate to Add Property
    //     return AddPropertyV2();
    //   }
    // } else {
    //   /// As user payment status not found or configured
    //   // Navigate to Add Property
    //   return AddPropertyV2();
    // }
  }

  // Get Currency Symbol from Currency Code by their names
  static String getCurrencyCode(String currencyName) {
    final RegExp codePattern = RegExp(r'\(([A-Z]{3})\)');
    final match = codePattern.firstMatch(currencyName);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    
    final words = currencyName.split(' ');
    if (words.length >= 3) {
      String code = '';
      int wordCount = 0;
      for (var word in words) {
        if (word.isNotEmpty && wordCount < 3) {
          code += word[0].toUpperCase();
          wordCount++;
        }
      }
      if (code.length == 3) return code;
    }
    
    String code = '';
    for (int i = 0; i < currencyName.length && i < 3; i++) {
      if (currencyName[i].trim().isNotEmpty) {
        code += currencyName[i].toUpperCase();
      }
    }
    
    // Pad with X if needed
    while (code.length < 3) {
      code += 'X';
    }
    
    return code;
  }


  static bool showUpgradePlanPage() {
    UserPaymentStatus? userPaymentStatus = HiveStorageManager.readUserPaymentStatus();

    if (userPaymentStatus != null) {
      String enablePaidSubmission = userPaymentStatus.enablePaidSubmission ?? "";

      if (TOUCH_BASE_PAYMENT_ENABLED_STATUS != freeListing || (enablePaidSubmission != freeListing)) {
        int remainingListing = int.tryParse(userPaymentStatus.remainingListings ?? "0") ?? 0;

        if (enablePaidSubmission == freePaidListing) {
          return false;
        } else if (enablePaidSubmission == perListing) {
          if (remainingListing <= 0) {
            return true;
          }
        }
        else if (enablePaidSubmission == membership) {
          bool hasMembership = userPaymentStatus.userHasMembership ?? false;
          if (remainingListing != -1 && (!hasMembership || remainingListing <= 0)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static String? getDesignValue(String? design){
    if(design != null && design.isNotEmpty){
      if(design.contains("Design # ")){
        design = design.replaceAll("Design # ", "design_");
      }

      return design;
    }

    return null;
  }

  static bool getBooleanItemValueFromMap({
    required Map inputMap, required String key, bool defaultValue = false}) {
    if (inputMap.containsKey(key) && inputMap[key] is bool) {
      return  inputMap[key];
    }

    return defaultValue;
  }

  static String? getStringItemValueFromMap({required Map inputMap, required String key}){
    if(inputMap.containsKey(key) && inputMap[key] != null &&
        inputMap[key] is String && inputMap[key].isNotEmpty){
      return inputMap[key];
    }

    return null;
  }


  static List<CurrencyRatesModel> getCurrencyRatesFromList({
    required dynamic data,
    List<CurrencyRatesModel> defaultValue = const []
  }) {
    if (data != null && data is List) {
      try {
        return List<CurrencyRatesModel>.from(
          data.map((item) {
            if (item is Map) {
              return CurrencyRatesModel.fromMap(Map<String, dynamic>.from(item));
            }
            throw FormatException('Currency item is not a Map');
          })
        );
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }

  static CurrencyRatesModel? getCurrencyRateFromMap({
    required dynamic data,
    CurrencyRatesModel? defaultValue,
  }) {
    if (data != null && data is Map) {
      try {
        return CurrencyRatesModel.fromMap(Map<String, dynamic>.from(data));
      } catch (e) {
        return defaultValue;
      }
    }
    return defaultValue;
  }



 static CurrencyRatesModel? getCurrencyRateFromData({
  required dynamic data,
  String? defaultCurrencyString
}) {
  if (data != null) {
    try {
      if (data is Map) {
        final mappedData = Map<String, dynamic>.from(data);
        return CurrencyRatesModel.fromMap(mappedData);
      } else if (data is String) {
        try {
          final decoded = jsonDecode(data);
          if (decoded is Map) {
            return CurrencyRatesModel.fromMap(Map<String, dynamic>.from(decoded)); 
          } else {
            // print("Decoded data is not a Map: ${decoded.runtimeType}");
          }
        } catch (jsonError) {
          // print("JSON decode error: $jsonError for data: $data");
        }
      } else {
        // print("Unexpected data type received: ${data.runtimeType}");
      }
    } catch (e) {
      print("Error converting currency data: $e");
      // print("Data type: ${data.runtimeType}");
      // print("Data content: $data");
    }
  } 
  
  // If we couldn't convert the data but have a default currency string, try to use that
  if (defaultCurrencyString != null) {
    try {
      final decoded = jsonDecode(defaultCurrencyString);
      if (decoded is Map) {
        return CurrencyRatesModel.fromMap(Map<String, dynamic>.from(decoded));
      }
    } catch (e) {
      // print("Error parsing default currency string: $e");
    }
  }
  
  return null;
}

static List<Map<String, dynamic>> getToJsonListFromModel(dynamic dataList) {
  if (dataList is List<CurrencyRatesModel>) {
    return dataList.map((model) => model.toMap()).toList();
  } else if (dataList is List<Map<String, dynamic>>) {
    return dataList;
  } else {
    throw ArgumentError(
      'dataList must be either List<Map<String, dynamic>> or List<CurrencyRatesModel>',
    );
  }
}


 static List<Map<String, dynamic>>? getListWithObjectsFromMap({
  required Map inputMap,
  required String key,
}) {
  if (inputMap.containsKey(key) &&
      inputMap[key] != null &&
      inputMap[key] is List &&
      inputMap[key].isNotEmpty) {
    return List<Map<String, dynamic>>.from(inputMap[key]);
  }

  return null;
}



  static Map<String, dynamic>? getMapItemValueFromNestedMap({required Map inputMap, required String key}) {
    if(inputMap.containsKey(key) && 
       inputMap[key] != null &&
       inputMap[key] is Map) {
      return inputMap[key] as Map<String, dynamic>;
    }
    return null;
  }

  



  static int? getIntegerItemValueFromMap({required Map inputMap, required String key}){
    if(inputMap.containsKey(key) && inputMap[key] != null){
      if( inputMap[key] is int){
        return inputMap[key];
      }
      if( inputMap[key] is String){
        return int.tryParse(inputMap[key]);
      }
    }

    return null;
  }

  static String? getIntStatusFromMap(
      {required Map inputMap, required String key}) {
    if (inputMap.containsKey(key) && inputMap[key] != null) {
      int? value;
      if (inputMap[key] is int) {
        value = inputMap[key];
      } else if (inputMap[key] is String) {
        value = int.tryParse(inputMap[key]);
      }

      if (value != null) {
        switch (value) {
          case 0:
            return 'Pending';
          case 1:
            return 'Approved';
          case 2:
            return 'Suspended';
          case -1:
            return 'Declined';
        }
      }
    }

    return null;
  }


  static List? getListItemValueFromMap({required Map inputMap, required String key}){
    if(inputMap.containsKey(key) && inputMap[key] != null &&
        inputMap[key] is List && inputMap[key].isNotEmpty){
      return inputMap[key];
    }

    return null;
  }

  static List<String>? getStringListItemValueFromMap({required Map inputMap, required String key}){
    if(inputMap.containsKey(key) && inputMap[key] != null &&
        inputMap[key] is List && inputMap[key].isNotEmpty){
      return List<String>.from(inputMap[key]);
    }

    return null;
  }

  static Map? getMapItemValueFromMap({required Map inputMap, required String key}){
    if(inputMap.containsKey(key) && inputMap[key] != null &&
        inputMap[key] is Map && inputMap[key].isNotEmpty){
      return inputMap[key];
    }

    return null;
  }

  static dynamic getItemValueFromMap({required Map inputMap, required String key}){
    if(inputMap.containsKey(key) && inputMap[key] != null){
      return inputMap[key];
    }

    return null;
  }

  static String getStringValueFromDynamicItem({required dynamic item}){
    if (item != null) {
      if (item is List && item.isNotEmpty){
        return item[0] != null && item[0] is String ? item[0] : "";
      } else if (item is String) {
        return item;
      }
    }

    return "";
  }
  static bool getBooleanValueFromDynamicItem({required dynamic item}) {
    if (item != null) {
      if (item is List && item.isNotEmpty) {
        final value = item[0];
        if (value != null && value is String) {
          return value == "1";
        }
      } else if (item is String) {
        return item == "1";
      }
    }

    return false;
  }


  /// Returns true if 'inputItem' is not null and non-empty String.
  static bool isValidString(dynamic inputItem){
    if(inputItem is String && inputItem.isNotEmpty){
      return true;
    }
    return false;
  }

  static getRandomNumber({int? maxRange}){
    return Random().nextInt(maxRange ?? 1000);
  }

  static String getTimeAgoFormat({required String? time, String? locale = 'en'}) {
    if (time != null && time.isNotEmpty) {
      DateTime dt = DateTime.parse(time + "z");
      String lang = HiveStorageManager.readLanguageSelection() ?? "en";
      initializeLocaleForTimeAgo();
      return timeago.format(dt, locale: lang);
    }
    return "";
  }

  static initializeLocaleForTimeAgo() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('az', timeago.AzMessages());
    timeago.setLocaleMessages('ca', timeago.CaMessages());
    timeago.setLocaleMessages('cs', timeago.CsMessages());
    timeago.setLocaleMessages('da', timeago.DaMessages());
    timeago.setLocaleMessages('de', timeago.DeMessages());
    timeago.setLocaleMessages('dv', timeago.DvMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('es', timeago.EsMessages());
    timeago.setLocaleMessages('et', timeago.EtMessages());
    timeago.setLocaleMessages('fa', timeago.FaMessages());
    timeago.setLocaleMessages('fi', timeago.FiMessages());
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('gr', timeago.GrMessages());
    timeago.setLocaleMessages('he', timeago.HeMessages());
    timeago.setLocaleMessages('he', timeago.HeMessages());
    timeago.setLocaleMessages('hi', timeago.HiMessages());
    timeago.setLocaleMessages('hu', timeago.HuMessages());
    timeago.setLocaleMessages('id', timeago.IdMessages());
    timeago.setLocaleMessages('it', timeago.ItMessages());
    timeago.setLocaleMessages('ja', timeago.JaMessages());
    timeago.setLocaleMessages('km', timeago.KmMessages());
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    timeago.setLocaleMessages('ku', timeago.KuMessages());
    timeago.setLocaleMessages('mn', timeago.MnMessages());
    timeago.setLocaleMessages('nl', timeago.NlMessages());
    timeago.setLocaleMessages('pl', timeago.PlMessages());
    timeago.setLocaleMessages('ro', timeago.RoMessages());
    timeago.setLocaleMessages('ru', timeago.RuMessages());
    timeago.setLocaleMessages('rw', timeago.RwMessages());
    timeago.setLocaleMessages('sv', timeago.SvMessages());
    timeago.setLocaleMessages('ta', timeago.TaMessages());
    timeago.setLocaleMessages('th', timeago.ThMessages());
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setLocaleMessages('uk', timeago.UkMessages());
    timeago.setLocaleMessages('ur', timeago.UrMessages());
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    timeago.setLocaleMessages('zh', timeago.ZhMessages());
  }

  static List<String> getListFromString(String? optionsString,
      { Pattern splitPattern = "," }) {

    List<String> pickerDataList = [];
    if (optionsString != null && optionsString.isNotEmpty) {
      // // remove white spaces from start and end of string
      // optionsString = optionsString.replaceAll(RegExp(r'^\s+|\s+$'), '');
      //
      // // remove white spaces before and after comma
      // optionsString = optionsString.replaceAll(RegExp(r'\s*,\s*'), ',');

      // convert String to List<String>
      List<String> _tempList = optionsString.split(splitPattern);
      // remove any white-spaces
      for (String item in _tempList) {
        pickerDataList.add(item.trim());
      }
    }

    return pickerDataList;
  }

  static String getStringFromList(List<String>? dataList,
      { String splitPattern = "," }) {
    String dataString = "";

    if (dataList != null && dataList.isNotEmpty) {
      // convert List<String> to String
      dataString = dataList.join(splitPattern);
    }

    return dataString;
  }


  /// This method transforms a map with keys containing brackets (e.g., "key[subKey]")
  /// into a nested map structure. For example, the key "key[subKey]" will be transformed
  /// into a map like {"key": {"subKey": value}}.
  /// If the key does not contain brackets, it will remain unchanged.
  static Map<String, dynamic> transformMapWithBracketKeys(Map originalMap) {
  Map<String, dynamic> transformedMap = {};
  
  originalMap.forEach((key, value) {
    if (key is String && key.contains('[') && key.contains(']')) {
      int bracketStartIndex = key.indexOf('[');
      int bracketEndIndex = key.indexOf(']');
      
      if (bracketStartIndex > 0 && bracketEndIndex > bracketStartIndex) {
        String mainKey = key.substring(0, bracketStartIndex);
        String subKey = key.substring(bracketStartIndex + 1, bracketEndIndex);
        
        transformedMap[mainKey] = transformedMap[mainKey] ?? {};
        if (transformedMap[mainKey] is Map) {
          (transformedMap[mainKey] as Map)[subKey] = value;
        }
      } else {
        transformedMap[key] = value;
      }
    } else {
      transformedMap[key] = value;
    }
  });
  
  return transformedMap;
}
  /// Depricated method
  /// check if the map item is populated
  // static bool isMapItemPopulated(Map map, String key) {
  //   if (map.containsKey(key) && map[key] != null && map[key].isNotEmpty) {
  //     return true;
  //   }
  //   return false;
  // }
  
  /// check if the map item is populated
  /// This method checks if the map contains a key and if the value associated with that key is not null or empty.
  /// It also checks for keys that may have brackets in their names, such as "SEARCH_RESULTS_CUSTOM_FIELDS[basement-available]".
  /// If such a key exists, it checks if the value associated with that key is not null or empty.
  static bool isMapItemPopulated(Map map, String key) {
  if (map.containsKey(key)) {
    final value = map[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return true;
    }
  }

  // Check for keys like "SEARCH_RESULTS_CUSTOM_FIELDS[basement-available]"
  bool hasBracketKeys = map.keys.any((mapKey) {
    if (mapKey is String && mapKey.startsWith('$key[')) {
      final value = map[mapKey];
      return value != null && value.toString().trim().isNotEmpty;
    }
    return false;
  });

  return hasBracketKeys;
}

  static String getFormattedDate(String? gmtDate) {
    String sanitizedDate = "";
    if (gmtDate != null && gmtDate.isNotEmpty) {
      DateTime dateTime = DateTime.parse(gmtDate);
      sanitizedDate = DateFormat.yMMMMd(HiveStorageManager.readLanguageSelection() ?? 'en').format(dateTime);
    }
    return sanitizedDate;
  }

  static Map<String, dynamic> mergeMapsWithPrecedence(
      Map<String, dynamic> firstMap, Map<String, dynamic> secondMap) {
    Map<String, dynamic> mergedMap = {...firstMap};

    for (String key in secondMap.keys) {
      if (secondMap[key] != null) {
        mergedMap[key] = secondMap[key]!;
      }
    }

    return mergedMap;
  }

  static String formatPercentage(int percentage) {
    if (percentage > 0) {
      return "+${percentage}%";
    } else if (percentage < 0) {
      return "-${percentage}%";
    } else {
      return "0%";
    }
  }

  static Map<String, dynamic> removeElementFromLists(Map<String, dynamic> inputMap) {
    Map<String, dynamic> modifiedMap = {};

    inputMap.forEach((key, value) {

      if (value is List && value.contains("All")) {
        if (value.length == 2) {
          modifiedMap[key] = value.where((item) => item != "All").toList();
        } else {
          modifiedMap[key] = value;
        }
      } else {
        modifiedMap[key] = value;
      }
    });

    return modifiedMap;
  }

  static Map<String, dynamic>? extractJson(String responseString) {
    Map<String, dynamic> modifiedMap = {};

    try {
      if (responseString.contains("{")) {
        // Use regex to extract JSON part
        RegExp jsonRegex = RegExp(r'^\{.*\}');
        Match? match = jsonRegex.firstMatch(responseString);

        if (match != null) {
          String jsonString = match.group(0)!;
          Map<String, dynamic> jsonData = jsonDecode(jsonString);
          print(jsonData); // Parsed JSON
          return jsonData;
        } else {
          print("No valid JSON found");
        }

        String tempResponseString = responseString.split("{")[1];
        print("response $responseString");
        print("temp string response $tempResponseString");
        modifiedMap = jsonDecode("{${tempResponseString.split("}")[0]}}");
        return modifiedMap;
      }

      // modifiedMap = jsonDecode(responseString);
      // return modifiedMap;
    } catch (e) {

    }
    return null;
  }

  static void printAttentionMessage(String reason) {
    print("***************************************************************");
    print("* ATTENTION: $reason");
    print("***************************************************************");
  }

  static convertUploadAndDraftMapItemToArticle(Map? itemMap){
    List? tempImageList = itemMap![ADD_PROPERTY_PENDING_IMAGES_LIST];
    String _featuredImageLocalId = '';
    String featuredImagePath = '';
    if(tempImageList != null && tempImageList.isNotEmpty){
      _featuredImageLocalId = itemMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];
      for (var item in tempImageList) {
        Map<String, dynamic> _imageMap = UtilityMethods.convertMap(item);
        if (_featuredImageLocalId == _imageMap[PROPERTY_MEDIA_IMAGE_ID]) {
          featuredImagePath = _imageMap[PROPERTY_MEDIA_IMAGE_PATH];
        }
      }
    }
    Article _article = Article(
      title: itemMap[ADD_PROPERTY_TITLE],
      image: featuredImagePath,
    );

    Features _features = Features(
      propertyArea: itemMap[ADD_PROPERTY_SIZE],
      propertyAreaUnit: itemMap[ADD_PROPERTY_SIZE_PREFIX],
      landArea: itemMap[ADD_PROPERTY_LAND_AREA],
      landAreaUnit: itemMap[ADD_PROPERTY_LAND_AREA_PREFIX],
      bedrooms: itemMap[ADD_PROPERTY_BEDROOMS],
      bathrooms: itemMap[ADD_PROPERTY_BATHROOMS],
    );

    PropertyInfo _propertyInfo = PropertyInfo(
      price: itemMap[ADD_PROPERTY_PRICE],
    );

    _article.features = _features;
    _article.propertyInfo = _propertyInfo;
    _article.propertyDetailsMap![PRICE] = itemMap[ADD_PROPERTY_PRICE] ?? "";

    return _article;
  }

  static int getIntValueFromString(String inputString) {
    int _integerValue = int.tryParse(inputString.replaceAll(RegExp(r'[^\d]+'), '')) ?? 0;
    return _integerValue;
  }

  static List<String> getSanitizedStringPickerList(List<String> optionsList) {
    List<String> sanitizedOptionsList = [];

    if (optionsList.isNotEmpty) {
      sanitizedOptionsList = optionsList.map((option) {
        return option.replaceAll(RegExp(r'[^0-9]'),
            ''); // Replace any character that is not a digit with an empty string
      }).toList();
    }

    return sanitizedOptionsList;
  }

  static (bool, String) addCountryName(Map map) {
    if (map[propertyCountryDataType] != null) {
      if (map[propertyCountryDataType] is List &&
          map[propertyCountryDataType].isNotEmpty &&
          map[propertyCountryDataType][0] is String &&
          map[propertyCountryDataType][0].isNotEmpty &&
          map[propertyCountryDataType][0] != allCapString) {
        return (true, map[propertyCountryDataType][0]);
      } else if (map[propertyCountryDataType] is String &&
          map[propertyCountryDataType].isNotEmpty &&
          map[propertyCountryDataType] != allCapString) {
        return (true, map[propertyCountryDataType]);
      }
    }
    return (false, "");
  }

  static (bool, String) addStateName(Map map) {
    if (map[propertyStateDataType] != null) {
      if (map[propertyStateDataType] is List &&
          map[propertyStateDataType].isNotEmpty &&
          map[propertyStateDataType][0] is String &&
          map[propertyStateDataType][0].isNotEmpty &&
          map[propertyStateDataType][0] != allCapString) {
        return (true, map[propertyStateDataType][0]);
      } else if (map[propertyStateDataType] is String &&
          map[propertyStateDataType].isNotEmpty &&
          map[propertyStateDataType] != allCapString) {
        return (true, map[propertyStateDataType]);
      }
    }
    return (false, "");
  }

  static (bool, String) addCityName() {
    Map map = HiveStorageManager.readSelectedCityInfo();
    String city = UtilityMethods.valueForKeyOrEmpty(map as Map<String, dynamic>, CITY);
    if (city.isNotEmpty && city != allCapString) {
      return (true, city);
    }
    return (false, "");
  }

  static (bool, String) addAreaName(Map map) {
    if (map[propertyAreaDataType] != null) {
      if (map[propertyAreaDataType] is List &&
          map[propertyAreaDataType].isNotEmpty &&
          map[propertyAreaDataType][0] is String &&
          map[propertyAreaDataType][0].isNotEmpty &&
          map[propertyAreaDataType][0] != allCapString) {
        return (true, map[propertyAreaDataType][0]);
      } else if (map[propertyAreaDataType] is String &&
          map[propertyAreaDataType].isNotEmpty &&
          map[propertyAreaDataType] != allCapString) {
        return (true, map[propertyAreaDataType]);
      }
    }
    return (false, "");
  }

  static String getHomeLocationString(Map map, {
    bool allowCountry = true,
    bool allowState = true,
    bool allowCity = true,
    bool allowArea = true,
  }) {
    var (showCountry, countryName) = addCountryName(map);
    var (showState, stateName) = addStateName(map);
    var (showCity, cityName) = addCityName();
    var (showArea, areaName) = addAreaName(map);
    // print("Should Add Country Name: $showCountry");
    // print("Should Add State Name: $showState");
    // print("Should Add City Name: $showCity");
    // print("Should Add Area Name: $showArea");

    // List<String> components = [];
    //
    // if (showCountry) components.add(countryName);
    // if (showState) components.add(stateName);
    // if (showCity) components.add(cityName);
    // if (showArea) components.add(areaName);
    //
    // if (components.isEmpty) return "please_select";
    //
    // return components.join(", ");
    if (showCountry && !allowCountry) {
      showCountry = false;
    }

    if (showState && !allowState) {
      showState = false;
    }

    if (showCity && !allowCity) {
      showCity = false;
    }

    if (showArea && !allowArea) {
      showArea = false;
    }

    if (showCountry && !allowCountry) {
      showCountry = false;
    }

    if (showState && !allowState) {
      showState = false;
    }

    if (showCity && !allowCity) {
      showCity = false;
    }

    if (showArea && !allowArea) {
      showArea = false;
    }

    // Prioritize the last two strings
    if (showArea && showCity) {
      return "$cityName, $areaName";
    } else if (showCity && showState) {
      return "$stateName, $cityName";
    } else if (showArea && showState) {
      return "$stateName, $areaName";
    } else if (showCity && showCountry) {
      return "$countryName, $cityName";
    } else if (showArea && showCountry) {
      return "$countryName, $areaName";
    } else if (showState && showCountry) {
      return "$countryName, $stateName";
    }

    // If only one string is available, return that string
    if (showArea) return areaName;
    if (showCity) return cityName;
    if (showState) return stateName;
    if (showCountry) return countryName;

    // If no string is available, return "please_select"
    return "please_select";
  }

  static String getHomePropertyItemDesignName(Map item) {
    if (item[designKey] == ITEM_DESIGN_FROM_HOOK) {
      return item[titleKey];
    }
    return UtilityMethods.getDesignValue(item[designKey]) ?? DESIGN_01;
  }

  static double getTermsWithIconWidgetHeight(double width) {
    return (width / 4) - 5;
  }

  static String valueForKeyOrEmpty(Map<String, dynamic> map, String key) {
    if (map[key] != null) {
      List valueList = map[key] is List ? map[key] : [map[key]];
      return "${valueList.first}";
    }
    return "";
  }

  static List listForKeyOrEmpty(Map map, String key) {
    if (map[key] != null) {
      return map[key] is List ? map[key] : [map[key]];
    }
    return [];
  }

  /// Messages Related
  static String getThreadSenderDisplayName(ThreadItem item) {
    String? displayName = item.senderDisplayName;
    String? firstName = item.senderFirstName;
    String? lastName = item.senderLastName;

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    } else if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    } else if (lastName != null && lastName.isNotEmpty) {
      return lastName;
    }
    return "";
  }

  static String getThreadReceiverDisplayName(ThreadItem item) {
    String? displayName = item.receiverDisplayName;
    String? firstName = item.receiverFirstName;
    String? lastName = item.receiverLastName;

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    } else if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    } else if (lastName != null && lastName.isNotEmpty) {
      return lastName;
    }
    return "";
  }

  static void navigateToMembershipPlanPage(BuildContext context) {
    bool loadUserCurrentMembershipPackage = true;
    UserPaymentStatus? userPaymentStatus = HiveStorageManager.readUserPaymentStatus();

    if (userPaymentStatus != null) {
      bool hasMembership = userPaymentStatus.userHasMembership ?? false;
      if (!hasMembership) {
        loadUserCurrentMembershipPackage = false;
      }
    }

    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => MembershipPlanPage(fetchMembershipDetail: loadUserCurrentMembershipPackage),
    );
  }

  static String get _getDeviceType {

    // final double physicalWidth = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
    // final double devicePixelRatio =
    //     WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    // final double width = physicalWidth / devicePixelRatio;
    final data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    //print("window shortest size ${data.size.shortestSide}");
    return data.size.shortestSide < 700 ? 'phone' : 'tablet';
  }

  static bool get isTablet {
    return _getDeviceType == 'tablet';
  }

  static bool get showTabletView {
    return (Platform.isIOS && isTablet);
  }

  static bool listDependsOnUserSelection(homeConfigMap) {
    List subTypeList = UtilityMethods.listForKeyOrEmpty(homeConfigMap, subTypeListKey);
    List subTypeValueList = UtilityMethods.listForKeyOrEmpty(homeConfigMap, subTypeValueListKey);
    bool locationRelevantSection = homeConfigMap[subTypeKey] == propertyCountryDataType || homeConfigMap[subTypeKey] == propertyStateDataType
            || homeConfigMap[subTypeKey] == propertyCityDataType || homeConfigMap[subTypeKey] == propertyAreaDataType ;
    bool userSelectionDependantSection = homeConfigMap[subTypeValueKey] == userSelectedString;

    bool subTypeListContainLocationRelevantType =    subTypeList.contains(propertyCountryDataType) ||
        subTypeList.contains(propertyStateDataType) ||
        subTypeList.contains(propertyCityDataType) ||
        subTypeList.contains(propertyAreaDataType);
    bool subTypeValueValueIsUserSelection = subTypeValueList.contains(userSelectedString);
    return (locationRelevantSection && userSelectionDependantSection) || (subTypeListContainLocationRelevantType && subTypeValueValueIsUserSelection);
  }
  static String locationDependantSectionName(homeConfigMap, storedLocMap) {
    List subTypeList = UtilityMethods.listForKeyOrEmpty(homeConfigMap, subTypeListKey);

    if ( homeConfigMap[subTypeKey] == propertyCountryDataType || subTypeList.contains(propertyCountryDataType)) {
      return UtilityMethods.valueForKeyOrEmpty(storedLocMap, propertyCountryDataType);
    }

    if (homeConfigMap[subTypeKey] == propertyStateDataType || subTypeList.contains(propertyStateDataType)) {
      return UtilityMethods.valueForKeyOrEmpty(storedLocMap, propertyStateDataType);
    }
    if (homeConfigMap[subTypeKey] == propertyCityDataType || subTypeList.contains(propertyCityDataType)) {
      return UtilityMethods.valueForKeyOrEmpty(storedLocMap, CITY);
    }

    if (homeConfigMap[subTypeKey] == propertyAreaDataType ||  subTypeList.contains(propertyAreaDataType)) {
      return UtilityMethods.valueForKeyOrEmpty(storedLocMap, propertyAreaDataType);
    }
    return "";
  }


  static String titleForSectionBasedOnCitySelection(homeConfigMap, String city) {
    String title = "";

    if (!homeConfigMap.containsKey(titleKeyOrig)) {
      homeConfigMap[titleKeyOrig] = homeConfigMap[titleKey];
    }

    String titleKeyOriginal = homeConfigMap[titleKeyOrig];
    title = UtilityMethods.getLocalizedString(titleKeyOriginal);

    if (titleKeyOriginal.contains("Latest Properties")){
      title = UtilityMethods.getLocalizedString("latest_properties");
    }

    if (city.isNotEmpty && city.toLowerCase() != 'all' && city != 'please_select') {
      if (titleKeyOriginal.contains("{city_name}")) {
        title =  UtilityMethods.getLocalizedString(titleKeyOriginal, inputWords: [city]);
      } else if (titleKeyOriginal.contains("Latest Properties")){
        title = UtilityMethods.getLocalizedString("latest_properties_in_city", inputWords: [city]);
      }
    }

    if (title.contains("{city_name}")) {
      title = title.replaceAll("in {city_name}", "");
      title = title.replaceAll("{city_name}", "");
      title = UtilityMethods.getLocalizedString(title);
    }

    return title;
  }

  static TextInputType getKeyboardType(String? type) {
    if(type == textKeyboardType) {
      return TextInputType.text;
    } else if(type == numberKeyboardType) {
      return TextInputType.number;
    } else if(type == urlKeyboardType) {
      return TextInputType.url;
    } else if(type == emailKeyboardType) {
      return TextInputType.emailAddress;
    } else if(type == multilineKeyboardType) {
      return TextInputType.multiline;
    }
    return TextInputType.text;
  }

  static String getStringKeyboardType(TextInputType? type) {
    if(type == TextInputType.text) {
      return textKeyboardType;
    } else if(type == TextInputType.number) {
      return numberKeyboardType;
    } else if(type == TextInputType.url) {
      return urlKeyboardType;
    } else if(type == TextInputType.emailAddress) {
      return emailKeyboardType;
    } else if(type == TextInputType.multiline) {
      return multilineKeyboardType;
    }
    return textKeyboardType;
  }
}