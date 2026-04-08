import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _resultController.dispose();
    _scrollController.dispose();
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
    //テキストの最後尾（右端）までスクロール
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isBigWide =
            constraints.maxHeight < constraints.maxWidth &&
            700 < constraints.maxHeight;
        final resultFontSize = isBigWide ? 48.0 : 24.0;
        final inputFontSize = isBigWide ? 64.0 : 32.0;
        final panelFontSize = isBigWide ? 48.0 : 24.0;

        return Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                decoration: BoxDecoration(color: Colors.red),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
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
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: resultFontSize,
                        color: Colors.white,
                      ),
                    ),
                    TextField(
                      controller: _inputController,
                      scrollController: _scrollController,
                      readOnly: true,
                      textAlign: TextAlign.right,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.red,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: inputFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InputPanels(
              onButtonPressed: _onButtonPressed,
              panelFontSize: panelFontSize,
            ),
          ],
        );
      },
    );
  }
}

class InputPanels extends StatelessWidget {
  const InputPanels({
    required this.onButtonPressed,
    required this.panelFontSize,
    super.key,
  });

  final void Function(String) onButtonPressed;
  final double panelFontSize;

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
      border: TableBorder.all(
        style: BorderStyle.solid,
        color: Colors.grey[300]!,
      ),
      children: [
        for (final row in rows)
          TableRow(
            children: [
              for (final btn in row)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                  ),
                  onPressed: () => onButtonPressed(btn),
                  child: Text(
                    btn,
                    style: TextStyle(
                      fontSize: panelFontSize,
                      color: _getButtonColor(btn),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
