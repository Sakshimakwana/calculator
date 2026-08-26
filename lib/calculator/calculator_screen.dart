import 'package:app_matic_tech_flutter_app/calculator/widgets/calculator_mode_menu.dart';
import 'package:app_matic_tech_flutter_app/calculator/widgets/converter_screen.dart';
import 'package:app_matic_tech_flutter_app/calculator/widgets/maths_notes_screen.dart';
import 'package:app_matic_tech_flutter_app/calculator/widgets/scientific_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/calculator_history_sheet.dart';
import 'icons/calculator_icons.dart';
import 'theme/calculator_colors.dart';
import 'theme/calculator_typography.dart';
import 'widgets/calculator_button.dart';
import 'widgets/calculator_display.dart';
import 'widgets/calculator_top_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool shouldResetDisplay = true;
  String display = '0';
  String selectedMode = 'Basic';


  double? firstNumber;
  String? operation;
  final List<CalculatorHistoryItem> history = [];

  void goBackToBasic() {
    setState(() {
      selectedMode = 'Basic';
    });
  }
  void showModeMenu() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 10,
              right: 16,
              child: SizedBox(
                width: 220,
                child: CalculatorModeMenu(
                  selectedMode: selectedMode,
                  onSelected: changeMode,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void changeMode(String mode) {
    setState(() {
      selectedMode = mode;
    });
  }
  void showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: CalculatorHistorySheet(
            history: history,
          ),
        );
      },
    );
  }
  // ---------------- NUMBER ----------------

  void inputNumber(String number) {
    setState(() {
      if (display == 'Error') {
        display = number;
        firstNumber = null;
        operation = null;
        shouldResetDisplay = false;
        return;
      }

      if (shouldResetDisplay) {
        display = number;
        shouldResetDisplay = false;
        return;
      }

      // If display contains an operation,
      // start typing the second number.
      if (operation != null && display.contains(operation!)) {
        display = number;
        shouldResetDisplay = false;
        return;
      }

      if (display == '0') {
        display = number;
      } else {
        display += number;
      }
    });
  }

  // ---------------- DECIMAL ----------------

  void inputDecimal() {
    setState(() {
      if (display == 'Error') {
        display = '0.';
        firstNumber = null;
        operation = null;
        shouldResetDisplay = false;
        return;
      }

      if (shouldResetDisplay) {
        display = '0.';
        shouldResetDisplay = false;
        return;
      }

      if (!display.contains('.')) {
        display += '.';
      }
    });
  }

  // ---------------- DELETE ONE BY ONE ----------------

  void deleteLast() {
    setState(() {
      if (display == 'Error') {
        clear();
        return;
      }

      if (display.length <= 1) {
        display = '0';
        return;
      }

      display = display.substring(0, display.length - 1);

      if (display.isEmpty || display == '-') {
        display = '0';
      }
    });
  }

  // ---------------- AC ----------------

  void clear() {
    setState(() {
      display = '0';
      firstNumber = null;
      operation = null;
      shouldResetDisplay = false;
    });
  }

  // ---------------- +/- ----------------

  void toggleSign() {
    setState(() {
      if (display == '0' || display == 'Error') {
        return;
      }

      final value = double.tryParse(display);

      if (value == null) {
        return;
      }

      display = _formatNumber(-value!);
    });
  }

  // ---------------- % ----------------

  void percentage() {
    setState(() {
      final value = double.tryParse(display);

      if (value == null) {
        return;
      }

      display = _formatNumber(value / 100);
    });
  }

  // ---------------- OPERATION ----------------

  void selectOperation(String newOperation) {
    final value = double.tryParse(display);

    if (value == null) {
      return;
    }

    setState(() {
      // If an operation is already selected,
      // calculate the previous expression first.
      if (firstNumber != null && operation != null) {
        _calculate();
      }

      firstNumber = double.tryParse(display);
      operation = newOperation;

      // Show operation immediately.
      display = '${_formatNumber(firstNumber!)} $newOperation';

      shouldResetDisplay = true;
    });
  }

  // ---------------- EQUAL ----------------

  void calculate() {
    setState(() {
      _calculate();
    });
  }

  void _calculate() {
    if (firstNumber == null || operation == null) {
      return;
    }

    String secondDisplay = display;

    // Remove operation from display if it is visible.
    if (secondDisplay.contains(' ')) {
      secondDisplay = secondDisplay.split(' ').last;
    }

    final secondNumber = double.tryParse(secondDisplay);

    if (secondNumber == null) {
      return;
    }

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
          display = 'Error';
          firstNumber = null;
          operation = null;
          shouldResetDisplay = true;
          return;
        }

        result = firstNumber! / secondNumber;
        break;

      default:
        return;
    }

    final expression =
        '${_formatNumber(firstNumber!)}$operation${_formatNumber(secondNumber)}';

    final resultText = _formatNumber(result);

    history.insert(
      0,
      CalculatorHistoryItem(
        expression: expression,
        result: resultText,
      ),
    );

    display = resultText;

    firstNumber = null;
    operation = null;
    shouldResetDisplay = true;
  }

  // ---------------- FORMAT NUMBER ----------------

  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number.toString();
  }

  // ---------------- NUMBER BUTTON ----------------

  Widget numberButton(String value) {
    return CalculatorButton(
      onTap: () => inputNumber(value),
      child: Text(
        value,
        style: CalculatorTypography.number,
      ),
    );
  }

  // ---------------- FUNCTION BUTTON ----------------

  Widget functionButton(
      Widget icon,
      VoidCallback onTap,
      ) {
    return CalculatorButton(
      isFunction: true,
      onTap: onTap,
      child: icon,
    );
  }

  // ---------------- OPERATOR BUTTON ----------------

  Widget operatorButton(
      Widget icon,
      VoidCallback onTap,
      ) {
    return CalculatorButton(
      isOperator: true,
      onTap: onTap,
      child: icon,
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    if (selectedMode == 'Scientific') {
      return ScientificCalculator(
        onModeMenu: showModeMenu,
      );
    }

    if (selectedMode == 'Convert') {
      return ConverterScreen(
        onModeMenu: showModeMenu,
      );
    }

    if (selectedMode == 'Maths Notes') {
      return MathsNotesScreen(
        onModeMenu: showModeMenu,
      );
    }

    return Scaffold(
      backgroundColor: CalculatorColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CalculatorTopButton(
                    icon: const Icon(
                      CalculatorIcons.history,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: showHistory,
                  ),

                  CalculatorTopButton(
                    icon: const Icon(
                      CalculatorIcons.calculator,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: showModeMenu,
                  ),
                ],
              ),
            ),

            // DISPLAY
            Expanded(
              child: CalculatorDisplay(
                value: display,
              ),
            ),

            // BUTTONS
            Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                12,
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // DELETE
                  functionButton(
                    const Icon(
                      CalculatorIcons.delete,
                      color: Colors.white,
                      size: 31,
                    ),
                    deleteLast,
                  ),

                  // AC
                  CalculatorButton(
                    isFunction: true,
                    onTap: clear,
                    child: const Text(
                      'AC',
                      style: CalculatorTypography.function,
                    ),
                  ),

                  // %
                  functionButton(
                    const Icon(
                      CalculatorIcons.percent,
                      color: Colors.white,
                      size: 32,
                    ),
                    percentage,
                  ),

                  // ÷
                  operatorButton(
                    const Icon(
                      CalculatorIcons.divide,
                      color: Colors.white,
                      size: 34,
                    ),
                        () => selectOperation('÷'),
                  ),

                  // 7 8 9 ×
                  numberButton('7'),
                  numberButton('8'),
                  numberButton('9'),

                  operatorButton(
                    const Icon(
                      CalculatorIcons.multiply,
                      color: Colors.white,
                      size: 34,
                    ),
                        () => selectOperation('×'),
                  ),

                  // 4 5 6 -
                  numberButton('4'),
                  numberButton('5'),
                  numberButton('6'),

                  operatorButton(
                    const Icon(
                      CalculatorIcons.minus,
                      color: Colors.white,
                      size: 34,
                    ),
                        () => selectOperation('-'),
                  ),

                  // 1 2 3 +
                  numberButton('1'),
                  numberButton('2'),
                  numberButton('3'),

                  operatorButton(
                    const Icon(
                      CalculatorIcons.plus,
                      color: Colors.white,
                      size: 34,
                    ),
                        () => selectOperation('+'),
                  ),

                  // +/- 0 . =
                  functionButton(
                    CalculatorIcons.plusMinus(),
                    toggleSign,
                  ),

                  numberButton('0'),

                  CalculatorButton(
                    onTap: inputDecimal,
                    child: const Text(
                      '.',
                      style: CalculatorTypography.number,
                    ),
                  ),

                  operatorButton(
                    const Icon(
                      CalculatorIcons.equal,
                      color: Colors.white,
                      size: 34,
                    ),
                    calculate,
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