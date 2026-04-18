import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/admin_user_signup.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:houzi_package/widgets/show_dialog_for_filter.dart';
import 'package:houzi_package/widgets/show_dialog_for_search.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ApiManager _apiManager;
  late final TextEditingController _searchController;
  
  final RefreshController _allUsersRefreshController = RefreshController();
  final RefreshController _pendingUsersRefreshController = RefreshController();
  final approvalLists = HiveStorageManager.readApprovalStatusesList();
  Future<List<dynamic>>? _futureUsers;
  Future<List<dynamic>>? _futurePendingUsers;
  
  List<dynamic> _usersList = [];
  List<dynamic> _pendingUsersList = [];
  
  int _currentTabIndex = 0;
  int _page = 1;
  final int _perPage = 50;
  
  bool _isLoading = false;
  bool _showSearchDialog = false;
  bool _showFilterDialog = false;
  bool _isInternetConnected = true;
  bool _shouldLoadMore = true;
  
  late bool _isApprovalStatusEnabled;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
    print("Approval Status Enabled: $approvalLists");
    _loadInitialData();
  }

  void _initializeDependencies() {
    _apiManager = ApiManager();
    _searchController = TextEditingController();
    _isApprovalStatusEnabled = HiveStorageManager.readIsApprovalStatusEnabled();
    _tabController = TabController(
      length: _isApprovalStatusEnabled ? 2 : 1,
      vsync: this,
    )..addListener(_handleTabSelection);
    
    _apiManager.fetchListForUserApprovalStatuses();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() => _currentTabIndex = _tabController.index);
    }
  }

  void _loadInitialData() {
    if (_isApprovalStatusEnabled) {
      _futureUsers = _fetchUsers(1, "", null);
      _futurePendingUsers = _fetchPendingUsers(1, "");
    } else {
      _futureUsers = _fetchUsers(1, "", null);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _allUsersRefreshController.dispose();
    _pendingUsersRefreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showToast(String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Future<List<dynamic>> _fetchUsers(int page, String search, String? approvalStatus) async {
    if (!mounted) return [];
    
    final response = await _apiManager.fetchAllUsersV2(
      page, 
      _perPage, 
      search, 
      approvalStatus ?? ""
    );

    return _processUserResponse(response, page, search, approvalStatus, true);
  }

  Future<List<dynamic>> _fetchPendingUsers(int page, String search) async {
    if (!mounted) return [];
    
    final response = await _apiManager.fetchAllUsersV2(
      page, 
      _perPage, 
      search, 
      USER_APPROVAL_ACTIONS_PENDING
    );

    return _processUserResponse(response, page, search, USER_APPROVAL_ACTIONS_PENDING, false);
  }

  List<dynamic> _processUserResponse(
    ApiResponse<List> response,
    int page,
    String search,
    String? approvalStatus,
    bool isAllUsers
  ) {
    if (!mounted) return isAllUsers ? _usersList : _pendingUsersList;
    
    setState(() {
      _isInternetConnected = response.internet;
      
      if (response.success && response.internet) {
        final tempList = response.result ?? [];
        
        if (page == 1 || search.isNotEmpty || approvalStatus != null) {
          if (isAllUsers) {
            _usersList.clear();
          } else {
            _pendingUsersList.clear();
          }
        }

        if (tempList.isNotEmpty) {
          if (isAllUsers) {
            _usersList.addAll(tempList);
          } else {
            _pendingUsersList.addAll(tempList);
          }
        }

        _shouldLoadMore = tempList.length >= _perPage;
      }
      
      _isLoading = false;
    });
    
    return isAllUsers ? _usersList : _pendingUsersList;
  }

  void _loadDataForCurrentTab({bool forPullToRefresh = true}) {
    if (_isLoading) return;

    setState(() {
      _page = forPullToRefresh ? 1 : _page + 1;
      _isLoading = true;
    });

    final currentController = _isApprovalStatusEnabled && _currentTabIndex == 1
        ? _pendingUsersRefreshController
        : _allUsersRefreshController;

    if (_isApprovalStatusEnabled) {
      if (_currentTabIndex == 0) {
        _futureUsers = _fetchUsers(_page, _searchController.text, null);
      } else {
        _futurePendingUsers = _fetchPendingUsers(_page, _searchController.text);
      }
    } else {
      _futureUsers = _fetchUsers(_page, _searchController.text, null);
    }

    if (forPullToRefresh) {
      currentController.refreshCompleted();
    } else {
      if (_shouldLoadMore) {
        currentController.loadComplete();
      } else {
        currentController.loadNoData();
      }
    }
  }

  Future<void> _setActionsForUserApproval(int? userId, String action) async {
    if (userId == null) return;
    
    final response = await _apiManager.processUserApproval(userId, action);
    if (!mounted) return;
    
    Navigator.of(context).pop();
    
    if (response.success && response.internet) {
      _showToast(response.message ?? UtilityMethods.getLocalizedString("action_completed"));
      _loadDataForCurrentTab();
    } else {
      _showToast(response.message ?? UtilityMethods.getLocalizedString("action_failed"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isApprovalStatusEnabled 
        ? _buildTabbedView() 
        : _buildSingleView();
  }

  Widget _buildTabbedView() {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("users"),
        actions: [_buildAddUserButton()],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppThemePreferences.tabBarIndicatorColor,
          tabs: [
            _buildTab(UtilityMethods.getLocalizedString("all_users")),
            _buildTab(UtilityMethods.getLocalizedString("pending_users")),
          ],
        ),
      ),
      body: _buildTabBarView(),
    );
  }

  Widget _buildTab(String label) {
    return Tab(
      child: GenericTextWidget(
        label,
        style: AppThemePreferences().appTheme.genericTabBarTextStyle,
      ),
    );
  }

  Widget _buildSingleView() {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("users"),
        actions: [_buildAddUserButton()],
      ),
      body: _buildUsersList(
        _futureUsers!,
        _usersList,
        _allUsersRefreshController,
        isPendingUsers: false
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildUsersList(
          _futureUsers!,
          _usersList,
          _allUsersRefreshController,
          isPendingUsers: false
        ),
        _buildUsersList(
          _futurePendingUsers!,
          _pendingUsersList,
          _pendingUsersRefreshController,
          isPendingUsers: true
        ),
      ],
    );
  }

  Widget _buildAddUserButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: IconButton(
        icon: Icon(
          AppThemePreferences.addIcon,
          color: AppThemePreferences().appTheme.genericAppBarIconsColor,
        ),
        onPressed: () => _navigateToAddUser(),
      ),
    );
  }

  void _navigateToAddUser() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminUserSignUp(
          adminUserSignUpPageListener: (refresh) {
            if (refresh) _loadDataForCurrentTab();
          },
        ),
      ),
    );
  }

  Widget _buildUsersList(
    Future<List<dynamic>> future,
    List<dynamic> list,
    RefreshController controller, {
    required bool isPendingUsers
  }) {
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _showUsersList(future, list, controller, isPendingUsers),
            ),
          ],
        ),
        if (_showSearchDialog) _buildSearchDialog(),
        if (_showFilterDialog) _buildFilterDialog(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBarWidget(
        showSearchDialog: _showSearchDialog,
        showFilterDialog: _isApprovalStatusEnabled,
        isFilterButtonPressed: _showFilterDialog,
        controller: _searchController,
        listener: (showDialog, showFilter) {
          setState(() {
            _showSearchDialog = showDialog;
            _showFilterDialog = showFilter;
          });
        },
      ),
    );
  }

  Widget _showUsersList(
    Future<List<dynamic>> future,
    List<dynamic> list,
    RefreshController controller,
    bool isPendingUsers
  ) {
    if (!_isInternetConnected) {
      return _buildNoInternetWidget();
    }

    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicatorWidget();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoResultsWidget(isPendingUsers);
        }

        return _buildSmartRefresher(snapshot.data!, controller);
      },
    );
  }

  Widget _buildSmartRefresher(List<dynamic> list, RefreshController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: controller,
      header: const MaterialClassicHeader(),
      footer: CustomFooter(
        builder: (context, mode) {
          return mode == LoadStatus.loading && _shouldLoadMore
              ? const PaginationLoadingWidget()
              : const SizedBox.shrink();
        },
      ),
      onRefresh: () => _loadDataForCurrentTab(forPullToRefresh: true),
      onLoading: () => _loadDataForCurrentTab(forPullToRefresh: false),
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final userDetail = list[index] as Article;
          return _buildUserCard(userDetail);
        },
      ),
    );
  }

  Widget _buildUserCard(Article userDetail) {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
        AppThemePreferences.globalRoundedCornersRadius
      ),
      elevation: AppThemePreferences.boardPagesElevation,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserRow(userDetail),
            if (userDetail.houzezAccountApproved?.isNotEmpty == true)
              _buildApprovalStatus(userDetail),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(Article userDetail) {
    return Row(
      children: [
        _buildUserAvatar(userDetail),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenericTextWidget(
                userDetail.title ?? "",
                style: AppThemePreferences().appTheme.labelTextStyle,
              ),
              if (userDetail.description?.isNotEmpty == true)
                GenericTextWidget(
                  userDetail.category ?? "",
                  style: AppThemePreferences().appTheme.subTitleTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        if (userDetail.houzezAccountApproved?.isNotEmpty == true)
          IconButton(
            onPressed: () => _showActionBottomSheet(userDetail),
            icon: Icon(AppThemePreferences.moreVert),
          )
      ],
    );
  }

  Widget _buildUserAvatar(Article userDetail) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: FancyShimmerImage(
        height: 50,
        width: 50,
        imageUrl: userDetail.avatarUrls?["96"] ?? "",
        boxFit: BoxFit.cover,
        shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
        shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
        errorWidget: ShimmerEffectErrorWidget(
          iconData: AppThemePreferences.personIcon,
          iconSize: 20
        ),
      ),
    );
  }

  Widget _buildApprovalStatus(Article userDetail) {
    final isApproved = userDetail.houzezAccountApproved == USER_APPROVAL_STATUS_APPROVED;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          GenericTextWidget(
            "${UtilityMethods.getLocalizedString("approval_status")}: ",
            style: AppThemePreferences().appTheme.label01TextStyle,
          ),
          GenericTextWidget(
            userDetail.houzezAccountApproved?.capitalizeFirst() ?? "",
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

  void _showActionBottomSheet(Article article) {
    showModelBottomSheetWidget(
      context: context,
      builder: (context) => SafeArea(
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          children: [
            GenericOptionOfBottomSheet(
              label: UtilityMethods.getLocalizedString("approve"),
              icon: Icon(
                AppThemePreferences.verifiedIcon,
                color: AppThemePreferences.userStatusApprovedColor,
              ),
              onPressed: () => _setActionsForUserApproval(
                article.id, 
                USER_APPROVAL_ACTIONS_APPROVE
              ),
            ),
            GenericOptionOfBottomSheet(
              label: UtilityMethods.getLocalizedString("decline"),
              icon: Icon(
                AppThemePreferences.declinedIcon,
                color: AppThemePreferences.userStatusNotApprovedColor,
              ),
              onPressed: () => _setActionsForUserApproval(
                article.id, 
                USER_APPROVAL_ACTIONS_DECLINE
              ),
            ),
            GenericOptionOfBottomSheet(
              label: UtilityMethods.getLocalizedString("suspend"),
              icon: Icon(
                AppThemePreferences.suspendedIcon,
                color: AppThemePreferences.userStatusNotApprovedColor,
              ),
              onPressed: () => _setActionsForUserApproval(
                article.id, 
                USER_APPROVAL_ACTIONS_SUSPEND
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionOption({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: AppThemePreferences.dividerDecoration(right: true, bottom: true),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 5),
            GenericTextWidget(
              label,
              textAlign: TextAlign.center,
              style: AppThemePreferences().appTheme.bottomSheetOptionsTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchDialog() {
    return ShowSearchDialog(
      fromUsers: true,
      searchDialogPageListener: (showDialog, searchMap) {
        setState(() {
          _showSearchDialog = showDialog;
          _searchController.text = searchMap?[SEARCH_KEYWORD] ?? "";
        });
        _loadDataForCurrentTab();
      },
    );
  }

  Widget _buildFilterDialog() {
    return ShowFilterDialog(
      fromUsers: true,
      fromReviews: false,
      approvalList: approvalLists,
      filterDialogPageListener: (showDialog, approvalStatus, ) {
        setState(() => _showFilterDialog = showDialog);
        if (approvalStatus != null && _isApprovalStatusEnabled && _currentTabIndex == 0) {
          _futureUsers = _fetchUsers(1, _searchController.text, approvalStatus);
        }
      },
    );
  }

  Widget _buildNoInternetWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: NoInternetConnectionErrorWidget(
        onPressed: _loadDataForCurrentTab
      ),
    );
  }

  Widget _buildNoResultsWidget(bool isPendingUsers) {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: isPendingUsers
          ? UtilityMethods.getLocalizedString("no_pending_users")
          : UtilityMethods.getLocalizedString("no_users_found"),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirst() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }
}

class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const SizedBox(
        width: 40,
        height: 40,
        child: BallBeatLoadingWidget(),
      ),
    );
  }
}

 class GenericTabWidget extends StatelessWidget {
  final String label;

  const GenericTabWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: GenericTextWidget(
        label,
        style: AppThemePreferences().appTheme.genericTabBarTextStyle,
      ),
    );
  }
}

typedef SearchBarWidgetListener = Function(bool showSearchDialog, bool isFilterButtonPressed);
class SearchBarWidget extends StatelessWidget {
  final bool showSearchDialog;
  final bool showFilterDialog;
  final bool isFilterButtonPressed;
  final TextEditingController controller;
  final SearchBarWidgetListener listener;

  const SearchBarWidget({
    Key? key,
    required this.showSearchDialog,
    required this.isFilterButtonPressed,
    required this.controller,
    required this.listener, required this.showFilterDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => listener(true, false),
            
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                controller: controller,
                decoration: InputDecoration(
                  enabled: false,
                  contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  fillColor: AppThemePreferences().appTheme.containerBackgroundColor,
                  filled: true,
                  hintText: (controller.text.isEmpty)
                      ? UtilityMethods.getLocalizedString("search")
                      : controller.text,
                  hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
                  suffixIcon: !showFilterDialog ?Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: AppThemePreferences().appTheme.homeScreenSearchBarIcon 
                  ): null,
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: AppThemePreferences().appTheme.containerBackgroundColor!,
                      // width: 5.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(showFilterDialog)
          Positioned(
              right: 10,
              child: IconButton(
                onPressed: () => listener(false, true),
                icon: AppThemePreferences().appTheme.homeScreenSearchBarFilterIcon ?? const SizedBox.shrink(),
              ),
            ),
        ],
      ),
    );
  }
}

class GenericOptionOfBottomSheet extends StatelessWidget {
  final String label;
  final bool showDivider;
  final TextStyle? style;
  final Widget icon;
  final VoidCallback? onPressed;

  const GenericOptionOfBottomSheet({
    super.key,
    required this.label,
    this.showDivider = true,
    this.style,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: AppThemePreferences.dividerDecoration(right: true,bottom: true),
          // decoration: BoxDecoration(
          //
          //   // color: isSelected
          //   //     ? AppThemePreferences().appTheme.primaryColor
          //   //     : AppThemePreferences().appTheme.containerBackgroundColor,
          //   borderRadius: const BorderRadius.all(Radius.circular(5)),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              GenericTextWidget(
                label,
                textAlign: TextAlign.center,
                style: style ??
                    AppThemePreferences().appTheme.bottomSheetOptionsTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}