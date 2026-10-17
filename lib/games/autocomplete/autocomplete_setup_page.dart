import 'package:flutter/material.dart';

import '../../theme/styles.dart';
import '../../translations/translations.dart';
import '../game_catalog.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_setup.dart';
import 'autocomplete_data.dart';
import 'autocomplete_game.dart';
import 'autocomplete_play_page.dart';

class AutocompleteSetupPage extends StatefulWidget {
  const AutocompleteSetupPage({super.key});

  @override
  State<AutocompleteSetupPage> createState() => _AutocompleteSetupPageState();
}

class _AutocompleteSetupPageState extends State<AutocompleteSetupPage> {
  AutocompleteSettings _settings = const AutocompleteSettings();
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

  void _update(AutocompleteSettings next) => setState(() => _settings = next);

  void _start() {
    final settings = _settings.copyWith(
      players: _settings.isMultiplayer
          ? PlayerNameFields.namesOf(_players)
          : const [],
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AutocompletePlayPage(settings: settings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameSetupScaffold(
      game: GameCatalog.autocomplete,
      subtitle: Translations.autocompleteSubtitle,
      children: [
        GameModeTabs(
          multiplayer: _settings.isMultiplayer,
          singleLabel: Translations.tripleStepSingle,
          multiLabel: Translations.tripleStepMulti,
          onChanged: (multi) => _update(
            _settings.copyWith(
              mode: multi
                  ? AutocompleteMode.multiplayer
                  : AutocompleteMode.singlePlayer,
            ),
          ),
        ),
        if (_settings.isMultiplayer) ...[
          const SizedBox(height: 20),
          Text(Translations.tripleStepPlayers, style: AppStyles.label),
          const SizedBox(height: 8),
          PlayerNameFields(
            controllers: _players,
            onAdd: () => setState(() {
              _players.add(
                TextEditingController(
                  text: Translations.playerName(_players.length + 1),
                ),
              );
            }),
            onRemove: (i) => setState(() => _players.removeAt(i).dispose()),
          ),
        ],
        const SizedBox(height: 24),
        GameSliderRow(
          icon: Icons.timer_outlined,
          label: Translations.autocompleteSecondsPerRound,
          valueLabel: Translations.seconds(_settings.secondsPerRound),
          value: _settings.secondsPerRound.toDouble(),
          min: AutocompleteSettings.minSeconds.toDouble(),
          max: AutocompleteSettings.maxSeconds.toDouble(),
          divisions:
              AutocompleteSettings.maxSeconds - AutocompleteSettings.minSeconds,
          onChanged: (v) =>
              _update(_settings.copyWith(secondsPerRound: v.round())),
        ),
        const SizedBox(height: 20),
        GameSliderRow(
          icon: Icons.repeat_rounded,
          label: Translations.autocompleteRounds,
          valueLabel: '${_settings.rounds}',
          value: _settings.rounds.toDouble(),
          min: AutocompleteSettings.minRounds.toDouble(),
          max: AutocompleteSettings.maxRounds.toDouble(),
          divisions:
              AutocompleteSettings.maxRounds - AutocompleteSettings.minRounds,
          onChanged: (v) => _update(_settings.copyWith(rounds: v.round())),
        ),
        const SizedBox(height: 16),
        Text(Translations.autocompletePhraseSet, style: AppStyles.label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _settings.phraseSet,
          borderRadius: BorderRadius.circular(12),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.style_outlined),
          ),
          items: [
            for (final name in AutocompleteData.setNames)
              DropdownMenuItem(
                value: name,
                child: Text(Translations.wordSetName(name)),
              ),
          ],
          onChanged: (v) {
            if (v != null) _update(_settings.copyWith(phraseSet: v));
          },
        ),
        const SizedBox(height: 32),
        GameStartButton(label: Translations.tripleStepStart, onPressed: _start),
      ],
    );
  }
}
