import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/theme.dart';
import 'theme/theme_provider.dart';
import 'util/logic.dart';
import 'util/number_pad.dart';
import 'util/result_holder.dart';

class MidCalc extends StatefulWidget {
  const MidCalc({super.key});

  @override
  State<MidCalc> createState() => _MidCalcState();
}

class _MidCalcState extends State<MidCalc> {
  final Logic logic = Logic();
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    _loadSelectedButton();
  }

  Future<void> _loadSelectedButton() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSelected = [prefs.getBool('isDarkMode') ?? true, !isSelected[0]];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: ToggleButtons(
          isSelected: isSelected,
          borderColor: theme.colorScheme.onSurface,
          selectedBorderColor: theme.colorScheme.onSurface,
          borderWidth: 2,
          color: theme.colorScheme.onSurface,
          fillColor: theme.colorScheme.onSurface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          constraints:
              BoxConstraints(minWidth: MediaQuery.of(context).size.width / 8),
          onPressed: (index) {
            setState(() {
              isSelected = [index == 0, index == 1];
              context.read<ThemeProvider>().themeData =
                  index == 0 ? darkMode : lightMode;
            });
          },
          children: [
            Icon(
              isSelected[0] ? Icons.dark_mode : Icons.dark_mode_outlined,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
            Icon(
              isSelected[1] ? Icons.light_mode : Icons.light_mode_outlined,
              color: theme.colorScheme.onSurface,
              size: 20,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ResultHolder(logic: logic),
          const Divider(),
          NumberPad(logic: logic),
        ],
      ),
    );
  }
}
