import 'package:flutter/material.dart';

class LoginFieldLabel extends StatelessWidget {
  final String text;

  const LoginFieldLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
