import 'package:flutter/material.dart';

import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../game_theme.dart';
import '../triple_step/triple_step_data.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_setup.dart';
import 'podcast_game.dart';
import 'podcast_play_page.dart';

/// Podcast Game setup in two steps: the rules, then everyone's names.
class PodcastSetupPage extends StatefulWidget {
  const PodcastSetupPage({super.key});

  @override
  State<PodcastSetupPage> createState() => _PodcastSetupPageState();
}

class _PodcastSetupPageState extends State<PodcastSetupPage> {
  PodcastSettings _settings = const PodcastSettings();
  bool _namesStep = false;
  final List<TextEditingController> _names = [];

  @override
  void dispose() {
    for (final c in _names) {
      c.dispose();
    }
    super.dispose();
  }

  void _update(PodcastSettings next) => setState(() => _settings = next);

  void _next() {
    // Keep names already typed; add or trim fields to match the count.
    while (_names.length < _settings.playerCount) {
      _names.add(
        TextEditingController(text: Translations.playerName(_names.length + 1)),
      );
    }
    while (_names.length > _settings.playerCount) {
      _names.removeLast().dispose();
    }
    setState(() => _namesStep = true);
  }

  void _start() {
    final settings = _settings.copyWith(
      players: PlayerNameFields.namesOf(_names),
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PodcastPlayPage(settings: settings),
      ),
    );
  }

  String _timerLabel(int seconds) => Translations.timerLabel(seconds);

  @override
  Widget build(BuildContext context) {
    return GameSetupScaffold(
      game: GameCatalog.podcast,
      children: _namesStep ? _nameFields() : _ruleFields(),
    );
  }

  List<Widget> _ruleFields() {
    return [
      GameSliderRow(
        icon: Icons.schedule_rounded,
        label: Translations.tripleStepTimer,
        valueLabel: _timerLabel(_settings.timerSeconds),
        value: _settings.timerSeconds.toDouble(),
        min: PodcastSettings.minTimerSeconds.toDouble(),
        max: PodcastSettings.maxTimerSeconds.toDouble(),
        divisions:
            (PodcastSettings.maxTimerSeconds -
                PodcastSettings.minTimerSeconds) ~/
            PodcastSettings.timerStepSeconds,
        onChanged: (v) => _update(_settings.copyWith(timerSeconds: v.round())),
      ),
      const SizedBox(height: 20),
      GameSliderRow(
        icon: Icons.speed_rounded,
        label: Translations.podcastDifficulty,
        help: Translations.podcastDifficultyHelp,
        valueLabel: _settings.pace.label,
        value: _settings.pace.index.toDouble(),
        min: 0,
        max: (PodcastPace.values.length - 1).toDouble(),
        divisions: PodcastPace.values.length - 1,
        onChanged: (v) =>
            _update(_settings.copyWith(pace: PodcastPace.values[v.round()])),
      ),
      const SizedBox(height: 20),
      GameSliderRow(
        icon: Icons.groups_rounded,
        label: Translations.podcastPlayers,
        valueLabel: '${_settings.playerCount}',
        value: _settings.playerCount.toDouble(),
        min: PodcastSettings.minPlayers.toDouble(),
        max: PodcastSettings.maxPlayers.toDouble(),
        divisions: PodcastSettings.maxPlayers - PodcastSettings.minPlayers,
        onChanged: (v) => _update(_settings.copyWith(playerCount: v.round())),
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
      SizedBox(
        height: 58,
        child: FilledButton.icon(
          onPressed: _next,
          style: FilledButton.styleFrom(
            backgroundColor: GameColors.accent,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            textStyle: AppStyles.label.copyWith(
              fontSize: 17,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Text(Translations.podcastNext),
        ),
      ),
    ];
  }

  List<Widget> _nameFields() {
    return [
      Row(
        children: [
          IconButton(
            tooltip: Translations.podcastBackToRules,
            onPressed: () => setState(() => _namesStep = false),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 4),
          Text(Translations.podcastWhoIsPlaying, style: AppStyles.title),
        ],
      ),
      const SizedBox(height: 12),
      PlayerNameFields(controllers: _names),
      const SizedBox(height: 24),
      GameStartButton(label: Translations.tripleStepStart, onPressed: _start),
    ];
  }
}
