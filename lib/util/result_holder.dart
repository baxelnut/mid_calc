import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'logic.dart';

class ResultHolder extends StatefulWidget {
  final Logic logic;
  const ResultHolder({super.key, required this.logic});

  @override
  State<ResultHolder> createState() => _ResultHolderState();
}

class _ResultHolderState extends State<ResultHolder> {
  int digitCount = 0;

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    });
  }

  _checkSpecialValues() {
    var topText = widget.logic.operation.value;
    final bottomText = widget.logic.result.value;

    if (topText.contains('--')) {
      widget.logic.operation.value = topText.replaceAll('--', '');
      return widget.logic.operation.value;
    }

    if (topText == '1+1' && widget.logic.isResultDisplayed) {
      _showSnackBar('bruh');
    } else if (['69', '420', '69420', '42069'].contains(bottomText)) {
      _showSnackBar('nice');
    } else if (RegExp(r'[+\-*/]$').hasMatch(topText)) {
      digitCount = 0;
    } else {
      digitCount = topText.replaceAll(RegExp(r'[^0-9.]'), '').length;
    }

    if (digitCount >= 69) {
      _showSnackBar('bro what you counting?');
      widget.logic.operation.value = topText.substring(0, topText.length - 1);
    }
  }

  void _historyBottomSheet() {
    ThemeData theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 400,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              if (widget.logic.history.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Empty',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: widget.logic.history.length,
                      itemBuilder: (context, index) {
                        final historyItem = widget.logic.history[index];
                        return ListTile(
                          title: Text(
                            historyItem['operation']!,
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            historyItem['result']!,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.copy_outlined,
                                size: 20, color: theme.colorScheme.onSurface),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: historyItem['result']!));
                              Navigator.pop(context);
                              _showSnackBar('Copied to clipboard');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onSurface,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    setState(() {
                      widget.logic.clearHistory();
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Clear History',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatResult(String result) {
    double? number = double.tryParse(result);
    if (number != null && result.contains('.')) {
      return number.toStringAsFixed(10).replaceAll(RegExp(r'\.?0+$'), '');
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ValueListenableBuilder<String>(
                  valueListenable: widget.logic.result,
                  builder: (context, resultValue, child) {
                    return Text(
                      _checkSpecialValues() ?? widget.logic.operation.value,
                      style: widget.logic.isResultDisplayed
                          ? theme.textTheme.headlineSmall!.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            )
                          : theme.textTheme.headlineMedium,
                    );
                  },
                ),
              ),
            ),
            ValueListenableBuilder<String>(
              valueListenable: widget.logic.result,
              builder: (context, resultValue, child) {
                final formattedResult = formatResult(resultValue);

                return Text(
                  formattedResult,
                  style: widget.logic.isResultDisplayed
                      ? theme.textTheme.headlineLarge
                      : theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.history_outlined,
                    color: theme.colorScheme.onSurface,
                    size: 26,
                  ),
                  onTap: () => _historyBottomSheet(),
                ),
                const Spacer(),
                GestureDetector(
                  child: Icon(
                    Icons.backspace_outlined,
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onTap: () => widget.logic.userInput('⌫'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
