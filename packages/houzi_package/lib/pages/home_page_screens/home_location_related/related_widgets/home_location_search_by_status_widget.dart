import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/term.dart';
import 'package:houzi_package/widgets/search_by_status_widget.dart';
import 'package:provider/provider.dart';

// typedef HomeLocationSearchTypeWidgetListener = void Function(String name, String slug);


class HomeLocationSearchByStatusWidget extends StatefulWidget{
  // final HomeLocationSearchTypeWidgetListener listener;

  const HomeLocationSearchByStatusWidget({
    super.key,
    // required this.listener,
  });

  @override
  State<StatefulWidget> createState() => HomeLocationSearchByStatusWidgetState();
}

class HomeLocationSearchByStatusWidgetState extends State<HomeLocationSearchByStatusWidget> {

  int _selectedIndex = 0;
  List<dynamic> metaData = [];
  List<dynamic> dataList = [];
  List<String> labelsList = [];

  Term allObj = Term(name: "All", slug: "all");
  Term rentObj = Term(name: "For Rent", slug: "for-rent");
  Term saleObj = Term(name: "For Sale", slug: "for-sale");

  int maxAllowed = defaultSearchTypeSwitchOptions;

  VoidCallback? generalNotifierListener;

  @override
  void initState() {
    super.initState();

    metaData = HiveStorageManager.readPropertyStatusMetaData() ?? [];
    loadData();

    /// General Notifier Listener
    generalNotifierListener = () {
      if (GeneralNotifier().change == GeneralNotifier.APP_CONFIGURATIONS_UPDATED) {
        loadData();
      }
    };

    GeneralNotifier().addListener(generalNotifierListener!);
  }

  void loadData() {
    maxAllowed = defaultSearchTypeSwitchOptions;
    dataList.clear();
    labelsList.clear();
    
    if (metaData.isNotEmpty && metaData.length >= maxAllowed) {
      for (int i = 0; i < maxAllowed; i++) {
        dataList.add(metaData[i]);
      }
    } else {
      dataList.add(rentObj);
      dataList.add(saleObj);
    }

    if (dataList.isNotEmpty) {
      dataList.insert(0, allObj);
      Map<String, dynamic> map = HiveStorageManager.readHomeLocationSearchInfo();
      String searchedSlug = map[SEARCH_RESULTS_STATUS] ?? "";

      dataList.forEach((item) {
        labelsList.add(UtilityMethods.getLocalizedString(item.name));
        if (searchedSlug.isNotEmpty && item.slug == searchedSlug) {
          int index = dataList.indexOf(item);
          _selectedIndex = index;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (metaData.isEmpty) {
      metaData = HiveStorageManager.readPropertyStatusMetaData() ?? [];
      loadData();
    }

    return Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          loadData();
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SearchByStatusWidget(
                    initialLabelIndex: _selectedIndex,
                    cornerRadius: 24,
                    minWidth: 100,//80
                    minHeight: 45,
                    radiusStyle: true,
                    fontSize: AppThemePreferences.toggleSwitchTextFontSize,
                    totalSwitches: labelsList.length,
                    labels: labelsList,
                    onToggle: (index) {
                      if (index != null && index != _selectedIndex) {
                        _selectedIndex = index;
                        // widget.listener(dataList[index].name, dataList[index].slug);
                        String name = dataList[index].name;
                        String slug = dataList[index].slug;

                        Map<String, dynamic> map = HiveStorageManager.readHomeLocationSearchInfo();
                        if (slug == 'all') {
                          map.remove(SEARCH_RESULTS_STATUS);
                        } else {
                          map[PROPERTY_STATUS] = name;
                          map[SEARCH_RESULTS_STATUS] = slug;
                        }

                        HiveStorageManager.storeHomeLocationSearchInfo(map);
                        GeneralNotifier().publishChange(GeneralNotifier.SEARCH_ON_HOME_WITH_LOCATION);
                      }
                    },
                  ),
                ),
                // ToggleSwitch(
                //   cornerRadius: 24,
                //   minWidth: 100,//80
                //   minHeight: 45,
                //   radiusStyle: true,
                //   fontSize: AppThemePreferences.toggleSwitchTextFontSize,
                //   inactiveBgColor: AppThemePreferences().appTheme.switchUnselectedBackgroundColor,
                //   inactiveFgColor: AppThemePreferences().appTheme.switchUnselectedItemTextColor,
                //   activeFgColor: AppThemePreferences().appTheme.switchSelectedItemTextColor,
                //   activeBgColor: [
                //     AppThemePreferences().appTheme.switchSelectedBackgroundColor,
                //   ],
                //   totalSwitches: _searchTypeList.length,
                //   labels: _searchTypeList,
                //   initialLabelIndex: filterDataMap != null && filterDataMap.containsKey(PROPERTY_STATUS)
                //       && filterDataMap[PROPERTY_STATUS] != null && filterDataMap[PROPERTY_STATUS].isNotEmpty ?
                //   _searchTypeList.indexOf(filterDataMap[PROPERTY_STATUS]) : 0,
                //   onToggle: (index) {
                //     filterDataMap[PROPERTY_STATUS] = _searchTypeList[index];
                //     HiveStorageManager.storeFilterDataInfo(map: filterDataMap);
                //     homeScreen03SearchTypeWidgetListener(
                //       filterDataMap: filterDataMap,
                //     );
                //   },
                // ),
              ],
            ),
          );
        });
  }
}