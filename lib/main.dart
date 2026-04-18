import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:houzi/hooks_v2.dart';
import 'package:houzi_package/houzi_main.dart' as houzi_package;

Future<void> main() async {
  // Required for async operations and plugin initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Android
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hooks
  final HooksV2 v2Hooks = HooksV2();
  final Map<String, dynamic> hooksMap = {
    "headers": v2Hooks.getHeaderMap(),
    "propertyDetailPageIcons": v2Hooks.getPropertyDetailPageIconsMap(),
    "elegantHomeTermsIcons": v2Hooks.getElegantHomeTermsIconMap(),
    "drawerItems": v2Hooks.getDrawerItems(),
    "fonts": v2Hooks.getFontHook(),
    "propertyItem": v2Hooks.getPropertyItemHook(),
    "propertyItemV2": v2Hooks.getPropertyItemHookV2(),
    "propertyItemHeightHook": v2Hooks.getPropertyItemHeightHook(),
    "termItem": v2Hooks.getTermItemHook(),
    "agentItem": v2Hooks.getAgentItemHook(),
    "agencyItem": v2Hooks.getAgencyItemHook(),
    "widgetItems": v2Hooks.getWidgetHook(),
    "languageNameAndCode": v2Hooks.getLanguageCodeAndName(),
    "defaultLanguageCode": v2Hooks.getDefaultLanguageHook(),
    "defaultHomePage": v2Hooks.getDefaultHomePageHook(),
    "defaultCountryCode": v2Hooks.getDefaultCountryCodeHook(),
    "settingsOption": v2Hooks.getSettingsItemHook(),
    "profileItem": v2Hooks.getProfileItemHook(),
    "homeRightBarButtonWidget": v2Hooks.getHomeRightBarButtonWidgetHook(),
    "markerTitle": v2Hooks.getMarkerTitleHook(),
    "markerIcon": v2Hooks.getMarkerIconHook(),
    "customMapMarker": v2Hooks.getCustomMarkerHook(),
    "priceFormatter": v2Hooks.getPriceFormatterHook(),
    "compactPriceFormatter": v2Hooks.getCompactPriceFormatterHook(),
    "textFormFieldCustomizationHook": v2Hooks.getTextFormFieldCustomizationHook(),
    "editProfileShowFieldHook": v2Hooks.getEditProfileShowFieldHook(),
    "textFormFieldWidgetHook": v2Hooks.getTextFormFieldWidgetHook(),
    "customSegmentedControlHook": v2Hooks.getCustomSegmentedControlHook(),
    "drawerHeaderHook": v2Hooks.getDrawerHeaderHook(),
    "hidePriceHook": v2Hooks.getHidePriceHook(),
    "hideEmptyTerm": v2Hooks.hideEmptyTerm(),
    "homeSliverAppBarBodyHook": v2Hooks.getHomeSliverAppBarBodyHook(),
    "homeSliverAppBarBGImageHook": v2Hooks.getHomeSliverAppBarBGImageHook(),
    "homeWidgetsHook": v2Hooks.getHomeWidgetsHook(),
    "drawerWidgetsHook": v2Hooks.getDrawerWidgetsHook(),
    "membershipPlanHook": v2Hooks.getMembershipPlanHook(),
    "membershipPackageUpdatedHook": v2Hooks.getMembershipPackageUpdatedHook(),
    "paymentHook": v2Hooks.getPaymentHook(),
    "paymentSuccessfulHook": v2Hooks.getPaymentSuccessfulHook(),
    "addPlusButtonInBottomBarHook": v2Hooks.getAddPlusButtonInBottomBarHook(),
    "navbarWidgetsHook": v2Hooks.getNavbarWidgetsHook(),
    "clusterMarkerIconHook": v2Hooks.getCustomizeClusterMarkerIconHook(),
    "customClusterMarkerIconHook": v2Hooks.getCustomClusterMarkerIconHook(),
    "membershipPayWallDesignHook": v2Hooks.getMembershipPayWallDesignHook(),
    "minimumPasswordLengthHook": v2Hooks.getMinimumPasswordLengthHook(),
    "agentProfileConfigurationsHook": v2Hooks.getAgentProfileConfigurationsHook(),
    "userLoginActionHook": v2Hooks.getUserLoginActionHook(),
    "addPropertyActionHook": v2Hooks.getAddPropertyActionHook(),
    "drawerMenuItemDesignHook": v2Hooks.getDrawerMenuItemDesignHook(),
    "defaultAppThemeModeHook": v2Hooks.getDefaultAppThemeModeHook(),
    "messageApiRefreshTimeHook": v2Hooks.getMessageApiRefreshTimeHook(),
    "threadApiRefreshTimeHook": v2Hooks.getThreadApiRefreshTimeHook(),
    "customCountryHook": v2Hooks.getCustomCountryHook(),
  };

  // Launch Houzi app (Android-ready)
  await houzi_package.main(
    "assets/configurations/configurations.json",
    hooksMap,
  );
}