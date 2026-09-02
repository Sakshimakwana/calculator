import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_colors.dart';
import 'package:app_matic_tech_flutter_app/profileflow_T17/theme/profileflow_typography.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String> onChanged;

  static const genders = [
    'Male',
    'Female',
    'Other',
  ];

  IconData _icon(String gender) {
    switch (gender) {
      case 'Male':
        return Icons.person_outline_rounded;

      case 'Female':
        return Icons.person_2_outlined;

      default:
        return Icons.person_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: genders.map(
            (gender) {
          final selected = value == gender;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                onChanged(gender);
              },
              child: Container(
                height: 92,
                margin: EdgeInsets.only(
                  right: gender == genders.last ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: RegistrationColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? RegistrationColors.primary
                        : RegistrationColors.border,
                    width: selected ? 1.4 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: selected
                                ? RegistrationColors.primaryLight
                                : const Color(0xFFF2F1F5),
                            child: Icon(
                              _icon(gender),
                              color: selected
                                  ? RegistrationColors.primary
                                  : RegistrationColors.secondaryText,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            gender,
                            style: RegistrationTypography.field,
                          ),
                        ],
                      ),
                    ),

                    if (selected)
                      const Positioned(
                        right: 4,
                        top: 4,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor:
                          RegistrationColors.primary,
                          child: Icon(
                            Icons.check,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}