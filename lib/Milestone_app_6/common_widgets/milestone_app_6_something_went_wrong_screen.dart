
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SomethingWentWrongScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const SomethingWentWrongScreen({
    super.key,
    required this.onRetry,
  });

  @override
  State<SomethingWentWrongScreen> createState() =>
      _SomethingWentWrongScreenState();
}

class _SomethingWentWrongScreenState
    extends State<SomethingWentWrongScreen>
    with TickerProviderStateMixin {
  static const Color cream = Color(0xFFFFF8F2);
  static const Color brown = Color(0xFF70452F);
  static const Color darkBrown = Color(0xFF30231D);
  static const Color mutedBrown = Color(0xFF9A8173);
  static const Color peach = Color(0xFFF4E4D9);

  late final AnimationController _floatController;
  late final AnimationController _entryController;
  late final Animation<double> _entry;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _entry = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    _scale = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack,
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  Widget _floatingIcon(
      IconData icon,
      double size,
      Color color,
      double phase,
      ) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final double movement = math.sin(
          (_floatController.value * math.pi) + phase,
        ) * 9;

        return Transform.translate(
          offset: Offset(0, movement),
          child: child,
        );
      },
      child: Icon(icon, size: size, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // Animated illustration
                      ScaleTransition(
                        scale: _scale,
                        child: SizedBox(
                          width: 270,
                          height: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 205,
                                height: 205,
                                decoration: BoxDecoration(
                                  color: peach,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: brown.withOpacity(0.08),
                                      blurRadius: 28,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),

                              // Decorative orbit
                              Container(
                                width: 225,
                                height: 225,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFE8D0C0),
                                    width: 1.5,
                                  ),
                                ),
                              ),

                              // Takeaway bag
                              AnimatedBuilder(
                                animation: _floatController,
                                builder: (context, child) {
                                  final angle =
                                      math.sin(
                                        _floatController.value *
                                            math.pi * 2,
                                      ) * 0.045;

                                  return Transform.rotate(
                                    angle: angle,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 112,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    color: brown,
                                    borderRadius:
                                    BorderRadius.circular(23),
                                    boxShadow: [
                                      BoxShadow(
                                        color: brown.withOpacity(0.22),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        top: -3,
                                        child: Container(
                                          width: 48,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: brown,
                                              width: 7,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.restaurant_rounded,
                                            color: Color(0xFFFFE4CB),
                                            size: 43,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'TASTY!',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w800,
                                              letterSpacing: 1.5,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Floating food symbols
                              Positioned(
                                top: 26,
                                right: 24,
                                child: _floatingIcon(
                                  Icons.local_pizza_rounded,
                                  43,
                                  const Color(0xFFD98B43),
                                  0,
                                ),
                              ),
                              Positioned(
                                left: 20,
                                top: 65,
                                child: _floatingIcon(
                                  Icons.bakery_dining_rounded,
                                  37,
                                  const Color(0xFFBC7451),
                                  1.4,
                                ),
                              ),
                              Positioned(
                                right: 23,
                                bottom: 40,
                                child: _floatingIcon(
                                  Icons.lunch_dining_rounded,
                                  39,
                                  const Color(0xFF8C9A58),
                                  2.1,
                                ),
                              ),
                              Positioned(
                                left: 37,
                                bottom: 25,
                                child: _floatingIcon(
                                  Icons.circle,
                                  13,
                                  const Color(0xFFE5B79C),
                                  0.8,
                                ),
                              ),
                              Positioned(
                                right: 64,
                                top: 7,
                                child: _floatingIcon(
                                  Icons.star_rounded,
                                  23,
                                  const Color(0xFFE4AC55),
                                  2.7,
                                ),
                              ),

                              // Small broken delivery trail
                              Positioned(
                                bottom: 6,
                                child: Row(
                                  children: [
                                    _dot(7),
                                    const SizedBox(width: 7),
                                    _dot(5),
                                    const SizedBox(width: 7),
                                    Transform.rotate(
                                      angle: 0.6,
                                      child: Container(
                                        width: 17,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: mutedBrown,
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    _dot(5),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      FadeTransition(
                        opacity: _entry,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(_entry),
                          child: Column(
                            children: [
                              const Text(
                                'Oops! Something went wrong',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  height: 1.3,
                                  fontWeight: FontWeight.w800,
                                  color: darkBrown,
                                ),
                              ),
                              const SizedBox(height: 13),
                              const Text(
                                'Looks like our kitchen lost its '
                                    'connection!\nCheck your internet '
                                    'and let’s get things cooking again.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.7,
                                  color: mutedBrown,
                                ),
                              ),
                              const SizedBox(height: 28),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: widget.onRetry,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brown,
                                    foregroundColor: Colors.white,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh_rounded),
                                      SizedBox(width: 10),
                                      Text(
                                        'Try Again',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 19),
                              const Text(
                                'GOOD FOOD IS WORTH THE WAIT',
                                style: TextStyle(
                                  color: mutedBrown,
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _dot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: mutedBrown,
        shape: BoxShape.circle,
      ),
    );
  }
}
