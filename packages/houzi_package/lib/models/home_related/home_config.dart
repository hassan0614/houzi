import 'package:houzi_package/models/home_related/terms_with_icon.dart';

class HomeConfig {
  HomeConfig({
    this.homeLayout,
  });

  List<HomeLayout>? homeLayout;
}

class HomeLayout {

  String? sectionType;
  String? title;
  String? layoutDesign;
  String? subType;
  String? subTypeValue;
  String? sectionListingView;
  bool? showFeatured;
  bool? showNearby;
  List<dynamic>? subTypeList;
  List<dynamic>? subTypeValuesList;
  Map<String, dynamic>? searchApiMap;
  Map<String, dynamic>? searchRouteMap;
  List<TermsWithIcon>? termsWithIconLayout;

  HomeLayout({
    this.sectionType,
    this.title,
    this.layoutDesign,
    this.subType,
    this.subTypeValue,
    this.sectionListingView,
    this.showFeatured = false,
    this.showNearby = false,
    this.subTypeList,
    this.subTypeValuesList,
    this.searchApiMap,
    this.searchRouteMap,
    this.termsWithIconLayout,
  });
}
