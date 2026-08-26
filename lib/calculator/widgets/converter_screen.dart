import 'package:flutter/material.dart';

import '../icons/calculator_icons.dart';
import '../theme/calculator_colors.dart';
import '../theme/calculator_typography.dart';
import '../widgets/calculator_button.dart';
import '../widgets/calculator_top_button.dart';

class ConverterScreen extends StatefulWidget {
  final VoidCallback onModeMenu;

  const ConverterScreen({
    super.key,
    required this.onModeMenu,
  });

  @override
  State<ConverterScreen> createState() =>
      _ConverterScreenState();
}

class _ConverterScreenState
    extends State<ConverterScreen> {
  String fromCurrency = 'INR';
  String toCurrency = 'EUR';

  String amount = '0';

  double get rate => 0.0105;

  // --------------------------------------------------
  // NUMBER
  // --------------------------------------------------

  void addNumber(String value) {
    setState(() {
      if (value == '.') {
        if (amount.contains('.')) {
          return;
        }

        amount += '.';
        return;
      }

      if (amount == '0') {
        amount = value;
      } else {
        amount += value;
      }
    });
  }

  // --------------------------------------------------
  // DELETE
  // --------------------------------------------------

  void removeNumber() {
    setState(() {
      if (amount.length <= 1) {
        amount = '0';
        return;
      }

      amount = amount.substring(
        0,
        amount.length - 1,
      );

      if (amount.isEmpty || amount == '-') {
        amount = '0';
      }
    });
  }

  // --------------------------------------------------
  // AC
  // --------------------------------------------------

  void clearAmount() {
    setState(() {
      amount = '0';
    });
  }

  // --------------------------------------------------
  // PLUS / MINUS
  // --------------------------------------------------

  void toggleSign() {
    setState(() {
      if (amount == '0') {
        return;
      }

      if (amount.startsWith('-')) {
        amount = amount.substring(1);
      } else {
        amount = '-$amount';
      }
    });
  }

  // --------------------------------------------------
  // PERCENT
  // --------------------------------------------------

  void percentage() {
    setState(() {
      final value = double.tryParse(amount);

      if (value == null) {
        return;
      }

      amount = _formatNumber(value / 100);
    });
  }

  // --------------------------------------------------
  // SWAP
  // --------------------------------------------------

  void swap() {
    setState(() {
      final temp = fromCurrency;

      fromCurrency = toCurrency;
      toCurrency = temp;
    });
  }

  // --------------------------------------------------
  // FORMAT
  // --------------------------------------------------

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value
        .toStringAsFixed(10)
        .replaceFirst(
      RegExp(r'\.?0+$'),
      '',
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final inputAmount =
        double.tryParse(amount) ?? 0;

    final converted =
        inputAmount * rate;

    return Scaffold(
      backgroundColor:
      CalculatorColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------
            // TOP BUTTONS
            // ----------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  CalculatorTopButton(
                    icon: const Icon(
                      CalculatorIcons.history,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: () {},
                  ),

                  CalculatorTopButton(
                    icon: const Icon(
                      CalculatorIcons.calculator,
                      color: Colors.white,
                      size: 30,
                    ),
                    onTap: widget.onModeMenu,
                  ),
                ],
              ),
            ),

            // ----------------------------------------
            // CONVERTER DISPLAY
            // ----------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 24,
                  right: 24,
                  bottom: 1
                ),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  children: [
                    // FROM
                    _currencyRow(
                      amount,
                      fromCurrency,
                      true,
                    ),

                    // LINE + SWAP
                    Row(
                      children: [
                        GestureDetector(
                          onTap: swap,
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 2,
                              right: 18,
                            ),
                            child: Icon(
                              Icons.swap_vert,
                              color: Colors.orange,
                              size: 36,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    ),

                    // TO
                    _currencyRow(
                      converted.toStringAsFixed(2),
                      toCurrency,
                      false,
                    ),
                  ],
                ),
              ),
            ),

            // ----------------------------------------
            // NUMBER PAD
            // ----------------------------------------

            Expanded(
              flex: 2,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // ROW 1
                    Expanded(
                      child: Row(
                        children: [
                          _button(
                            child: const Icon(
                              CalculatorIcons.delete,
                              color: Colors.white,
                              size: 34,
                            ),
                            onTap: removeNumber,
                            isFunction: true,
                          ),

                          _button(
                            child: const Text(
                              'AC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onTap: clearAmount,
                            isFunction: true,
                          ),


                          _button(
                            child: const Text(
                              '%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onTap: percentage,
                            isFunction: true,
                          ),

                          _button(
                            child: const Icon(
                              CalculatorIcons.divide,
                              color: Colors.white,
                              size: 34,
                            ),
                            onTap: () {},
                            isOperator: true,
                          ),
                        ],
                      ),
                    ),

                    // ROW 2
                    Expanded(
                      child: Row(
                        children: [
                          _numberButton('7'),
                          _numberButton('8'),
                          _numberButton('9'),

                          _button(
                            child: const Icon(
                              CalculatorIcons.multiply,
                              color: Colors.white,
                              size: 34,
                            ),
                            onTap: () {},
                            isOperator: true,
                          ),
                        ],
                      ),
                    ),

                    // ROW 3
                    Expanded(
                      child: Row(
                        children: [
                          _numberButton('4'),
                          _numberButton('5'),
                          _numberButton('6'),

                          _button(
                            child: const Icon(
                              CalculatorIcons.minus,
                              color: Colors.white,
                              size: 34,
                            ),
                            onTap: () {},
                            isOperator: true,
                          ),
                        ],
                      ),
                    ),

                    // ROW 4
                    Expanded(
                      child: Row(
                        children: [
                          _numberButton('1'),
                          _numberButton('2'),
                          _numberButton('3'),

                          _button(
                            child: const Icon(
                              CalculatorIcons.plus,
                              color: Colors.white,
                              size: 34,
                            ),
                            onTap: () {},
                            isOperator: true,
                          ),
                        ],
                      ),
                    ),

                    // ROW 5
                    Expanded(
                      child: Row(
                        children: [
                          _button(
                            child:
                            CalculatorIcons.plusMinus(),
                            onTap: toggleSign,
                          ),

                          _numberButton('0'),

                          _button(
                            child: const Text(
                              '.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onTap: () => addNumber('.'),
                          ),
                          _button(
                            child: const Icon(
                              CalculatorIcons.equal,
                              color: Colors.white,
                              size: 34,
                            ),
                            onTap: () {},
                            isOperator: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // CURRENCY ROW
  // --------------------------------------------------

  Widget _currencyRow(
      String value,
      String currency,
      bool editable,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: editable
                ? Colors.white
                : Colors.white54,
            fontSize: 54,
            fontWeight: FontWeight.w300,
          ),
        ),

        const SizedBox(width: 8),

        Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Text(
              currency,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 0),

            const Icon(
              Icons.unfold_more,
              color: Colors.white54,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------
  // NUMBER BUTTON
  // --------------------------------------------------
  Widget _numberButton(String number) {
    return _button(
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w300,
        ),
      ),
      onTap: () => addNumber(number),
    );
  }

  // --------------------------------------------------
  // COMMON BUTTON
  // --------------------------------------------------

  Widget _button({
    required Widget child,
    required VoidCallback onTap,
    bool isOperator = false,
    bool isFunction = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: CalculatorButton(
          child: child,
          onTap: onTap,
          isOperator: isOperator,
          isFunction: isFunction,
        ),
      ),
    );
  }
}