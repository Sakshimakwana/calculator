import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/widgets/edit_profile_screen.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';

class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({
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
  State<ProfileSummaryScreen> createState() =>
      _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState
    extends State<ProfileSummaryScreen> {
  late String _name;
  late String _email;
  late String _phone;
  late String _gender;
  late DateTime _birthDate;
  late String _country;
  late bool _notifications;

  @override
  void initState() {
    super.initState();

    _name = widget.name;
    _email = widget.email;
    _phone = widget.phone;
    _gender = widget.gender;
    _birthDate = widget.birthDate;
    _country = widget.country;
    _notifications = widget.notifications;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          name: _name,
          email: _email,
          phone: _phone,
          gender: _gender,
          birthDate: _birthDate,
          country: _country,
          notifications: _notifications,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _name = result['name'];
      _email = result['email'];
      _phone = result['phone'];
      _gender = result['gender'];
      _birthDate = result['birthDate'];
      _country = result['country'];
      _notifications = result['notifications'];
    });
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    18,
                    12,
                    12,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Profile Summary',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: RegistrationColors.text,
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        'Here is your profile overview',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w400,
                          color:
                          RegistrationColors.secondaryText,
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildProfileCard(),

                      const SizedBox(height: 16),

                      _buildEditButton(context),
                    ],
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
      height: 135,
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
        clipBehavior: Clip.none,
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

          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://i.pravatar.cc/300?img=47',
                        fit: BoxFit.cover,
                        loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                            ) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                RegistrationColors.primary,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color:
                            RegistrationColors.primary,
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    right: -1,
                    bottom: 1,
                    child: GestureDetector(
                      onTap: _openEditProfile,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: RegistrationColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: -50,
            child: Container(
              height: 70,
              decoration: const BoxDecoration(
                color: RegistrationColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: RegistrationColors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: RegistrationColors.border,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          _profileRow(
            icon: Icons.person_outline_rounded,
            title: 'Full Name',
            value: _name,
          ),

          _divider(),

          _profileRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: _email,
          ),

          _divider(),

          _profileRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: _phone,
          ),

          _divider(),

          _profileRow(
            icon: Icons.person_2_outlined,
            title: 'Gender',
            value: _gender,
          ),

          _divider(),

          _profileRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date of Birth',
            value: _formatDate(_birthDate),
          ),

          _divider(),

          _profileRow(
            icon: Icons.public_outlined,
            title: 'Country',
            value: _country,
          ),

          _divider(),

          _profileRow(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            value: _notifications
                ? 'Enabled'
                : 'Disabled',
          ),
        ],
      ),
    );
  }

  Widget _profileRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return SizedBox(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: RegistrationColors.secondaryText,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: RegistrationColors.text,
                ),
              ),
            ),

            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color:
                  RegistrationColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: RegistrationColors.divider,
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: _openEditProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: RegistrationColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}