import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../theme/shoppingflow_colors.dart';
import '../theme/shoppingflow_typography.dart';

class ShoppingFlowOrderSuccessScreen extends StatefulWidget {
  const ShoppingFlowOrderSuccessScreen({
    super.key,
  });

  @override
  State<ShoppingFlowOrderSuccessScreen> createState() =>
      _ShoppingFlowOrderSuccessScreenState();
}

class _ShoppingFlowOrderSuccessScreenState
    extends State<ShoppingFlowOrderSuccessScreen> {

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _playSuccessSound();
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(
      AssetSource('sounds/Successful.mp3'),
    );
  }

  void _continueShopping(BuildContext context) {
    Navigator.popUntil(
      context,
          (route) => route.isFirst,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                // Tick Lottie Animation
                Container(
                  width: 160,
                  height: 160,

                  decoration: BoxDecoration(
                    color:
                    ShoppingFlowColors.primaryLight,

                    shape: BoxShape.circle,
                  ),

                  child: Lottie.asset(
                    'assets/json/tick.json',

                    width: 140,
                    height: 140,

                    fit: BoxFit.contain,

                    repeat: false,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Order Placed!',
                  style: ShoppingFlowTypography.success,
                ),

                const SizedBox(height: 10),

                const Text(
                  'Your order has been successfully placed.',
                  textAlign: TextAlign.center,
                  style: ShoppingFlowTypography.body,
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: () {
                      _continueShopping(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      ShoppingFlowColors.primary,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      'Continue Shopping',
                      style:
                      ShoppingFlowTypography.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}