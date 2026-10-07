import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/widgets/milestone_app_6_button.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6OnboardingScreen
    extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6OnboardingScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6OnboardingScreen>
  createState() =>
      _MilestoneApp6OnboardingScreenState();
}

class _MilestoneApp6OnboardingScreenState
    extends State<
        MilestoneApp6OnboardingScreen> {
  final PageController _controller =
  PageController();

  int _page = 0;

  final pages = const [
    (
    title: 'Good Food\nBetter You',
    text:
    'Discover amazing food from the best restaurants near you.',
    image:
    'https://images.unsplash.com/photo-1547592180-85f173990554?w=900',
    ),
    (
    title: 'Fresh Food\nFast Delivery',
    text:
    'Order your favourites and enjoy them at your door.',
    image:
    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=900',
    ),
    (
    title: 'Eat Good\nFeel Great',
    text:
    'Save your favourites and build your perfect meal.',
    image:
    'https://images.unsplash.com/photo-1547592180-85f173990554?w=900',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      MilestoneApp6Colors.cream,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,

                onPageChanged: (value) {
                  setState(() {
                    _page = value;
                  });
                },

                itemBuilder: (
                    context,
                    index,
                    ) {
                  final item =
                  pages[index];

                  return AnimatedBuilder(
                    animation: _controller,

                    builder: (
                        context,
                        child,
                        ) {
                      return Padding(
                        padding:
                        const EdgeInsets.fromLTRB(
                          32,
                          30,
                          32,
                          10,
                        ),

                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [
                            Hero(
                              tag:
                              'onboarding-food-$index',

                              child:
                              MilestoneApp6Image(
                                url:
                                item.image,
                                width: 280,
                                height: 280,
                                borderRadius:
                                BorderRadius.circular(
                                  140,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 38,
                            ),

                            AnimatedSwitcher(
                              duration:
                              const Duration(
                                milliseconds: 300,
                              ),

                              child: Text(
                                item.title,

                                key:
                                ValueKey(
                                  item.title,
                                ),

                                textAlign:
                                TextAlign.center,

                                style:
                                const TextStyle(
                                  fontSize: 30,
                                  fontWeight:
                                  FontWeight.w700,
                                  height: 1.08,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            Text(
                              item.text,

                              textAlign:
                              TextAlign.center,

                              style: TextStyle(
                                color:
                                Theme.of(
                                  context,
                                ).hintColor,

                                fontSize: 13,

                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children:
              List.generate(
                pages.length,

                    (index) =>
                    AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds: 220,
                      ),

                      margin:
                      const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),

                      width:
                      index == _page
                          ? 20
                          : 7,

                      height: 7,

                      decoration:
                      BoxDecoration(
                        color: index == _page
                            ? MilestoneApp6Colors
                            .orange
                            : Colors.black26,

                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.all(24),

              child: MilestoneApp6Button(
                label:
                _page ==
                    pages.length - 1
                    ? 'Get Started'
                    : 'Next',

                onPressed: () async {
                  if (_page ==
                      pages.length - 1) {
                    await widget.state
                        .finishOnboarding();

                    if (!mounted) return;

                    context.go('/home');
                  } else {
                    _controller.nextPage(
                      duration:
                      const Duration(
                        milliseconds: 450,
                      ),
                      curve:
                      Curves.easeOutCubic,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}