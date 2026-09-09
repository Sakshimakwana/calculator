import 'package:flutter/material.dart';

class ResponsiveDashboardT22ResponsiveLayout extends StatelessWidget {
  const ResponsiveDashboardT22ResponsiveLayout({
    super.key,
    required this.phone,
    required this.tablet,
  });

  final Widget phone;
  final Widget tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return phone;
        }

        return tablet;
      },
    );
  }
}