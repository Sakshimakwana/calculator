import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_profile_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class AccountCreatedScreen extends StatefulWidget {
  const AccountCreatedScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.country,
    required this.notifications,
  });

  final String name;
  final String email;
  final String phone;
  final String gender;
  final DateTime birthDate;
  final String country;
  final bool notifications;

  @override
  State<AccountCreatedScreen> createState() => _AccountCreatedScreenState();
}

class _AccountCreatedScreenState extends State<AccountCreatedScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Play success sound when this screen opens
    _playSuccessSound();
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(
      AssetSource('sounds/Successful.mp3'),
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
      backgroundColor: RegistrationColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Lottie animation
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Lottie.asset(
                        'assets/json/tick.json',
                        repeat: false,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Account Created!',
                      style: RegistrationTypography.title,
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Your account has been created\nsuccessfully.',
                      textAlign: TextAlign.center,
                      style: RegistrationTypography.body,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileSummaryScreen(
                          name: widget.name,
                          email: widget.email,
                          phone: widget.phone,
                          gender: widget.gender,
                          birthDate: widget.birthDate,
                          country: widget.country,
                          notifications: widget.notifications,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RegistrationColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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