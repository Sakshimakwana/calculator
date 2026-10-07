import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/models/milestone_app_6_address_model.dart';
import 'package:flutter/material.dart';

class AddressWidgetsSavedAddressCard extends StatelessWidget {
  final MilestoneApp6Address address;
  final bool isSelected;
  final bool canDelete;

  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressWidgetsSavedAddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.canDelete,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getAddressIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;

      case 'work':
        return Icons.business_center_rounded;

      case 'office':
        return Icons.business_rounded;

      case 'other':
        return Icons.location_on_rounded;

      default:
        return Icons.location_on_rounded;
    }
  }

  String _displayLabel(String label) {
    if (label.isEmpty) {
      return 'Address';
    }

    return label[0].toUpperCase() +
        label.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark =
        theme.brightness == Brightness.dark;

    return Material(
      color: isDark
          ? const Color(0xFF202025)
          : Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            8,
            16,
          ),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ==================================================
              // ADDRESS ICON
              // ==================================================

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .primary
                      .withOpacity(0.08),
                  borderRadius:
                  BorderRadius.circular(11),
                ),
                child: Icon(
                  _getAddressIcon(address.label),
                  color:
                  theme.colorScheme.primary,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              // ==================================================
              // ADDRESS CONTENT
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _displayLabel(
                              address.label,
                            ),
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),

                        if (isSelected)
                          Container(
                            margin:
                            const EdgeInsets.only(
                              right: 6,
                            ),
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration:
                            BoxDecoration(
                              color: theme
                                  .colorScheme
                                  .primary
                                  .withOpacity(
                                0.10,
                              ),
                              borderRadius:
                              BorderRadius
                                  .circular(6),
                            ),
                            child: Text(
                              'Selected',
                              style: TextStyle(
                                color: theme
                                    .colorScheme
                                    .primary,
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      address.fullAddress,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: theme
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.80),
                      ),
                    ),

                    // ==================================================
                    // COORDINATES
                    // ==================================================

                    if (address.latitude != null &&
                        address.longitude != null) ...[
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .location_on_outlined,
                            size: 14,
                            color:
                            theme.hintColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${address.latitude!.toStringAsFixed(6)}, '
                                  '${address.longitude!.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                theme.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ==================================================
              // THREE DOT MENU
              // ==================================================

              PopupMenuButton<String>(
                tooltip: 'Address options',
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  }

                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),

                    if (canDelete)
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ];
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}