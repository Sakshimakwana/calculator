import 'package:flutter/material.dart';
import 'appointment_colors.dart';

class AppointmentTypography {
  static const title = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w700,
    color: AppointmentColors.text,
  );

  static const subtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppointmentColors.secondaryText,
  );

  static const label = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppointmentColors.text,
  );

  static const fieldText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppointmentColors.text,
  );

  static const button = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppointmentColors.white,
  );
}