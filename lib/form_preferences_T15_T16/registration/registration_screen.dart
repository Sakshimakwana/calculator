import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/settings/settings_screen.dart';
import 'widgets/registration_header.dart';
import 'widgets/registration_text_field.dart';
import 'widgets/register_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({
    super.key,
    this.onLogin,
  });

  final VoidCallback? onLogin;

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // Full Name Validator
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
      return 'Please enter a valid name';
    }

    return null;
  }

  // Email Validator
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Mobile Validator
  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Mobile number must contain only numbers';
    }

    if (value.trim().length != 10) {
      return 'Please enter a valid 10 digit mobile number';
    }

    return null;
  }

  // Password Validator
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm Password Validator
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Register
  void _register() {
    final isValid = _formKey.currentState!.validate();

    if (!_agreeTerms) {
      setState(() {});
    }

    if (!isValid || !_agreeTerms) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Container(
          width: double.infinity,

          color: Colors.white,

          child: SingleChildScrollView(
            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  RegistrationHeader(
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      36,
                      36,
                      36,
                      200,
                    ),

                    child: Column(
                      children: [
                        RegistrationTextField(
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                          controller: _nameController,
                          validator: _validateName,
                        ),

                        const SizedBox(height: 20),

                        RegistrationTextField(
                          label: 'Email',
                          hint: 'Enter your email',
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          keyboardType:
                          TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),

                        const SizedBox(height: 20),

                        RegistrationTextField(
                          label: 'Mobile Number',
                          hint: 'Enter your mobile number',
                          icon: Icons.phone_outlined,
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          validator: _validateMobile,
                        ),

                        const SizedBox(height: 20),

                        RegistrationTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: _validatePassword,
                          onChanged: (_) {
                            setState(() {});
                          },
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: _obscurePassword
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        RegistrationTextField(
                          label: 'Confirm Password',
                          hint: 'Confirm your password',
                          icon: Icons.lock_outline,
                          controller:
                          _confirmPasswordController,
                          obscureText:
                          _obscureConfirmPassword,
                          validator:
                          _validateConfirmPassword,
                          onChanged: (_) {
                            setState(() {});
                          },
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip:
                            _obscureConfirmPassword
                                ? 'Show password'
                                : 'Hide password',
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
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        FormField<bool>(
                          initialValue: _agreeTerms,
                          validator: (_) {
                            if (!_agreeTerms) {
                              return 'Please agree to the Terms & Conditions';
                            }

                            return null;
                          },
                          builder: (field) {
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Checkbox(
                                        value: _agreeTerms,
                                        activeColor:
                                        AppColors.pink,
                                        materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                        onChanged: (value) {
                                          setState(() {
                                            _agreeTerms =
                                                value ?? false;
                                          });

                                          field.didChange(
                                            _agreeTerms,
                                          );

                                          field.validate();
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 5),

                                    Expanded(
                                      child: RichText(
                                        text: const TextSpan(
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                              'I agree to the ',
                                            ),
                                            TextSpan(
                                              text:
                                              'Terms & Conditions',
                                              style: TextStyle(
                                                color:
                                                AppColors.pink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                if (field.hasError)
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Text(
                                      field.errorText!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        RegisterButton(
                          onPressed: _register,
                        ),

                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),

                            GestureDetector(
                              onTap: widget.onLogin,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.pink,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}