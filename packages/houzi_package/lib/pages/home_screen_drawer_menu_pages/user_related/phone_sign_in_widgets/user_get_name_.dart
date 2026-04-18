import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/user/user_login_info.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/providers/state_providers/user_log_provider.dart';


class UserDisplayName extends StatefulWidget {
  final String phoneNumber;
  final String uid;
  final String countryDialCode;
   UserDisplayName({required this.phoneNumber, required this.uid, required this.countryDialCode,Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserDisplayNameState();
}

class UserDisplayNameState extends State<UserDisplayName>
    with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  final ApiManager _apiManager = ApiManager();

  String username = '';
  bool _showWaitingWidget = false;
  bool isInternetConnected = true;

  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _apiManager.fetchSignInNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("name"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: (UtilityMethods.showTabletView)
                          ? const EdgeInsets.only(left: 150.0, top: 100, right: 150)
                          : const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Column(
                        children: [
                          textEnterAssociatedEmail(),
                          addEmail(),
                          submitButton(),
                        ],
                      ),
                    ),
                  ],
                ),
                loginWaitingWidget(),
                bottomActionBarWidget(),
              ],
            ),
          ),
        ),
      );
  }

  Widget textEnterAssociatedEmail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("enter_your_name"),
        style: AppThemePreferences().appTheme.heading02TextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget addEmail() {
    return TextFormFieldWidget(
      ignorePadding: true,
      labelText: UtilityMethods.getLocalizedString(""),
      hintText:  UtilityMethods.getLocalizedString("enter_your_name"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      onSaved: (String? value) {
        username = value!;
      },
    );
  }

  Widget submitButton() {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("submit"),
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            String cc = widget.countryDialCode;
            if (cc.contains("+")) {
              cc = cc.replaceAll("+", "");
            }
            Map<String, dynamic> userInfo = {
              USER_SOCIAL_PLATFORM : PLATFORM_PHONE,
              USER_SOCIAL_USER_NAME : cc+widget.phoneNumber,
              USER_SOCIAL_DISPLAY_NAME : username,
              USER_SOCIAL_ID : widget.uid,
            };
            setState(() {
              _showWaitingWidget = true;
            });

            socialSignOn(userInfo);
          }
        }
      )
    );
  }

  Future<void> socialSignOn(Map<String, dynamic> userInfo) async {
    ApiResponse<UserLoginInfo?> response = await _apiManager.socialSignOn(userInfo, nonce);

    if (mounted) {
      setState(() {
        _showWaitingWidget = false;

        isInternetConnected = response.internet;

        if (response.success && response.internet && response.result != null) {
          UserLoginInfo info = response.result!;

          _showToast(context, UtilityMethods.getLocalizedString("user_Login_successfully"));

          Map<String, dynamic> loggedInUserData = _apiManager.convertUserLoginInfoToJson(info);;
          HiveStorageManager.storeUserLoginInfoData(loggedInUserData);
          HiveStorageManager.storeUserCredentials(userInfo);

          Provider.of<UserLoggedProvider>(context, listen: false).loggedIn();

          GeneralNotifier().publishChange(GeneralNotifier.USER_LOGGED_IN);

          OneSignalConfig.oneSignalLoginFunc(info);

          UtilityMethods.navigateToRouteByPushAndRemoveUntil(
              context: context, builder: (context) => MyHomePage());

        } else {
          String _message = "user_login_failed";
          if (response.message.isNotEmpty) {
            _message = response.message;
          }
          ShowToastWidget(buildContext: context, text: _message);
        }

      });
    }
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget bottomActionBarWidget() {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(showRetryButton: false),
          ],
        ),
      ),
    );
  }

  Widget loginWaitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 90,
            bottom: 0,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 80,
                  height: 20,
                  child: BallBeatLoadingWidget(),
                ),
              ),
            ),
          )
        : Container();
  }
}
