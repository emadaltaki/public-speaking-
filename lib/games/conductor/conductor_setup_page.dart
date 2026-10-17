import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../game_theme.dart';
import '../games_hub_page.dart';
import '../triple_step/triple_step_data.dart';
import '../widgets/game_controls.dart';
import 'conductor_game.dart';
import 'conductor_play_page.dart';

/// The Conductor setup: timer, title suggestion and word set.
class ConductorSetupPage extends StatefulWidget {
  const ConductorSetupPage({super.key});

  @override
  State<ConductorSetupPage> createState() => _ConductorSetupPageState();
}

class _ConductorSetupPageState extends State<ConductorSetupPage> {
  ConductorSettings _settings = const ConductorSettings();

  void _update(ConductorSettings next) => setState(() => _settings = next);

  void _start() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConductorPlayPage(settings: _settings),
      ),
    );
  }

  String _timerLabel(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (s == 0) return m == 1 ? '1 minute' : '$m minutes';
    return '$m:${s.toString().padLeft(2, '0')} min';
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    return Title(
      title: 'The Conductor | ${Translations.siteName}',
      color: AppColors.navy,
      child: Scaffold(
        backgroundColor: GameColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GamesHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: wide ? 48 : 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppStyles.elevatedShadow,
                      ),
                      padding: EdgeInsets.all(wide ? 36 : 22),
                      child: _form(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: GameColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.graphic_eq_rounded, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translations.conductorTitle,
                    style: AppStyles.title.copyWith(fontSize: 24),
                  ),
                  Text(
                    Translations.conductorSetupSubtitle,
                    style: AppStyles.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: Translations.tripleStepBackToGames,
              onPressed: () => Navigator.of(context).canPop()
                  ? Navigator.of(context).pop()
                  : Navigator.of(context).pushReplacementNamed(AppRoutes.games),
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GameColors.accentSoft,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            Translations.conductorHowTo,
            style: AppStyles.bodySmall.copyWith(color: AppColors.navy),
          ),
        ),
        const SizedBox(height: 24),
        GameSliderRow(
          icon: Icons.schedule_rounded,
          label: Translations.tripleStepTimer,
          valueLabel: _timerLabel(_settings.timerSeconds),
          value: _settings.timerSeconds.toDouble(),
          min: ConductorSettings.minTimerSeconds.toDouble(),
          max: ConductorSettings.maxTimerSeconds.toDouble(),
          divisions:
              (ConductorSettings.maxTimerSeconds -
                  ConductorSettings.minTimerSeconds) ~/
              ConductorSettings.timerStepSeconds,
          onChanged: (v) =>
              _update(_settings.copyWith(timerSeconds: v.round())),
        ),
        const SizedBox(height: 16),
        GameToggleRow(
          label: Translations.tripleStepSuggestTitle,
          help: Translations.tripleStepSuggestTitleHelp,
          value: _settings.suggestTitle,
          onChanged: (v) => _update(_settings.copyWith(suggestTitle: v)),
        ),
        const SizedBox(height: 16),
        Text(Translations.tripleStepWordSet, style: AppStyles.label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _settings.wordSet,
          borderRadius: BorderRadius.circular(12),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.style_outlined),
          ),
          items: [
            for (final name in TripleStepData.wordSetNames)
              DropdownMenuItem(value: name, child: Text(name)),
          ],
          onChanged: _settings.suggestTitle
              ? (v) {
                  if (v != null) _update(_settings.copyWith(wordSet: v));
                }
              : null,
        ),
        const SizedBox(height: 32),
        GameStartButton(label: Translations.tripleStepStart, onPressed: _start),
      ],
    );
  }
}
