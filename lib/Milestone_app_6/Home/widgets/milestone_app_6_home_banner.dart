import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/milestone_app_6_colors.dart';
import '../../common_widgets/milestone_app_6_image.dart';

class MilestoneApp6HomeBanner extends StatelessWidget {
  const MilestoneApp6HomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    final bool isTablet = width >= 700;

    final double bannerHeight = isTablet ? 150.0 : 140.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        15,
        10,
        15,
        10,
      ),
      child: SizedBox(
        height: bannerHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ----------------------------------------------------
              // BACKGROUND
              // ----------------------------------------------------

              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      MilestoneApp6Colors.green,
                      Color(0xFFFCE4EC),
                    ],
                  ),
                ),
              ),

              // ----------------------------------------------------
              // IMAGE
              // ----------------------------------------------------

              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: isTablet ? width * .48 : width * .52,
                child: MilestoneApp6Image(
                  url:
                  'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1000',
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                ),
              ),

              // ----------------------------------------------------
              // OVERLAY
              // ----------------------------------------------------

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [
                          0.0,
                          0.38,
                          0.65,
                          1.0,
                        ],
                        colors: [
                          Colors.black.withOpacity(.40),
                          Colors.black.withOpacity(.25),
                          Colors.black.withOpacity(.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ----------------------------------------------------
              // CONTENT
              // ----------------------------------------------------

              Positioned(
                left: 18,
                top: 15,
                bottom: 15,
                child: SizedBox(
                  width: isTablet ? width * .42 : width * .43,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delicious Food\nDelivered to You',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          context.go('/categories');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: MilestoneApp6Colors.cream,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
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