class FilterPageElement {
  String? sectionType;
  String? title;
  String? dataType;
  String? apiValue;
  String? pickerType;
  bool? showSearchByCity;
  bool? showSearchByLocation;
  String? minValue;
  String? maxValue;
  String? divisions;
  String? options;
  String? pickerSubType;
  String? uniqueKey;
  String? queryType;
  String? defaultRadius;
  List<String>? locationPickerHierarchyList;

  FilterPageElement({
    this.sectionType,
    this.title,
    this.dataType,
    this.apiValue,
    this.pickerType,
    this.showSearchByCity = true,
    this.showSearchByLocation = true,
    this.minValue = "0",
    this.maxValue = "1000000",
    this.divisions = "1000",
    this.options,
    this.pickerSubType,
    this.uniqueKey,
    this.queryType,
    this.defaultRadius = "50",
    this.locationPickerHierarchyList,
  });
}

