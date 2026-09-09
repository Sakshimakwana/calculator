import 'package:app_matic_tech_flutter_app/shoppingflow_T20/widgets/shoppingflow_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingFlowT20SignupScreen extends StatefulWidget {
  const ShoppingFlowT20SignupScreen({
    super.key,
  });

  @override
  State<ShoppingFlowT20SignupScreen> createState() =>
      _ShoppingFlowT20SignupScreenState();
}

class _ShoppingFlowT20SignupScreenState
    extends State<ShoppingFlowT20SignupScreen> {

  // ==================================================
  // Controllers
  // ==================================================

  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // ==================================================
  // Focus Nodes
  // ==================================================

  final FocusNode _nameFocusNode = FocusNode();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _phoneFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  final FocusNode _confirmPasswordFocusNode =
  FocusNode();

  // ==================================================
  // Form Key
  // ==================================================

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // ==================================================
  // Password Visibility
  // ==================================================

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  // ==================================================
  // Dispose
  // ==================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  // ==================================================
  // Name Validation
  // ==================================================

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    if (value.trim().length != 10) {
      return 'Please add exactly 10 characters';
    }

    return null;
  }

  // ==================================================
  // Email Validation
  // ==================================================

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please add @ in your email';
    }

    if (!value.contains('.')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // ==================================================
  // Phone Validation
  // ==================================================

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }

  // ==================================================
  // Password Validation
  // ==================================================

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // ==================================================
  // Confirm Password Validation
  // ==================================================

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ==================================================
  // SIGN UP
  // ==================================================

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get SharedPreferences
    final prefs =
    await SharedPreferences.getInstance();

    // Save user information
    await prefs.setString(
      'user_name',
      _nameController.text.trim(),
    );

    await prefs.setString(
      'user_email',
      _emailController.text.trim(),
    );

    await prefs.setString(
      'user_phone',
      _phoneController.text.trim(),
    );

    await prefs.setString(
      'user_password',
      _passwordController.text,
    );

    // Mark user as registered
    await prefs.setBool(
      'user_registered',
      true,
    );

    if (!mounted) return;

    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account created successfully',
        ),
      ),
    );

    // Go to Login
    context.go('/login');
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 25,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // ==================================================
                // Back Button
                // ==================================================

                IconButton(
                  onPressed: () {
                    context.go('/login');
                  },

                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // Icon
                // ==================================================

                Center(
                  child: Container(
                    width: 70,
                    height: 70,

                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 36,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // Title
                // ==================================================

                const Center(
                  child: Text(
                    'Create Account',

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Sign up to start shopping',

                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // Name
                // ==================================================

                const Text(
                  'Name',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                ShoppingFlowTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,

                  hintText: 'Enter 10 characters',

                  prefixIcon:
                  Icons.person_outline,

                  maxLength: 10,

                  keyboardType:
                  TextInputType.name,

                  textInputAction:
                  TextInputAction.next,

                  validator:
                  _validateName,

                  onFieldSubmitted: (_) {
                    _emailFocusNode
                        .requestFocus();
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // Email
                // ==================================================

                const Text(
                  'Email',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                ShoppingFlowTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,

                  hintText:
                  'example@gmail.com',

                  prefixIcon:
                  Icons.email_outlined,

                  keyboardType:
                  TextInputType.emailAddress,

                  textInputAction:
                  TextInputAction.next,

                  validator:
                  _validateEmail,

                  onFieldSubmitted: (_) {
                    _phoneFocusNode
                        .requestFocus();
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // Phone
                // ==================================================

                const Text(
                  'Phone',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                ShoppingFlowTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,

                  hintText:
                  'Enter 10 digit number',

                  prefixIcon:
                  Icons.phone_outlined,

                  keyboardType:
                  TextInputType.phone,

                  maxLength: 10,

                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly,
                  ],

                  textInputAction:
                  TextInputAction.next,

                  validator:
                  _validatePhone,

                  onFieldSubmitted: (_) {
                    _passwordFocusNode
                        .requestFocus();
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // Password
                // ==================================================

                const Text(
                  'Password',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                ShoppingFlowTextField(
                  controller:
                  _passwordController,

                  focusNode:
                  _passwordFocusNode,

                  hintText:
                  'Enter password',

                  prefixIcon:
                  Icons.lock_outline,

                  obscureText:
                  _obscurePassword,

                  suffixIcon:
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                        !_obscurePassword;
                      });
                    },

                    icon: Icon(
                      _obscurePassword
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                    ),
                  ),

                  keyboardType:
                  TextInputType
                      .visiblePassword,

                  textInputAction:
                  TextInputAction.next,

                  validator:
                  _validatePassword,

                  onFieldSubmitted: (_) {
                    _confirmPasswordFocusNode
                        .requestFocus();
                  },
                ),

                const SizedBox(height: 20),

                // ==================================================
                // Confirm Password
                // ==================================================

                const Text(
                  'Confirm Password',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                ShoppingFlowTextField(
                  controller:
                  _confirmPasswordController,

                  focusNode:
                  _confirmPasswordFocusNode,

                  hintText:
                  'Re-enter your password',

                  prefixIcon:
                  Icons.lock_reset_outlined,

                  obscureText:
                  _obscureConfirmPassword,

                  suffixIcon:
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                        !_obscureConfirmPassword;
                      });
                    },

                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons
                          .visibility_off_outlined
                          : Icons
                          .visibility_outlined,
                    ),
                  ),

                  keyboardType:
                  TextInputType
                      .visiblePassword,

                  textInputAction:
                  TextInputAction.done,

                  validator:
                  _validateConfirmPassword,

                  onFieldSubmitted: (_) {
                    _signUp();
                  },
                ),

                const SizedBox(height: 30),

                // ==================================================
                // SIGN UP BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: FilledButton(
                    onPressed: _signUp,

                    style:
                    FilledButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Sign Up',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LOGIN
                // ==================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Text(
                      'Already have an account? ',

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },

                      child: const Text(
                        'Login',

                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}