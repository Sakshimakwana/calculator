import 'dart:ui';

import 'package:flutter/material.dart';

class CalculatorHistoryItem {
  final String expression;
  final String result;

  const CalculatorHistoryItem({
    required this.expression,
    required this.result,
  });
}

class CalculatorHistorySheet extends StatelessWidget {
  final List<CalculatorHistoryItem> history;


  const CalculatorHistorySheet({
    super.key,
    required this.history,


  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 8,
        sigmaY: 8,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(38),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // TOP HANDLE
              Container(
                width: 52,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  18,
                  10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    30,
                  ),
                  children: [
                    _sectionTitle('Previous 7 Days'),

                    const SizedBox(height: 8),

                    if (history.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          'No calculations',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
                        ),
                      )
                    else
                      ...history.map(
                            (item) => _historyItem(item),
                      ),

                    const SizedBox(height: 35),

                    _sectionTitle('Previous 30 Days'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _historyItem(CalculatorHistoryItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.expression,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.result,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}