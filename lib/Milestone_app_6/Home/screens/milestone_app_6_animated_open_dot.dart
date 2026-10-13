import 'package:flutter/material.dart';

class MilestoneApp6AnimatedOpenDot extends StatefulWidget {
  final bool isOpen;
  final double size;

  const MilestoneApp6AnimatedOpenDot({
    super.key,
    required this.isOpen,
    this.size = 18,
  });

  @override
  State<MilestoneApp6AnimatedOpenDot> createState() =>
      _MilestoneApp6AnimatedOpenDotState();
}

class _MilestoneApp6AnimatedOpenDotState
    extends State<MilestoneApp6AnimatedOpenDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  static const Color _openGreen = Color(0xFF00A85A);
  static const Color _lightGreen = Color(0xFFD9FBE8);
  static const Color _closedRed = Color(0xFFE53935);
  static const Color _lightRed = Color(0xFFFFE3E1);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulse = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    if (widget.isOpen) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(
    covariant MilestoneApp6AnimatedOpenDot oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.isOpen && !oldWidget.isOpen) {
      _controller.repeat();
    } else if (!widget.isOpen && oldWidget.isOpen) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isOpen ? _lightGreen : _lightRed;
    final dotColor = widget.isOpen ? _openGreen : _closedRed;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: widget.isOpen
          ? AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final progress = _pulse.value;
                final ringSize = widget.size * progress;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: ringSize,
                      height: ringSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _openGreen.withValues(
                            alpha: (1 - progress).clamp(0.0, 1.0),
                          ),
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: widget.size * 0.38,
                      height: widget.size * 0.38,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _openGreen.withValues(alpha: 0.3),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: Container(
                width: widget.size * 0.38,
                height: widget.size * 0.38,
                decoration: const BoxDecoration(
                  color: _closedRed,
                  shape: BoxShape.circle,
                ),
              ),
            ),
    );
  }
}
