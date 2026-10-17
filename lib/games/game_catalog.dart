import 'package:flutter/material.dart';

/// One step of a game's "How to play" popup.
class HowToStep {
  const HowToStep(this.icon, this.text);

  final IconData icon;
  final String text;
}

/// One entry in the games hub. Add a new game by adding an entry here and a
/// route for it in [AppRoutes]; its card, setup header and "How to play"
/// popup come from this entry automatically.
class GameInfo {
  const GameInfo({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.skills,
    this.howToPlay = const [],
    this.tip,
    this.route,
  });

  final String id;
  final String title;
  final String tagline;
  final String description;
  final IconData icon;
  final List<String> skills;

  /// Three or four short steps shown in the "How to play" popup.
  final List<HowToStep> howToPlay;

  /// Optional one-line tip shown under the steps.
  final String? tip;

  /// Null while the game is still being built.
  final String? route;

  bool get available => route != null;
}

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String games = '/games';
  static const String tripleStep = '/games/triple-step';
  static const String conductor = '/games/conductor';
  static const String podcast = '/games/podcast';
  static const String autocomplete = '/games/autocomplete';
}

class GameCatalog {
  GameCatalog._();

  static const GameInfo tripleStep = GameInfo(
    id: 'triple-step',
    title: 'Triple Step',
    tagline: 'Speak on a topic while weaving in surprise words.',
    description:
        'Get a topic and keep talking. Random words pop up one at a time, '
        'and you work each one into your speech.',
    icon: Icons.record_voice_over_rounded,
    skills: ['Impromptu', 'Focus', 'Flow'],
    route: AppRoutes.tripleStep,
    howToPlay: [
      HowToStep(Icons.tune_rounded, 'Pick how many words and how long.'),
      HowToStep(
        Icons.record_voice_over_rounded,
        'You get a topic. Start talking about it.',
      ),
      HowToStep(
        Icons.bolt_rounded,
        'A new word pops up every few seconds. Use it in your speech.',
      ),
      HowToStep(Icons.flag_rounded, 'Keep going until the timer ends.'),
    ],
    tip: "It's fine if a word doesn't fit. Make it fit. That's the fun!",
  );

  static const GameInfo conductor = GameInfo(
    id: 'conductor',
    title: 'The Conductor',
    tagline: 'Follow the pitch from 1 (low) to 10 (high).',
    description:
        'Talk on a topic while a pitch number changes at random. Move '
        'your voice up and down to match it and build vocal variety.',
    icon: Icons.graphic_eq_rounded,
    skills: ['Pitch', 'Vocal variety', 'Control'],
    route: AppRoutes.conductor,
    howToPlay: [
      HowToStep(
        Icons.record_voice_over_rounded,
        'You get a topic. Talk about it.',
      ),
      HowToStep(
        Icons.looks_one_rounded,
        'A number from 1 to 10 shows on screen.',
      ),
      HowToStep(
        Icons.graphic_eq_rounded,
        '1 = low, deep voice. 10 = high, bright voice.',
      ),
      HowToStep(
        Icons.swap_vert_rounded,
        'When the number changes, change your voice to match.',
      ),
    ],
    tip: "Exaggerate! It feels silly, but it's how you build range.",
  );

  static const GameInfo podcast = GameInfo(
    id: 'podcast',
    title: 'The Podcast Game',
    tagline: 'One topic, a group, and the mic keeps jumping.',
    description:
        'Everyone shares one topic. A name lights up on screen and that '
        'person speaks until the name switches to someone else.',
    icon: Icons.podcasts_rounded,
    skills: ['Group', 'Listening', 'Quick thinking'],
    route: AppRoutes.podcast,
    howToPlay: [
      HowToStep(Icons.group_add_rounded, 'Add everyone who is playing.'),
      HowToStep(Icons.topic_rounded, 'The whole group gets one topic.'),
      HowToStep(Icons.mic_rounded, 'The name on screen is who talks now.'),
      HowToStep(
        Icons.shuffle_rounded,
        'When the name changes, the new person picks up where the last one stopped.',
      ),
    ],
    tip: 'Listen closely so you can continue the story when it is your turn.',
  );

  static const GameInfo autocomplete = GameInfo(
    id: 'autocomplete',
    title: 'Autocomplete',
    tagline: 'Rapid fire: finish the sentence out loud, fast.',
    description:
        'A sentence starter appears, sometimes silly, sometimes deep. '
        'Finish it out loud before the timer runs out. Then the next one!',
    icon: Icons.bolt_rounded,
    skills: ['Rapid fire', 'Creativity', 'Confidence'],
    route: AppRoutes.autocomplete,
    howToPlay: [
      HowToStep(Icons.short_text_rounded, 'A half-finished sentence appears.'),
      HowToStep(
        Icons.record_voice_over_rounded,
        'Finish it out loud. Any answer works, even a silly one.',
      ),
      HowToStep(Icons.timer_outlined, 'Beat the little timer.'),
      HowToStep(
        Icons.skip_next_rounded,
        'A new sentence comes right away. Keep going!',
      ),
    ],
    tip: "Don't stop to think of the perfect answer. Say the first thing!",
  );

  static const List<GameInfo> games = [
    tripleStep,
    conductor,
    podcast,
    autocomplete,
    GameInfo(
      id: 'coming-soon',
      title: 'More games soon',
      tagline: 'New speaking games are on the way.',
      description: 'We are building more ways to practice. Check back soon.',
      icon: Icons.auto_awesome_rounded,
      skills: [],
    ),
  ];
}
