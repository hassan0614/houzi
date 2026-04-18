
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with ValidationMixin {

  String nonce = "";

  bool _isInternetConnected = true;
  bool _showWaitingWidget = false;

  final formKey = GlobalKey<FormState>();

  final ApiManager _apiManager = ApiManager();

  TextEditingController registerPass = TextEditingController();
  TextEditingController registerPassRetype = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _apiManager.fetchUpdatePasswordNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("change_password"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        addPassword(context),
                        reTypePassword(context),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: updatePasswordButtonWidget(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ChangePasswordWaitingWidget(showWaitingWidget: _showWaitingWidget),
              ChangePasswordBottomActionBarWidget(isInternetConnected: _isInternetConnected),
            ],
          ),
        ),
      ),
    );
  }

  Widget addPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("password"),
        hintText: UtilityMethods.getLocalizedString("enter_your_password"),
        controller: registerPass,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) => validatePassword(value),
      ),
    );
  }

  Widget reTypePassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("confirm_password"),
        hintText: UtilityMethods.getLocalizedString("confirm_your_password"),
        obscureText: true,
        controller: registerPassRetype,
        keyboardType: TextInputType.visiblePassword,
        validator: (String? value) {
          if (value!.length < 8) {
            return UtilityMethods.getLocalizedString("password_length_at_least_eight");
          }
          if (value.isEmpty) {
            return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
          }

          if (registerPass.text != registerPassRetype.text) {
            return UtilityMethods.getLocalizedString("password_does_not_match");
          }
          return null;
        },
      ),
    );
  }

  Widget updatePasswordButtonWidget(BuildContext context) {
    return ButtonWidget(
      text: UtilityMethods.getLocalizedString("update_password"),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();

          if (mounted) {
            setState(() {
              _showWaitingWidget = true;
            });
          }

          Map<String, dynamic> params = {
            NEW_PASSWORD_KEY : registerPass.text,
            CONFIRM_PASSWORD_KEY : registerPassRetype.text,
          };

          ApiResponse<String> response = await _apiManager.updateUserPassword(params, nonce);

          if (mounted) {
            setState(() {
              _isInternetConnected = response.internet;

              _showWaitingWidget = false;

              if (response.success && response.internet) {
                ShowToastWidget(buildContext: context, text: response.message);

                Map credentials = HiveStorageManager.readUserCredentials();
                Map<String, dynamic> userInfo = {
                  USER_NAME: credentials[UserNameKey],
                  PASSWORD: registerPass.text,
                };
                HiveStorageManager.storeUserCredentials(userInfo);

                Navigator.of(context).pop();
              } else {
                String _message = "error_occurred";
                if (response.message.isNotEmpty) {
                  _message = response.message;
                }
                ShowToastWidget(buildContext: context, text: _message);
              }
            });
          }
        }
      },
    );
  }
}

class ChangePasswordWaitingWidget extends StatelessWidget {
  final bool showWaitingWidget;
  
  const ChangePasswordWaitingWidget({
    Key? key,
    required this.showWaitingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showWaitingWidget) return Positioned(
      left: 0,
      right: 0,
      top: 0,
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
    );
    
    
    return Container();
  }
}

class ChangePasswordBottomActionBarWidget extends StatelessWidget {
  final bool isInternetConnected;
  
  const ChangePasswordBottomActionBarWidget({
    Key? key,
    required this.isInternetConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

