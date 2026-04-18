import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class UserForgetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserForgetPasswordState();
}

class UserForgetPasswordState extends State<UserForgetPassword> with ValidationMixin {

  String usernameOrEmail = '', username = '';
  String nonce = "";

  bool isInternetConnected = true;

  final formKey = GlobalKey<FormState>();

  final ApiManager _apiManager = ApiManager();

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _apiManager.fetchResetPasswordNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("forgot_password"),
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
                          buttonForgotPassword(),
                        ],
                      ),
                    ),
                  ],
                ),
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
        UtilityMethods.getLocalizedString("enter_the_email_address_or_user_name"),
        style: AppThemePreferences().appTheme.heading02TextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget addEmail() {
    return TextFormFieldWidget(
      ignorePadding: true,
      labelText: UtilityMethods.getLocalizedString("user_name_email"),
      hintText:  UtilityMethods.getLocalizedString("enter_your_user_name_or_email_address"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      onSaved: (String? value) {
        usernameOrEmail = value!;
      },
    );
  }

  Widget buttonForgotPassword() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("submit"),
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();

            Map<String, dynamic> _params = {
              UserLoginKey : usernameOrEmail,
            };

            ApiResponse<String> response = await _apiManager.forgotPassword(_params, nonce);

            if (mounted) {
              setState(() {
                isInternetConnected = response.internet;
              });
            }

            if (response.success && response.internet) {
              _showToast(context, response.message);
              Navigator.pop(context);
            } else {
              String _message = "error_occurred";
              if (response.message.isNotEmpty) {
                _message = response.message;
              }
              _showToast(context, _message);
            }
          }
        }
      )
    );
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
}
