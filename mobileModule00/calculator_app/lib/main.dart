import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  debugPrint("Starting Calculator App");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'Calculator',
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Calculator(),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  num _calcExprString(String input) {
    String processedInput = input.replaceAllMapped(
      RegExp(r'[eE]([+-]?)([0-9]+)'),
      (match) {
        String sign = match.group(1) == '-' ? '-' : '';
        String exponent = match.group(2)!;
        return '*10^($sign$exponent)';
      },
    );

    Expression exp = GrammarParser().parse(processedInput);
    return RealEvaluator().evaluate(exp);
  }

  void _executeCalc() {
    try {
      final num result = _calcExprString(_inputController.text);
      if (!result.isFinite) throw Exception("Result is Infinite or NaN");
      setState(() {
        _resultController.text = (result % 1 == 0)
            ? result.toInt().toString()
            : result.toString();
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        _resultController.text = 'Error';
      });
    }
  }

  void _onButtonPressed(String label) {
    debugPrint("Button pressed: $label");
    setState(() {
      if (label == 'C') {
        if (_inputController.text.isNotEmpty) {
          _inputController.text = _inputController.text.substring(
            0,
            _inputController.text.length - 1,
          );
        }
      } else if (label == 'AC') {
        _inputController.text = '';
        _resultController.text = '';
      } else if (label == '=') {
        _executeCalc();
      } else if (label.isNotEmpty) {
        _inputController.text += label;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double dyPadding = constraints.maxHeight < 200 ? 12.0 : 16.0;
              return Container(
                alignment: Alignment.topRight,
                //背景色を赤に
                decoration: BoxDecoration(color: Colors.red),
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: dyPadding,
                  bottom: dyPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _resultController,
                      readOnly: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.blue,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    TextField(
                      controller: _inputController,
                      readOnly: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.red,
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        InputPanels(onButtonPressed: _onButtonPressed),
      ],
    );
  }
}

class InputPanels extends StatelessWidget {
  const InputPanels({required this.onButtonPressed, super.key});

  final void Function(String) onButtonPressed;

  Color _getButtonColor(String label) {
    if (label == 'C' || label == 'AC') {
      return Colors.red;
    } else if (label == '=') {
      return Colors.green;
    } else if (['+', '-', '*', '/'].contains(label)) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['7', '8', '9', 'C', 'AC'],
      ['4', '5', '6', '+', '-'],
      ['1', '2', '3', '*', '/'],
      ['0', '.', '00', '=', ''],
    ];

    return Table(
      children: [
        for (var row in rows)
          TableRow(
            decoration: BoxDecoration(),
            children: [
              for (var btn in row)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () => onButtonPressed(btn),
                    child: Text(
                      btn,
                      style: TextStyle(
                        fontSize: 24,
                        color: _getButtonColor(btn),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
