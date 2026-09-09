import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/typography_profile_T4_1/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Apptypography.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'image_placeholder.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    const double appBarHeight = 250;
    return Scaffold(
      backgroundColor: AppColors.background,

      extendBodyBehindAppBar: true,

      appBar: AppBar(
        toolbarHeight: appBarHeight,
        backgroundColor: Colors.transparent,
        flexibleSpace: Stack(
          children: [
            Image.asset(
              'assets/images/background_image.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
              errorBuilder: (context, error, stackTrace) {
                return ImagePlaceholder.background();
              },
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withValues(alpha: 0.20),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withValues(alpha: 0.20),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: const Offset(0, 28),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.40),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=500&q=80',
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return  ImagePlaceholder.profile();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 275),
        child: Column(
          children: [
            SizedBox(height: 40,),
            const Text(
              'Olivia Carter',
              style: Apptypography.HeadName,
            ),

            const SizedBox(height: 2),

            const Text(
              'Senior Flutter Developer',
              style: Apptypography.designation,
            ),

            const SizedBox(height: 3),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.body,
                ),
                SizedBox(width: 4),
                Text(
                  'Ahmedabad, India',
                  style: Apptypography.body,
                ),
              ],
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10)
                        )
                      ),
                      child: const Text(
                        'Follow',
                        style: Apptypography.button,
                      ),
                    ),
                  ),),

                  const SizedBox(width: 10),

                  Expanded(
                    child: SizedBox(
                      height: 46,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        LucideIcons.messageSquareMore ,
                        size: 18,
                      ),
                      label: const Text(
                        'Message',
                        style: Apptypography.button,
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 45),
                        side: const BorderSide(
                          color: AppColors.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),),),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Me',
                    style: Apptypography.heading,
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Flutter developer passionate about building clean, scalable, and user-friendly mobile applications for Android and iOS.',
                    style: Apptypography.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Skills',
                    style: Apptypography.heading,
                  ),

                  const SizedBox(height: 7),
                  Row(
                    children: [
                      _skill('Flutter'),
                      _skill('Dart'),
                      _skill('Firebase'),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      _skill('REST APIs'),
                      _skill('Git'),
                      _skill('UI/UX'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25,width:25 ,),

            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.linkedin,
                    color: Colors.blue,
                    size: 35,
                  ),
                  FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.black,
                    size: 35,
                  ),
                  FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Colors.pink,
                    size: 35,
                  ),
                  FaIcon(
                    FontAwesomeIcons.globe,
                    color: AppColors.primary,
                    size: 35,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 7),

          ],
        ),
      ),
    );
  }

  Widget _skill(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.skillBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Apptypography.skill,
        ),
      ),
    );
  }
}