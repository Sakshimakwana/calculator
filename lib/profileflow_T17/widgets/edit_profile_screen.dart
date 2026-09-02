import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/profileflow_registration_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/profileflow_colors.dart';
import '../theme/profileflow_typography.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
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

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late String _gender;
  late DateTime _birthDate;
  late String _country;
  late bool _notifications;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.name,
    );

    _emailController = TextEditingController(
      text: widget.email,
    );

    _phoneController = TextEditingController(
      text: widget.phone,
    );

    _gender = widget.gender;
    _birthDate = widget.birthDate;
    _country = widget.country;
    _notifications = widget.notifications;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
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
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }

    return null;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _selectBirthDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _birthDate = selectedDate;
      });
    }
  }

  Future<void> _selectCountry() async {
    final countries = [
      'India',
      'United States',
      'United Kingdom',
      'Canada',
      'Australia',
    ];

    final selectedCountry = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: RegistrationColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: countries.map((country) {
              return ListTile(
                title: Text(
                  country,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: RegistrationColors.text,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, country);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedCountry != null) {
      setState(() {
        _country = selectedCountry;
      });
    }
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'gender': _gender,
        'birthDate': _birthDate,
        'country': _country,
        'notifications': _notifications,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RegistrationColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: RegistrationColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      18,
                      12,
                      15,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: RegistrationColors.text,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Center(
                          child: Text(
                            'Update your profile information',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 9,
                              color:
                              RegistrationColors.secondaryText,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RegistrationColors.text,
                          ),
                        ),

                        const SizedBox(height: 6),

                        RegistrationTextField(
                          controller: _nameController,
                          focusNode: FocusNode(),
                          hint: 'Full Name',
                          icon: Icons.person_outline_rounded,
                          validator: _nameValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]'),
                            ),
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RegistrationColors.text,
                          ),
                        ),

                        const SizedBox(height: 6),

                        RegistrationTextField(
                          controller: _emailController,
                          focusNode: FocusNode(),
                          hint: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType:
                          TextInputType.emailAddress,
                          validator: _emailValidator,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RegistrationColors.text,
                          ),
                        ),

                        const SizedBox(height: 6),

                        RegistrationTextField(
                          controller: _phoneController,
                          focusNode: FocusNode(),
                          hint: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: _phoneValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Gender',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RegistrationColors.text,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _buildGenderSelector(),

                        const SizedBox(height: 16),

                        const Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RegistrationColors.text,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _buildDateField(),

                        const SizedBox(height: 16),

                        const Text(
                          'Country',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: RegistrationColors.text,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _buildCountryField(),

                        const SizedBox(height: 16),

                        _buildNotificationTile(),

                        const SizedBox(height: 20),

                        _buildSaveButton(),

                        const SizedBox(height: 10),

                        _buildCancelButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 105,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF805CFA),
            Color(0xFF693CE8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 12,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),

          const Center(
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        _genderItem('Male'),
        const SizedBox(width: 8),
        _genderItem('Female'),
        const SizedBox(width: 8),
        _genderItem('Other'),
      ],
    );
  }

  Widget _genderItem(String value) {
    final isSelected = _gender == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _gender = value;
          });
        },
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFF2EEFF)
                : RegistrationColors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isSelected
                  ? RegistrationColors.primary
                  : RegistrationColors.border,
              width: isSelected ? 1.3 : 0.8,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: RegistrationColors.text,
                  ),
                ),
              ),

              if (isSelected)
                const Positioned(
                  right: 5,
                  top: 5,
                  child: Icon(
                    Icons.check_circle,
                    size: 15,
                    color: RegistrationColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectBirthDate,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: RegistrationColors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color:RegistrationColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(_birthDate),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: RegistrationColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 17,
              color: RegistrationColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    return GestureDetector(
      onTap: _selectCountry,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: RegistrationColors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: RegistrationColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _country,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: RegistrationColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color:RegistrationColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: RegistrationColors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: RegistrationColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 20,
            color: RegistrationColors.primary,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: RegistrationColors.text,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Receive updates about new features and offers',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 8,
                    color:
                    RegistrationColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: _notifications,
            activeThumbColor: RegistrationColors.primary,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: RegistrationColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: RegistrationColors.primary,
          side: const BorderSide(
            color: RegistrationColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          'Cancel',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}