import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../game_theme.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_setup.dart';
import 'triple_step_data.dart';
import 'triple_step_game.dart';
import 'triple_step_play_page.dart';

/// Phase 1: choose the mode and rules, then start training.
class TripleStepSetupPage extends StatefulWidget {
  const TripleStepSetupPage({super.key});

  @override
  State<TripleStepSetupPage> createState() => _TripleStepSetupPageState();
}

class _TripleStepSetupPageState extends State<TripleStepSetupPage> {
  static const int _maxPlayers = 6;

  TripleStepSettings _settings = const TripleStepSettings();
  final List<TextEditingController> _players = [
    TextEditingController(text: Translations.playerName(1)),
    TextEditingController(text: Translations.playerName(2)),
  ];

  @override
  void dispose() {
    for (final c in _players) {
      c.dispose();
    }
    super.dispose();
  }

  void _update(TripleStepSettings next) => setState(() => _settings = next);

  void _start() {
    final names = [
      for (var i = 0; i < _players.length; i++)
        _players[i].text.trim().isEmpty
            ? Translations.playerName(i + 1)
            : _players[i].text.trim(),
    ];
    final settings = _settings.copyWith(
      players: _settings.isMultiplayer ? names : const [],
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TripleStepPlayPage(settings: settings),
      ),
    );
  }

  String _timerLabel(int seconds) => Translations.timerLabel(seconds);

  @override
  Widget build(BuildContext context) {
    return GameSetupScaffold(
      game: GameCatalog.tripleStep,
      subtitle: Translations.tripleStepSetupSubtitle,
      children: _fields(),
    );
  }

  List<Widget> _fields() {
    return [
      _ModeTabs(
        mode: _settings.mode,
        onChanged: (m) => _update(_settings.copyWith(mode: m)),
      ),
      if (_settings.isMultiplayer) ...[
        const SizedBox(height: 20),
        _playersEditor(),
      ],
      const SizedBox(height: 28),
      GameSliderRow(
        icon: Icons.format_list_numbered_rounded,
        label: Translations.tripleStepTopics,
        help: Translations.tripleStepTopicsHelp,
        valueLabel: '${_settings.topicCount}',
        value: _settings.topicCount.toDouble(),
        min: TripleStepSettings.minTopicCount.toDouble(),
        max: TripleStepSettings.maxTopicCount.toDouble(),
        divisions:
            TripleStepSettings.maxTopicCount - TripleStepSettings.minTopicCount,
        onChanged: (v) => _update(_settings.copyWith(topicCount: v.round())),
      ),
      const SizedBox(height: 20),
      GameSliderRow(
        icon: Icons.schedule_rounded,
        label: Translations.tripleStepTimer,
        valueLabel: _timerLabel(_settings.timerSeconds),
        value: _settings.timerSeconds.toDouble(),
        min: TripleStepSettings.minTimerSeconds.toDouble(),
        max: TripleStepSettings.maxTimerSeconds.toDouble(),
        divisions:
            (TripleStepSettings.maxTimerSeconds -
                TripleStepSettings.minTimerSeconds) ~/
            TripleStepSettings.timerStepSeconds,
        onChanged: (v) => _update(_settings.copyWith(timerSeconds: v.round())),
      ),
      const SizedBox(height: 16),
      GameToggleRow(
        label: Translations.tripleStepSuggestTitle,
        help: Translations.tripleStepSuggestTitleHelp,
        value: _settings.suggestTitle,
        onChanged: (v) => _update(_settings.copyWith(suggestTitle: v)),
      ),
      GameToggleRow(
        label: Translations.tripleStepSurvival,
        help: Translations.tripleStepSurvivalHelp,
        value: _settings.survivalMode,
        onChanged: (v) => _update(_settings.copyWith(survivalMode: v)),
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
        onChanged: (v) {
          if (v != null) _update(_settings.copyWith(wordSet: v));
        },
      ),
      const SizedBox(height: 32),
      GameStartButton(label: Translations.tripleStepStart, onPressed: _start),
    ];
  }

  Widget _playersEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Translations.tripleStepPlayers, style: AppStyles.label),
        const SizedBox(height: 8),
        for (var i = 0; i < _players.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _players[i],
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      hintText: Translations.playerName(i + 1),
                    ),
                  ),
                ),
                if (_players.length > 2)
                  IconButton(
                    tooltip: Translations.tripleStepRemovePlayer,
                    onPressed: () => setState(() {
                      _players.removeAt(i).dispose();
                    }),
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
              ],
            ),
          ),
        if (_players.length < _maxPlayers)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() {
                _players.add(
                  TextEditingController(
                    text: Translations.playerName(_players.length + 1),
                  ),
                );
              }),
              style: TextButton.styleFrom(
                foregroundColor: GameColors.accentDark,
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(Translations.tripleStepAddPlayer),
            ),
          ),
      ],
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.mode, required this.onChanged});

  final TripleStepMode mode;
  final ValueChanged<TripleStepMode> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tab(TripleStepMode value, IconData icon, String label) {
      final selected = mode == value;
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
          tab(
            TripleStepMode.singlePlayer,
            Icons.person_rounded,
            Translations.tripleStepSingle,
          ),
          tab(
            TripleStepMode.multiplayer,
            Icons.groups_rounded,
            Translations.tripleStepMulti,
          ),
        ],
      ),
    );
  }
}
