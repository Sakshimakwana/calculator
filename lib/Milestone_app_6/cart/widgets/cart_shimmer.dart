import 'package:flutter/material.dart';

class MilestoneApp6CartShimmer extends StatelessWidget {
  const MilestoneApp6CartShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.dividerColor.withOpacity(.20),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 88,
                height: 88,
                margin: const EdgeInsets.only(left: 11),
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 14,
                        decoration: BoxDecoration(
                          color:
                          theme.dividerColor.withOpacity(.15),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                          theme.dividerColor.withOpacity(.15),
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 110,
                        height: 28,
                        decoration: BoxDecoration(
                          color:
                          theme.dividerColor.withOpacity(.15),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}