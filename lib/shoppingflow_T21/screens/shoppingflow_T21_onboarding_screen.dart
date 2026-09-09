import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/shoppingflow_T21_onboarding_page.dart';
import '../widgets/shoppingflow_T21_page_indicator.dart';
import '../theme/shoppingflow_T21_colors.dart';

class ShoppingFlowT21OnboardingScreen extends StatefulWidget {
  const ShoppingFlowT21OnboardingScreen({super.key});

  @override
  State<ShoppingFlowT21OnboardingScreen> createState() =>
      _ShoppingFlowT21OnboardingScreenState();
}

class _ShoppingFlowT21OnboardingScreenState
    extends State<ShoppingFlowT21OnboardingScreen> {

  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<ShoppingFlowT21OnboardingData> _pages = const [
    ShoppingFlowT21OnboardingData(
      image: 'assets/shoppingflow_T21_onboarding_1.png',
      title: 'Discover',
      description:
      'Find the best products handpicked for you.',
    ),
    ShoppingFlowT21OnboardingData(
      image: 'assets/shoppingflow_T21_onboarding_2.png',
      title: 'Easy Shopping',
      description:
      'Add to cart and checkout in a few simple steps.',
    ),
    ShoppingFlowT21OnboardingData(
      image: 'assets/shoppingflow_T21_onboarding_3.png',
      title: 'Fast Delivery',
      description:
      'Get your orders delivered fast at your doorstep.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Save onboarding as completed
  // Then navigate to Login
  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'shoppingflow_T21_onboarding_done',
      true,
    );

    if (!mounted) return;

    // Go to Login instead of Home
    context.go('/login');
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShoppingFlowT21Colors.background,

      body: SafeArea(
        child: Column(
          children: [

            // Skip button - hide on the last page
            if (_currentPage != _pages.length - 1)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skip,
                  child: const Text('Skip'),
                ),
              ),

            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,

                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },

                itemBuilder: (context, index) {
                  return ShoppingFlowT21OnboardingPage(
                    data: _pages[index],
                  );
                },
              ),
            ),

            // Page indicators
            ShoppingFlowT21PageIndicator(
              currentPage: _currentPage,
              count: _pages.length,
            ),

            const SizedBox(height: 20),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,

                child: _currentPage == _pages.length - 1

                // Last page
                    ? FilledButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Get Started',
                  ),
                )

                // Other pages
                    : Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: _nextPage,
                    borderRadius:
                    BorderRadius.circular(30),

                    child: Container(
                      width: 54,
                      height: 54,

                      decoration:
                      const BoxDecoration(
                        color:
                        ShoppingFlowT21Colors
                            .primary,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}