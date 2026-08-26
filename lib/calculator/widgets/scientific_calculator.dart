import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../widgets/calculator_button.dart';

class ScientificCalculator extends StatefulWidget {
  final VoidCallback onBack;

  const ScientificCalculator({
    super.key,
    required this.onBack,
  });

  @override
  State<ScientificCalculator> createState() =>
      _ScientificCalculatorState();
}

class _ScientificCalculatorState
    extends State<ScientificCalculator> {
  String display = '0';

  double? firstNumber;
  String? operation;

  bool shouldResetDisplay = false;
  bool secondMode = false;
  bool degreeMode = false;

  double memory = 0;

  // ---------------- NUMBER ----------------

  void number(String value) {
    setState(() {
      if (display == 'Error' || shouldResetDisplay) {
        display = value;
        shouldResetDisplay = false;
        return;
      }

      if (display == '0') {
        display = value;
      } else {
        display += value;
      }
    });
  }

  void decimal() {
    setState(() {
      if (display == 'Error' || shouldResetDisplay) {
        display = '0.';
        shouldResetDisplay = false;
        return;
      }

      if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  // ---------------- DELETE / AC ----------------

  void delete() {
    setState(() {
      if (display == 'Error' || display.length <= 1) {
        display = '0';
        return;
      }

      display = display.substring(
        0,
        display.length - 1,
      );
    });
  }

  void clear() {
    setState(() {
      display = '0';
      firstNumber = null;
      operation = null;
      shouldResetDisplay = false;
    });
  }

  // ---------------- BASIC OPERATIONS ----------------

  double get value =>
      double.tryParse(display) ?? 0;

  void setOperation(String newOperation) {
    if (display == 'Error') return;

    if (firstNumber != null && operation != null) {
      calculate();
    }

    firstNumber = value;
    operation = newOperation;
    shouldResetDisplay = true;
  }

  void calculate() {
    if (firstNumber == null || operation == null) {
      return;
    }

    final secondNumber = value;

    double result;

    switch (operation) {
      case '+':
        result = firstNumber! + secondNumber;
        break;

      case '-':
        result = firstNumber! - secondNumber;
        break;

      case '×':
        result = firstNumber! * secondNumber;
        break;

      case '÷':
        if (secondNumber == 0) {
          error();
          return;
        }

        result = firstNumber! / secondNumber;
        break;

      case '^':
        result = math.pow(
          firstNumber!,
          secondNumber,
        ).toDouble();
        break;

      case '√':
        if (secondNumber == 0) {
          error();
          return;
        }

        result = math.pow(
          firstNumber!,
          1 / secondNumber,
        ).toDouble();
        break;

      default:
        return;
    }

    setState(() {
      display = _format(result);
      firstNumber = null;
      operation = null;
      shouldResetDisplay = true;
    });
  }

  // ---------------- PLUS / MINUS ----------------

  void toggleSign() {
    if (display == '0' || display == 'Error') {
      return;
    }

    setState(() {
      if (display.startsWith('-')) {
        display = display.substring(1);
      } else {
        display = '-$display';
      }
    });
  }

  // ---------------- PERCENT ----------------

  void percent() {
    setState(() {
      display = _format(value / 100);
    });
  }

  // ---------------- SCIENTIFIC ----------------

  void square() {
    setState(() {
      display = _format(value * value);
      shouldResetDisplay = true;
    });
  }

  void cube() {
    setState(() {
      display = _format(value * value * value);
      shouldResetDisplay = true;
    });
  }

  void reciprocal() {
    if (value == 0) {
      error();
      return;
    }

    setState(() {
      display = _format(1 / value);
      shouldResetDisplay = true;
    });
  }

  void squareRoot() {
    if (value < 0) {
      error();
      return;
    }

    setState(() {
      display = _format(math.sqrt(value));
      shouldResetDisplay = true;
    });
  }

  void cubeRoot() {
    setState(() {
      display = _format(
        math.pow(value, 1 / 3).toDouble(),
      );
      shouldResetDisplay = true;
    });
  }

  void sine() {
    final angle = degreeMode
        ? value * math.pi / 180
        : value;

    setState(() {
      display = _format(math.sin(angle));
      shouldResetDisplay = true;
    });
  }

  void cosine() {
    final angle = degreeMode
        ? value * math.pi / 180
        : value;

    setState(() {
      display = _format(math.cos(angle));
      shouldResetDisplay = true;
    });
  }

  void tangent() {
    final angle = degreeMode
        ? value * math.pi / 180
        : value;

    setState(() {
      display = _format(math.tan(angle));
      shouldResetDisplay = true;
    });
  }

  void sinh() {
    setState(() {
      display = _format(
        (math.exp(value) - math.exp(-value)) / 2,
      );
      shouldResetDisplay = true;
    });
  }

  void cosh() {
    setState(() {
      display = _format(
        (math.exp(value) + math.exp(-value)) / 2,
      );
      shouldResetDisplay = true;
    });
  }

  void tanh() {
    setState(() {
      final e1 = math.exp(value);
      final e2 = math.exp(-value);

      display = _format(
        (e1 - e2) / (e1 + e2),
      );

      shouldResetDisplay = true;
    });
  }

  void naturalLog() {
    if (value <= 0) {
      error();
      return;
    }

    setState(() {
      display = _format(math.log(value));
      shouldResetDisplay = true;
    });
  }

  void log10() {
    if (value <= 0) {
      error();
      return;
    }

    setState(() {
      display = _format(
        math.log(value) / math.ln10,
      );
      shouldResetDisplay = true;
    });
  }

  void factorial() {
    if (value < 0 ||
        value != value.floor() ||
        value > 170) {
      error();
      return;
    }

    double result = 1;

    for (int i = 1; i <= value.toInt(); i++) {
      result *= i;
    }

    setState(() {
      display = _format(result);
      shouldResetDisplay = true;
    });
  }

  void exponential() {
    setState(() {
      display = _format(math.exp(value));
      shouldResetDisplay = true;
    });
  }

  void power10() {
    setState(() {
      display = _format(
        math.pow(10, value).toDouble(),
      );
      shouldResetDisplay = true;
    });
  }

  void pi() {
    setState(() {
      display = _format(math.pi);
      shouldResetDisplay = true;
    });
  }

  void e() {
    setState(() {
      display = _format(math.e);
      shouldResetDisplay = true;
    });
  }

  // ---------------- MEMORY ----------------

  void memoryClear() {
    memory = 0;
  }

  void memoryAdd() {
    memory += value;
  }

  void memorySubtract() {
    memory -= value;
  }

  void memoryRecall() {
    setState(() {
      display = _format(memory);
      shouldResetDisplay = true;
    });
  }

  // ---------------- OTHER ----------------

  void randomNumber() {
    setState(() {
      display = math.Random()
          .nextDouble()
          .toStringAsFixed(8);

      shouldResetDisplay = true;
    });
  }

  void toggleSecond() {
    setState(() {
      secondMode = !secondMode;
    });
  }

  void toggleAngle() {
    setState(() {
      degreeMode = !degreeMode;
    });
  }

  void error() {
    setState(() {
      display = 'Error';
      firstNumber = null;
      operation = null;
      shouldResetDisplay = true;
    });
  }

  String _format(double number) {
    if (number.isNaN || number.isInfinite) {
      return 'Error';
    }

    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number
        .toStringAsFixed(8)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const Spacer(),
              ],
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    20,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // SCIENTIFIC BUTTONS

            GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              crossAxisCount: 6,
              crossAxisSpacing: 4,
              mainAxisSpacing: 8,
              childAspectRatio: 1.45,
              children: [
                _button('(', () {}),
                _button(')', () {}),
                _button('mc', memoryClear),
                _button('m+', memoryAdd),
                _button('m−', memorySubtract),
                _button('mr', memoryRecall),

                _button(
                  '2nd',
                  toggleSecond,
                ),

                _button(
                  secondMode ? 'x³' : 'x²',
                  secondMode ? cube : square,
                ),

                _button(
                  'xʸ',
                      () => setOperation('^'),
                ),

                _button(
                  'eˣ',
                  exponential,
                ),

                _button(
                  '10ˣ',
                  power10,
                ),

                _button(
                  '1/x',
                  reciprocal,
                ),

                _button(
                  '²√x',
                  squareRoot,
                ),

                _button(
                  '³√x',
                  cubeRoot,
                ),

                _button(
                  'ʸ√x',
                      () => setOperation('√'),
                ),

                _button(
                  'ln',
                  naturalLog,
                ),

                _button(
                  'log₁₀',
                  log10,
                ),

                _button(
                  'x!',
                  factorial,
                ),

                _button(
                  'sin',
                  sine,
                ),

                _button(
                  'cos',
                  cosine,
                ),

                _button(
                  'tan',
                  tangent,
                ),

                _button(
                  'e',
                  e,
                ),

                _button(
                  'EE',
                      () {},
                ),

                _button(
                  'Rand',
                  randomNumber,
                ),

                _button(
                  'sinh',
                  sinh,
                ),

                _button(
                  'cosh',
                  cosh,
                ),

                _button(
                  'tanh',
                  tanh,
                ),

                _button(
                  'π',
                  pi,
                ),

                _button(
                  degreeMode ? 'Deg' : 'Rad',
                  toggleAngle,
                ),
              ],
            ),

            // NUMBER PAD

            GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.30,
              children: [
                _button(
                  '⌫',
                  delete,
                  isFunction: true,
                  isNumberPad: true,
                ),

                _button(
                  'AC',
                  clear,
                  isFunction: true,
                  isNumberPad: true,
                ),

                _button(
                  '%',
                  percent,
                  isFunction: true,
                  isNumberPad: true,
                ),

                _button(
                  '÷',
                      () => setOperation('÷'),
                  isOperator: true,
                  isNumberPad: true,
                ),

                _button(
                  '7',
                      () => number('7'),
                  isNumberPad: true,
                ),

                _button(
                  '8',
                      () => number('8'),
                  isNumberPad: true,
                ),

                _button(
                  '9',
                      () => number('9'),
                  isNumberPad: true,
                ),

                _button(
                  '×',
                      () => setOperation('×'),
                  isOperator: true,
                  isNumberPad: true,
                ),

                _button(
                  '4',
                      () => number('4'),
                  isNumberPad: true,
                ),

                _button(
                  '5',
                      () => number('5'),
                  isNumberPad: true,
                ),

                _button(
                  '6',
                      () => number('6'),
                  isNumberPad: true,
                ),

                _button(
                  '−',
                      () => setOperation('-'),
                  isOperator: true,
                  isNumberPad: true,
                ),

                _button(
                  '1',
                      () => number('1'),
                  isNumberPad: true,
                ),

                _button(
                  '2',
                      () => number('2'),
                  isNumberPad: true,
                ),

                _button(
                  '3',
                      () => number('3'),
                  isNumberPad: true,
                ),

                _button(
                  '+',
                      () => setOperation('+'),
                  isOperator: true,
                  isNumberPad: true,
                ),

                _button(
                  '+/−',
                  toggleSign,
                  isNumberPad: true,
                ),

                _button(
                  '0',
                      () => number('0'),
                  isNumberPad: true,
                ),

                _button(
                  '.',
                  decimal,
                  isNumberPad: true,
                ),

                _button(
                  '=',
                  calculate,
                  isOperator: true,
                  isNumberPad: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BUTTON ----------------

  Widget _button(
      String text,
      VoidCallback onTap, {
        bool isOperator = false,
        bool isFunction = false,
        bool isNumberPad = false,
      }) {
    return CalculatorButton(
      onTap: onTap,
      isOperator: isOperator,
      isFunction: isFunction,
      isNumberPad: isNumberPad,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}