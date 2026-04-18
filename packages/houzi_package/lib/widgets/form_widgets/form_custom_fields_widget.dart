import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/custom_fields/custom_fields.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/widgets/add_property_widgets/custom_fields_widgets.dart';

typedef GenericFormCustomFieldWidgetListener = void Function(Map<String, dynamic> dataMap);

class GenericFormCustomFieldWidget extends StatefulWidget {
  final HouziFormItem formItem;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final GenericFormCustomFieldWidgetListener listener;
  final int? formItemIndex;
  
  const GenericFormCustomFieldWidget({
    Key? key,
    required this.formItem,
    this.infoDataMap,
    this.formItemPadding,
    required this.listener,
    this.formItemIndex,
  }) : super(key: key);

  @override
  State<GenericFormCustomFieldWidget> createState() => _GenericFormCustomFieldWidgetState();
}

class _GenericFormCustomFieldWidgetState extends State<GenericFormCustomFieldWidget> {
  
  Map<String, dynamic>? infoDataMap;
  Map<String, dynamic>? listenerDataMap;
  List<CustomField> customFieldsList = [];
  ApiManager _apiManager = ApiManager();

  @override
  void initState() {
    super.initState();

    infoDataMap = widget.infoDataMap;

    Map<String, dynamic> data = HiveStorageManager.readCustomFieldsDataMaps();
    if (data.isNotEmpty) {
      final Custom custom = _apiManager.getCustomFieldsData(data);
      customFieldsList = custom.customFields ?? [];
    }


  }

  @override
  void dispose() {
    infoDataMap = null;
    listenerDataMap = null;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (customFieldsList.isNotEmpty) {
      return Column(
        children: customFieldsList.map((fieldData) {
          return CustomFieldsWidget(
            padding: widget.formItemPadding,
            customFieldData: fieldData,
            propertyInfoMap: infoDataMap,
            formItemIndex: widget.formItemIndex,
            customFieldsPageListener: (Map<String, dynamic> dataMap){
              infoDataMap!.addAll(dataMap);
              widget.listener(infoDataMap!);
            },
          );
        }).toList(),
      );
    }
    
    return Container();
  }
}
