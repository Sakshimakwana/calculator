import 'package:flutter/material.dart';

class SignupLoginLink extends StatelessWidget {
  final VoidCallback onLogin;

  const SignupLoginLink({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(.65),
          ),
        ),
        GestureDetector(
          onTap: onLogin,
          child: Text(
            'Sign in',
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}