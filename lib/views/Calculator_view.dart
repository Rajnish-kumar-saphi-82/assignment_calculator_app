import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  static const List<String> _buttons = [
    'C',
    '*',
    '/',
    '<-',
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '%',
    '0',
    '.',
    '=',
  ];

  String _display = '';
  double? _firstOperand;
  String? _operator;
  bool _waitingForSecond = false;

  void _onButtonPressed(String label) {
    setState(() {
      if (label == 'C') {
        _display = '';
        _firstOperand = null;
        _operator = null;
        _waitingForSecond = false;
      } else if (label == '<-') {
        if (_display.isNotEmpty) {
          _display = _display.substring(0, _display.length - 1);
        }
      } else if ('+-*/%'.contains(label)) {
        if (_display.isNotEmpty) {
          _firstOperand = double.tryParse(_display);
          _operator = label;
          _waitingForSecond = true;
          _display = '';
        }
      } else if (label == '=') {
        if (_firstOperand != null && _operator != null && _display.isNotEmpty) {
          final double? secondOperand = double.tryParse(_display);
          if (secondOperand == null) return;

          double result = 0;

          switch (_operator) {
            case '+':
              result = _firstOperand! + secondOperand;
              break;
            case '-':
              result = _firstOperand! - secondOperand;
              break;
            case '*':
              result = _firstOperand! * secondOperand;
              break;
            case '/':
              if (secondOperand == 0) {
                _display = 'Error';
                _firstOperand = null;
                _operator = null;
                _waitingForSecond = false;
                return;
              }
              result = _firstOperand! / secondOperand;
              break;
            case '%':
              result = _firstOperand! % secondOperand;
              break;
          }

          _display = result % 1 == 0
              ? result.toInt().toString()
              : result.toString();

          _firstOperand = null;
          _operator = null;
          _waitingForSecond = false;
        }
      } else {
        if (_waitingForSecond) {
          _display = label;
          _waitingForSecond = false;
        } else {
          if (label == '.' && _display.contains('.')) return;
          _display += label;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: BackButton(color: Colors.white),
      ),

      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _display,
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
                children: [
                  for (final label in _buttons)
                    ElevatedButton(
                      onPressed: () => _onButtonPressed(label),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEDEDED),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(label, style: const TextStyle(fontSize: 28)),
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
