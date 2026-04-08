import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: ToggleText(textA: "A simple text", textB: "Hello World"),
        ),
      ),
    );
  }
}

class ToggleText extends StatefulWidget {
  const ToggleText({required this.textA, required this.textB, super.key});

  final String textA;
  final String textB;

  @override
  State<ToggleText> createState() => _ToggleTextState();
}

class _ToggleTextState extends State<ToggleText> {
  bool _showTextA = true;

  void _toggle() {
    setState(() {
      _showTextA = !_showTextA;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          decoration: const BoxDecoration(
            color: Color(0xFF808026),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Text(
            _showTextA ? widget.textA : widget.textB,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: _toggle,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
          ),
          child: const Text(
            "Click me",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF808026),
            ),
          ),
        ),
      ],
    );
  }
}
