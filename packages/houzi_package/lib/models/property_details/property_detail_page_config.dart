class PropertyDetailPageLayout {
  PropertyDetailPageLayout({
    this.propertyDetailPageLayout,
  });

  List<PropertyDetailPageLayoutElement>? propertyDetailPageLayout;
}

class PropertyDetailPageLayoutElement {
  PropertyDetailPageLayoutElement({
    this.widgetType,
    this.widgetTitle,
    this.widgetEnable,
    this.widgetViewType,
  });

  String? widgetType;
  String? widgetTitle;
  bool? widgetEnable;
  String? widgetViewType;


}
