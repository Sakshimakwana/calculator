import 'package:app_matic_tech_flutter_app/controllers/cart_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/repositories/cart_repository.dart';
import 'package:app_matic_tech_flutter_app/repositories/delivery_repository_impl.dart';
import 'package:app_matic_tech_flutter_app/repositories/order_repository.dart';
import 'package:app_matic_tech_flutter_app/repositories/review_repository.dart';
import 'package:flutter/material.dart';
import 'Milestone_app_6/routes/milestone_app_6_routes.dart';
import 'Milestone_app_6/state/milestone_app_6_state.dart';
import 'Milestone_app_6/theme/milestone_app_6_theme.dart';
import 'package:provider/provider.dart';
import 'controllers/delivery_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/review_controller.dart';
import 'core/network/api_service.dart';
import 'core/network/dio_client.dart';
import 'Milestone_app_6/Login/auth_storage/auth_storage.dart';
import 'Milestone_app_6/Login/data/auth_repo/auth_repository.dart';
import 'Milestone_app_6/Login/data/auth_controller/auth_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStorage.init();
  await AddressStorage.init();

  final state =
  MilestoneApp6State();

  await state.load();

  final routes =
  MilestoneApp6Routes(state);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(
            AuthRepository(
              ApiService(DioClient.dio),
            ),
          ),
        ),

        ChangeNotifierProvider<CartController>(
          create: (_) => CartController(
            CartRepository(
              ApiService(DioClient.dio),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderController(
            OrderRepository(
              ApiService(DioClient.dio),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewController(
            ReviewRepository(
              ApiService(
                DioClient.dio,
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              DeliveryController(
                repository:
                DeliveryRepositoryImpl(),
              ),
        ),
      ],
      child: MilestoneApp6App(
        state: state,
        routes: routes,
      ),
    ),
  );
}

class MilestoneApp6App
    extends StatelessWidget {
  final MilestoneApp6State state;
  final MilestoneApp6Routes routes;

  const MilestoneApp6App({
    super.key,
    required this.state,
    required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,

      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,

          title: 'Foodie',

          theme:
          MilestoneApp6Theme.light,

          darkTheme:
          MilestoneApp6Theme.dark,

          themeMode:
          state.themeMode,

          routerConfig:
          routes.router,
        );
      },
    );
  }
}

//
// import 'package:app_matic_tech_flutter_app/modern_store_home_T24/modern_store_home_app.dart';
// import 'package:app_matic_tech_flutter_app/modern_store_home_T24/modern_store_home_routes.dart';
// import 'package:app_matic_tech_flutter_app/shoppingflow_T20/routes/shoppingflow_T20_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'Responsive_Dashboard_T22_T23/Services_T23/Theme_T23_theme_service.dart';
// import 'Responsive_Dashboard_T22_T23/routes/responsive_dashboard_T22_routes.dart';
// import 'Responsive_Dashboard_T22_T23/theme_T23/Theme_T23_app_theme.dart';
// import 'animations_shopping_T25/animations_shopping_routes.dart';
// import 'form_preferences_T15_T16/settings/localization/app_localizations.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Load saved theme
//   final bool savedDarkMode =
//   await ThemeService.loadTheme();
//
//   runApp(
//     MyApp(
//       initialDarkMode: savedDarkMode,
//     ),
//   );
// }
//
// class MyApp extends StatefulWidget {
//   final bool initialDarkMode;
//
//   const MyApp({
//     super.key,
//     required this.initialDarkMode,
//   });
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late bool isDarkMode;
//
//   @override
//   void initState() {
//     super.initState();
//
//     isDarkMode = widget.initialDarkMode;
//   }
//
//   // ============================================================
//   // THEME CHANGE LOGIC
//   // ============================================================
//
//   Future<void> changeTheme(bool value) async {
//     setState(() {
//       isDarkMode = value;
//     });
//
//     await ThemeService.saveTheme(value);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//
//       // ========================================================
//       // LIGHT THEME
//       // ========================================================
//
//       theme: AppTheme.lightTheme,
//
//       // ========================================================
//       // DARK THEME
//       // ========================================================
//
//       darkTheme: AppTheme.darkTheme,
//
//       // ========================================================
//       // CURRENT THEME
//       // ========================================================
//
//       themeMode: isDarkMode
//           ? ThemeMode.dark
//           : ThemeMode.light,
//
//       // ========================================================
//       // ROUTER
//       // ========================================================
//
//
//        // routerConfig: shoppingFlowT20Router,
//       //routerConfig: animationsShoppingRouter,
//      // routerConfig: ModernStoreHomeRoutes.router,
//       routerConfig: responsiveDashboardT22Router(
//         isDarkMode: isDarkMode,
//         onThemeChanged: changeTheme,
//       ),
//
//
//       // ========================================================
//       // LOCALIZATION
//       // ========================================================
//
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//
//       supportedLocales: const [
//         Locale('en'),
//       ],
//     );
//   }
// }