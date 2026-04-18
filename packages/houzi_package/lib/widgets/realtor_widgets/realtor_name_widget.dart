import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class RealtorNameWidget extends StatelessWidget {
  final String title;
  final String tag;
  final bool isVerified;

  const RealtorNameWidget({
    required this.title,
    required this.tag,
    required this.isVerified,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: tag == AGENTS_TAG
            ? const EdgeInsets.only(top: 10)
            : const EdgeInsets.only(top: 15),
        constraints: BoxConstraints(
          maxWidth: constraints.maxWidth,
        ),
        child: Row(
          textDirection: textDirection,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth -
                    28,
              ),
              child: GenericTextWidget(
                title,
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 1,
                strutStyle: const StrutStyle(forceStrutHeight: true),
                overflow: TextOverflow.ellipsis,
                style: AppThemePreferences()
                    .appTheme
                    .homeScreenRealtorTitleTextStyle,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: isVerified
                    ? AppThemePreferences().appTheme.agentAgencyVerifiedIcon
                    : null),
          ],
        ),
      );
    });
  }
}
