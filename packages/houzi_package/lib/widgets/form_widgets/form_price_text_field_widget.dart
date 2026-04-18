import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/models/listing_related/currency_rate_model.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef GenericPriceFormTextFieldWidgetListener = void Function(
    Map<String, dynamic> dataMap);

class GenericPriceFormTextFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final bool isPropertyForUpdate;
  final GenericPriceFormTextFieldWidgetListener listener;
  const GenericPriceFormTextFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.isPropertyForUpdate = false,
    this.formItemPadding,
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericPriceFormTextFieldWidget> createState() =>
      _GenericPriceFormTextFieldWidgetState();
}

class _GenericPriceFormTextFieldWidgetState
    extends State<GenericPriceFormTextFieldWidget> with ValidationMixin {
  String? apiKey;
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;
  final TextEditingController controller = TextEditingController();
  String? selectedDropdownValue;
  List<String> validCurrencies = [];
  bool _isMultiCurrencyEnabled = false;
  Map<dynamic, dynamic> _multiCurrency = {};
  dynamic _defaultMultiCurrency;
  String _defaultCurrency = '';
  
  String selectedCurrency = '';
    final CurrencyRatesModel? _baseCurrency = HiveStorageManager.readBaseCurrency() ;
  @override
  void initState() {
  // print("[Currency] Base currency: $_baseCurrency");
  // print("[Currency] Controller text: ${selectedCurrency}, ${infoDataMap?[ADD_PROPERTY_CURRENCY]}");

    // Get currency data from storage
    _defaultMultiCurrency = HiveStorageManager.readDefaultMultiCurrency();
    _isMultiCurrencyEnabled =
        HiveStorageManager.readMultiCurrencyEnabledStatus();
    _multiCurrency =
        HiveStorageManager.readMultiCurrencyDataMaps() as Map? ?? {};
    _defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? '\$';
    
    // print("[Currency] Symbol: ${widget.infoDataMap?[ADD_PROPERTY_CURRENCY]}");
    // Filter out empty keys from multi-currency map
    validCurrencies = _multiCurrency.values
        .where((k) => k != null && k.toString().isNotEmpty)
        .toSet()
        .toList()
        .cast<String>();
    
    // Handle currency selection
    selectedCurrency = getSelectedCurrency(
      defaultMultiCurrency: _defaultMultiCurrency,
      defaultCurrency: _defaultCurrency,
      baseCurrency:  _baseCurrency,
      validCurrencies: validCurrencies,
      infoDataMap: widget.infoDataMap,
      infoDataKey: ADD_PROPERTY_CURRENCY,
      isPropertyForUpdate: widget.isPropertyForUpdate,
    );

  

    infoDataMap = widget.infoDataMap;
    apiKey = widget.formItem.apiKey;

    if (infoDataMap != null && apiKey != null && apiKey!.isNotEmpty) {
      if (infoDataMap!.containsKey(apiKey)) {
        controller.text = infoDataMap![apiKey] ?? "";

        // print("[Currency] Controller text: ${controller.text}");
      }
    }

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
   

    return Column(
      children: [
        if (_isMultiCurrencyEnabled)
          _multiCurrencySelector()
        else
          _currencyViewer(),
        TextFormFieldWidget(
          labelText: widget.formItem.title,
          hintText: widget.formItem.hint,
          additionalHintText: widget.formItem.additionalHint,
          padding: widget.formItemPadding,
          controller: controller,
          keyboardType: widget.formItem.keyboardType ?? TextInputType.text,
          maxLines: widget.formItem.maxLines,
          onSaved: (text) => updateValue(text),
          onChanged: (text) => updateValue(text),
          isCompulsory: widget.formItem.performValidation,
          validator: (text) {
            updateValue(text);
            if (widget.formItem.performValidation) {
              return validationFunc(text, widget.formItem.validationType);
            }
            return null;
          },
        ),
      ],
    );
  }

  String getSelectedCurrency({
    required dynamic defaultMultiCurrency,
    required String defaultCurrency,
    required CurrencyRatesModel? baseCurrency,
    required List<String> validCurrencies,
    required Map<String, dynamic>? infoDataMap,
    required String infoDataKey,
    required bool isPropertyForUpdate,
  }) {
    String selectedCurrency = defaultCurrency;
    final String? infoCurrency =
        infoDataMap != null ? infoDataMap[infoDataKey] as String? : null;
    if (infoCurrency != null && isPropertyForUpdate && infoCurrency.isNotEmpty) {
      selectedCurrency = infoCurrency;
    }
    if (validCurrencies.isNotEmpty) {
      if (isPropertyForUpdate) {
        if (infoCurrency != null && validCurrencies.contains(infoCurrency)) {
          selectedDropdownValue = infoCurrency;
        }
        if (infoCurrency != null) {
          selectedCurrency = infoCurrency;
        }
      } else {
        selectedDropdownValue = validCurrencies.contains(defaultMultiCurrency)
            ? defaultMultiCurrency
            : validCurrencies.first;
      }

      selectedCurrency = selectedDropdownValue!;
    }
    if (baseCurrency != null && baseCurrency.symbol.isNotEmpty) {
      if (isPropertyForUpdate && infoCurrency != null) {
          selectedCurrency = infoCurrency;
      }
      else{
      print("[validCurrencies] Selected currency: $baseCurrency");
      selectedCurrency = baseCurrency.symbol;}
    }

    // Assign to infoDataMap if it's not null
    infoDataMap?[infoDataKey] = selectedCurrency;
    return selectedCurrency;
  }

  updateValue(String? text) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      listenerDataMap = {apiKey!: text};
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

  TextFormFieldWidget _currencyViewer() {
    return TextFormFieldWidget(
      labelText: UtilityMethods.getLocalizedString("Currency"),
      hintText: selectedCurrency,
      additionalHintText:
          UtilityMethods.getLocalizedString("default_currency_additional_hint"),
      padding: widget.formItemPadding,
      enabled: false,
    );
  }

  // Multi Currency Selector
  Widget _multiCurrencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: widget.formItemPadding,
          child: GenericTextWidget(
            UtilityMethods.getLocalizedString("Currency"),
            style: AppThemePreferences().appTheme.labelTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppThemePreferences.globalRoundedCornersRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppThemePreferences().appTheme.primaryColor!)),
              hintText: UtilityMethods.getLocalizedString("Select Currency"),
            ),
            value: selectedDropdownValue, // This is now properly initialized
            isExpanded: true,
            hint: HintText(
                text: UtilityMethods.getLocalizedString("Select Currency")),
            items: validCurrencies.isNotEmpty ? validCurrencies.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList() : null, // Handle empty list
            onChanged: validCurrencies.isNotEmpty ? (value) {
              setState(() {
                selectedDropdownValue = value;
                // Initialize listenerDataMap if null
                listenerDataMap ??= {};
                listenerDataMap![ADD_PROPERTY_CURRENCY] = selectedDropdownValue;
                widget.listener(listenerDataMap!);
                infoDataMap?[ADD_PROPERTY_CURRENCY] = selectedDropdownValue;
              });
            } : null, // Disable if no currencies available
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: AdditionalHintWidget(
              UtilityMethods.getLocalizedString("multi-currency-hint-text"),
              textStyle: AppThemePreferences().appTheme.hintTextStyle),
        ),
      ],
    );
  }
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
    return GenericTextWidget(
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