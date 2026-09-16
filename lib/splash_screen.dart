import 'dart:async';
import 'package:app_matic_tech_flutter_app/AMT_lottie_animation.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/login_screen.dart';
import 'package:app_matic_tech_flutter_app/Product_Catalogue_T11/widgets/home_screen.dart';
import 'package:app_matic_tech_flutter_app/appointment_booking_T17/appointment_booking_screen.dart';
import 'package:app_matic_tech_flutter_app/contact_app_T10/contact_list_screen.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/dashboard_screen.dart';
import 'package:app_matic_tech_flutter_app/dashboard_T9/widgets/dashboard_settings_screen.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/registration/registration_screen.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/settings/widgets/settings_section.dart';
import 'package:app_matic_tech_flutter_app/instagram_style_ui_T6/instagram_style_ui_screen.dart';
import 'package:app_matic_tech_flutter_app/lottie_animation.dart';
import 'package:app_matic_tech_flutter_app/pricing_plan_T7/pricing_plan_screen.dart';
import 'package:app_matic_tech_flutter_app/product_details_header_T8/product_details_header_screen.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/product_filter_t18_product_screen.dart';
import 'package:app_matic_tech_flutter_app/profile_card_T4/Profile_screen.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/profileflow_registration_screen.dart';
import 'package:app_matic_tech_flutter_app/project_basics_T1/student_data.dart';
import 'package:app_matic_tech_flutter_app/reusable_card_gallery_T5/reusable_card_gallery_screen.dart';
import 'package:app_matic_tech_flutter_app/shoppingflow_T19/shoppingflow_product_list_screen.dart';
import 'package:app_matic_tech_flutter_app/text_widgets_T2/motivational_quotes.dart';
import 'package:app_matic_tech_flutter_app/typography_profile_T4_1/about_me.dart';
import 'package:flutter/material.dart';
import 'Product_Catalogue_T11/data/product_catalogue_data.dart';
import 'Product_Catalogue_T11/product_cataloge_screen.dart';
import 'calculator/calculator_screen.dart';
import 'counter_app_T3/counter_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
  //
  //    Timer(
  //      const Duration(seconds: 3),
  //          () {
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //              builder: (context) =>//ProductFilterT18ProductScreen()
  //   //           //RegistrationScreen()
  //   //           //HomeScreen()
  //   //             //LoginScreen()
  //   //             //ProductDetailsScreen()
  //   //                 //ContactListScreen()
  //   //                 //DashboardScreen()
  //   //                 //ProductDetailsHeaderScreen()
  //   //                 //PricingPlanScreen()
  //                   // InstagramStyleUiScreen()
  //   //                 //ReusableCardGalleryScreen()
  //   //                 //AboutMe()
  //   //                 //ProfileCard()
  //   //                 //CounterScreen()
  //   //                 //MotivationalQuotes()
  //   //                 //StudentData()
  //              //ShoppingFlowProductListScreen()
  //           // )
  //        );
  //      },
  //    );
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