import 'package:flutter/material.dart';
import 'package:houzi_package/deep_link/deep_link_manager.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';

class DeepLinkWidget extends StatefulWidget {
  final bool configRead;
  DeepLinkWidget(this.configRead);

  @override
  State<DeepLinkWidget> createState() => _DeepLinkWidgetState();
}

class _DeepLinkWidgetState extends State<DeepLinkWidget> {
  late DeepLinkBloc deepLinkBloc;
  final MyHomePage homePage = const MyHomePage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the bloc dependency.
    deepLinkBloc = Provider.of<DeepLinkBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: deepLinkBloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DEEP_LINK = snapshot.data.toString();
          GeneralNotifier().publishChange(GeneralNotifier.DEEP_LINK_RECEIVED);
        }
        if (!widget.configRead) {
          return Container(
            color: ThemeNotifier.isCurrentThemeDarkMode() ? AppThemePreferences.backgroundColorDark : AppThemePreferences.backgroundColorLight,
          );
        }
        return homePage;
      },
    );

  }
}
