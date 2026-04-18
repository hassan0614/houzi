import 'package:flutter/material.dart';

class HouziFormPage {
  bool enable;
  String? title;
  List<String>? allowedRoles;
  List<HouziFormSectionFields>? pageFields;

  HouziFormPage({
    this.enable = true,
    this.title,
    this.allowedRoles,
    this.pageFields,
  });
}

class HouziFormSectionFields {
  bool enable;
  String? section;
  List<HouziFormItem>? fields;

  HouziFormSectionFields({
    this.enable = true,
    this.section,
    this.fields,
  });
}

class HouziFormItem{
  bool enable;
  List<String>? allowedRoles;
  String apiKey;
  String? sectionType;
  String? termType;
  String? title;
  String? hint;
  String? additionalHint;
  bool performValidation;
  String? validationType;
  int maxLines;
  TextInputType? keyboardType;
  dynamic fieldValues;

  HouziFormItem({
    required this.apiKey,
    required this.sectionType,
    this.title,
    this.enable = true,
    this.allowedRoles,
    this.termType,
    this.hint,
    this.additionalHint,
    this.performValidation = false,
    this.validationType,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.fieldValues,
  });
}

class FieldValues {
  Map<String,dynamic>? fieldValuesMap;

  FieldValues({
    this.fieldValuesMap
  });

  static FieldValues fromJson(Map<String, dynamic> json) => FieldValues(
      fieldValuesMap: json
  );

  static Map<String, dynamic>? toJson(FieldValues fieldValues) {
    return fieldValues.fieldValuesMap;
  }

}