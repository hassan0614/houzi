import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/pages/crm_pages/crm_api_management/crm_api_handler/api_manager_crm.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

class CRMNotesListings extends StatefulWidget {
  final String id;
  final String fetch;
  const CRMNotesListings({Key? key, required this.id, required this.fetch}) : super(key: key);

  @override
  State<CRMNotesListings> createState() => _CRMNotesListingsState();
}

class _CRMNotesListingsState extends State<CRMNotesListings> {

  final formKey = GlobalKey<FormState>();
  final ApiMangerCRM _apiManagerCRM = ApiMangerCRM();
  final _noteTextController = TextEditingController();

  Future<List<dynamic>>? _futureNotesFromBoard;
  List<dynamic> notesFromBoardList = [];

  bool isLoading = false;
  bool shouldLoadMore = true;
  bool showIndicatorWidget = false;

  int page = 1;
  int perPage = 10;

  String nonce = "";

  @override
  void initState() {
    super.initState();
    fetchNotes();
    fetchNonce();
  }

  fetchNotes() {
    notesFromBoardList = [];
    _futureNotesFromBoard = fetchNotesFromBoard().then((value) {
        notesFromBoardList = value;
        setState(() {});
        return notesFromBoardList;
      },
    );

    setState(() {});
  }

  fetchNonce() async {
    ApiResponse response = await _apiManagerCRM.fetchLeadDeleteNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  Future<List<dynamic>> fetchNotesFromBoard() async {
    List<dynamic> tempList = [];
    late ApiResponse<List> response;

    if (widget.fetch == FETCH_INQUIRY) {
      response = await _apiManagerCRM.fetchInquiryDetailNotesFromBoard(widget.id);
    } else if (widget.fetch == FETCH_LEAD) {
      response = await _apiManagerCRM.fetchLeadsDetailNotesFromBoard(widget.id);
    }

    if (mounted) {
      setState(() {
        if (response.success && response.internet) {
          tempList = response.result;
        }

        if (tempList.isNotEmpty) {
          notesFromBoardList.addAll(tempList);
        }
      });
    }

    return notesFromBoardList;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                addNoteWidget(),
                showInquiryNotesList(context, _futureNotesFromBoard),
              ],
            ),
            loadingIndicatorWidget(),

          ],
        ),
      ),
    );
  }

  Widget showInquiryNotesList(BuildContext context,
      Future<List<dynamic>>? futureInquiryDetailNotesFromBoard) {
    return FutureBuilder<List<dynamic>>(
      future: futureInquiryDetailNotesFromBoard,
      builder: (context, articleSnapshot) {
        isLoading = false;

        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return Container();
          }
          // if (articleSnapshot.data.length < perPage) {
          //   shouldLoadMore = false;
          //   _refreshController.loadNoData();
          // }

          List<dynamic> inquiriesFromBoard = articleSnapshot.data!;

          // if (isRefreshing) {
          //   //need to clear the list if refreshing.
          //   inquiriesFromBoardList.clear();
          // }
          //inquiriesFromBoardList.addAll(list);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: inquiriesFromBoard.length,
            itemBuilder: (context, index) {
              if (inquiriesFromBoard.isEmpty) {
                return const NoResultErrorWidget();
              }

              if (inquiriesFromBoard[index] is! CRMNotes) {
                return Container();
              }
              CRMNotes inquiryNotes = inquiriesFromBoard[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: CardWidget(
                  shape: AppThemePreferences.roundedCorners(
                      AppThemePreferences.globalRoundedCornersRadius),
                  elevation: AppThemePreferences.boardPagesElevation,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CRMTypeHeadingWidget("notes", inquiryNotes.time),
                              CRMNormalTextWidget(inquiryNotes.note),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ShowDialogBoxWidget(
                                context,
                                title:
                                UtilityMethods.getLocalizedString("delete"),
                                content: GenericTextWidget(
                                    UtilityMethods.getLocalizedString(
                                        "delete_confirmation")),
                                actions: <Widget>[
                                  TextButtonWidget(
                                    onPressed: () => Navigator.pop(context),
                                    child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString(
                                            "cancel")),
                                  ),
                                  TextButtonWidget(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        showIndicatorWidget = true;
                                      });

                                      Map<String, dynamic> params = {
                                        NOTE_ID: inquiryNotes.noteId,
                                      };

                                      ApiResponse<String> response = await _apiManagerCRM.deleteCRMNotes(params);

                                      if (mounted) {
                                        setState(() {
                                          showIndicatorWidget = false;

                                          if (response.success) {
                                            _showToast(context, response.message);
                                            notesFromBoardList.removeAt(index);
                                            _showToast(context, UtilityMethods.getLocalizedString("note_deleted"));
                                          } else {
                                            String _message = "error_occurred";
                                            if (response.message.isNotEmpty) {
                                              _message = response.message;
                                            }
                                            _showToast(context, _message);
                                          }
                                        });
                                      }
                                    },
                                    child: GenericTextWidget(
                                        UtilityMethods.getLocalizedString("yes")),
                                  ),
                                ],
                              );
                            },
                            child: Icon(
                              AppThemePreferences.deleteIcon,
                              color: AppThemePreferences.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return loadingIndicatorWidget();
      },
    );
  }

  Widget addNoteWidget() {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 20),
            child: TextFormFieldWidget(
                controller: _noteTextController,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                labelText: UtilityMethods.getLocalizedString("notes"),
                hintText: UtilityMethods.getLocalizedString("enter_note"),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return UtilityMethods.getLocalizedString(
                        "this_field_cannot_be_empty");
                  }
                  return null;
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ButtonWidget(
              text: UtilityMethods.getLocalizedString("add_notes"),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  setState(() {
                    showIndicatorWidget = true;
                  });

                  String noteType = "";
                  if(widget.fetch == FETCH_INQUIRY) {
                    noteType = ENQUIRY;
                  } else if(widget.fetch == FETCH_LEAD) {
                    noteType = LEAD;
                  }

                  Map<String, dynamic> params = {
                    NOTE: _noteTextController.text,
                    BELONG_TO: widget.id,
                    NOTE_TYPE: noteType
                  };

                  ApiResponse<String> response = await _apiManagerCRM.addCRMNotes(params, nonce);

                  if (mounted) {
                    setState(() {
                      showIndicatorWidget = false;
                    });
                  }

                  if (response.success) {
                    _showToast(context, response.message);
                    _noteTextController.clear();
                    fetchNotes();
                  } else {
                    String _message = "error_occurred";
                    if (response.message.isNotEmpty) {
                      _message = response.message;
                    }
                    _showToast(context, _message);
                  }
                }
              }),
        ),
      ],
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget loadingIndicatorWidget() {
    return showIndicatorWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: const SizedBox(
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
