class Custom {
  List<CustomField>? customFields;

  Custom({
    this.customFields,
  });
}

class CustomField {
  CustomField({
    this.id,
    this.label,
    this.fieldId,
    this.type,
    this.options,
    this.fvalues,
    this.isSearch,
    this.searchCompare,
    this.placeholder,
  });

  String? id;
  String? label;
  String? fieldId;
  String? type;
  String? options;
  dynamic fvalues;
  String? isSearch;
  dynamic searchCompare;
  String? placeholder;
}

class FvaluesClass {
  FvaluesClass({
    this.fValuesMap
  });

  Map<String,dynamic>? fValuesMap;

  factory FvaluesClass.fromJson(Map<String, dynamic> json) => FvaluesClass(
    fValuesMap: json
  );

}

class CustomFieldModel{
  String? name;
  String? parent;

  CustomFieldModel(this.name, this.parent);
}
