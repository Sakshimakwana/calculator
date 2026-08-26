import 'package:flutter/material.dart';
import '../icons/calculator_icons.dart';
import 'calculator_top_button.dart';

class MathsNotesScreen extends StatefulWidget {
  final VoidCallback onModeMenu;

  const MathsNotesScreen({
    super.key,
    required this.onModeMenu,
  });

  @override
  State<MathsNotesScreen> createState() =>
      _MathsNotesScreenState();
}

class _MathsNotesScreenState
    extends State<MathsNotesScreen> {
  final List<String> notes = [];

  void addNote() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();

        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          title: const Text(
            'New Note',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter maths note',
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    notes.add(controller.text);
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),

            Row(
              children: [
                const Spacer(),

                const Text(
                  'Maths Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                CalculatorTopButton(
                  icon: const Icon(
                    CalculatorIcons.calculator,
                    color: Colors.white,
                    size: 30,
                  ),
                  onTap: widget.onModeMenu,
                ),

                const SizedBox(width: 8),

                CalculatorTopButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    size: 30,
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 5),

            const Text(
              'No Notes',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 18,
              ),
            ),

            Expanded(
              child: notes.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: Colors.white54,
                      size: 65,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'No Notes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      notes[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: addNote,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}