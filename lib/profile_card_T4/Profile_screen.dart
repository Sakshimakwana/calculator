import 'package:app_matic_tech_flutter_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'button_profile_colors.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ButtonProfileColors.screenBackground,
      appBar: AppBar(
        backgroundColor: ButtonProfileColors.screenBackground,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ButtonProfileColors.darkNavy,
            size: 22,
          ),
        ),

        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: ButtonProfileColors.darkNavy,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: ButtonProfileColors.darkNavy,
              size: 28,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),

        child: Column(
          children: [
            // Profile Card
            Expanded(
              flex: 7,
              child: _profileCard(),
            ),

            const SizedBox(height: 10),
            Expanded(
              flex: 3,
              child: _imagePreview(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: ButtonProfileColors.cardBackground,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: ButtonProfileColors.borderColor,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,

            children: [
              Padding(
                padding: const EdgeInsets.all(10),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),

                  child: Image.network(
                    'https://images.unsplash.com/photo-1500534623283-312aade485b7',
                    width: double.infinity,
                    height: 180,

                    fit: BoxFit.cover,
                    loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                        ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        width: double.infinity,
                        height: 180,

                        color: ButtonProfileColors.placeholderBackground,

                        child: const Center(
                          child: CircularProgressIndicator(
                            color:
                            ButtonProfileColors.primaryIndigo,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                        ) {
                      return _imageErrorPlaceholder(
                        height: 180,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      'assets/images/profile.jpg',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 54),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        'Alex Morgan',

                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color:
                          ButtonProfileColors.darkNavy,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Container(
                        width: 21,
                        height: 21,

                        decoration: const BoxDecoration(
                          color:
                          ButtonProfileColors.verificationBlue,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    'Flutter Developer & UI Enthusiast',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color:
                      ButtonProfileColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: const [
                      Icon(
                        Icons.location_on_outlined,
                        color:
                        ButtonProfileColors.primaryIndigo,
                        size: 20,
                      ),

                      SizedBox(width: 4),

                      Text(
                        'San Francisco, CA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color:
                          ButtonProfileColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Building thoughtful mobile experiences.',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ButtonProfileColors.darkNavy,
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      _socialIcon(
                        icon: FontAwesomeIcons.instagram,
                      ),

                      const SizedBox(width: 28),

                      _socialIcon(
                        icon: FontAwesomeIcons.linkedinIn,
                      ),

                      const SizedBox(width: 28),

                      _socialIcon(
                        icon: FontAwesomeIcons.github,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _followButton(),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: _messageButton(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _socialIcon({
    required FaIconData icon,
  }) {
    return Container(
      width: 50,
      height: 50,

      decoration: const BoxDecoration(
        color: ButtonProfileColors.lightLavender,
        shape: BoxShape.circle,
      ),

      child: Center(
        child: FaIcon(
          icon,
          color: ButtonProfileColors.primaryIndigo,
          size: 24,
        ),
      ),
    );
  }

  Widget _followButton() {
    return SizedBox(
      height: 48,

      child: ElevatedButton.icon(
        onPressed: () {},

        icon: const Icon(
          Icons.person_add_alt_1,
          size: 22,
        ),

        label: const Text(
          'Follow',

          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor:
          ButtonProfileColors.primaryIndigo,

          foregroundColor: Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _messageButton() {
    return SizedBox(
      height: 48,

      child: OutlinedButton.icon(
        onPressed: () {},

        icon: const Icon(
          Icons.chat_outlined,
          size: 22,
        ),

        label: const Text(
          'Message',

          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          foregroundColor:
          ButtonProfileColors.primaryIndigo,

          side: const BorderSide(
            color: ButtonProfileColors.primaryIndigo,
            width: 1.5,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
  Widget _imagePreview() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: ButtonProfileColors.cardBackground,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: ButtonProfileColors.borderColor,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Image Preview',

            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ButtonProfileColors.darkNavy,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),

              child: Image.network(
                'https://invalid-image-url-example.com/image.jpg',

                width: double.infinity,

                fit: BoxFit.cover,

                errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                    ) {
                  return _imageErrorPlaceholder(
                    height: double.infinity,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _imageErrorPlaceholder({
    required double height,
  }) {
    return Container(
      width: double.infinity,
      height: height,

      decoration: BoxDecoration(
        color:
        ButtonProfileColors.placeholderBackground,

        border: Border.all(
          color: ButtonProfileColors.borderColor,
          width: 1.5,
        ),

        borderRadius: BorderRadius.circular(8),
      ),

      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.image_not_supported_outlined,

            color:
            ButtonProfileColors.placeholderIconText,

            size: 48,
          ),

          SizedBox(height: 8),

          Text(
            'Image unavailable',

            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color:
              ButtonProfileColors.placeholderIconText,
            ),
          ),
        ],
      ),
    );
  }
}