import 'package:app_matic_tech_flutter_app/Login_page_T14/widgets/login_button.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/widgets/login_header.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/widgets/login_text_field.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/widgets/remember_me_row.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/widgets/special_login_button.dart';
import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_app_colors.dart';
import 'package:app_matic_tech_flutter_app/Login_page_T14/theme/login_typogarphy.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool obscurePassword = true;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.94,
            heightFactor: 0.94,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LoginHeader(),

                      const SizedBox(height: 20),

                      LoginTextField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        nextFocusNode: passwordFocusNode,
                        label: 'Email',
                        hint: 'Enter your email',
                        prefixIcon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      LoginTextField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        label: 'Password',
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock_outline,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 17,
                            color: AppColors.icon,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      RememberMeRow(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      LoginButton(
                        isLoading: isLoading,
                        onPressed: login,
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.lightBorder,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'or continue with',
                              style: AppTypography.small,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.lightBorder,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialLoginButton(
                            icon: const Text(
                              'G',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          const SocialLoginButton(
                            icon: Icon(
                              Icons.apple,
                              size: 27,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 30),
                          const SocialLoginButton(
                            icon: Icon(
                              Icons.facebook,
                              size: 27,
                              color: Color(0xFF1877F2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: AppTypography.small,
                          ),
                          const Text(
                            'Sign Up',
                            style: AppTypography.link,
                          ),
                        ],
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