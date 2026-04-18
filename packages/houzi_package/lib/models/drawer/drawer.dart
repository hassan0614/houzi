class DrawerLayoutConfig {
  DrawerLayoutConfig({
    this.drawerLayout,
  });

  List<DrawerLayout>? drawerLayout;
}

class DrawerLayout {
  DrawerLayout({
    this.sectionType,
    this.title,
    this.checkLogin,
    this.enable,
    this.expansionTileChildren,
    this.dataMap,
  });

  String? sectionType;
  String? title;
  bool? checkLogin;
  bool? enable;
  List<ExpansionTileChild>? expansionTileChildren;
  Map<String, dynamic>? dataMap;
}

class ExpansionTileChild {
  ExpansionTileChild({
    this.sectionType,
    this.title,
    this.checkLogin,
  });

  String? sectionType;
  String? title;
  bool? checkLogin;
}
