import 'package:flutter/material.dart';

import 'logic.dart';

class NumberPad extends StatefulWidget {
  final Logic logic;

  const NumberPad({required this.logic, super.key});

  @override
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ValueListenableBuilder<String>(
          valueListenable: widget.logic.operation,
          builder: (context, operation, child) {
            return GridView.builder(
              itemCount: widget.logic.numberPad.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                TextStyle? buttonTextStyle;
                Color? buttonStyle = theme.colorScheme.primary;

                switch (widget.logic.numberPad[index]) {
                  case '( )':
                  case '%':
                    buttonStyle = theme.colorScheme.primary.withOpacity(0.7);
                    buttonTextStyle = theme.textTheme.headlineMedium!
                        .copyWith(color: theme.colorScheme.secondary);
                    break;
                  case '÷':
                  case '×':
                  case '-':
                  case '+':
                    buttonStyle = theme.colorScheme.primary.withOpacity(0.7);
                    buttonTextStyle = theme.textTheme.headlineMedium!.copyWith(
                        color: theme.colorScheme.secondary,
                        fontSize: 50,
                        fontWeight: FontWeight.w100);
                    break;
                  case '+/-':
                    buttonStyle = theme.colorScheme.primary.withOpacity(0.7);
                    buttonTextStyle =
                        theme.textTheme.headlineMedium!.copyWith(fontSize: 30);
                    break;
                  case 'C':
                    buttonStyle = theme.colorScheme.primary.withOpacity(0.7);
                    buttonTextStyle = theme.textTheme.headlineMedium!
                        .copyWith(color: theme.colorScheme.tertiary);
                    break;
                  case '=':
                    buttonStyle = theme.colorScheme.secondary;
                    buttonTextStyle = theme.textTheme.headlineMedium!;
                    break;
                  default:
                    buttonTextStyle = theme.textTheme.headlineMedium!;
                }

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: buttonStyle,
                    shape: const CircleBorder(),
                  ),
                  child: Text(
                    widget.logic.numberPad[index],
                    style: buttonTextStyle,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.logic.userInput(widget.logic.numberPad[index]);
                    });
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
