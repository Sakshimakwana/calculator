import 'package:app_matic_tech_flutter_app/Milestone_app_6/Login/widgets/login_field_label.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Register/widgets/signup_button.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Register/widgets/signup_header.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Register/widgets/signup_login_link.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Register/widgets/signup_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../Login/data/auth_controller/auth_controller.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/register/widgets/signup_success_dialog.dart';

class MilestoneApp6SignupScreen extends StatefulWidget {
  const MilestoneApp6SignupScreen({
    super.key,
  });

  @override
  State<MilestoneApp6SignupScreen> createState() =>
      _MilestoneApp6SignupScreenState();
}

class _MilestoneApp6SignupScreenState
    extends State<MilestoneApp6SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;



  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your full name';
    }

    if (name.length < 2) {
      return 'Enter a valid name';
    }

    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(name)) {
      return 'Name can contain letters only';
    }

    return null;
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

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter a password';
    }

    if (password.length < 8) {
      return 'Use at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Add at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Add at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Add at least one number';
    }

    if (!RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-\\/\[\];'`~+=]''')
        .hasMatch(password)) {
      return 'Add at least one special character';
    }

    return null;
  }
  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    final authContoller = context.read<AuthController>();

    setState(() {
      _isLoading = true;
    });

    final success = await authContoller.register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
    );


    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if(!success){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(authContoller.errorMessage ??'Registration failed. Please try again',
          ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return SignupSuccessDialog(
          message: authContoller.registerResponse?.message ??
              'Your account has been created successfully.\n'
                  'Please login to continue.',
          onContinue: () {
            Navigator.pop(dialogContext);
          },
        );
      },
    );

    if (!mounted) return;

    context.go('/login');
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
              vertical: 28,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  28,
                  32,
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

                      const SignupHeader(),
                      const SizedBox(height: 10),
                      const LoginFieldLabel(
                        text: 'Full name',
                      ),

                      const SizedBox(height: 8),

                      SignupTextField(
                        controller: _nameController,
                        hint: 'Enter your full name',
                        icon: Icons.person_outline_rounded,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                      ),

                      const SizedBox(height: 17),

                      const LoginFieldLabel(
                        text: 'Email',
                      ),

                      const SizedBox(height: 8),

                      SignupTextField(
                        controller: _emailController,
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),

                      const SizedBox(height: 17),

                      const LoginFieldLabel(
                        text: 'Phone number',
                      ),

                      const SizedBox(height: 8),

                      SignupTextField(
                        controller: _phoneController,
                        hint: 'Enter your phone number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        maxLength: 10,
                        validator: _validatePhone,
                      ),

                      const SizedBox(height: 17),

                      const LoginFieldLabel(
                        text: 'Password',
                      ),

                      const SizedBox(height: 8),

                      SignupTextField(
                        controller: _passwordController,
                        hint: 'Enter password',
                        icon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.next,
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 17),

                       const LoginFieldLabel(
                        text: 'Confirm password',
                      ),

                      const SizedBox(height: 8),

                      SignupTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm your password',
                        icon: Icons.lock_reset_outlined,
                        textInputAction: TextInputAction.done,
                        obscureText: _obscureConfirmPassword,
                        validator: _validateConfirmPassword,
                        onSubmitted: _createAccount,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      SignupButton(
                        isLoading: _isLoading,
                        onPressed: _createAccount,
                      ),

                      const SizedBox(height: 21),

                      SignupLoginLink(
                        onLogin: () {
                          context.go('/login');
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