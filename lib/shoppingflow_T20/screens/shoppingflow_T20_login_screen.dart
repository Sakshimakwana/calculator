import 'package:app_matic_tech_flutter_app/shoppingflow_T20/widgets/shoppingflow_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShoppingFlowT20LoginScreen extends StatefulWidget {
  const ShoppingFlowT20LoginScreen({
    super.key,
  });

  @override
  State<ShoppingFlowT20LoginScreen> createState() =>
      _ShoppingFlowT20LoginScreenState();
}

class _ShoppingFlowT20LoginScreenState
    extends State<ShoppingFlowT20LoginScreen> {

  // --------------------------------------------------
  // Controllers
  // --------------------------------------------------

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  // --------------------------------------------------
  // Focus Nodes
  // --------------------------------------------------

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  // --------------------------------------------------
  // Form Key
  // --------------------------------------------------

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // --------------------------------------------------
  // Password visibility
  // --------------------------------------------------

  bool _obscurePassword = true;

  // --------------------------------------------------
  // Dispose
  // --------------------------------------------------

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // --------------------------------------------------
  // Email validation
  // --------------------------------------------------

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email with @';
    }

    if (!value.contains('.')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // --------------------------------------------------
  // Password validation
  // --------------------------------------------------

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // --------------------------------------------------
  // Login
  // --------------------------------------------------

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs =
    await SharedPreferences.getInstance();

    final bool registered =
        prefs.getBool('user_registered') ?? false;

    // User hasn't signed up
    if (!registered) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please sign up first',
          ),
        ),
      );

      context.go('/signup');

      return;
    }

    final savedEmail =
    prefs.getString('user_email');

    final savedPassword =
    prefs.getString('user_password');

    final enteredEmail =
    _emailController.text.trim();

    final enteredPassword =
        _passwordController.text;

    // Check email
    if (enteredEmail != savedEmail) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email does not match the registered email',
          ),
        ),
      );

      return;
    }

    // Check password
    if (enteredPassword != savedPassword) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incorrect password',
          ),
        ),
      );

      return;
    }

    // Login successful
    if (!mounted) return;

    context.go('/home');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // --------------------------------------------------
                  // Logo
                  // --------------------------------------------------

                  Center(
                    child: Container(
                      width: 70,
                      height: 70,

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 38,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --------------------------------------------------
                  // Title
                  // --------------------------------------------------

                  const Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Center(
                    child: Text(
                      'Login to continue shopping',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // --------------------------------------------------
                  // Email
                  // --------------------------------------------------
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ShoppingFlowTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,

                    hintText: 'Enter your email',

                    prefixIcon: Icons.email_outlined,

                    keyboardType:
                    TextInputType.emailAddress,

                    textInputAction:
                    TextInputAction.next,

                    validator: _validateEmail,

                    onFieldSubmitted: (_) {
                      _passwordFocusNode.requestFocus();
                    },
                  ),

                  const SizedBox(height: 20),

                  // --------------------------------------------------
                  // Password
                  // --------------------------------------------------
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ShoppingFlowTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,


                    hintText: 'Enter your password',

                    prefixIcon:
                    Icons.lock_outline,

                    obscureText:
                    _obscurePassword,

                    suffixIcon: IconButton(
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
                      ),
                    ),

                    keyboardType:
                    TextInputType.visiblePassword,

                    textInputAction:
                    TextInputAction.done,

                    validator: _validatePassword,

                    onFieldSubmitted: (_) {
                      _login();
                    },
                  ),

                  const SizedBox(height: 12),

                  // --------------------------------------------------
                  // Forgot Password
                  // --------------------------------------------------

                  Align(
                    alignment:
                    Alignment.centerRight,

                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                      },

                      child: const Text(
                        'Forgot Password?',
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // --------------------------------------------------
                  // Login Button
                  // --------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 54,

                    child: FilledButton(
                      onPressed: _login,

                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --------------------------------------------------
                  // Signup
                  // --------------------------------------------------

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          context.go('/signup');
                        },

                        child: const Text(
                          'Sign Up',
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
      ),
    );
  }
}