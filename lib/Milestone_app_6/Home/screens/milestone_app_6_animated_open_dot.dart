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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulse = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
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
    if (!widget.isOpen) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: CircleAvatar(
            radius: 3.5,
            backgroundColor: Colors.redAccent,
          ),
        ),
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
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
                    color: const Color(0xFF20C878).withValues(
                      alpha: (1 - progress).clamp(0.0, 1.0),
                    ),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF20C878),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
