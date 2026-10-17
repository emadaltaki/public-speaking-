import 'package:flutter/material.dart';

/// One entry in the games hub. Add a new game by adding an entry here and a
/// route for it in [AppRoutes].
class GameInfo {
  const GameInfo({
    required this.id,
    required this.title,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.skills,
    this.route,
  });

  final String id;
  final String title;
  final String tagline;
  final String description;
  final IconData icon;
  final List<String> skills;

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
}

class GameCatalog {
  GameCatalog._();

  static const List<GameInfo> games = [
    GameInfo(
      id: 'triple-step',
      title: 'Triple Step',
      tagline: 'Speak on a topic while weaving in surprise words.',
      description:
          'Get a topic and a list of random words. Keep talking and work '
          'every word into your speech before the timer runs out.',
      icon: Icons.record_voice_over_rounded,
      skills: ['Impromptu', 'Focus', 'Flow'],
      route: AppRoutes.tripleStep,
    ),
    GameInfo(
      id: 'conductor',
      title: 'The Conductor',
      tagline: 'Follow the pitch from 1 (low) to 10 (high).',
      description:
          'Talk on a topic while a pitch number changes at random. Move '
          'your voice up and down to match it and build vocal variety.',
      icon: Icons.graphic_eq_rounded,
      skills: ['Pitch', 'Vocal variety', 'Control'],
      route: AppRoutes.conductor,
    ),
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
