import 'package:app_matic_tech_flutter_app/modern_store_home_T24/theme/modern_store_home_colors.dart';
import 'package:app_matic_tech_flutter_app/modern_store_home_T24/theme/modern_store_home_typography.dart';
import 'package:flutter/material.dart';

import 'modern_store_home_routes.dart';

class ModernStoreHomeApp extends StatelessWidget {
  const ModernStoreHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ShopEase',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'ModernStoreInter',
        scaffoldBackgroundColor:
        ModernStoreHomeColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ModernStoreHomeColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: ModernStoreHomeTypography.textTheme,
      ),

      routerConfig: ModernStoreHomeRoutes.router,
    );
  }
}