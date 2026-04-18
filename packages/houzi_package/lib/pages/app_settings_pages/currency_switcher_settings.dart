import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/listing_related/currency_rate_model.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_radio_list_tile.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';

class CurrencySwitcherSettings extends StatefulWidget {
  const CurrencySwitcherSettings({super.key});

  @override
  State<StatefulWidget> createState() => CurrencySwitcherSettingsState();
}

class CurrencySwitcherSettingsState extends State<CurrencySwitcherSettings> {
  List<CurrencyRatesModel> currencyList = HiveStorageManager.readExchangeCurrencyMetaData();
    final CurrencyRatesModel? _baseCurrency = HiveStorageManager.readBaseCurrency() ;

  late CurrencyRatesModel _selectedCurrencyModel;
  List<CurrencyRatesModel> _currencyList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencyData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("currency_switcher_setting"),
        automaticallyImplyLeading: true,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _currencyList.isEmpty
              ? NoResultErrorWidget(
        headerErrorText: UtilityMethods.getLocalizedString("no_currency_data_available"),
        bodyErrorText: UtilityMethods.getLocalizedString("no_currency_data_available"),
        buttonText: UtilityMethods.getLocalizedString("go_back"),
        onButtonPressed: () {
          Navigator.pop(context);
        },
              )
              : ListView.builder(
                  itemCount: _currencyList.length,
                  itemBuilder: (context, index) {
                    final currency = _currencyList[index];
                    final currencyName = currency.name;
                    final currencyCode = UtilityMethods.getCurrencyCode(currencyName);

                    return GenericRadioListTile(

                      title: "$currencyName ($currencyCode)",
                      value: currency,
                      groupValue: _selectedCurrencyModel,
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrencyModel = value;
                          print(_selectedCurrencyModel);
                        });
                        _saveSelectedCurrency(_selectedCurrencyModel, _currencyList); 
                      },
                    );
                  },
                ),
    );
  }

   void _loadCurrencyData() async {
  try {
    final selectedCurrencyFromStorage = HiveStorageManager.readSelectedCurrency();
    print("Selected currency from storage: $selectedCurrencyFromStorage");

    if (currencyList.isEmpty) {
      // Show no data UI
      setState(() {
        _isLoading = false;
      });
      return;
    }

    CurrencyRatesModel selectedCurrencyModel;

    if (selectedCurrencyFromStorage != null) {
      // Try to find the stored currency in the current list
      selectedCurrencyModel = currencyList.firstWhere(
        (model) => model.currency == selectedCurrencyFromStorage.currency,
        orElse: () => currencyList.first,
      );
    } else {
      selectedCurrencyModel = (currencyList.contains(_baseCurrency) ? _baseCurrency : currencyList.first)!;
    }

    setState(() {
      _currencyList = List.from(currencyList);
      _selectedCurrencyModel = selectedCurrencyModel;
      _isLoading = false;
    });
  } catch (e) {
    print('Error loading currency data: $e');
    setState(() {
      _isLoading = false;
    });
  }
}




  void _saveSelectedCurrency(CurrencyRatesModel currencyModel, List<CurrencyRatesModel> currencyListModel) {
    HiveStorageManager.storeSelectedCurrency(currencyModel);
    HiveStorageManager.storeExchangeCurrencyMetaData(currencyListModel);
    UtilityMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: (context) => const MyHomePage());
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }
}