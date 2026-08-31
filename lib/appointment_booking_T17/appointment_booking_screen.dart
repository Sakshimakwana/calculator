import 'package:flutter/material.dart';

import 'theme/appointment_colors.dart';
import 'widgets/appointment_header.dart';
import 'widgets/service_dropdown.dart';
import 'widgets/employee_dropdown.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/time_picker_field.dart';
import 'widgets/book_appointment_button.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState
    extends State<AppointmentBookingScreen> {
  String? selectedService;
  String? selectedEmployee;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void bookAppointment() {
    if (selectedService == null ||
        selectedEmployee == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select all appointment details'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment booked successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppointmentColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 15),
          child: Column(
            children: [
              AppointmentHeader(
                onBack: () => Navigator.pop(context),
              ),

              const SizedBox(height: 18),

              // Add your appointment illustration here.
              SizedBox(
                height: 130,
                child: Image.asset(
                  'assets/images/appointment.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  40,
                  14,
                  70,
                ),
                decoration: BoxDecoration(
                  color: AppointmentColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ServiceDropdown(
                      value: selectedService,
                      onChanged: (value) {
                        setState(() {
                          selectedService = value;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    EmployeeDropdown(
                      value: selectedEmployee,
                      onChanged: (value) {
                        setState(() {
                          selectedEmployee = value;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    DatePickerField(
                      value: selectedDate,
                      onChanged: (value) {
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    TimePickerField(
                      value: selectedTime,
                      onChanged: (value) {
                        setState(() {
                          selectedTime = value;
                        });
                      },
                    ),

                    const SizedBox(height: 45),

                    BookAppointmentButton(
                      onPressed: bookAppointment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}