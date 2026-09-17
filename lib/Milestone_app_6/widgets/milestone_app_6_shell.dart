import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import 'milestone_app_6_bottom_nav.dart';

class MilestoneApp6Shell extends StatefulWidget {
  final MilestoneApp6State state;
  final Widget child;

  const MilestoneApp6Shell({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  State<MilestoneApp6Shell> createState() =>
      _MilestoneApp6ShellState();
}

class _MilestoneApp6ShellState
    extends State<MilestoneApp6Shell> {
  // ==============================================================
  // BOTTOM NAVIGATION VISIBILITY
  // ==============================================================

  final ValueNotifier<bool> _bottomNavVisible =
  ValueNotifier<bool>(true);

  // ==============================================================
  // DISPOSE
  // ==============================================================

  @override
  void dispose() {
    _bottomNavVisible.dispose();
    super.dispose();
  }

  // ==============================================================
  // SCROLL LISTENER
  // ==============================================================

  bool _handleScrollNotification(
      BuildContext context,
      ScrollNotification notification,
      ) {
    final location =
        GoRouterState.of(context).uri.path;

    // ============================================================
    // ONLY HOME
    // ============================================================

    if (!location.startsWith('/home')) {
      if (!_bottomNavVisible.value) {
        _bottomNavVisible.value = true;
      }

      return false;
    }

    // ============================================================
    // USER SCROLL
    // ============================================================

    if (notification is UserScrollNotification) {
      // ----------------------------------------------------------
      // SCROLL DOWN
      // ----------------------------------------------------------

      if (notification.direction ==
          ScrollDirection.reverse) {
        if (_bottomNavVisible.value) {
          _bottomNavVisible.value = false;
        }
      }

      // ----------------------------------------------------------
      // SCROLL UP
      // ----------------------------------------------------------

      else if (notification.direction ==
          ScrollDirection.forward) {
        if (!_bottomNavVisible.value) {
          _bottomNavVisible.value = true;
        }
      }
    }

    // ============================================================
    // REACHED TOP
    // ============================================================

    if (notification.metrics.pixels <= 0) {
      if (!_bottomNavVisible.value) {
        _bottomNavVisible.value = true;
      }
    }

    return false;
  }

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final tablet =
        MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      // ==========================================================
      // BODY
      // ==========================================================

      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return _handleScrollNotification(
            context,
            notification,
          );
        },

        child: Row(
          children: [
            // ======================================================
            // TABLET SIDEBAR
            // ======================================================

            if (tablet)
              _sideBar(context),

            // ======================================================
            // MAIN CONTENT
            // ======================================================

            Expanded(
              child: widget.child,
            ),
          ],
        ),
      ),

      // ==========================================================
      // MOBILE BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: tablet
          ? null
          : ValueListenableBuilder<bool>(
        valueListenable:
        _bottomNavVisible,
        builder: (
            context,
            visible,
            child,
            ) {
          return AnimatedContainer(
            duration:
            const Duration(
              milliseconds: 280,
            ),
            curve:
            Curves.easeInOut,

            // =================================================
            // FULL BAR HEIGHT
            // =================================================

            height: visible ? 80 : 0,

            child: ClipRect(
              child: Align(
                alignment:
                Alignment.topCenter,

                heightFactor:
                visible ? 1.0 : 0.0,

                child:
                MilestoneApp6BottomNav(
                  state: widget.state,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==============================================================
  // SIDEBAR
  // ==============================================================

  Widget _sideBar(
      BuildContext context,
      ) {
    final location =
        GoRouterState.of(context)
            .uri
            .path;

    return NavigationRail(
      selectedIndex:
      _selectedIndex(location),

      // ============================================================
      // NAVIGATION
      // ============================================================

      onDestinationSelected: (value) {
        const paths = [
          '/home',
          '/categories',
          '/cart',
          '/profile',
        ];

        // Always show navigation
        // when changing page.
        _bottomNavVisible.value = true;

        context.go(paths[value]);
      },

      // ============================================================
      // LABEL
      // ============================================================

      labelType:
      NavigationRailLabelType.all,

      // ============================================================
      // BACKGROUND
      // ============================================================

      backgroundColor:
      MilestoneApp6Colors.orangeDark,

      // ============================================================
      // SELECTED ICON
      // ============================================================

      selectedIconTheme:
      const IconThemeData(
        color: Colors.white,
      ),

      // ============================================================
      // UNSELECTED ICON
      // ============================================================

      unselectedIconTheme:
      const IconThemeData(
        color: Colors.white70,
      ),

      // ============================================================
      // SELECTED TEXT
      // ============================================================

      selectedLabelTextStyle:
      const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),

      // ============================================================
      // UNSELECTED TEXT
      // ============================================================

      unselectedLabelTextStyle:
      const TextStyle(
        color: Colors.white70,
        fontSize: 11,
      ),

      // ============================================================
      // LOGO
      // ============================================================

      leading: const Padding(
        padding: EdgeInsets.only(
          top: 18,
          bottom: 24,
        ),
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.white,
          size: 30,
        ),
      ),

      // ============================================================
      // DESTINATIONS
      // ============================================================

      destinations: const [
        // ==========================================================
        // HOME
        // ==========================================================

        NavigationRailDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home,
          ),
          label: Text(
            'Home',
          ),
        ),

        // ==========================================================
        // CATEGORIES
        // ==========================================================

        NavigationRailDestination(
          icon: Icon(
            Icons.grid_view_outlined,
          ),
          selectedIcon: Icon(
            Icons.grid_view,
          ),
          label: Text(
            'Categories',
          ),
        ),

        // ==========================================================
        // CART
        // ==========================================================

        NavigationRailDestination(
          icon: Icon(
            Icons.shopping_cart_outlined,
          ),
          selectedIcon: Icon(
            Icons.shopping_cart,
          ),
          label: Text(
            'Cart',
          ),
        ),

        // ==========================================================
        // PROFILE
        // ==========================================================

        NavigationRailDestination(
          icon: Icon(
            Icons.person_outline,
          ),
          selectedIcon: Icon(
            Icons.person,
          ),
          label: Text(
            'Profile',
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // SELECTED INDEX
  // ==============================================================

  int _selectedIndex(
      String location,
      ) {
    if (location.startsWith(
      '/categories',
    )) {
      return 1;
    }

    if (location.startsWith('/cart')) {
      return 2;
    }

    if (location.startsWith('/profile')) {
      return 3;
    }

    return 0;
  }
}