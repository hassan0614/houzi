import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef UserInfoWidgetListener = Function({
bool? showWaitingWidgetForPicUpload,
bool? showUploadPhotoButton,
bool? isInternetConnected,
});

class UserInfoWidget extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool showUploadPhotoButton;
  final UserInfoWidgetListener listener;
  final File? imageFile;

  const UserInfoWidget({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.showUploadPhotoButton,
    required this.listener,
    required this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          UpdateProfileImageButtonWidget(
            imageFile: imageFile,
            showUploadPhotoButton: showUploadPhotoButton,
            listener: listener,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                GenericTextWidget(
                  userName,
                  style: AppThemePreferences().appTheme.heading01TextStyle,
                ),
                Divider(thickness: 0,color: AppThemePreferences.homeScreenDrawerTextColorDark,),
                GenericTextWidget(
                  userEmail,
                  style: AppThemePreferences().appTheme.heading01TextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: AppThemePreferences.dividerDecoration(),
    );
  }
}

typedef UpdateProfileImageButtonWidgetListener = Function({
bool? showWaitingWidgetForPicUpload,
bool? showUploadPhotoButton,
bool? isInternetConnected,
});

class UpdateProfileImageButtonWidget extends StatefulWidget {
  final bool showUploadPhotoButton;
  final File? imageFile;
  final UpdateProfileImageButtonWidgetListener listener;


  UpdateProfileImageButtonWidget({
    Key? key,
    required this.showUploadPhotoButton,
    this.imageFile,
    required this.listener,
  }) : super(key: key);

  @override
  State<UpdateProfileImageButtonWidget> createState() => _UpdateProfileImageButtonWidgetState();
}

class _UpdateProfileImageButtonWidgetState extends State<UpdateProfileImageButtonWidget> {
  final ApiManager _apiManager = ApiManager();

  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _apiManager.fetchUpdateProfileImageNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showUploadPhotoButton) {
      return ButtonWidget(
        text: UtilityMethods.getLocalizedString("upload_photo"),
        onPressed: () {
          widget.listener(showWaitingWidgetForPicUpload: true);
          uploadPhoto(context);
        },
      );
    }

    return Container();
  }

  Future<void> uploadPhoto(BuildContext context) async {
    Map<String, dynamic> params = {
      UpdateUserProfileImagePathKey : widget.imageFile!.path,
    };

    ApiResponse<String> response = await _apiManager.updateUserProfileImage(params, nonce);

    if (response.success && response.internet) {
      widget.listener(
        isInternetConnected: response.internet,
        showUploadPhotoButton: false,
      );

      String url = response.result;
      HiveStorageManager.setUserAvatar(url);
      widget.listener(showUploadPhotoButton: false);
      GeneralNotifier().publishChange(GeneralNotifier.USER_PROFILE_UPDATE);

      widget.listener(showWaitingWidgetForPicUpload: false);
      ShowToastWidget(
        buildContext: context,
        text: UtilityMethods.getLocalizedString("profile_updated_successfully"),
      );

    } else {
      widget.listener(
        showWaitingWidgetForPicUpload: false,
        isInternetConnected: response.internet,
        showUploadPhotoButton: false,
      );

      String _message = "error_occurred";
      if (response.message.isNotEmpty) {
        _message = response.message;
      }
      ShowToastWidget(buildContext: context, text: _message);
    }
  }
}

