import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../state/milestone_app_6_state.dart';
import '../../theme/milestone_app_6_colors.dart';
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
  State<MilestoneApp6Shell> createState() => _MilestoneApp6ShellState();
}

class _MilestoneApp6ShellState extends State<MilestoneApp6Shell> {
  bool _shouldShowNavigation(String location) {
    return location == '/home' ||
        location == '/cart' ||
        location == '/profile';
  }
  // ==============================================================
  // BOTTOM NAVIGATION VISIBILITY
  // ==============================================================

  final ValueNotifier<bool> _bottomNavVisible = ValueNotifier<bool>(true);

  // ==============================================================
  // DISPOSE
  // ==============================================================

  @override
  void dispose() {
    _bottomNavVisible.dispose();
    super.dispose();
  }


  Future<void> _handleBack(BuildContext context) async {
    final router = GoRouter.of(context);
    final location = router.state.uri.path;

    // Navigate to the previous screen if possible.
    if (router.canPop()) {
      router.pop();
      return;
    }

    // If not on Home, return to Home first.
    if (!location.startsWith('/home')) {
      router.go('/home');
      return;
    }

    // On Home: ask before exiting.
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Exit App?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to exit this app?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF514B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    if (shouldExit == true) {
      await SystemNavigator.pop();
    }
  }

  bool _handleScrollNotification(
    BuildContext context,
    ScrollNotification notification,
  ) {
    final location = GoRouterState.of(context).uri.path;

    if (location != '/home') {
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

      if (notification.direction == ScrollDirection.reverse) {
        if (_bottomNavVisible.value) {
          _bottomNavVisible.value = false;
        }
      }

      // ----------------------------------------------------------
      // SCROLL UP
      // ----------------------------------------------------------

      else if (notification.direction == ScrollDirection.forward) {
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
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final location = GoRouterState.of(context).uri.path;

    final showNavigation = _shouldShowNavigation(location);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack(context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            // SCREEN CONTENT
            Positioned.fill(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  return _handleScrollNotification(
                    context,
                    notification,
                  );
                },
                child: Row(
                  children: [
                    // Show sidebar only on the three main routes.
                    if (tablet && showNavigation)
                      _sideBar(context),

                    Expanded(
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ),

            // FLOATING BOTTOM NAVIGATION
            if (!tablet && showNavigation)
              Positioned(
                left: 20,
                right: 20,
                bottom: 0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _bottomNavVisible,
                  builder: (context, visible, child) {
                    return AnimatedSlide(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      offset: visible
                          ? Offset.zero
                          : const Offset(0, 1.5),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: visible ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !visible,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                              MediaQuery.of(context).padding.bottom + 12,
                            ),
                            child: MilestoneApp6BottomNav(
                              state: widget.state,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }


  // ==============================================================
  // SIDEBAR
  // ==============================================================

  Widget _sideBar(
    BuildContext context,
  ) {
    final location = GoRouterState.of(context).uri.path;

    return NavigationRail(
      selectedIndex: _selectedIndex(location),

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

      labelType: NavigationRailLabelType.all,

      // ============================================================
      // BACKGROUND
      // ============================================================

      backgroundColor: MilestoneApp6Colors.orangeDark,

      // ============================================================
      // SELECTED ICON
      // ============================================================

      selectedIconTheme: const IconThemeData(
        color: Colors.white,
      ),

      // ============================================================
      // UNSELECTED ICON
      // ============================================================

      unselectedIconTheme: const IconThemeData(
        color: Colors.white70,
      ),

      // ============================================================
      // SELECTED TEXT
      // ============================================================

      selectedLabelTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),

      // ============================================================
      // UNSELECTED TEXT
      // ============================================================

      unselectedLabelTextStyle: const TextStyle(
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
