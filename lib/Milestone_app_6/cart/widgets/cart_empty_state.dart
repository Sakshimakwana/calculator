import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class MilestoneApp6CartEmptyState extends StatelessWidget {
  const MilestoneApp6CartEmptyState({super.key});

  static const Color primaryColor = Color(0xFFFF514B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

// Keep animation compact so the button always fits.
        final animationHeight = availableHeight * 0.40;

        return SizedBox(
          width: double.infinity,
          height: availableHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 35),

                SizedBox(
                  height: 340,
                  width: double.infinity,
                  child: Lottie.asset(
                    'assets/animations/Empty_cart_animation.json',
                    fit: BoxFit.contain,
                    repeat: false,
                    animate: true,
                  ),
                ),

                const SizedBox(height: 35),

// Heading
                Text(
                  'Your Cart is Empty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF111318),
                  ),
                ),

                const SizedBox(height: 7),

// Description
                Text(
                  'Looks like you haven’t added anything\n'
                      'to your cart yet. Explore delicious food\n'
                      'from nearby restaurants.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: theme.hintColor,
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: 400,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'BROWSE RESTAURANTS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward, size: 21),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
