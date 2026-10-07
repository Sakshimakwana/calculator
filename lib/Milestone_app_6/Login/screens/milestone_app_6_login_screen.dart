import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/widgets/login_email_field.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/widgets/login_password_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/auth_controller/auth_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/widgets/login_header.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/widgets/login_button.dart';
import '../widgets/login_field_label.dart';
import '../widgets/login_signup_link.dart';

class MilestoneApp6LoginScreen extends StatefulWidget {
  const MilestoneApp6LoginScreen({
    super.key,
  });
  @override
  State<MilestoneApp6LoginScreen> createState() =>
      _MilestoneApp6LoginScreenState();
}

class _MilestoneApp6LoginScreenState
    extends State<MilestoneApp6LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    return null;
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authController = context.read<AuthController>();

    setState(() {
      _isLoading = true;
    });

    final success = await authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text);


    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          authController.errorMessage ?? 'login failed. Please try again',
        ),
        behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(14),
      ),
      )
      );
      return;
    }
    context.go('/select-address');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  28,
                  34,
                  28,
                  28,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 35,
                      offset: const Offset(0, 15),
                      color: Colors.black.withOpacity(.06),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 22),
                      const LoginHeader(),

                      const SizedBox(height: 30),


                      const LoginFieldLabel(
                        text: 'Email',
                      ),
                      const SizedBox(height: 8),

                      LoginEmailField(
                        controller: _emailController,
                        validator: _validateEmail,
                      ),

                      const SizedBox(height: 18),

                      const LoginFieldLabel(
                        text: 'Password',
                      ),

                      const SizedBox(height: 8),

                      LoginPasswordField(
                        controller: _passwordController,
                        obscurePassword: _obscurePassword,
                        validator: _validatePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        onSubmitted: _login,
                      ),

                      const SizedBox(height: 26),

                      LoginButton(
                        isLoading: _isLoading,
                        onPressed: _login,
                      ),

                      const SizedBox(height: 22),

                      LoginSignupLink(
                        onCreateAccount: () {
                          context.push('/signup');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}