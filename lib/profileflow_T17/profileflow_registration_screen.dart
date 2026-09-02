import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_account_created_screen.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_country_dropdown.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_date_picker_field.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_gender_selector.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_notification_tile.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_registration_header.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_registration_text_field.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_terms_section.dart';
import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';
import 'package:flutter/services.dart';

class ProfileFlowRegistrationScreen extends StatefulWidget {
  const ProfileFlowRegistrationScreen({super.key});

  @override
  State<ProfileFlowRegistrationScreen> createState() => _ProfileFlowRegistrationScreen();
}

class _ProfileFlowRegistrationScreen extends State<ProfileFlowRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  int _step = 1;

  String? _gender;
  DateTime? _birthDate;
  String? _country;

  bool _notifications = true;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  String? _required(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone is required';
    }

    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Minimum 8 characters required';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Include at least one lowercase letter';
    }

    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Include at least one number';
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _next() {
    FocusScope.of(context).unfocus();

    if (_step == 1) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    if (_step == 2) {
      if (_gender == null ||
          _birthDate == null ||
          _country == null) {
        setState(() {});
        return;
      }
    }

    if (_step == 4) {
      if (!_termsAccepted || !_privacyAccepted) {
        setState(() {});
        return;
      }

      _showSuccess();
      return;
    }

    setState(() {
      _step++;
    });
  }

  void _back() {
    FocusScope.of(context).unfocus();

    if (_step == 1) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _step--;
    });
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: RegistrationColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _showSuccess() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountCreatedScreen(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          gender: _gender!,
          birthDate:_birthDate!,
          country: _country!,
          notifications: _notifications,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RegistrationColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              28,
            ),
            child: Column(
              children: [
                if (_step == 1)
                  _accountHeader()
                else
                  RegistrationHeader(
                    step: _step,
                    onBack: _back,
                  ),
                const SizedBox(height: 26),
                _buildStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _accountHeader() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: _back,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 19,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: RegistrationColors.primaryLight,
              width: 5,
            ),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 43,
            color: RegistrationColors.primary,
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Create Account',
          style: RegistrationTypography.title,
        ),

        const SizedBox(height: 5),

        const Text(
          'Let’s get started with your details',
          style: RegistrationTypography.subtitle,
        ),
      ],
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return _accountStep();

      case 2:
        return _personalStep();

      case 3:
        return _preferenceStep();

      case 4:
        return _termsStep();

      default:
        return const SizedBox();
    }
  }

  Widget _accountStep() {
    return Column(
      children: [
        RegistrationTextField(
          controller: _nameController,
          focusNode: _nameFocus,
          hint: 'Full Name',
          icon: Icons.person_outline_rounded,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name is required';
            }

            return null;
          },
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z ]'),
            ),
            LengthLimitingTextInputFormatter(10),
          ],
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _emailFocus.requestFocus();
          },
        ),

        const SizedBox(height: 10),

        RegistrationTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          hint: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: _emailValidator,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _phoneFocus.requestFocus();
          },
        ),

        const SizedBox(height: 10),

        RegistrationTextField(
          controller: _phoneController,
          focusNode: _phoneFocus,
          hint: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: _phoneValidator,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _passwordFocus.requestFocus();
          },
        ),

        const SizedBox(height: 10),

        RegistrationTextField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          hint: 'Password',
          icon: Icons.lock_outline_rounded,
          obscureText: !_passwordVisible,
          validator: _passwordValidator,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 19,
            ),
          ),
          onFieldSubmitted: (_) {
            _confirmPasswordFocus.requestFocus();
          },
        ),

        const SizedBox(height: 10),

        RegistrationTextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          hint: 'Confirm Password',
          icon: Icons.lock_outline_rounded,
          obscureText: !_confirmPasswordVisible,
          validator: _confirmPasswordValidator,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _confirmPasswordVisible =
                !_confirmPasswordVisible;
              });
            },
            icon: Icon(
              _confirmPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 19,
            ),
          ),
        ),

        const SizedBox(height: 24),

        _primaryButton(
          text: 'Next',
          onPressed: _next,
        ),

        const SizedBox(height: 18),

        const Text(
          'Already have an account? Sign In',
          style: RegistrationTypography.body,
        ),
      ],
    );
  }

  Widget _personalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Personal Details',
                style: RegistrationTypography.title,
              ),
              SizedBox(height: 5),
              Text(
                'Tell us more about yourself',
                style: RegistrationTypography.subtitle,
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Gender',
          style: RegistrationTypography.label,
        ),

        const SizedBox(height: 9),

        GenderSelector(
          value: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),

        if (_gender == null)
          const Padding(
            padding: EdgeInsets.only(
              top: 5,
              left: 4,
            ),
            child: Text(
              'Please select your gender',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: RegistrationColors.error,
              ),
            ),
          ),

        const SizedBox(height: 18),

        const Text(
          'Date of Birth',
          style: RegistrationTypography.label,
        ),

        const SizedBox(height: 9),

        DatePickerField(
          value: _birthDate,
          onTap: _selectBirthDate,
          errorText: _birthDate == null
              ? 'Please select your birth date'
              : null,
        ),

        const SizedBox(height: 18),

        const Text(
          'Country',
          style: RegistrationTypography.label,
        ),

        const SizedBox(height: 9),

        CountryDropdown(
          value: _country,
          onChanged: (value) {
            setState(() {
              _country = value;
            });
          },
        ),

        const SizedBox(height: 24),

        _primaryButton(
          text: 'Next',
          onPressed: _next,
        ),
      ],
    );
  }

  Widget _preferenceStep() {
    return Column(
      children: [
        const Text(
          'Preferences',
          style: RegistrationTypography.title,
        ),

        const SizedBox(height: 5),

        const Text(
          'Choose your preferences',
          style: RegistrationTypography.subtitle,
        ),

        const SizedBox(height: 27),

        NotificationTile(
          value: _notifications,
          onChanged: (value) {
            setState(() {
              _notifications = value;
            });
          },
        ),

        const SizedBox(height: 28),

        _primaryButton(
          text: 'Next',
          onPressed: _next,
        ),

        const SizedBox(height: 10),

        _secondaryButton(
          text: 'Back',
          onPressed: _back,
        ),
      ],
    );
  }

  Widget _termsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Column(
            children: [
              Text(
                'Terms & Conditions',
                style: RegistrationTypography.title,
              ),
              SizedBox(height: 5),
              Text(
                'Please review and accept to continue',
                style: RegistrationTypography.subtitle,
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: RegistrationColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.verified_user_outlined,
            size: 65,
            color: RegistrationColors.primary,
          ),
        ),

        const SizedBox(height: 15),

        TermsSection(
          termsAccepted: _termsAccepted,
          privacyAccepted: _privacyAccepted,
          onTermsChanged: (value) {
            setState(() {
              _termsAccepted = value ?? false;
            });
          },
          onPrivacyChanged: (value) {
            setState(() {
              _privacyAccepted = value ?? false;
            });
          },
        ),

        if (!_termsAccepted || !_privacyAccepted)
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Both agreements are required',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: RegistrationColors.error,
              ),
            ),
          ),

        const SizedBox(height: 18),

        _primaryButton(
          text: 'Create Account',
          onPressed: _next,
        ),

        const SizedBox(height: 10),

        _secondaryButton(
          text: 'Back',
          onPressed: _back,
        ),
      ],
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: RegistrationColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Text(
          text,
          style: RegistrationTypography.button,
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: RegistrationColors.primary,
          side: const BorderSide(
            color: RegistrationColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Text(
          text,
          style: RegistrationTypography.button.copyWith(
            color: RegistrationColors.primary,
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.country,
    required this.notifications,
  });

  final String name;
  final String email;
  final String phone;
  final String gender;
  final DateTime birthDate;
  final String country;
  final bool notifications;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RegistrationColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            22,
            30,
            22,
            28,
          ),
          child: Column(
            children: [
              const SizedBox(height: 35),

              Container(
                width: 105,
                height: 105,
                decoration: const BoxDecoration(
                  color: RegistrationColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Account Created!',
                style: RegistrationTypography.title,
              ),

              const SizedBox(height: 6),

              const Text(
                'Your account has been created successfully.',
                textAlign: TextAlign.center,
                style: RegistrationTypography.subtitle,
              ),

              const SizedBox(height: 28),

              _profileRow(
                Icons.person_outline_rounded,
                'Full Name',
                name,
              ),

              _profileRow(
                Icons.email_outlined,
                'Email',
                email,
              ),

              _profileRow(
                Icons.phone_outlined,
                'Phone',
                phone,
              ),

              _profileRow(
                Icons.person_2_outlined,
                'Gender',
                gender,
              ),

              _profileRow(
                Icons.calendar_today_outlined,
                'Date of Birth',
                _formatDate(birthDate),
              ),

              _profileRow(
                Icons.public_outlined,
                'Country',
                country,
              ),

              _profileRow(
                Icons.notifications_none_rounded,
                'Notifications',
                notifications ? 'Enabled' : 'Disabled',
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    RegistrationColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Go to Dashboard',
                    style: RegistrationTypography.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      decoration: const BoxDecoration(
        color: RegistrationColors.white,
        border: Border(
          bottom: BorderSide(
            color: RegistrationColors.divider,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: RegistrationColors.secondaryText,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              label,
              style: RegistrationTypography.body,
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: RegistrationTypography.field,
            ),
          ),
        ],
      ),
    );
  }
}