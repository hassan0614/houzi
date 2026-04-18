import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/term.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_full_screen.dart';

typedef SequentialLocationPickerListener = void Function(
    Map<String, dynamic> map);

class SequentialLocationPickerWidget extends StatefulWidget {
  final List<String> locationHierarchyList;
  final SequentialLocationPickerListener listener;

  const SequentialLocationPickerWidget({
    super.key,
    required this.listener,
    required this.locationHierarchyList,
  });

  @override
  _SequentialLocationPickerWidgetState createState() =>
      _SequentialLocationPickerWidgetState();
}

class _SequentialLocationPickerWidgetState
    extends State<SequentialLocationPickerWidget> {
  final ApiManager _apiManager = ApiManager();
  bool isInternetConnected = true;
  bool isDataLoadError = false;
  bool isSubmitButtonError = false;
  List<dynamic> _locationsList = [];
  List<dynamic> _countryList = [];
  List<dynamic> _statesList = [];
  List<dynamic> _areaList = [];
  List<dynamic> listToShow = [];

  Map<String, dynamic> sequentialLocationMap = {};
  String? _country;
  String? _state;
  String? _city;
  String? _area;
  String currentTermType = "";
  bool dataIsLoading = true;
  String _slpLastKey = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    if (widget.locationHierarchyList.isNotEmpty) {
      _slpLastKey = widget.locationHierarchyList.last;
    }

    if (widget.locationHierarchyList.contains(propertyCountryDataType)) {
      await _loadCountryData();
    }

    if (widget.locationHierarchyList.contains(propertyStateDataType)) {
      await _loadStateData();
    }

    if (widget.locationHierarchyList.contains(propertyCityDataType)) {
      await _loadCityData();
    }

    // if (widget.locationHierarchyList.contains(propertyAreaDataType)) {
    //   await _loadAreaData();
    // }

    _setInitialDisplay();

    setState(() {
      dataIsLoading = false;
    });
  }

  Future<void> _loadCountryData() async {
    var countryData = HiveStorageManager.readPropertyCountriesMetaData();
    if (countryData != null && countryData.isNotEmpty) {
      _countryList = countryData;
    } else {
      countryData = await fetchTermData(propertyCountryDataType);
      if (countryData != null && countryData.isNotEmpty) {
        _countryList = countryData;
        HiveStorageManager.storePropertyCountriesMetaData(countryData);
      }
    }
  }

  Future<void> _loadStateData() async {
    var stateData = HiveStorageManager.readPropertyStatesMetaData();
    if (stateData != null && stateData.isNotEmpty) {
      _statesList = stateData;
    } else {
      stateData = await fetchTermData(propertyStateDataType);
      if (stateData != null && stateData.isNotEmpty) {
        _statesList = stateData;
        HiveStorageManager.storePropertyStatesMetaData(stateData);
      }
    }
  }

  Future<void> _loadCityData() async {
    var cityData = HiveStorageManager.readCitiesMetaData();
    if (cityData != null && cityData.isNotEmpty) {
      _locationsList = cityData;
    } else {
      cityData = await fetchTermData(propertyCityDataType);
      if (cityData != null && cityData.isNotEmpty) {
        _locationsList = cityData;
        HiveStorageManager.storeCitiesMetaData(cityData);
      }
    }
  }

  // Future<void> _loadAreaData() async {
  //   var areaData = HiveStorageManager.readPropertyAreaMetaData();
  //   if (areaData != null && areaData.isNotEmpty) {
  //     _areaList = areaData;
  //   } else {
  //     areaData = await fetchTermData(propertyAreaDataType);
  //     if (areaData != null && areaData.isNotEmpty) {
  //       _areaList = areaData;
  //       HiveStorageManager.storePropertyAreaMetaData(areaData);
  //     }
  //   }
  // }

  void _setInitialDisplay() {
    if (_countryList.isNotEmpty &&
        widget.locationHierarchyList.contains(propertyCountryDataType)) {
      listToShow = _countryList;
      currentTermType = propertyCountryDataType;
    } else if (_statesList.isNotEmpty &&
        widget.locationHierarchyList.contains(propertyStateDataType)) {
      listToShow = _statesList;
      currentTermType = propertyStateDataType;
    } else if (_locationsList.isNotEmpty &&
        widget.locationHierarchyList.contains(propertyCityDataType)) {
      listToShow = _locationsList;
      currentTermType = propertyCityDataType;
    } else if (_areaList.isNotEmpty &&
        widget.locationHierarchyList.contains(propertyAreaDataType)) {
      listToShow = _areaList;
      currentTermType = propertyAreaDataType;
    }
  }

  Future<List<dynamic>> fetchTermData(String term, {String? parentSlug}) async {
    List<dynamic> termData = [];

    ApiResponse<List> response =
        await _apiManager.fetchTermData(term, parentSlug: parentSlug);

    if (mounted) {
      setState(() {
        isInternetConnected = response.internet;

        if (response.success && response.internet) {
          termData = response.result;
          isDataLoadError = false;
        } else {
          isDataLoadError = true;
        }
      });
    }

    return termData;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TermPickerFullScreen(
      showLoadingWidget: dataIsLoading,
      title: getTitle(),
      termType: currentTermType,
      termMetaDataList: listToShow,
      termsDataMap: const {},
      fromSequential: true,
      termPickerFullScreenListener: (pickedTerm, pickedTermId, pickedTermSlug) {
        updateAddressRelatedFields(
            currentTermType, pickedTerm, pickedTermSlug, pickedTermId);
      },
    );
  }

  String getTitle() {
    switch (currentTermType) {
      case propertyCountryDataType:
        return "Select property_country";
      case propertyStateDataType:
        return "Select property_state";
      case propertyCityDataType:
        return "Select property_city";
      case propertyAreaDataType:
        return "Select property_area";
      default:
        return "Select";
    }
  }

  void sendMapAndClosePicker() {
    widget.listener(sequentialLocationMap);
    Navigator.pop(context);
  }

  updateAddressRelatedFields(
      String key, String? value, String pickedTermSlug, int? pickedTermId) {
    if (key == propertyCountryDataType) {
      _country = value;
      sequentialLocationMap[key] = [value];
      sequentialLocationMap[PROPERTY_COUNTRY_SLUG] = [pickedTermSlug];
      print("Country: $_country");

      _state = "";
      _city = "";
      _area = "";

      if (key != _slpLastKey) {
        resetStatesList(_country);
      } else {
        // sendMapAndClosePicker();
      }
    } else if (key == propertyStateDataType) {
      _state = value;
      sequentialLocationMap[key] = [value];
      sequentialLocationMap[PROPERTY_STATE_SLUG] = [pickedTermSlug];
      print("State: $_state");

      _city = "";
      _area = "";

      if (key != _slpLastKey) {
        resetCitiesList(_state);
        // sendMapAndClosePicker();
      }
    } else if (key == propertyCityDataType) {
      _city = value;
      sequentialLocationMap[CITY] = [value];
      sequentialLocationMap[CITY_SLUG] = [pickedTermSlug];
      sequentialLocationMap[CITY_ID] = [pickedTermId];
      print("City: $value");

      _area = "";

      if (key != _slpLastKey) {
        resetAreasList(_city);
        // sendMapAndClosePicker();
      }
    } else if (key == propertyAreaDataType) {
      _area = value;
      sequentialLocationMap[key] = [value];
      sequentialLocationMap[PROPERTY_AREA_SLUG] = [pickedTermSlug];
      print("Area: $value");
    } else {
      sequentialLocationMap[key] = [value];
    }

    setState(() {});

    if (key == _slpLastKey) {
      sendMapAndClosePicker();
    }
  }

  resetStatesList(String? countryName) async {
    if (countryName == null || countryName.isEmpty) return;

    final countryTerm = UtilityMethods.getPropertyMetaDataObjectWithItemName(
        dataType: propertyCountryDataType, name: countryName);

    if (countryTerm?.slug == null) return;

    String cacheKey = "${propertyStateDataType}_${countryTerm!.slug!}";
    var cachedStates = HiveStorageManager.readPropertyStatesMetaData();

    if (cachedStates != null && cachedStates.isNotEmpty) {
      var isCurrentCountryStates = cachedStates.where((state) =>
          state.parentTerm?.toLowerCase() == countryTerm.slug!.toLowerCase()).toList();

      if (isCurrentCountryStates.isNotEmpty) {
        _statesList = isCurrentCountryStates;
        setState(() {
          dataIsLoading = false;
          listToShow = _statesList;
          currentTermType = propertyStateDataType;
        });
        return;
      }
    }


    final statesResponse = await fetchTermData(propertyStateDataType,
        parentSlug: countryTerm.slug!);

    if (statesResponse.isNotEmpty) {
      print("States found for country: $countryName");
      _statesList = statesResponse;
    } else {
      if (statesResponse.isEmpty) {
        print("No states found for country: $countryName");
        if (mounted) sendMapAndClosePicker();
      }
    }

    setState(() {
      listToShow = _statesList;
      currentTermType = propertyStateDataType;
    });
  }

  resetCitiesList(String? stateName) async {
    if (stateName == null || stateName.isEmpty) return;
    setState(() {
      dataIsLoading = true;
    });

    final stateTerm = UtilityMethods.getPropertyMetaDataObjectWithItemName(
        dataType: propertyStateDataType, name: stateName);

    if (stateTerm?.slug == null) return;
    var cachedStates = HiveStorageManager.readCitiesMetaData();

    if (cachedStates != null && cachedStates.isNotEmpty) {
      var filteredStates = cachedStates
          .where((state) =>
              state.parentTerm?.toLowerCase() == stateTerm!.slug!.toLowerCase())
          .toList();

      if (filteredStates.isNotEmpty) {
        _statesList = filteredStates;
        setState(() {
          dataIsLoading = false;
          listToShow = _statesList;
          currentTermType = propertyCityDataType;
        });
        return;
      }
    }

    final citiesResponse =
        await fetchTermData(propertyCityDataType, parentSlug: stateTerm!.slug!);

    if (citiesResponse.isNotEmpty) {
      _locationsList = citiesResponse;
    } else {
      if (citiesResponse.isEmpty) {
        print("No states found for country: $stateName");
        if (mounted) sendMapAndClosePicker();
      }
    }

    setState(() {
      dataIsLoading = false;
      listToShow = _locationsList;
      currentTermType = propertyCityDataType;
    });
  }

  resetAreasList(String? cityName) async {
    if (cityName == null || cityName.isEmpty) return;
    setState(() {
      dataIsLoading = true;
    });

    final cityTerm = UtilityMethods.getPropertyMetaDataObjectWithItemName(
        dataType: propertyCityDataType, name: cityName);

    if (cityTerm?.slug == null) return;

    final areaResponse =
        await fetchTermData(propertyAreaDataType, parentSlug: cityTerm!.slug!);

    if (areaResponse.isNotEmpty) {
      _areaList = areaResponse;
      setState(() {
        dataIsLoading = false;
        listToShow = _areaList;
        currentTermType = propertyAreaDataType;
      });
    } else {
      if (areaResponse.isEmpty) {
        print("No states found for country: $cityName");
        if (mounted) sendMapAndClosePicker();
      }
    }
  }
}
