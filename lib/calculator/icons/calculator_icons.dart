import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CalculatorIcons {
  static const history = LucideIcons.clock;
  static const calculator = LucideIcons.calculator;

  static const delete = LucideIcons.delete;
  static const percent = LucideIcons.percent;

  static const divide = LucideIcons.divide;
  static const multiply = LucideIcons.x;
  static const minus = LucideIcons.minus;
  static const plus = LucideIcons.plus;
  static const equal = LucideIcons.equal;



  // AC
  static Widget ac({
    double size = 30,
    Color color = Colors.white,
    bool hasValue = false,
  }) {
    return Text(
      hasValue ? 'C' : 'AC',
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static Widget plusMinus({
    double size = 32,
    Color color = Colors.white,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Icon(
              LucideIcons.plus,
              size: size * 0.48,
              color: color,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Icon(
              LucideIcons.minus,
              size: size * 0.48,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}