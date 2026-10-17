import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../game_theme.dart';

/// Setup-form controls shared by the games.

class GameSliderRow extends StatelessWidget {
  const GameSliderRow({
    super.key,
    required this.icon,
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.help,
  });

  final IconData icon;
  final String label;
  final String? help;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: GameColors.accentDark),
            const SizedBox(width: 8),
            Text(label, style: AppStyles.label.copyWith(fontSize: 15)),
            if (help != null) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: help!,
                triggerMode: TooltipTriggerMode.tap,
                preferBelow: false,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.help_outline_rounded,
                    size: 18,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ],
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: GameColors.accentSoft,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                valueLabel,
                style: AppStyles.label.copyWith(color: GameColors.accentDark),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: GameColors.accent,
            inactiveTrackColor: GameColors.track,
            thumbColor: GameColors.accent,
            overlayColor: GameColors.accent.withValues(alpha: 0.15),
            trackHeight: 6,
            showValueIndicator: ShowValueIndicator.never,
            tickMarkShape: SliderTickMarkShape.noTickMark,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            semanticFormatterCallback: (_) => valueLabel,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class GameToggleRow extends StatelessWidget {
  const GameToggleRow({
    super.key,
    required this.label,
    required this.help,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String help;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: AppStyles.label.copyWith(fontSize: 15)),
        subtitle: Text(help, style: AppStyles.bodySmall.copyWith(fontSize: 13)),
        onTap: () => onChanged(!value),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: GameColors.accent,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFCBD3DA),
          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
    );
  }
}

/// The big amber START TRAINING button.
class GameStartButton extends StatelessWidget {
  const GameStartButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: FilledButton.icon(
        onPressed: onPressed,
        style:
            FilledButton.styleFrom(
              backgroundColor: GameColors.accent,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              textStyle: AppStyles.label.copyWith(
                fontSize: 17,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w800,
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.hovered)
                    ? GameColors.accentDark
                    : GameColors.accent,
              ),
            ),
        icon: const Icon(Icons.play_arrow_rounded, size: 26),
        label: Text(label),
      ),
    );
  }
}

/// Single Player / Multiplayer switch.
class GameModeTabs extends StatelessWidget {
  const GameModeTabs({
    super.key,
    required this.multiplayer,
    required this.onChanged,
    required this.singleLabel,
    required this.multiLabel,
  });

  final bool multiplayer;
  final ValueChanged<bool> onChanged;
  final String singleLabel;
  final String multiLabel;

  @override
  Widget build(BuildContext context) {
    Widget tab(bool value, IconData icon, String label) {
      final selected = multiplayer == value;
      return Expanded(
        child: Semantics(
          selected: selected,
          button: true,
          child: GestureDetector(
            onTap: () => onChanged(value),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: selected ? AppStyles.softShadow : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: selected
                          ? GameColors.accentDark
                          : AppColors.mutedText,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.label.copyWith(
                          color: selected
                              ? AppColors.navy
                              : AppColors.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: GameColors.track,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          tab(false, Icons.person_rounded, singleLabel),
          tab(true, Icons.groups_rounded, multiLabel),
        ],
      ),
    );
  }
}
