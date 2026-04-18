import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import '../../pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';

typedef ReviewOptionsWidgetListener = Function({
  int? contentItemID,
  bool? isApprove,
  bool? isTrash,
});

class ReviewOptionsWidget extends StatelessWidget {
  final int contentItemID;
  final String reportNonce;
  final ReviewOptionsWidgetListener listener;
  final bool isAdminReviewManagement;
  final bool isFromProperty;

  const ReviewOptionsWidget({
    Key? key,
    required this.contentItemID,
    required this.reportNonce,
    required this.listener,
    required this.isFromProperty,
    required this.isAdminReviewManagement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPopupMenu(context),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      surfaceTintColor: Colors.transparent,
      color: AppThemePreferences().appTheme.popUpMenuBgColor,
      offset: const Offset(0, 50),
      elevation: AppThemePreferences.popupMenuElevation,
      icon: Icon(
        Icons.more_horiz_outlined,
        color: AppThemePreferences().appTheme.iconsColor,
      ),
      onSelected: (value) => _handleMenuSelection(context, value),
      itemBuilder: (context) => _buildMenuItems(),
    );
  }

  void _handleMenuSelection(BuildContext context, dynamic value) {
    switch (value) {
      case OPTION_REPORT:
        _handleReportOption(context);
        break;
      case OPTION_PUBLISH:
        _processReviewAction(isApprove: true);
        break;
      case OPTION_REJECT:
        _processReviewAction(isApprove: false);
        break;
      case OPTION_REVIEW_DELETE:
        listener(contentItemID: contentItemID, isTrash: true);
        break;
    }
  }

  void _handleReportOption(BuildContext context) {
    final bool isLoggedIn = HiveStorageManager.isUserLoggedIn();
    
    if (isLoggedIn) {
      _onReportTap(context);
    } else {
      _navigateToSignIn(context);
    }
  }

  List<PopupMenuEntry> _buildMenuItems() {
    final bool checkIfUserIsAdmin = HiveStorageManager.readIsUserAdmin() ?? false;
    
    final List<PopupMenuEntry> items = [
      _buildGenericPopupMenuItem(
        value: OPTION_REPORT,
        text: UtilityMethods.getLocalizedString("report"),
        iconData: AppThemePreferences.reportIcon,
      ),
    ];

    if (isAdminReviewManagement && checkIfUserIsAdmin && !isFromProperty) {
      items.addAll([
        _buildGenericPopupMenuItem(
          value: OPTION_PUBLISH,
          text: UtilityMethods.getLocalizedString("publish"),
          iconData: AppThemePreferences.verifiedIcon,
        ),
        _buildGenericPopupMenuItem(
          value: OPTION_REJECT,
          text: UtilityMethods.getLocalizedString("reject"),
          iconData: AppThemePreferences.declinedIcon,
        ),
        _buildGenericPopupMenuItem(
          value: OPTION_REVIEW_DELETE,
          text: UtilityMethods.getLocalizedString("delete"),
          iconData: AppThemePreferences.trashIcon,
        ),
      ]);
    }

    return items;
  }

  void _processReviewAction({required bool isApprove}) {
    listener(contentItemID: contentItemID, isApprove: isApprove);
  }

  void _onReportTap(BuildContext context) {
    final bool isLoggedIn = HiveStorageManager.isUserLoggedIn();
    
    if (!isLoggedIn) {
      _navigateToSignIn(context);
      return;
    }

    _showReportConfirmationDialog(context);
  }

  void _showReportConfirmationDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialogWidget(
        title: GenericTextWidget(
          UtilityMethods.getLocalizedString("report"),
        ),
        content: GenericTextWidget(
          UtilityMethods.getLocalizedString("report_confirmation"),
        ),
        actions: [
          _buildCancelButton(context),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButtonWidget(
      onPressed: () => Navigator.pop(context),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("cancel"),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return TextButtonWidget(
      onPressed: () => _handleReportConfirmation(context),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("yes"),
      ),
    );
  }

  Future<void> _handleReportConfirmation(BuildContext context) async {
    final ApiManager apiManager = ApiManager();
    
    final Map<String, dynamic> params = {
      ContentIdKey: contentItemID,
      ContentTypeKey: "review",
    };

    try {
      final ApiResponse<String> response = 
          await apiManager.reportContent(params, reportNonce);

      if (response.success) {
        listener(contentItemID: contentItemID);
        _showToast(context, response.message);
        Navigator.of(context).pop();
      } else {
        final String message = response.message.isNotEmpty 
            ? response.message 
            : "error_occurred";
        _showToast(context, message);
      }
    } catch (e) {
      _showToast(context, "error_occurred");
    }
  }

  void _navigateToSignIn(BuildContext context) {
    final Route route = MaterialPageRoute(
      builder: (context) => UserSignIn(
        (String closeOption) {
          if (closeOption == CLOSE) {
            Navigator.pop(context);
          }
        },
      ),
    );
    Navigator.push(context, route);
  }

  PopupMenuItem _buildGenericPopupMenuItem({
    required dynamic value,
    required String text,
    required IconData iconData,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            iconData,
            size: 18,
            color: AppThemePreferences().appTheme.iconsColor,
          ),
          const SizedBox(width: 10),
          GenericTextWidget(
            text,
            style: AppThemePreferences().appTheme.subBody01TextStyle,
          ),
        ],
      ),
    );
  }

  /// Shows a toast message
  void _showToast(BuildContext context, String message) {
    ShowToastWidget(
      buildContext: context,
      text: message,
    );
  }
}