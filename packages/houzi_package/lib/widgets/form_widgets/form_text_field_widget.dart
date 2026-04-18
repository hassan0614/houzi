import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef GenericTextFormFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormTextFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericTextFormFieldWidgetListener listener;
//   // Dropdown widget
//    final bool enableDropdown;
//    final List<String>? dropdownItems;
//    final void Function(String?)? onDropdownChanged;
//    final String? initialDropdownValue;
//  final bool isMultiCurrencyEnabled;
  const GenericFormTextFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener, 
    // required this.enableDropdown, this.dropdownItems,  this.onDropdownChanged,  this.initialDropdownValue, this.isMultiCurrencyEnabled = false,
  }) : super(key: key);

  @override
  State<GenericFormTextFieldWidget> createState() => _GenericFormTextFieldWidgetState();
}

class _GenericFormTextFieldWidgetState extends State<GenericFormTextFieldWidget> with ValidationMixin {

  String? apiKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;
  final TextEditingController controller = TextEditingController();
  String? selectedDropdownValue;
  @override
  void initState() {
    apiKey = widget.formItem.apiKey;
    infoDataMap = widget.infoDataMap;
    
    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        controller.text = infoDataMap![apiKey] ?? "";
      }
    }
    //  selectedDropdownValue = widget.initialDropdownValue ?? 
    //  (widget.dropdownItems != null && widget.dropdownItems!.isNotEmpty ? widget.dropdownItems!.first : null);
    super.initState();
  }

  @override
  void dispose() {
    apiKey = null;
    infoDataMap = null;
    listenerDataMap = null;
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (apiKey == ADD_PROPERTY_MAP_ADDRESS && widget.infoDataMap != null) {
      String tempApiKey = ADD_PROPERTY_MAP_ADDRESS+"temp";
      String infoFromMap = widget.infoDataMap!.containsKey(tempApiKey)  ? widget.infoDataMap![tempApiKey] : "";
      if (infoFromMap.isNotEmpty && infoFromMap != controller.text) {
        controller.text = infoFromMap;
        widget.infoDataMap!.remove(tempApiKey);
      }
    }
    

    return Column(
      children: [
          // if (widget.enableDropdown && widget.isMultiCurrencyEnabled)
          //  _multiCurrencySelector(),
        TextFormFieldWidget(
          labelText: widget.formItem.title,
          hintText: widget.formItem.hint,
          additionalHintText: widget.formItem.additionalHint,
          padding: widget.formItemPadding,
          controller: controller,
          keyboardType: widget.formItem.keyboardType ?? TextInputType.text,
          maxLines: widget.formItem.maxLines,
          onSaved: (text)=> updateValue(text),
          onChanged: (text)=> updateValue(text),
          isCompulsory: widget.formItem.performValidation,
          validator: (text) {
            updateValue(text);
            if(widget.formItem.performValidation) {
              return validationFunc(text, widget.formItem.validationType);
            }
            return null;
          },
        ),
      ],
    );
  }

  updateValue(String? text) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = { apiKey! : text };
      widget.listener(listenerDataMap!);
    }
  }
  
  String? validationFunc(String? text, String? type) {
    if (type == stringValidation) {
      return validateTextField(text);
    } else if (type == emailValidation) {
      return validateEmail(text);
    } else if (type == passwordValidation) {
      return validatePassword(text);
    } else if (type == phoneNumberValidation) {
      return validatePhoneNumber(text);
    } else if (type == userNameValidation) {
      return validateUserName(text);
    }

    return validateTextField(text);

  }
  //   // Multi Currency Selector
  //  Widget _multiCurrencySelector(){
  //      return  Column(
  //        crossAxisAlignment: CrossAxisAlignment.start,
  //        mainAxisAlignment: MainAxisAlignment.start,
  //        children: [
  //          Container(
  //                padding: widget.formItemPadding,
  //                child: LabelWidget(
  //            UtilityMethods.getLocalizedString("Currency"),
  //            labelTextStyle: AppThemePreferences().appTheme.labelTextStyle,
  //          )
  //              ),
  //          // const SizedBox(height: 8),
  //          Container(
  //            padding: widget.formItemPadding,
  //                  decoration: BoxDecoration(
  //                    borderRadius:  BorderRadius.circular(
  //                        AppThemePreferences.globalRoundedCornersRadius),
  //                  ),
  //              child: DropdownButtonFormField<String>(
 
  //                decoration: InputDecoration(
  //                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppThemePreferences().appTheme.primaryColor!)),
  //                ),
  //                value: selectedDropdownValue,
  //                isExpanded: true,
  //                 hint: HintText(text: UtilityMethods.getLocalizedString("Select Currency")),
  //                items: widget.dropdownItems!.map((item) {
  //                  return DropdownMenuItem<String>(
  //                    value: item,
  //                    child: Text(item),
  //                  );
  //                }).toList(),
  //                onChanged: (value) {
  //                  setState(() {
  //                    selectedDropdownValue = value;
  //                  });
  //                  widget.onDropdownChanged?.call(value);
  //                },
  //              ),
  //            ),
  //        ],
  //      );
  //  }
 }
 
 class LabelWidget extends StatelessWidget {
   final String text;
   final TextStyle? labelTextStyle;
 
   const LabelWidget(
       this.text, {
         Key? key,
         this.labelTextStyle,
       }) : super(key: key);
 
   @override
   Widget build(BuildContext context) {
     return  GenericTextWidget(
       UtilityMethods.getLocalizedString(text),
       style: labelTextStyle ?? AppThemePreferences().appTheme.labelTextStyle,
     );
   }
}

 class HintText extends StatelessWidget {
   final String text;
   const HintText({super.key, required this.text});
 
   @override
   Widget build(BuildContext context) {
     return GenericTextWidget(
       UtilityMethods.getLocalizedString(text),
       style: AppThemePreferences().appTheme.labelTextStyle,
     );
   }
   
 } 