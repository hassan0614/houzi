
import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef ShowFilterDialogPageListener = void Function(
    bool showDialog, String? approvalStatus, );

class ShowFilterDialog extends StatefulWidget {
  final ShowFilterDialogPageListener filterDialogPageListener;
  final bool fromUsers;
  final bool fromReviews;
  final List approvalList;

  const ShowFilterDialog({
    super.key,
    required this.filterDialogPageListener,
    this.fromUsers = false,
    this.fromReviews = false,
    required this.approvalList,
  });

  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowFilterDialog> {

  List<dynamic> approvalList = [];
  bool _showWaitingWidget = true;
  String? _selectedApprovalStatus;
  String? _selectedBulkActionCategory;

  @override
  void initState() {
    super.initState();
    loadMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.filterDialogPageListener(false, null,),
      child: Scaffold(
        backgroundColor: AppThemePreferences.filterDialogBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              color: AppThemePreferences().appTheme.cardColor,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildUserStatusSection(),
                    ],
                  ),
                  if (_showWaitingWidget) BallBeatLoadingWidget(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            UtilityMethods.getLocalizedString("Filter_users"),
            style: AppThemePreferences().appTheme.heading03TextStyle,
          ),
          IconButton(
            icon: Icon(AppThemePreferences.closeIcon),
            onPressed: () => widget.filterDialogPageListener(false, null,),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GenericTextWidget(
          UtilityMethods.getLocalizedString("bulk_action"),
          style: AppThemePreferences().appTheme.headingTextStyle,
        ),
        const SizedBox(height: 10),
        
          _buildDropdown(
            items: approvalList,
            fromReviews: widget.fromReviews,
            hint: UtilityMethods.getLocalizedString("bulk_action_category"),
            value: _selectedBulkActionCategory,
            onChanged: (value) => setState(() => _selectedBulkActionCategory = value),
          ),
        const SizedBox(height: 10),
        ButtonWidget(
          text: UtilityMethods.getLocalizedString("apply"),
          onPressed: () {
            widget.filterDialogPageListener(false, null, );
          },
        ),
      ],
    );
  }

  Widget _buildUserStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          items: approvalList,
          fromReviews: widget.fromReviews,
          hint: UtilityMethods.getLocalizedString("select_status"),
          value: _selectedApprovalStatus,
          onChanged: (value) => setState(() => _selectedApprovalStatus = value),
        ),
        const SizedBox(height: 10),
        ButtonWidget(
          text: UtilityMethods.getLocalizedString("filter"),
          onPressed: () {
            widget.filterDialogPageListener(false, _selectedApprovalStatus, );
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
  required List<dynamic> items,
  required bool fromReviews,
  required String hint,
  required String? value,
  required Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: value,
    dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
    icon: Icon(AppThemePreferences.dropDownArrowIcon),
    decoration: AppThemePreferences.formFieldDecoration(hintText: hint),
    items: items.map<DropdownMenuItem<String>>((item) {
      String itemValue;
      String itemLabel;

      // Handle if item is a String
      if (item is String) {
        itemValue = item;
        itemLabel = item;
      }
      // Handle if item is a Map or Object with status and label
      else if (item is Map && item.containsKey('status') && item.containsKey('label')) {
        itemValue = item['status'].toString();
        itemLabel = item['label'].toString();
      }
      else if (item != null && item.status != null && item.label != null) {
        itemValue = item.status.toString();
        itemLabel = item.label.toString();
      }
      else {
        itemValue = item.toString();
        itemLabel = item.toString();
      }

      return DropdownMenuItem<String>(
        value: itemValue,
        child: GenericTextWidget(UtilityMethods.getLocalizedString(itemLabel)),
      );
    }).toList(),
    onChanged: onChanged,
  );
}


 

  Future<void> loadMetaData() async {
    try {
      approvalList = widget.approvalList;
      // approvalList = HiveStorageManager.readApprovalStatusesList();
    } catch (e) {
      UtilityMethods.printAttentionMessage("Error loading metadata: $e");
    }

    if (mounted) {
      setState(() => _showWaitingWidget = false);
    }
  }

 
}