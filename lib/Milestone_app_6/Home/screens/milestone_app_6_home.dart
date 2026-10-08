import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/methods/milestone_app_6_home_logic.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_app_bar.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_banner.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_empty_food_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_restaurants_section.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_section_title.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_sticky_content.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_sticky_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../state/milestone_app_6_state.dart';

class MilestoneApp6HomeScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6HomeScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6HomeScreen> createState() =>
      _MilestoneApp6HomeScreenState();
}

class _MilestoneApp6HomeScreenState
    extends State<MilestoneApp6HomeScreen> {
  late final MilestoneApp6HomeLogic logic;

  @override
  void initState() {
    super.initState();

    logic = MilestoneApp6HomeLogic(
      appState: widget.state,
      onChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    logic.initialize();
  }

  @override
  void dispose() {
    logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSearch =
        logic.searchController.text
            .trim()
            .isNotEmpty;

    return CustomScrollView(
      controller:
      logic.homeScrollController,
      physics:
      const BouncingScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: logic.refreshHome,
        ),

        // ========================================================
        // APP BAR
        // ========================================================

        MilestoneApp6HomeAppBar(
          fullname: logic.fullname,
          selectedAddress:
          logic.selectedApiAddress,
          isLoadingAddress:
          logic.isLoadingAddress,
          onAddressTap: () async {
            await context.push(
              '/profile/address',
            );

            if (!mounted) {
              return;
            }

            await logic.loadSelectedAddress();
            await logic.loadNearbyRestaurants();
          },
        ),

        SliverPersistentHeader(
          pinned: true,
          delegate: MilestoneApp6HomeStickyHeaderDelegate(
            minHeight: 175,
            maxHeight: 175,
            child: MilestoneApp6HomeStickyContent(
              searchController: logic.searchController,
              searchHintIndex: logic.searchHintIndex,
              searchHints: logic.searchHints,
              isListening: logic.isListening,
              onMicTap: () {
                FocusScope.of(context).unfocus();

                logic.toggleListening(
                  onUnavailable: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Speech recognition is not available.',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                );
              },
              onClear: logic.clearSearch,
              isLoadingCategories:
              logic.isLoadingRestaurants &&
                  logic.nearbyRestaurants.isEmpty,
              categories: logic.apiCategories,
              selectedCategory: logic.selectedCategory,
              findCategoryMenu: logic.findCategoryMenu,
              onCategorySelected: logic.selectCategory,
            ),
          ),
        ),


        const SliverToBoxAdapter(
          child: MilestoneApp6HomeBanner(),
        ),


        SliverToBoxAdapter(
          child:
          MilestoneApp6HomeSectionTitle(
            title: 'All Restaurants',
            onSeeAll: () {
              context.push(
                '/restaurants',
              );
            },
          ),
        ),

        SliverToBoxAdapter(
          child:
          MilestoneApp6HomeRestaurantsSection(
            isLoading:
            logic.isLoadingRestaurants,

            error:
            logic.restaurantError,

            restaurants:
            logic.filteredNearbyRestaurants,

            onRetry:
            logic.loadNearbyRestaurants,

            isLoadingMore:
            logic.isLoadingMoreRestaurants,

            hasMorePages:
            logic.hasMoreRestaurantPages,

            recordsLoaded:
            logic.recordsLoaded,

            totalRestaurants:
            logic.totalRestaurants,

            selectedCategory:
            logic.selectedCategory,
          ),
        ),

        if (hasSearch &&
            logic.filteredNearbyRestaurants
                .isEmpty)
          SliverToBoxAdapter(
            child:
            MilestoneApp6HomeEmptyFoodState(
              hasSearch: true,
              onClearSearch:
              logic.clearSearch,
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
      ],
    );
  }
}