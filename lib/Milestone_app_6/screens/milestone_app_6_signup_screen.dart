import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app_matic_tech_flutter_app/controllers/auth_controller.dart';

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

  // ============================================================
  // FULL NAME
  // ============================================================

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

  // ============================================================
  // EMAIL
  // ============================================================

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

  // ============================================================
  // PHONE
  // ============================================================

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

  // ============================================================
  // PASSWORD
  // ============================================================

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

  // ============================================================
  // CONFIRM PASSWORD
  // ============================================================

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

  // ============================================================
  // CREATE ACCOUNT
  // ============================================================

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
      ),
      );
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            28,
            30,
            28,
            22,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Account Created!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                authContoller.registerResponse?.message ??
                'Your account has been created successfully.\nPlease sign in to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(.65),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Continue to Sign In',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

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
                      // ==================================================
                      // HEADER
                      // ==================================================

                      Text(
                        'Create your account',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.7,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        'Sign up to start ordering delicious food.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(.65),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ==================================================
                      // FULL NAME
                      // ==================================================

                      const _FieldLabel(
                        text: 'Full name',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _nameController,
                        textCapitalization:
                        TextCapitalization.words,
                        textInputAction:
                        TextInputAction.next,
                        validator: _validateName,
                        decoration: _inputDecoration(
                          context,
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),

                      const SizedBox(height: 17),

                      // ==================================================
                      // EMAIL
                      // ==================================================

                      const _FieldLabel(
                        text: 'Email',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailController,
                        keyboardType:
                        TextInputType.emailAddress,
                        textInputAction:
                        TextInputAction.next,
                        validator: _validateEmail,
                        decoration: _inputDecoration(
                          context,
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                        ),
                      ),

                      const SizedBox(height: 17),

                      // ==================================================
                      // PHONE
                      // ==================================================

                      const _FieldLabel(
                        text: 'Phone number',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction:
                        TextInputAction.next,
                        maxLength: 10,
                        validator: _validatePhone,
                        decoration: _inputDecoration(
                          context,
                          hint: 'Enter your phone number',
                          icon: Icons.phone_outlined,
                        ).copyWith(
                          counterText: '',
                        ),
                      ),

                      const SizedBox(height: 17),

                      // ==================================================
                      // PASSWORD
                      // ==================================================

                      const _FieldLabel(
                        text: 'Password',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction:
                        TextInputAction.next,
                        validator: _validatePassword,
                        decoration: _inputDecoration(
                          context,
                          hint: 'Enter password',
                          icon: Icons.lock_outline_rounded,
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
                                  : Icons
                                  .visibility_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 17),

                      // ==================================================
                      // CONFIRM PASSWORD
                      // ==================================================

                      const _FieldLabel(
                        text: 'Confirm password',
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller:
                        _confirmPasswordController,
                        obscureText:
                        _obscureConfirmPassword,
                        textInputAction:
                        TextInputAction.done,
                        validator:
                        _validateConfirmPassword,
                        onFieldSubmitted: (_) =>
                            _createAccount(),
                        decoration: _inputDecoration(
                          context,
                          hint: 'Confirm your password',
                          icon: Icons.lock_reset_outlined,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                !_obscureConfirmPassword;
                              });
                            },
                            //abcsd
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons
                                  .visibility_outlined,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // ==================================================
                      // CREATE ACCOUNT
                      // ==================================================

                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed:
                          _isLoading
                              ? null
                              : _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor:
                            primary.withOpacity(.25),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 21),

                      // ==================================================
                      // LOGIN
                      // ==================================================

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(
                              color: theme
                                  .textTheme.bodyMedium?.color
                                  ?.withOpacity(.65),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/login');
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      BuildContext context, {
        required String hint,
        required IconData icon,
        Widget? suffixIcon,
      }) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        size: 21,
        color: theme.colorScheme.primary
            .withOpacity(.70),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest
          .withOpacity(.45),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: theme.dividerColor.withOpacity(.35),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: theme.dividerColor.withOpacity(.35),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({
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