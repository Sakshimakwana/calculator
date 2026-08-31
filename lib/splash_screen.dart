import 'dart:async';
import 'package:app_matic_tech_flutter_app/Login_page_T14/login_screen.dart';
import 'package:app_matic_tech_flutter_app/Product_Catalogue_T11/widgets/home_screen.dart';
import 'package:app_matic_tech_flutter_app/appointment_booking_T17/appointment_booking_screen.dart';
import 'package:app_matic_tech_flutter_app/contact_app_T10/contact_list_screen.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/dashboard_screen.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/registration/registration_screen.dart';
import 'package:app_matic_tech_flutter_app/instagram_style_ui/instagram_style_ui_screen.dart';
import 'package:app_matic_tech_flutter_app/pricing_plan/pricing_plan_screen.dart';
import 'package:app_matic_tech_flutter_app/product_details_header/product_details_header_screen.dart';
import 'package:app_matic_tech_flutter_app/profile_card/Profile_screen.dart';
import 'package:app_matic_tech_flutter_app/reusable_card_gallery/reusable_card_gallery_screen.dart';
import 'package:app_matic_tech_flutter_app/text_widgets/motivational_quotes.dart';
import 'package:app_matic_tech_flutter_app/typography_profile/about_me.dart';
import 'package:flutter/material.dart';
import 'Product_Catalogue_T11/data/product_catalogue_data.dart';
import 'Product_Catalogue_T11/product_cataloge_screen.dart';
import 'calculator/calculator_screen.dart';
import 'counter_app/counter_screen.dart';
import 'project_basics/student_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentBookingScreen()
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(height: 20),

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