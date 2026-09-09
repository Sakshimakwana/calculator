import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewSplashScreenRouter extends StatefulWidget {
  const NewSplashScreenRouter({super.key});

  @override
  State<NewSplashScreenRouter> createState() => _NewSplashScreenRouterState();
}

class _NewSplashScreenRouterState extends State<NewSplashScreenRouter> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 3),
      _openNextScreen,
    );
  }

  Future<void> _openNextScreen() async {
    final prefs = await SharedPreferences.getInstance();

    final onboardingDone =
        prefs.getBool('shoppingflow_T21_onboarding_done') ?? false;

    if (!mounted) return;

    if (onboardingDone) {
      context.go('/login');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello Flutter',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}