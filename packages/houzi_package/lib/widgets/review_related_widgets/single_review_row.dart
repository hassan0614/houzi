import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/review_options_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

import '../../files/generic_methods/utility_methods.dart';
import '../generic_text_widget.dart';

class SingleReviewRow extends StatefulWidget {
  final reviewDetailMap;
  final showDetailedReview;
  final reportNonce;
  final bool? approvalActionWidget;
  final bool? isReportReview;
  final Function(int, bool, )? onReviewAction;
  final Function(int, bool)? onReviewDeleteAction;
  final bool isFromProperty;


  SingleReviewRow( 
    this.reviewDetailMap, 
    this.showDetailedReview, 
    this.reportNonce,
    {
      this.onReviewAction,
      this.isReportReview, 
      this.approvalActionWidget, 
      this.onReviewDeleteAction,
      this.isFromProperty = false,
      Key? key
    }
  ) : super(key: key);

  @override
  _SingleReviewRowState createState() => _SingleReviewRowState();
}

class _SingleReviewRowState extends State<SingleReviewRow> {
  final checkRatingApprovedByAdmin =
      HiveStorageManager.readNewRatingsApprovedByAdminData();
  final checkIfUserIsAdmin =
      HiveStorageManager.readIsUserAdmin() ?? false;
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      shape: AppThemePreferences.roundedCorners(AppThemePreferences.reviewRoundedCornersRadius),
      elevation: AppThemePreferences.reviewsElevation,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showDetailedReview)
              Row(
                children: [
                  userAvatarWidget(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: textWidget(
                          widget.reviewDetailMap.userDisplayName.isEmpty == ""
                              ? widget.reviewDetailMap.userName
                              : widget.reviewDetailMap.userDisplayName,
                          AppThemePreferences().appTheme.heading01TextStyle!),
                    ),
                  ),
                  ReviewOptionsWidget(
                    isFromProperty: widget.isFromProperty,
                    reportNonce: widget.reportNonce,
                    contentItemID: widget.reviewDetailMap.id,
                    isAdminReviewManagement: widget.approvalActionWidget!,
                    listener: ({contentItemID, isApprove, isTrash}) {
                      if (contentItemID != null && isApprove != null) {
                        widget.onReviewAction?.call(contentItemID, isApprove);
                      }
                      if( isTrash != null && contentItemID != null){
                        widget.onReviewDeleteAction?.call(contentItemID, isTrash);
                      }
                    },
                  )
                ],
              ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: textWidget(widget.reviewDetailMap.title,
                      AppThemePreferences().appTheme.articleReviewsTitle!),
                ),
                Expanded(
                  child: textWidget(
                    widget.reviewDetailMap.modifiedGmt,
                    AppThemePreferences().appTheme.subTitle02TextStyle!,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                starsWidget(widget.reviewDetailMap.reviewStars),
                widget.showDetailedReview
                    ? Container()
                    : textWidget(
                      widget.reviewDetailMap.userDisplayName.isEmpty == ""
                        ? widget.reviewDetailMap.userName
                        : widget.reviewDetailMap.userDisplayName,
                        AppThemePreferences().appTheme.subTitle02TextStyle!),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: textWidget(UtilityMethods.cleanContent(widget.reviewDetailMap.content), null),
            ),
            if (widget.reviewDetailMap.reviewActionLabel.isNotEmpty &&
                widget.reviewDetailMap.reviewActionLabel != null &&
                checkRatingApprovedByAdmin && checkIfUserIsAdmin)
              _buildApprovalStatus(widget.reviewDetailMap),
          ],
        ),
      ),
    );
  }
  
  Widget _buildApprovalStatus(Article review) {
    final isApproved = review.reviewActionLabel == REVIEW_APPROVAL_STATUS_APPROVE;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          GenericTextWidget(
            "${UtilityMethods.getLocalizedString("approval_status")}: ",
            style: AppThemePreferences().appTheme.label01TextStyle,
          ),
          GenericTextWidget(
            review.reviewActionLabel?.capitalizeFirst() ?? "",
            style: AppThemePreferences().appTheme.label01TextStyle?.copyWith(
              color: isApproved
                  ? AppThemePreferences.userStatusApprovedColor
                  : AppThemePreferences.userStatusNotApprovedColor
            ),
          ),
        ],
      ),
    );
  }
 
  Widget starsWidget(String totalRating) {
   if (totalRating == null || totalRating.isEmpty || totalRating == 'null') {
    return Container();
  }
  
  final rating = double.tryParse(totalRating);
  
  if (rating == null) {
    debugPrint("Invalid rating value: '$totalRating'");
    return Container();
  }
  
  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      itemSize: 20,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: AppThemePreferences.ratingWidgetStarsColor,
      ),
      onRatingUpdate: (rating) {},
    ),
  );
}

  Widget userAvatarWidget() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FancyShimmerImage(
          imageUrl: widget.reviewDetailMap.image,
          boxFit: BoxFit.cover,
          shimmerBaseColor:
              AppThemePreferences().appTheme.shimmerEffectBaseColor,
          shimmerHighlightColor:
              AppThemePreferences().appTheme.shimmerEffectHighLightColor,
          width: 50,
          height: 50,
          errorWidget: ShimmerEffectErrorWidget(iconSize: 30),
        ),
      ),
    );
  }

  Widget textWidget(
    String text,
    TextStyle? style, {
    TextAlign textAlign = TextAlign.start,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 5),
      child: GenericTextWidget(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
