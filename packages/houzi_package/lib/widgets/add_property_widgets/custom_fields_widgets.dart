import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/custom_fields/custom_fields.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef CustomFieldsPageListener = void Function(Map<String, dynamic> _dataMap);

class CustomFieldsWidget extends StatefulWidget {
  final CustomField customFieldData;
  final propertyInfoMap;
  final bool fromFilterPage;
  final EdgeInsetsGeometry? padding;
  final CustomFieldsPageListener customFieldsPageListener;
  final int? formItemIndex;

  CustomFieldsWidget({
    required this.customFieldData,
    required this.propertyInfoMap,
    this.fromFilterPage = false,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
    required this.customFieldsPageListener,
    this.formItemIndex,
  });

  @override
  State<CustomFieldsWidget> createState() => _CustomFieldsWidgetState();
}

class _CustomFieldsWidgetState extends State<CustomFieldsWidget> {

  String textValue = "";

  Map propertyInfoMap = {};
  Map selectMap = {};
  Map multiSelectMap = {};
  Map<String,dynamic> customFieldDataPropertyInfoMap = {};

  int numberValue = 0;
  int selectedRadioButton = -1;

  List<dynamic> multiSelectList = [];
  List<dynamic> selectedMultiSelectList = [];

  var dropDownValue;
  var numberController = TextEditingController();

  final multiSelectTextController = TextEditingController();
  final textFieldTextController = TextEditingController();

  VoidCallback? generalNotifierLister;

  late CustomField customField;

  ApiManager _apiManager = ApiManager();

  @override
  void initState() {
    super.initState();

    customField = widget.customFieldData;
    propertyInfoMap = widget.propertyInfoMap;
    
    if (customField.type == CUSTOM_FIELDS_TYPE_SELECT) {
      selectMap = customField.fvalues;
    }

    if (customField.type == CUSTOM_FIELDS_TYPE_MULTI_SELECT) {
      multiSelectMap = customField.fvalues;
      multiSelectMap.forEach((k, v) => multiSelectList.add(CustomFieldModel(k, v)));
    }

    if (customField.type == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST) {
      List<dynamic> tempList = customField.fvalues;
      for (var item in tempList) {
        multiSelectList.add(CustomFieldModel(item, item));
      }
    }

    /// Initialization Work.......
    if (propertyInfoMap.isNotEmpty) {
      if (propertyInfoMap[customField.fieldId] != null &&
          propertyInfoMap[customField.fieldId].isNotEmpty){
        if (customField.type == CUSTOM_FIELDS_TYPE_NUMBER) {
          var value = propertyInfoMap[customField.fieldId];
          if(value is List){
            numberController.text = value[0];
          }else {
            numberController.text = value.toString();
          }
          numberValue = int.tryParse(numberController.text) ?? 0;
        }

        if (customField.type == CUSTOM_FIELDS_TYPE_TEXT ||
            customField.type == CUSTOM_FIELDS_TYPE_TEXT_AREA) {
          var value = propertyInfoMap[customField.fieldId];
          if(value is List){
            textValue = value[0];
          }else{
            textValue = value.toString();
          }
          textFieldTextController.text = textValue;
        }

        if (customField.type == CUSTOM_FIELDS_TYPE_SELECT) {
          var value = propertyInfoMap[customField.fieldId];
          if(value is List){
            dropDownValue = value[0];
          }else{
            dropDownValue = value.toString();
          }

        }

        if (customField.type == CUSTOM_FIELDS_TYPE_MULTI_SELECT ||
            customField.type == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST) {
          var data = propertyInfoMap[customField.fieldId];
          if(data is List){
            selectedMultiSelectList = data;
          }else {
  if (data is Map) {
    // Handle Map case with key-value pairs
    data.forEach((key, value) {
      if (widget.fromFilterPage) {
        selectedMultiSelectList.add(key);
      } else {
        selectedMultiSelectList.add(value);
      }
    });
  } else if (data is String) {
    // Handle String case - just add the string directly
    selectedMultiSelectList.add(data);
  } else if (data is List) {
    // Handle List case
    for (var item in data) {
      selectedMultiSelectList.add(item);
    }
  }
}
        }

        if (customField.type == CUSTOM_FIELDS_TYPE_RADIO ) {
          var value = propertyInfoMap[customField.fieldId];
          if(value is List){
            value = value.isNotEmpty ? value[0] : '';
          }
          getIndexForRadioButton(value);
        }
      }
    }

    generalNotifierLister = () {
      if (GeneralNotifier().change == GeneralNotifier.RESET_FILTER_DATA) {
        resetData();
      }
    };
    GeneralNotifier().addListener(generalNotifierLister!);

  }

  getIndexForRadioButton(String value) {
    List<CustomField> customFieldsList = [];
    Map<String, dynamic> data = HiveStorageManager.readCustomFieldsDataMaps();
    if (data.isNotEmpty) {
      final Custom custom = _apiManager.getCustomFieldsData(data);
      customFieldsList = custom.customFields ?? [];
    }

    var fieldList = [];
    if (customFieldsList.isNotEmpty) {
      for (var data in customFieldsList) {
        if (data.fieldId == customField.fieldId) {
          fieldList.add(data.fvalues);
          var tempList = fieldList[0];
          for (var data in tempList) {
            if (data == value) {
              String selectedRadioButtonStr = data;

              for (int i = 0; i < customField.fvalues.length; i++) {
                if (customField.fvalues[i] == selectedRadioButtonStr) {
                  selectedRadioButton = i;
                }
              }
            }
          }
        }
      }
    }

  }

  void resetData(){
    if(mounted){
      setState(() {
        selectedRadioButton = -1;
        selectedMultiSelectList.clear();
        numberController.text = "";
        numberValue = 0;
        dropDownValue = null;
        multiSelectTextController.text = "";
        textFieldTextController.text = "";
        textValue = "";
      });
    }
  }

  @override
  void dispose() {
    multiSelectTextController.dispose();
    textFieldTextController.dispose();
    if (generalNotifierLister != null) {
      GeneralNotifier().removeListener(generalNotifierLister!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (customField.type == CUSTOM_FIELDS_TYPE_MULTI_SELECT ||
        customField.type == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST) {
      if (selectedMultiSelectList.isNotEmpty &&
          selectedMultiSelectList.toSet().toList().length == 1) {
        multiSelectTextController.text =
            "${UtilityMethods.getLocalizedString(selectedMultiSelectList.toSet().toList().first)}";
      } else if (selectedMultiSelectList.isNotEmpty &&
          selectedMultiSelectList.toSet().toList().length > 1) {
        multiSelectTextController.text = UtilityMethods.getLocalizedString(
            "multi_select_drop_down_item_selected",
            inputWords: [
              (selectedMultiSelectList.toSet().toList().length.toString())
            ]);
      } else {
        multiSelectTextController.text = "";
      }
    }

    return Container(
      decoration: widget.formItemIndex == 0 ? null : AppThemePreferences.dividerDecoration(top: true),
      margin: widget.formItemIndex == 0 ? null : const EdgeInsets.only(top: 20),
      padding: widget.padding,
      child: getGenericCustomFieldsWidget(),
    );
  }
  
  Widget getGenericCustomFieldsWidget(){
    TextStyle? filterPageHeadingTitleTextStyle =
        AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle;

    if (customField.type == CUSTOM_FIELDS_TYPE_TEXT){
      return textWidget(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customField.type == CUSTOM_FIELDS_TYPE_RADIO){
      return radioButtonWidgets(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customField.type == CUSTOM_FIELDS_TYPE_SELECT){
      return dropDownViewWidget(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customField.type == CUSTOM_FIELDS_TYPE_NUMBER){
      return numberWidget(
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customField.type == CUSTOM_FIELDS_TYPE_TEXT_AREA){
      return textWidget(
        maxLines: 5,
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    } else if (customField.type == CUSTOM_FIELDS_TYPE_MULTI_SELECT ||
        customField.type == CUSTOM_FIELDS_TYPE_CHECKBOX_LIST){
      return multiSelectDropDownViewWidget(
        multiSelectList,
        labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
      );
    }
    
    return textWidget(
      labelTextStyle: widget.fromFilterPage ? filterPageHeadingTitleTextStyle : null,
    );
  }

  Widget radioButtonWidgets({TextStyle? labelTextStyle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (customField.label != null && customField.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LabelWidget(
              customField.label!,
              labelTextStyle: labelTextStyle,
            ),
          ),
        Padding(
          padding: UtilityMethods.isRTL(context)
              ? const EdgeInsets.only(right: 5.0)
              : const EdgeInsets.only(left: 5.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customField.fvalues.length,
            itemBuilder: (BuildContext context, int index) {
              return userChoiceFromRadioButton(
                value: index,
                groupValue: selectedRadioButton,
                onChanged: (value) {
                  String key = customField.fieldId ?? "";

                  if (key.isNotEmpty) {
                    setState(() {
                      selectedRadioButton = value!;
                      customFieldDataPropertyInfoMap["selectedRadioButton"] = value;
                      customFieldDataPropertyInfoMap[key] = customField.fvalues[index];
                    });
                    widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
                  }
                },
                optionText: customField.fvalues[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget userChoiceFromRadioButton({
    required int value,
    required int groupValue,
    required void Function(int?) onChanged,
    required String optionText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
          activeColor: AppThemePreferences().appTheme.primaryColor,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged
        ),
        GenericTextWidget(
          optionText,
          style: AppThemePreferences().appTheme.label01TextStyle,
        ),
      ],
    );
  }

  Widget dropDownViewWidget({TextStyle? labelTextStyle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(customField.label != null && customField.label!.isNotEmpty) Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LabelWidget(
            customField.label!,
            labelTextStyle: labelTextStyle,
          ),
        ),
        DropdownButtonFormField(
          dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
          icon: Icon(AppThemePreferences.dropDownArrowIcon),
          decoration: AppThemePreferences.formFieldDecoration(hintText: customField.placeholder),
          items: selectMap.map((key, value) {
            return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: GenericTextWidget(value),
                ));
            // return MapEntry(
            //     value,
            //     DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     ));
          }).values.toList(),
          value: dropDownValue,
          onChanged: (value) {
            String? key = customField.fieldId;
            if(key != null && value != null){
              customFieldDataPropertyInfoMap[key] = value;
              widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
            }
          },
          validator: (val) {
            // String value = val.toString();
            // if (val != null && value.isNotEmpty) {
            String? key = customField.fieldId;
            if(key != null && val != null){
              String value = val.toString();
              customFieldDataPropertyInfoMap[key] = value;
              widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget numberWidget({TextStyle? labelTextStyle}) {
    return GenericStepperWidget(
      labelTextStyle: labelTextStyle,
      givenWidth: 230, // 250
      textAlign: TextAlign.center,
      padding: EdgeInsets.zero,
      labelText: customField.label,
      labelTextPadding: EdgeInsets.zero,
      controller: numberController,
      onRemovePressed: () {
        String? key = customField.fieldId;
        if (key != null && numberValue > 0) {
          setState(() {
            numberValue -= 1;
            numberController.text = numberValue.toString();
            customFieldDataPropertyInfoMap[key] = numberValue.toString();
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
      },
      onAddPressed: () {
        String? key = customField.fieldId;
        if (key != null && numberValue >= 0) {
          setState(() {
            numberValue += 1;
            numberController.text = numberValue.toString();
            customFieldDataPropertyInfoMap[key] = numberValue.toString();
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
      },
      onChanged: (value) {
        String? key = customField.fieldId;
        if (key != null) {
          setState(() {
            numberValue = int.parse(value);
            customFieldDataPropertyInfoMap[key] = value;
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
      },
      validator: (String? value) {
        String? key = customField.fieldId;
        if (key != null && value != null && value.isNotEmpty) {
          setState(() {
            customFieldDataPropertyInfoMap[key] = value;
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
        return null;
      },
    );
  }

  Widget textWidget({int maxLines = 1, TextStyle? labelTextStyle}) {
    return TextFormFieldWidget(
      maxLines: maxLines,
      labelTextStyle: labelTextStyle,
      padding: EdgeInsets.zero,
      labelText: customField.label,
      hintText: customField.placeholder,
      controller: textFieldTextController,
      validator: (String? value) {
        String? key = customField.fieldId;
        if (key != null && value != null && value.isNotEmpty) {
          setState(() {
            customFieldDataPropertyInfoMap[key] = value;
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
        return null;
      },
      onChanged: (value){
        String? key = customField.fieldId;
        if (key != null) {
          setState(() {
            customFieldDataPropertyInfoMap[key] = value;
          });
          widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
        }
      },
      // initialValue: textValue,
    );
  }

  Widget multiSelectDropDownViewWidget(List dataList, {TextStyle? labelTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(customField.label != null && customField.label!.isNotEmpty)Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LabelWidget(
            customField.label!,
            labelTextStyle: labelTextStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.zero,
          child: TextFormField(
            controller: multiSelectTextController,
            decoration: AppThemePreferences.formFieldDecoration(
              hintText: UtilityMethods.getLocalizedString("select"),
              suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
            ),
            readOnly: true,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showMultiSelect(context, dataList);
            },
            validator: (String? value) {
              if (value != null && value.isNotEmpty) {
                // setState(() {
                //   customFieldDataPropertyInfoMap[customField.fieldId] = value;
                // });
                // widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _showMultiSelect(BuildContext context, List dataList) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialogWidget(
          selectedItemsList: selectedMultiSelectList,
          fromCustomFields: true,
          fromSearchPage: widget.fromFilterPage,
//           title: selectedMultiSelectList != null &&
//               selectedMultiSelectList.isNotEmpty &&
//               selectedMultiSelectList.length > 1
//               ? selectedMultiSelectList.length.toString() + " " + GenericMethods.getLocalizedString("selected")
//               : GenericMethods.getLocalizedString("select"),
//           dataItemsList: multiSelectMap,
          title: UtilityMethods.getLocalizedString("select"),
          dataItemsList: dataList,
          multiSelectDialogWidgetListener: (List<dynamic> selectedItemsList, List<dynamic> listOfSelectedItemsSlugs) {
            Map map = {};
            if(widget.fromFilterPage){
              Map tempMap = {for (var item in listOfSelectedItemsSlugs) '$item' : '$item'};
              map.addAll(tempMap);
            }else{
              Map tempMap = {for (var item in selectedItemsList) '$item' : '$item'};
              map.addAll(tempMap);
            }

            selectedMultiSelectList = selectedItemsList;

            String? key = customField.fieldId;
            if (key != null) {
              customFieldDataPropertyInfoMap[key] = map;
              widget.customFieldsPageListener(customFieldDataPropertyInfoMap);
            }
          },
        );
      },
    );
  }
}
