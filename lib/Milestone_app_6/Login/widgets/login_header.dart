import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        Center(
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              color: primary,
              size: 30,
            ),
          ),
        ),

        const SizedBox(height: 22),

        Text(
          'Welcome back',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -.6,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Log in to continue ordering delicious food.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(.65),
          ),
        ),
      ],
    );
  }
}