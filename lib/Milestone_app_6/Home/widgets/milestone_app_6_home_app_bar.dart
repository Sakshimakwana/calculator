import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../Address/models/milestone_app_6_address_model.dart';

class MilestoneApp6HomeAppBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final Color primaryColor =
        Theme.of(context).colorScheme.primary;

    return SliverAppBar(
      pinned: false,
      floating: false,
      snap: false,
      expandedHeight: 100,
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,

      title: const Text(
        'Foodie',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 12,
          ),
          child: GestureDetector(
            onTap: onAddressTap,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 180,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 17,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child:isLoadingAddress
                        ? Shimmer.fromColors(
                      baseColor: primaryColor.withOpacity(0.15),
                      highlightColor: primaryColor.withOpacity(0.40),
                      period: const Duration(milliseconds: 1200),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 55,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 95,
                            height: 7,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    )
                        : selectedAddress == null
                        ? Text(
                      'Add address',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w700,
                        color: primaryColor,
                      ),
                    )
                        : Column(
                      mainAxisSize:
                      MainAxisSize.min,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedAddress!
                              .label
                              .trim()
                              .isEmpty
                              ? 'Address'
                              : selectedAddress!
                              .label
                              .trim(),
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selectedAddress!
                              .fullAddress
                              .trim(),
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w500,
                            color: primaryColor
                                .withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],

      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              0,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                Text(
                  'Hi, $fullname',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'What would you like to eat today?',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}