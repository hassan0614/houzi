import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef QueryOptionsWidgetListener = Function({
  int? queryItemIndex,
});

class QueryOptionsWidget extends StatelessWidget {
  final String queryItemID;
  final int queryItemIndex;
  final Map<String, dynamic> queryDataMap;
  final QueryOptionsWidgetListener listener;

  QueryOptionsWidget({
    Key? key,
    required this.queryItemID,
    required this.queryItemIndex,
    required this.queryDataMap,
    required this.listener,
  }) : super(key: key);

  String? idToDelete;
  final ApiManager _apiManager = ApiManager();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton(
          surfaceTintColor: Colors.transparent,
          color: AppThemePreferences().appTheme.popUpMenuBgColor,
          offset: Offset(0, 50),
          elevation: AppThemePreferences.popupMenuElevation,
          icon: Icon(
            Icons.more_horiz_outlined,
            color: AppThemePreferences().appTheme.iconsColor,
          ),
          onSelected: (value) {
            if (value == OPTION_EDIT) {
              onEditTap(context, queryDataMap);
            }
            if (value == OPTION_DELETE) {
              onDeleteTap(context, queryDataMap, queryItemID, queryItemIndex);
            }
          },
          itemBuilder: (context) {
            return [
              GenericPopupMenuItem(
                value: OPTION_EDIT,
                text: UtilityMethods.getLocalizedString("edit"),
                iconData: AppThemePreferences.editIcon,
              ),
              GenericPopupMenuItem(
                value: OPTION_DELETE,
                text: UtilityMethods.getLocalizedString("delete"),
                iconData: AppThemePreferences.deleteIcon,
              ),
            ];
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: CardWidget(
            elevation: AppThemePreferences.zeroElevation,
            shape: AppThemePreferences.roundedCorners(
                AppThemePreferences.savedPageSearchIconRoundedCornersRadius),
            color: AppThemePreferences().appTheme.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                UtilityMethods.isRTL(context) ?  Icons.west : Icons.east,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        // SizedBox(height: 50),
      ],
    );
  }

  PopupMenuItem GenericPopupMenuItem({
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
          SizedBox(width: 10),
          GenericTextWidget(
            text,
            style: AppThemePreferences().appTheme.subBody01TextStyle,
          ),
        ],
      ),
    );
  }

  onDeleteTap(BuildContext context, Map<String, dynamic> queryMap, String dataId, int index) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialogWidget(
        title: GenericTextWidget(UtilityMethods.getLocalizedString("delete")),
        content: GenericTextWidget(
            UtilityMethods.getLocalizedString("delete_confirmation")),
        actions: <Widget>[
          TextButtonWidget(
            onPressed: () => Navigator.pop(context),
            child:
            GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
          ),
          TextButtonWidget(
            onPressed: () async {
              if (idToDelete != null && idToDelete == dataId) {
                return;
              }

              idToDelete = dataId;
              Map<String, dynamic> params = {
                IdKey : dataId,
              };

              ApiResponse<String> response = await _apiManager.deleteSavedSearch(params);

              if (response.success && response.internet) {
                idToDelete = null;
                listener(queryItemIndex: index);
                Navigator.pop(context);
                _showToast(context, response.message);
              } else {
                Navigator.pop(context);
                String _message = "error_occurred";
                if (response.message.isNotEmpty) {
                  _message = response.message;
                }
                _showToast(context, _message);
              }
            },
            child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
          ),
        ],
      ),
    );
  }

  onEditTap(BuildContext context, Map<String, dynamic> queryMap) {
    if(queryMap.containsKey(ROOMS) && queryMap[ROOMS] != null &&
        queryMap[ROOMS] is List){
      List tempList = queryMap[ROOMS];
      if(tempList.contains("6")){
        int index = tempList.indexWhere((element) => element == "6");
        if(index != -1) {
          tempList[index] = "6+";
        }
      }
      queryMap[ROOMS] = tempList;
    }
    if(queryMap.containsKey(BATHROOMS) && queryMap[BATHROOMS] != null &&
        queryMap[BATHROOMS] is List){
      List tempList = queryMap[BATHROOMS];
      if(tempList.contains("6")){
        int index = tempList.indexWhere((element) => element == "6");
        if(index != -1) {
          tempList[index] = "6+";
        }
      }
      queryMap[BATHROOMS] = tempList;
    }

    if(queryMap.containsKey(BEDROOMS) && queryMap[BEDROOMS] != null &&
        queryMap[BEDROOMS] is List){
      List tempList = queryMap[BEDROOMS];
      if(tempList.contains("6")){
        int index = tempList.indexWhere((element) => element == "6");
        if(index != -1) {
          tempList[index] = "6+";
        }
      }
      queryMap[BEDROOMS] = tempList;
    }

    HiveStorageManager.storeFilterDataInfo(map: queryMap);
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => FilterPage(
        mapInitializeData: queryMap,
        filterPageListener: (Map<String, dynamic> dataMap, String closeOption) {
          if (closeOption == DONE) {
            NavigateToSearchResultScreen(
              context: context,
              dataInitializationMap: queryMap,
            );
          }
          if (closeOption == CLOSE) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void NavigateToSearchResultScreen({
    required BuildContext context,
    required Map<String, dynamic> dataInitializationMap,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResult(
          dataInitializationMap: dataInitializationMap,
          searchPageListener: (Map<String, dynamic> map, String closeOption) {
            if (closeOption == CLOSE) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
