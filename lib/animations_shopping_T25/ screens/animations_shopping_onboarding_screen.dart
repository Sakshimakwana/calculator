import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../theme/animations_shopping_colors.dart';
import '../theme/animations_shopping_typography.dart';

class AnimationsShoppingOnboardingScreen extends StatefulWidget {
  const AnimationsShoppingOnboardingScreen({super.key});

  @override
  State<AnimationsShoppingOnboardingScreen> createState() =>
      _AnimationsShoppingOnboardingScreenState();
}

class _AnimationsShoppingOnboardingScreenState
    extends State<AnimationsShoppingOnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Shop Smarter',
      'description':
      'Discover the best products\nat amazing prices.',
    },
    {
      'title': 'Find Your Favorites',
      'description':
      'Save your favorite products\nand find them anytime.',
    },
    {
      'title': 'Easy Shopping',
      'description':
      'Add products to your cart\nand checkout with ease.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/animations-shopping/home');
    }
  }

  void _skip() {
    context.go('/animations-shopping/home');
  }

  @override
  Widget build(BuildContext context) {
    final page = pages[currentPage];

    return Scaffold(
      backgroundColor: AnimationsShoppingColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              // ------------------------------------------------
              // SKIP
              // ------------------------------------------------

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text(
                    'Skip',
                    style: AnimationsShoppingTypography.body,
                  ),
                ),
              ),

              // ------------------------------------------------
              // THREE ONBOARDING PAGES
              // ------------------------------------------------

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,

                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },

                  itemBuilder: (context, index) {
                    return AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 400,
                      ),

                      transitionBuilder: (
                          child,
                          animation,
                          ) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.92,
                              end: 1,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },

                      child: Column(
                        key: ValueKey(index),
                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [
                          // ------------------------------------------------
                          // LOTTIE SHOPPING CART
                          // ------------------------------------------------

                          Hero(
                            tag: 'shopping-cart-animation',
                            child: Container(
                              width: 280,
                              height: 280,

                              decoration: BoxDecoration(
                                color: AnimationsShoppingColors
                                    .imageBackground,
                                borderRadius:
                                BorderRadius.circular(40),
                              ),

                              child: Lottie.asset(
                                'assets/animations/Shopping_cart.json',
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 45),

                          // ------------------------------------------------
                          // TITLE
                          // ------------------------------------------------

                          Text(
                            pages[index]['title']!,
                            textAlign: TextAlign.center,
                            style:
                            AnimationsShoppingTypography.title,
                          ),

                          const SizedBox(height: 12),

                          // ------------------------------------------------
                          // DESCRIPTION
                          // ------------------------------------------------

                          Text(
                            pages[index]['description']!,
                            textAlign: TextAlign.center,
                            style:
                            AnimationsShoppingTypography.body,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ------------------------------------------------
              // PAGE INDICATORS
              // ------------------------------------------------

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                      (index) {
                    final isActive =
                        index == currentPage;

                    return AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),

                      curve: Curves.easeOut,

                      width: isActive ? 24 : 7,
                      height: 7,

                      margin: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),

                      decoration: BoxDecoration(
                        color: isActive
                            ? AnimationsShoppingColors.primary
                            : Colors.grey.shade300,

                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ------------------------------------------------
              // NEXT BUTTON
              // ------------------------------------------------

              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  backgroundColor:
                  AnimationsShoppingColors.primary,

                  onPressed: _nextPage,

                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 250,
                    ),

                    child: Icon(
                      currentPage == 2
                          ? Icons.check
                          : Icons.arrow_forward,
                      key: ValueKey(currentPage),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}