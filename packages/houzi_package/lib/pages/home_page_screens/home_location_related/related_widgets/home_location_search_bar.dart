import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_sources/api_places.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/places_related/place_models.dart';
import 'package:houzi_package/widgets/address_search.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:uuid/uuid.dart';

class HomeLocationSearchBarWidget extends StatefulWidget{

  const HomeLocationSearchBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeLocationSearchBarWidgetState();
}

class HomeLocationSearchBarWidgetState extends State<HomeLocationSearchBarWidget> {

  Map<String, dynamic> searchMap = {};
  String _selectedLocation = '';
  String _latitude = '';
  String _longitude = '';
  VoidCallback? generalNotifierLister;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> dataMap = HiveStorageManager.readHomeLocationSearchInfo();

    if (dataMap.isNotEmpty) {
      if (dataMap.containsKey(SELECTED_LOCATION)) {
        _selectedLocation = dataMap[SELECTED_LOCATION] ?? "";
        searchMap[SELECTED_LOCATION] = _selectedLocation;
      }

      if (dataMap.containsKey(LATITUDE)) {
        _latitude = dataMap[LATITUDE] ?? "";
        searchMap[LATITUDE] = _latitude;
      }

      if (dataMap.containsKey(LONGITUDE)) {
        _longitude = dataMap[LONGITUDE] ?? "";
        searchMap[LONGITUDE] = _longitude;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: LocationBarWidget(
              selectedLocation: _selectedLocation,
              onTap: ()=> onLocationBarPressed(),
            ),
          ),),

        // Expanded(
        //   flex: 2,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 2),
        //     child: SearchIconButtonWidget(
        //       onTap: ()=> onSearchPressed(),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void onLocationBarPressed() async {
    final sessionToken = const Uuid().v4();
    final Suggestion? result = await showSearch(
      context: context,
      delegate: AddressSearch(sessionToken),
      query: _selectedLocation,
    );

    if (result != null) {
      ApiResponse<PlaceDetails?> response = await PlaceApiProvider.getPlaceDetailFromPlaceId(result.placeId!);

      if (response.success && response.result != null) {
        PlaceDetails placeDetails = response.result!;

        if (mounted) {
          setState(() {
            _selectedLocation = placeDetails.location ?? "";
            _latitude = placeDetails.latitudeStr ?? "";
            _longitude = placeDetails.longitudeStr ?? "";

            searchMap[SELECTED_LOCATION] = _selectedLocation;
            searchMap[LATITUDE] = _latitude;
            searchMap[LONGITUDE] = _longitude;

            if (searchMap.isNotEmpty) {
              if (_latitude.isNotEmpty && _longitude.isNotEmpty) {
                searchMap[USE_RADIUS] = "on";
                searchMap[SEARCH_LOCATION] = "true";
                searchMap[RADIUS] = "50";
              }

              Map<String, dynamic> map = HiveStorageManager.readHomeLocationSearchInfo();
              map.addAll(searchMap);

              HiveStorageManager.storeHomeLocationSearchInfo(map);
              GeneralNotifier().publishChange(GeneralNotifier.SEARCH_ON_HOME_WITH_LOCATION);
            }
          });
        }
      } else {
        ShowToastWidget(buildContext: context, text: response.message);
      }
    }
  }

  void onSearchPressed(){
    if (searchMap.isNotEmpty) {
      searchMap[USE_RADIUS] = "on";
      searchMap[SEARCH_LOCATION] = "true";
      searchMap[RADIUS] = "50";

      HiveStorageManager.storeFilterDataInfo(map: searchMap);
      GeneralNotifier().publishChange(GeneralNotifier.SEARCH_ON_HOME_WITH_LOCATION);
      GeneralNotifier().publishChange(GeneralNotifier.FILTER_DATA_LOADING_COMPLETE);
    }

    UtilityMethods.storeOrUpdateRecentSearches(searchMap);

    UtilityMethods.navigateToSearchResultScreen(
        context: context,
        dataInitializationMap: searchMap,
        navigateToSearchResultScreenListener: ({filterDataMap}){

        }
    );

    // Reset the Fields for next Search
    // setState(() {
    //   _selectedLocation = '';
    //   _latitude = '';
    //   _longitude = '';
    //   _filterDataMap = {};
    // });
  }
}

class LocationBarWidget extends StatelessWidget {
  final String selectedLocation;
  final void Function() onTap;

  const LocationBarWidget({
    super.key,
    required this.selectedLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onTap(),
      child: SizedBox(
        height: 36.0,
        child: TextFormField(
          readOnly: true,
          strutStyle: const StrutStyle(forceStrutHeight: true),
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              enabled: false,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor!),
              ),
              // disabledBorder: InputBorder.none,
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12.0),
              //   borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor),
              // ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12.0),
              //   borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor),
              // ),
              contentPadding: const EdgeInsets.only(top: 5, left: 0, right: 0),
              // contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
              fillColor: AppThemePreferences().appTheme.searchBarBackgroundColor,
              filled: true,
              hintText: (selectedLocation.isEmpty) ?
              UtilityMethods.getLocalizedString("location") : selectedLocation,
              hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),//10
                child: Icon(
                  AppThemePreferences.gpsLocationIcon,
                  size: AppThemePreferences.homeScreenSearchBarIconSize,
                  color: AppThemePreferences().appTheme.homeScreenSearchBarIconColor,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                maxWidth: 50,
              )
          ),
        ),
      ),
    );
  }
}

class SearchIconButtonWidget extends StatelessWidget {
  final void Function() onTap;

  const SearchIconButtonWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppThemePreferences.actionButtonBackgroundColor,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: ()=> onTap(),
        icon: Icon(
          UtilityMethods.isRTL(context) ?
          AppThemePreferences.homeScreenSearchArrowIconRTL :
          AppThemePreferences.homeScreenSearchArrowIconLTR,
          color: AppThemePreferences().appTheme.homeScreenSearchArrowIconBackgroundColor,
        ),
      ),
    );
  }
}