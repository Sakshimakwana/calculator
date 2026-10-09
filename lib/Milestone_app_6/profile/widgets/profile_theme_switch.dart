import 'package:flutter/material.dart';
import '../../state/milestone_app_6_state.dart';

class MilestoneApp6ProfileThemeSwitch extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6ProfileThemeSwitch({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final bool dark = state.themeMode == ThemeMode.dark;

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(
        Icons.dark_mode_outlined,
      ),
      title: const Text(
        'Theme',
      ),
      subtitle: Text(
        dark ? 'Dark' : 'Light',
      ),
      value: dark,
      onChanged: state.setDarkMode,
    );
  }
}
