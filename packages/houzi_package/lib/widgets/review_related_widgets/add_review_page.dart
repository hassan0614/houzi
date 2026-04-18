import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import '../../files/generic_methods/utility_methods.dart';
import '../generic_text_widget.dart';

class AddReview extends StatefulWidget {
  final reviewPostType;
  final listingId;
  final listingTitle;
  final permaLink;

  AddReview({
    this.reviewPostType,
    this.listingId,
    this.listingTitle,
    this.permaLink,
  });

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  final ApiManager _apiManager = ApiManager();

  bool _showWaitingWidget = false;

  String _title = "";
  String _review = "";
  String _rating = "";
  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _apiManager.fetchAddReviewNonceResponse();
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
          appBarTitle: UtilityMethods.getLocalizedString("leave_a_review"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            starsWidget(),
                            addTitleWidget(),
                            addReviewWidget(),
                            addReviewButton(),
                          ],
                        ),
                        loginWaitingWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget starsWidget() {
    return RatingBar.builder(
      initialRating: 0,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: AppThemePreferences.ratingWidgetStarsColor,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating.toString();
        });
        //print(_rating);
      },
    );
  }

  Widget addTitleWidget() {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 10),
      labelText: UtilityMethods.getLocalizedString("title"),
      validator: (value) => validateTextField(value!),
      onSaved: (text) {
        setState(() {
          _title = text!;
        });
      },
    );
  }

  Widget addReviewWidget() {
    return TextFormFieldWidget(
      labelText: UtilityMethods.getLocalizedString("review"),
      maxLines: 10,
      padding: const EdgeInsets.only(top: 10),
      validator: (value) => validateTextField(value!),
      onSaved: (text) {
        setState(() {
          _review = text!;
        });
      },
    );
  }

  Widget addReviewButton() {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("leave_a_review"),
        onPressed: () async {
          if (_rating.isEmpty) {
            final snackBar = SnackBar(
              content: GenericTextWidget(
                UtilityMethods.getLocalizedString("at_least_give_one_star"),
                style: AppThemePreferences().appTheme.formFieldErrorTextStyle
              ),
              // action: SnackBarAction(
              //   label: UtilityMethods.getLocalizedString("ok"),
              //   onPressed: () {
              //     // Some code to undo the change.
              //   },
              // ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              if (mounted) {
                setState(() {
                  _showWaitingWidget = true;
                });
              }

              Map<String, dynamic> params = {
                REVIEW_TITLE: _title,
                REVIEW_STARS: _rating,
                REVIEW: _review,
                REVIEW_POST_TYPE: widget.reviewPostType,
                REVIEW_LISTING_ID: widget.listingId,
                REVIEW_LISTING_TITLE: widget.listingTitle,
                REVIEW_PERMA_LINK: widget.permaLink,
              };

              ApiResponse<String> response = await _apiManager.addReview(params, nonce);

              print("Add Review Response: ${response.toString()}");
              if (mounted) {
                setState(() {
                  _showWaitingWidget = false;
                });
              }

              if (response.success && response.internet) {
                _showToast(context, response.message);
                print("Review added successfully: ${response.message}");
                Navigator.pop(context);
              } else {
                String _message = "error_occurred";
                if (response.message.isNotEmpty) {
                  _message = response.message;
                }
                _showToast(context, _message);
                print("Error: ${response.message}");
              }
            }
          }
        },
      ),
    );
  }

  Widget loginWaitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
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
          )
        : Container();
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
