import 'package:flutter/material.dart';

class AddressWidgetsLocationActions extends StatelessWidget {
  final VoidCallback onCurrentLocation;
  final VoidCallback onAddAddress;

  final bool isLoadingLocation;
  final bool isSavingAddress;
  final bool canAdd;

  const AddressWidgetsLocationActions({
    super.key,
    required this.onCurrentLocation,
    required this.onAddAddress,
    required this.isLoadingLocation,
    required this.isSavingAddress,
    required this.canAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final isDark =
        theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF202025)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ======================================================
          // CURRENT LOCATION
          // ======================================================

          InkWell(
            onTap: isLoadingLocation
                ? null
                : onCurrentLocation,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.my_location_rounded,
                      color: primary,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoadingLocation
                              ? 'Getting current location...'
                              : 'Use current location',
                          style: TextStyle(
                            color: primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Use your device location',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isLoadingLocation)
                    const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.hintColor,
                    ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            thickness: 1,
            color: theme.dividerColor.withOpacity(0.20),
          ),

          // ======================================================
          // ADD ADDRESS
          // ======================================================

          InkWell(
            onTap: (isSavingAddress || !canAdd)
                ? null
                : onAddAddress,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: canAdd
                        ? primary
                        : theme.disabledColor,
                    size: 25,
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          canAdd
                              ? 'Add Address'
                              : 'Maximum 3 addresses reached',
                          style: TextStyle(
                            color: canAdd
                                ? primary
                                : theme.disabledColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        if (!canAdd) ...[
                          const SizedBox(height: 3),
                          Text(
                            'Delete an address before adding another.',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.hintColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}