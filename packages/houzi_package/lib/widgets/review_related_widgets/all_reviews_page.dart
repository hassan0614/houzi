import 'dart:async';
import 'package:flutter/material.dart';
import 'package:houzi_package/api_management/api_handlers/api_manager.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/all_users.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/add_review_page.dart';
import 'package:houzi_package/widgets/review_related_widgets/single_review_row.dart';
import 'package:houzi_package/widgets/show_dialog_for_filter.dart';
import 'package:houzi_package/widgets/show_dialog_for_search.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';

class AllReviews extends StatefulWidget {
  final id;
  final fromProperty;
  final reviewPostType;
  final permaLink;
  final listingTitle;
  final title;

  AllReviews({
    this.id,
    this.fromProperty,
    this.reviewPostType,
    this.permaLink = "",
    this.listingTitle,
    this.title,
  });

  @override
  _AllReviewsState createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews>
    with SingleTickerProviderStateMixin {
  final ApiManager _apiManager = ApiManager();
  final TextEditingController _searchController = TextEditingController();

  late final TabController _tabController;
  int _currentTabIndex = 0;

  List<dynamic> _allReviewsList = [];
  int _allPage = 1;
  bool _allShouldLoadMore = true;
  RefreshController _allRefreshController = RefreshController();

  final checkRatingApprovedByAdmin =
      HiveStorageManager.readNewRatingsApprovedByAdminData();
  final checkIfUserIsAdmin =
      HiveStorageManager.readIsUserAdmin() ?? false;
  // For pending reviews tab
  List<dynamic> _pendingReviewsList = [];
  int _pendingPage = 1;
  bool _pendingShouldLoadMore = true;
  RefreshController _pendingRefreshController = RefreshController();
  bool isInternetConnected = true;
  bool isRefreshing = false;
  bool isLoading = false;
  String nonce = "";
  String _searchQuery = '';
  String? _selectedFilterStatus;
  Timer? _debounce;
  bool _showSearchDialog = false;
  bool _showFilterDialog = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    if (!widget.fromProperty) {
      _tabController.addListener(() {
        if (_tabController.index != _currentTabIndex) {
          setState(() {
            _currentTabIndex = _tabController.index;
          });
          _resetPagination();
          loadDataFromApi();
        }
      });
    }

    loadDataFromApi();
    fetchNonce();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    if (!widget.fromProperty) {
      _tabController.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery != _searchController.text) {
        setState(() {
          _searchQuery = _searchController.text;
          _resetPagination();
          loadDataFromApi();
        });
      }
    });
  }

  void _resetPagination() {
    if (!widget.fromProperty) {
      _allPage = 1;
      _pendingPage = 1;
      _allShouldLoadMore = true;
      _pendingShouldLoadMore = true;
      _allReviewsList.clear();
      _pendingReviewsList.clear();
    } else {
      _allPage = 1;
      _allShouldLoadMore = true;
      _allReviewsList.clear();
    }
  }

  fetchNonce() async {
    ApiResponse response = await _apiManager.fetchReportContentNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  Future<void> loadDataFromApi({bool forPullToRefresh = true}) async {
    if (isLoading) return;

    setState(() {
      isRefreshing = forPullToRefresh;
      isLoading = true;
    });

    if (widget.fromProperty && widget.reviewPostType != null) {
      await _fetchPropertyReviews(forPullToRefresh);
    } else {
      if (_currentTabIndex == 0) {
        await _fetchAllReviews(forPullToRefresh);
      } else {
        await _fetchPendingReviews(forPullToRefresh);
      }
    }

    if (forPullToRefresh) {
      if (widget.fromProperty) {
        _allRefreshController.refreshCompleted();
      } else {
        if (_currentTabIndex == 0) {
          _allRefreshController.refreshCompleted();
        } else {
          _pendingRefreshController.refreshCompleted();
        }
      }
    } else {
      if (widget.fromProperty) {
        _allRefreshController.loadComplete();
      } else {
        if (_currentTabIndex == 0) {
          _allRefreshController.loadComplete();
        } else {
          _pendingRefreshController.loadComplete();
        }
      }
    }
  }

  Future<void> _fetchPropertyReviews(bool forPullToRefresh) async {
    int page = forPullToRefresh ? 1 : _allPage + 1;
    if (!forPullToRefresh) {
      _allPage = page;
    }

    ApiResponse<List> response = await _apiManager.listingReviews(
      widget.id,
      page.toString(),
      "10",
    );

    if (mounted) {
      setState(() {
        isInternetConnected = response.internet;
        isLoading = false;

        if (response.success && response.internet) {
          List<dynamic> tempList = response.result ?? [];

          if (page == 1) {
            _allReviewsList = tempList;
          } else {
            _allReviewsList.addAll(tempList);
          }

          _allShouldLoadMore = tempList.length >= 10;
        } else {
          _allShouldLoadMore = false;
        }
      });
    }
  }

  Future<void> _fetchAllReviews(bool forPullToRefresh) async {
    int page = forPullToRefresh ? 1 : _allPage + 1;
    if (!forPullToRefresh) {
      _allPage = page;
    }

    ApiResponse response = await _apiManager.fetchAllReviews(
        page.toString(), "10", "", _searchQuery,
        status: _selectedFilterStatus ?? "");

    if (mounted) {
      setState(() {
        isInternetConnected = response.internet;
        isLoading = false;

        if (response.success && response.internet) {
          List<dynamic> tempList =
              response.result is List ? response.result : [];

          if (page == 1) {
            _allReviewsList = tempList;
          } else {
            _allReviewsList.addAll(tempList);
          }

          _allShouldLoadMore = tempList.length >= 10;
        } else {
          _allShouldLoadMore = false;
        }
      });
    }
  }

  Future<void> _fetchPendingReviews(bool forPullToRefresh) async {
    int page = forPullToRefresh ? 1 : _pendingPage + 1;
    if (!forPullToRefresh) {
      _pendingPage = page;
    }

    ApiResponse response = await _apiManager.fetchAllReviews(
        page.toString(), "10", "", _searchQuery,
        status: _selectedFilterStatus ?? REVIEW_APPROVAL_STATUS_PENDING);

    if (mounted) {
      setState(() {
        isInternetConnected = response.internet;
        isLoading = false;

        if (response.success && response.internet) {
          List<dynamic> tempList =
              response.result is List ? response.result : [];

          if (page == 1) {
            _pendingReviewsList = tempList;
          } else {
            _pendingReviewsList.addAll(tempList);
          }

          _pendingShouldLoadMore = tempList.length >= 10;
        } else {
          _pendingShouldLoadMore = false;
        }
      });
    }
  }

  Future<void> _processReviewAction(int reviewId, bool isApprove) async {
    final response =
        await _apiManager.processReviewApproval(reviewId, isApprove);
    // final responseForTrash =  await _apiManager.putReviewsToTrash(reviewId);
    if (!mounted) return;

    if (response.success && response.internet) {
      _showToast(response.message);
      _resetPagination();
      loadDataFromApi();
    } else {
      _showToast(response.message ?? "Action failed");
    }
  }
  void _processReviewDeleteAction(int reviewId, )async{
    final responseForTrash = await _apiManager.putReviewsToTrash(reviewId);
    if (!mounted) return;

    if (responseForTrash.success && responseForTrash.internet) {
      _showToast(responseForTrash.message ?? "Review moved to trash");
      _resetPagination();
      loadDataFromApi();
    } else {
      _showToast(responseForTrash.message ?? "Failed to move review to trash");
    }
  }


  Widget _buildTabbedView() {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("reviews"),
        actions: _buildAppBarActions(),
        bottom: TabBar(
          indicatorColor: AppThemePreferences.tabBarIndicatorColor,
          controller: _tabController,
          tabs: [
            _buildTab(label: UtilityMethods.getLocalizedString("all_reviews")),
            _buildTab(
                label: UtilityMethods.getLocalizedString("pending_reviews")),
          ],
        ),
      ),
      body: _buildTabBarView(),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildReviewsList(
            _allReviewsList, _allRefreshController, _allShouldLoadMore,
            isPendingTab: false, isTab: true),
        _buildReviewsList(_pendingReviewsList, _pendingRefreshController,
            _pendingShouldLoadMore,
            isPendingTab: true, isTab: true),
      ],
    );
  }

  Widget _buildTab({required String label}) {
    return Tab(
      child: GenericTextWidget(
        label,
        style: AppThemePreferences().appTheme.genericTabBarTextStyle,
      ),
    );
  }

  Widget _buildSingleView(
      {bool showSearchBar = true, bool showFilterDialog = true}) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("reviews"),
        actions: _buildAppBarActions(),
      ),
      body: Column(
        children: [
          if (showSearchBar && isInternetConnected)
            _buildSearchBar(showSearchDialog: showFilterDialog),
          if (widget.title != null && widget.title.isNotEmpty)
            propertyNameWidget(),
          Expanded(
            child: _buildReviewsList(
                _allReviewsList, _allRefreshController, _allShouldLoadMore, isTab: checkIfUserIsAdmin),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      if (!widget.fromProperty ||
          (widget.title == null || widget.title.isEmpty))
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Icon(
              AppThemePreferences.addIcon,
              color: AppThemePreferences.backgroundColorLight,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReview(
                    reviewPostType: widget.reviewPostType,
                    permaLink: widget.permaLink,
                    listingTitle: widget.listingTitle,
                    listingId: widget.id,
                  ),
                ),
              );
            },
          ),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (checkRatingApprovedByAdmin)
            widget.fromProperty
                ? _buildSingleView(
                    showSearchBar: true,
                    showFilterDialog:
                        !widget.fromProperty ) 
                : _buildTabbedView() 
          else
            widget.fromProperty
                ? _buildSingleView(
                    showSearchBar:
                        false) 
                : _buildSingleView(
                    showSearchBar: true,
                    showFilterDialog:
                        false), 

          // // Dialogs
          // if (_showSearchDialog)
          //   ShowSearchDialog(
          //     searchDialogPageListener: (showDialog, searchMap) {
          //       setState(() => _showSearchDialog = showDialog);
          //       if (searchMap != null) {
          //         setState(() {
          //           _searchQuery = searchMap[SEARCH_KEYWORD] ?? "";
          //           _resetPagination();
          //           loadDataFromApi();
          //         });
          //       }
          //     },
          //     fromReviews: true,
          //   ),

          if (_showFilterDialog) _buildFilterDialog(),
        ],
      ),
    );
  }

  Widget _buildReviewsList(List<dynamic> reviewsList,
      RefreshController controller, bool shouldLoadMore,
      {bool isPendingTab = false, bool isTab = true,}) {
    if (isLoading && reviewsList.isEmpty) {
      return loadingIndicatorWidget();
    }

    if (!isInternetConnected) {
      return NoInternetConnectionErrorWidget(
          onPressed: () => loadDataFromApi());
    }

    if (reviewsList.isNotEmpty) {
      return Column(
        children: [
          if(isTab && checkRatingApprovedByAdmin && !widget.fromProperty)
          _buildSearchBar(showSearchDialog: true, showFilterDialog: checkRatingApprovedByAdmin),
          Expanded(
            child: _builtReviewList(reviewsList, controller, shouldLoadMore,
                isPendingTab: isPendingTab),
          ),
        ],
      );
    }

    return noResultFoundPage(isPendingTab);
  }

  Widget _builtReviewList(List<dynamic> reviewsList,
      RefreshController controller, bool shouldLoadMore,
      {bool isPendingTab = false}) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: controller,
      onRefresh: () => loadDataFromApi(),
      onLoading: () => loadDataFromApi(forPullToRefresh: false),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body = Container();
          if (mode == LoadStatus.loading && shouldLoadMore) {
            body = paginationLoadingWidget();
          }
          return SizedBox(height: 55.0, child: Center(child: body));
        },
      ),
      child: ListView.builder(
        itemCount: reviewsList.length,
        itemBuilder: (context, index) {
          var review = reviewsList[index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: SingleReviewRow(
              review,
              true,
              nonce,
              isFromProperty: widget.fromProperty,
              approvalActionWidget: checkRatingApprovedByAdmin,
              onReviewAction: (reviewId, isApprove) {
                _processReviewAction(reviewId, isApprove);
              },
              onReviewDeleteAction: (reviewId, isTrash) {
                _processReviewDeleteAction(reviewId,);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar({bool showSearchDialog = true, bool showFilterDialog = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchBarWidget(
        showSearchDialog: _showSearchDialog,
        showFilterDialog: showFilterDialog,
        isFilterButtonPressed: _showFilterDialog,
        controller: _searchController,
        listener: (showDialog, showFilter) {
          setState(() {
            if (showDialog) {
              _showSearchDialog = showDialog;
            } else if (showFilter) {
              _showFilterDialog = showFilter;
            }
          });
        },
      ),
    );
  }

  Widget _buildFilterDialog() {
    return ShowFilterDialog(
      fromUsers: false,
      fromReviews: true,
      approvalList: USER_REVIEWS_FILTER_LIST,
      filterDialogPageListener: (
        showDialog,
        approvalStatus,
      ) {
        setState(() {
          _showFilterDialog = showDialog;
          if (approvalStatus != _selectedFilterStatus) {
            _selectedFilterStatus = approvalStatus;
            _resetPagination();
            loadDataFromApi();
          }
        });
      },
    );
  }

  Widget propertyNameWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        child: CardWidget(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GenericTextWidget(
                    widget.title,
                    style: AppThemePreferences().appTheme.heading01TextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  AppThemePreferences.arrowForwardIcon,
                  color: AppThemePreferences().appTheme.iconsColor,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (widget.reviewPostType == PROPERTY) {
            UtilityMethods.navigateToPropertyDetailPage(
              context: context,
              propertyID: widget.id,
              heroId: widget.id.toString(),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RealtorInformationDisplayPage(
                  heroId: "1",
                  realtorId: widget.id.toString(),
                  agentType: widget.reviewPostType == USER_ROLE_AGENT_VALUE
                      ? AGENT_INFO
                      : AGENCY_INFO,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget loadingIndicatorWidget() {
    return const Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }

  Widget paginationLoadingWidget() {
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

  Widget noResultFoundPage([bool isPendingTab = false]) {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: isPendingTab
          ? UtilityMethods.getLocalizedString("no_pending_reviews")
          : UtilityMethods.getLocalizedString("no_reviews_found"),
    );
  }

  void _showToast(String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
