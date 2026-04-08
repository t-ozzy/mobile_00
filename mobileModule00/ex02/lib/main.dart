import 'package:flutter/material.dart';

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
  void _onButtonPressed(String label) {
    debugPrint("Button pressed: $label");
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
                      controller: TextEditingController(text: "0"),
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
                      controller: TextEditingController(text: "0"),
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
