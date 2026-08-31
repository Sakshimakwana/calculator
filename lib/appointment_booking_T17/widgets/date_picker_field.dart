import 'package:flutter/material.dart';
import '../theme/appointment_colors.dart';
import '../theme/appointment_typography.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  String formatDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${weekdays[date.weekday - 1]}';
  }

  Future<void> selectDate(BuildContext context) async {
    final today = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: value ?? today,
      firstDate: today,
      lastDate: DateTime(
        today.year + 1,
        today.month,
        today.day,
      ),
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: AppointmentTypography.label,
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: () => selectDate(context),
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
                  Icons.calendar_month_outlined,
                  color: AppointmentColors.icon,
                  size: 19,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value == null
                        ? 'Select Date'
                        : formatDate(value!),
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