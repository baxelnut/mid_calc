// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logic {
  ValueNotifier<String> operation = ValueNotifier<String>('');
  ValueNotifier<String> result = ValueNotifier<String>('');
  int _openParenthesesCount = 0;
  bool isResultDisplayed = false;

  List<String> numberPad = [
    'C',
    '( )',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '+/-',
    '0',
    '.',
    '=',
  ];

  void userInput(String input) {
    String sanitizedValue = operation.value.replaceAll(RegExp(r'[^0-9]'), '');

    if (sanitizedValue.length >= 69 && RegExp(r'\d').hasMatch(input)) {
      return;
    }

    if (input == 'C') {
      operation.value = '';
      result.value = '';
      _openParenthesesCount = 0;
      isResultDisplayed = false;
    } else if (input == '⌫') {
      _handleBackspace();
    } else if (input == '+/-') {
      _toggleSign();
    } else if (input == '%') {
      _applyPercentage();
    } else if (input == '=') {
      _finalizeExpression();
    } else if (input == '( )') {
      _handleParentheses();
    } else {
      _handleNormalInput(input);
      isResultDisplayed = false;
    }
    _evaluateExpression();
  }

  void _handleBackspace() {
    if (operation.value.isNotEmpty) {
      if (operation.value.endsWith('(')) {
        _openParenthesesCount--;
      } else if (operation.value.endsWith(')')) {
        _openParenthesesCount++;
      }
      operation.value =
          operation.value.substring(0, operation.value.length - 1);
    }
  }

  void _toggleSign() {
    if (operation.value.isNotEmpty &&
        RegExp(r'\d$').hasMatch(operation.value)) {
      String lastNumber = operation.value.split(RegExp(r'[+\-×÷()]')).last;
      if (lastNumber.startsWith('-')) {
        operation.value = operation.value
                .substring(0, operation.value.length - lastNumber.length) +
            lastNumber.substring(1);
      } else {
        operation.value =
            '${operation.value.substring(0, operation.value.length - lastNumber.length)}-$lastNumber';
      }
    }
  }

  void _applyPercentage() {
    if (operation.value.isNotEmpty &&
        RegExp(r'\d$').hasMatch(operation.value)) {
      String lastNumber = operation.value.split(RegExp(r'[+\-×÷()]')).last;
      double percentage = double.parse(lastNumber) / 100;
      operation.value = operation.value
              .substring(0, operation.value.length - lastNumber.length) +
          percentage.toString();
    }
  }

  void _handleParentheses() {
    if (_openParenthesesCount == 0 ||
        operation.value.endsWith('+') ||
        operation.value.endsWith('-') ||
        operation.value.endsWith('×') ||
        operation.value.endsWith('÷') ||
        operation.value.isEmpty) {
      operation.value += '(';
      _openParenthesesCount++;
    } else if (_openParenthesesCount > 0) {
      operation.value += ')';
      _openParenthesesCount--;
    }
  }

  void _handleNormalInput(String input) {
    if (operation.value.isNotEmpty &&
        RegExp(r'\d$').hasMatch(operation.value) &&
        input == '(') {
      operation.value += '×(';
      _openParenthesesCount++;
    } else if (operation.value.isNotEmpty &&
        RegExp(r'\)$').hasMatch(operation.value) &&
        RegExp(r'\d').hasMatch(input)) {
      operation.value += '×$input';
    } else {
      if (operation.value.isEmpty && RegExp(r'[+\-×÷]').hasMatch(input)) {
      } else if (operation.value.isNotEmpty &&
          RegExp(r'[+\-×÷]').hasMatch(input) &&
          RegExp(r'[+\-×÷]')
              .hasMatch(operation.value[operation.value.length - 1])) {
        operation.value =
            operation.value.substring(0, operation.value.length - 1) + input;
      } else {
        operation.value += input;
      }
    }
  }

  void _finalizeExpression() {
    while (_openParenthesesCount > 0) {
      operation.value += ')';
      _openParenthesesCount--;
    }
    _calculateResult();
  }

  void _calculateResult() {
    try {
      String expression =
          operation.value.replaceAll('×', '*').replaceAll('÷', '/');
      if (operation.value.isNotEmpty &&
          !RegExp(r'[+\-×÷]$').hasMatch(operation.value)) {
        Parser parser = Parser();
        Expression exp = parser.parse(expression);
        ContextModel contextModel = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, contextModel);

        result.value = eval.toString();

        if (eval == eval.toInt()) {
          result.value = eval.toInt().toString();
        }

        history.add({
          'operation': operation.value,
          'result': result.value,
        });
        _saveHistory();
        operation.notifyListeners();
        result.notifyListeners();
      } else {
        result.value = 'Error';
      }
    } catch (e) {
      result.value = 'Error';
    }
    isResultDisplayed = true;
  }

  void _evaluateExpression() {
    try {
      final expression =
          operation.value.replaceAll('×', '*').replaceAll('÷', '/');
      final parser = Parser();
      final exp = parser.parse(expression);
      final contextModel = ContextModel();
      result.value = exp.evaluate(EvaluationType.REAL, contextModel).toString();
      if (result.value.endsWith('.0')) {
        result.value = result.value.substring(0, result.value.length - 2);
      }
    } catch (e) {
      result.value = '';
    }
  }

  List<Map<String, String>> history = [];

  Logic() {
    _loadHistory();
  }

  void addToHistory(String operation, String result) {
    history.add({'operation': operation, 'result': result});
    _saveHistory();
  }

  void clearHistory() {
    history.clear();
    _saveHistory();
  }

  void _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(history);
    await prefs.setString('history', encodedData);
  }

  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('history');
    if (encodedData != null) {
      history = List<Map<String, String>>.from(jsonDecode(encodedData));
    }
  }
}
