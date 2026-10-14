import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../Address/models/milestone_app_6_address_model.dart';

class MilestoneApp6HomeAppBar extends StatefulWidget {
  final String fullname;
  final MilestoneApp6Address? selectedAddress;
  final bool isLoadingAddress;
  final VoidCallback onAddressTap;

  const MilestoneApp6HomeAppBar({
    super.key,
    required this.fullname,
    required this.selectedAddress,
    required this.isLoadingAddress,
    required this.onAddressTap,
  });

  @override
  State<MilestoneApp6HomeAppBar> createState() =>
      _MilestoneApp6HomeAppBarState();
}

class _MilestoneApp6HomeAppBarState extends State<MilestoneApp6HomeAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -4,
      end: 4,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    final addressLabel = widget.selectedAddress == null
        ? 'Add delivery address'
        : widget.selectedAddress!.label.trim().isEmpty
            ? 'Delivery address'
            : widget.selectedAddress!.label.trim();

    final addressText = widget.selectedAddress == null
        ? 'Choose your delivery location'
        : widget.selectedAddress!.fullAddress.trim();

    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      primary: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 0,
      expandedHeight: 104,
      collapsedHeight: 0,
      title: null,
      actions: const [],
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
// LEFT: DELIVERY ADDRESS
                Expanded(
                  flex: 7,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onAddressTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 2,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(
                                Icons.location_on_rounded,
                                color: primaryColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: widget.isLoadingAddress
                                  ? _buildAddressShimmer(isDark)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                addressLabel,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme
                                                    .textTheme.titleSmall
                                                    ?.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 17,
                                              color: primaryColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          addressText.isEmpty
                                              ? 'Tap to select address'
                                              : addressText,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontSize: 10.5,
                                            height: 1.25,
                                            color: theme.hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

// RIGHT: ANIMATED FOOD / LOCATION ILLUSTRATION
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 90,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              // Animated pink zigzag lines
                              Positioned.fill(
                                child:CustomPaint(
                                  painter: _PinkZigzagPainter(
                                    progress: _animationController.value,
                                    primaryColor: primaryColor,
                                  ),
                                ),
                              ),

                              // Floating profile avatar
                              Positioned(
                                right: 10,
                                top: 12 + _floatAnimation.value * 0.4,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFD2B48C).withOpacity(0.16),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: primaryColor.withOpacity(0.10),
                                    child: Icon(
                                      Icons.delivery_dining_rounded,
                                      size: 23,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  Widget _buildAddressShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.white12 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.white24 : Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 85,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 7),
          Container(
            width: 120,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

}

class _PinkZigzagPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;

  const _PinkZigzagPainter({
    required this.progress,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final dx = progress * 7;

    path.moveTo(size.width * 0.12 + dx, -5);
    path.lineTo(size.width * 0.38 + dx, size.height * 0.85);
    path.lineTo(size.width * 0.56 + dx, size.height * 0.30);
    path.lineTo(size.width * 0.72 + dx, size.height * 0.90);
    path.lineTo(size.width * 0.84 + dx, size.height * 0.22);
    path.lineTo(size.width * 1.12 + dx, size.height * 0.78);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinkZigzagPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor;
  }
}

