class NavBar {
  List<NavbarItem>? navbarLayout;

  NavBar({
    this.navbarLayout,
  });
}

class NavbarItem {
  String? sectionType;
  String? title;
  String? url;
  bool? checkLogin;
  List<String>? subTypeList;
  List<String>? subTypeValuesList;
  Map<String, dynamic>? searchApiMap;
  String? iconDataJson;

  NavbarItem({
    this.sectionType,
    this.title,
    this.url,
    this.checkLogin = false,
    this.subTypeList,
    this.subTypeValuesList,
    this.searchApiMap,
    this.iconDataJson,
  });
}