import 'package:flutter/material.dart';
import '../theme/calculator_colors.dart';

class CalculatorButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isOperator;
  final bool isFunction;
  final bool isNumberPad;

  const CalculatorButton({
    super.key,
    required this.child,
    required this.onTap,
    this.isOperator = false,
    this.isFunction = false,
    this.isNumberPad = false,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  bool pressed = false;

  Color get normalColor {
    if (widget.isOperator) {
      return CalculatorColors.operatorButton;
    }

    if (widget.isFunction) {
      return CalculatorColors.functionButton;
    }

    return CalculatorColors.numberButton;
  }

  Color get pressedColor {
    if (widget.isOperator) {
      return CalculatorColors.operatorPressed;
    }

    if (widget.isFunction) {
      return CalculatorColors.functionPressed;
    }

    return CalculatorColors.numberPressed;
  }

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTapDown: (_) {
        setState(() {
          pressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          pressed = false;
        });

        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration(
          color: pressed ? pressedColor : normalColor,
          shape: widget.isNumberPad
              ? BoxShape.rectangle
              : BoxShape.circle,
          borderRadius: widget.isNumberPad
              ? BorderRadius.circular(100)
              : null,
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );

    return widget.isNumberPad
        ? ClipOval(child: button)
        : button;
  }
}