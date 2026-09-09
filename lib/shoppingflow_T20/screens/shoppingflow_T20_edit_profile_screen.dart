import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/shoppingflow_T20_state.dart';

class ShoppingFlowT20EditProfileScreen
    extends StatefulWidget {
  const ShoppingFlowT20EditProfileScreen({
    super.key,
  });

  @override
  State<ShoppingFlowT20EditProfileScreen>
  createState() =>
      _ShoppingFlowT20EditProfileScreenState();
}

class _ShoppingFlowT20EditProfileScreenState
    extends State<ShoppingFlowT20EditProfileScreen> {

  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();

    final user =
        shoppingFlowT20State.currentUser;

    nameController =
        TextEditingController(
          text: user?.name ?? '',
        );

    emailController =
        TextEditingController(
          text: user?.email ?? '',
        );

    phoneController =
        TextEditingController(
          text: user?.phone ?? '',
        );

    addressController =
        TextEditingController(
          text: user?.address ?? '',
        );
  }

  void updateProfile() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    shoppingFlowT20State.updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Profile updated successfully',
        ),
      ),
    );

    context.go('/profile');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('Edit Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [

              TextFormField(
                controller:
                nameController,
                decoration:
                const InputDecoration(
                  labelText: 'Name',
                  prefixIcon:
                  Icon(Icons.person_outline),
                  border:
                  OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter your name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                emailController,
                keyboardType:
                TextInputType.emailAddress,
                decoration:
                const InputDecoration(
                  labelText: 'Email',
                  prefixIcon:
                  Icon(Icons.email_outlined),
                  border:
                  OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter email';
                  }

                  if (!value.contains('@')) {
                    return 'Enter valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                phoneController,
                keyboardType:
                TextInputType.phone,
                decoration:
                const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon:
                  Icon(Icons.phone_outlined),
                  border:
                  OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Enter phone';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller:
                addressController,
                maxLines: 3,
                decoration:
                const InputDecoration(
                  labelText: 'Address',
                  prefixIcon:
                  Icon(
                    Icons.location_on_outlined,
                  ),
                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: updateProfile,
                  child: const Text(
                    'Save Changes',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}