import 'package:flutter/material.dart';

import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../triple_step/triple_step_data.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_setup.dart';
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

  String _timerLabel(int seconds) => Translations.timerLabel(seconds);

  @override
  Widget build(BuildContext context) {
    return GameSetupScaffold(
      game: GameCatalog.conductor,
      subtitle: Translations.conductorSetupSubtitle,
      children: _fields(),
    );
  }

  List<Widget> _fields() {
    return [
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
        onChanged: (v) => _update(_settings.copyWith(timerSeconds: v.round())),
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
            DropdownMenuItem(
              value: name,
              child: Text(Translations.wordSetName(name)),
            ),
        ],
        onChanged: _settings.suggestTitle
            ? (v) {
                if (v != null) _update(_settings.copyWith(wordSet: v));
              }
            : null,
      ),
      const SizedBox(height: 32),
      GameStartButton(label: Translations.tripleStepStart, onPressed: _start),
    ];
  }
}
