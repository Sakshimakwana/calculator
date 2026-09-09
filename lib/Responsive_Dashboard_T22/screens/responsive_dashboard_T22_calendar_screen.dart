import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';
import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22CalendarScreen
    extends StatefulWidget {
  const ResponsiveDashboardT22CalendarScreen({
    super.key,
  });

  @override
  State<ResponsiveDashboardT22CalendarScreen>
  createState() =>
      _ResponsiveDashboardT22CalendarScreenState();
}

class _ResponsiveDashboardT22CalendarScreenState
    extends State<ResponsiveDashboardT22CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> meetings = [
    {
      'title': 'Team Meeting',
      'date': '09 Sep 2026',
      'time': '10:00 AM',
      'people': '5 members',
    },
    {
      'title': 'Design Review',
      'date': '09 Sep 2026',
      'time': '02:00 PM',
      'people': '3 members',
    },
    {
      'title': 'Project Discussion',
      'date': '10 Sep 2026',
      'time': '11:30 AM',
      'people': '4 members',
    },
    {
      'title': 'Client Meeting',
      'date': '12 Sep 2026',
      'time': '03:00 PM',
      'people': '6 members',
    },
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = picked;
    });
  }

  Future<void> _scheduleMeeting() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null || !mounted) return;

    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();

        return AlertDialog(
          title: const Text('Schedule Meeting'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Meeting title',
              hintText: 'Enter meeting title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );

    if (title == null || title.isEmpty || !mounted) return;

    setState(() {
      meetings.add({
        'title': title,
        'date':
        '${selectedDate.day.toString().padLeft(2, '0')} '
            '${_monthName(selectedDate.month)} '
            '${selectedDate.year}',
        'time': selectedTime.format(context),
        'people': '1 member',
      });
    });
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      ResponsiveDashboardT22Colors.background,
      appBar: AppBar(
        leading:
        const ResponsiveDashboardT22BackButton(),
        title: const Text(
          'Calendar',
          style:
          ResponsiveDashboardT22Typography.section,
        ),
        backgroundColor:
        ResponsiveDashboardT22Colors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Schedule & Meetings',
                style:
                ResponsiveDashboardT22Typography.title,
              ),

              const SizedBox(height: 6),

              const Text(
                'Select a date and manage your meetings',
                style:
                ResponsiveDashboardT22Typography.subtitle,
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                  ResponsiveDashboardT22Colors.surface,
                  borderRadius:
                  BorderRadius.circular(16),
                  border: Border.all(
                    color:
                    ResponsiveDashboardT22Colors.border,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      size: 35,
                      color:
                      ResponsiveDashboardT22Colors.primary,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Date',
                            style: TextStyle(
                              fontSize: 11,
                              color:
                              ResponsiveDashboardT22Colors
                                  .mutedText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${selectedDate.day} '
                                '${_monthName(selectedDate.month)} '
                                '${selectedDate.year}',
                            style:
                            ResponsiveDashboardT22Typography
                                .section,
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _selectDate,
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _scheduleMeeting,
                  icon: const Icon(
                    Icons.add_rounded,
                  ),
                  label: const Text(
                    'Schedule Meeting',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'All Meetings',
                style:
                ResponsiveDashboardT22Typography.section,
              ),

              const SizedBox(height: 12),

              ...meetings.map(
                    (meeting) => _MeetingCard(
                  title: meeting['title']!,
                  date: meeting['date']!,
                  time: meeting['time']!,
                  people: meeting['people']!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({
    required this.title,
    required this.date,
    required this.time,
    required this.people,
  });

  final String title;
  final String date;
  final String time;
  final String people;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        ResponsiveDashboardT22Colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
          ResponsiveDashboardT22Colors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color:
              ResponsiveDashboardT22Colors.primarySoft,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_rounded,
              color:
              ResponsiveDashboardT22Colors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color:
                    ResponsiveDashboardT22Colors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$date • $time',
                  style:
                  ResponsiveDashboardT22Typography
                      .cardLabel,
                ),
                const SizedBox(height: 3),
                Text(
                  people,
                  style:
                  ResponsiveDashboardT22Typography
                      .cardLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}