import 'package:flutter/material.dart';
import '../theme/appointment_colors.dart';
import '../theme/appointment_typography.dart';

class TimePickerField extends StatelessWidget {
  const TimePickerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;

  Future<void> selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: value ?? const TimeOfDay(hour: 11, minute: 0),
    );

    if (selectedTime != null) {
      onChanged(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: AppointmentTypography.label,
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: () => selectTime(context),
          borderRadius: BorderRadius.circular(11),
          child: Container(
            height: 47,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppointmentColors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: AppointmentColors.border,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  color: AppointmentColors.icon,
                  size: 19,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value == null
                        ? 'Select Time'
                        : value!.format(context),
                    style: AppointmentTypography.fieldText,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}