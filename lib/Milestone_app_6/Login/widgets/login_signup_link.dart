import 'package:flutter/material.dart';

class LoginSignupLink extends StatelessWidget {
  final VoidCallback onCreateAccount;

  const LoginSignupLink({
    super.key,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: [
        Text(
          "Don't have an account?",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(.65),
          ),
        ),
        GestureDetector(
          onTap: onCreateAccount,
          child: Text(
            'Create an account',
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