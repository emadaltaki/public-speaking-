import 'package:flutter/material.dart';

import '../games/game_catalog.dart';
import '../games/game_theme.dart';
import '../games/games_hub_page.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'auth_service.dart';
import 'auth_storage.dart';
import 'progress_store.dart';

/// "Sign in" in the header, or the signed-in visitor's name linking to
/// their account page.
class AccountButton extends StatelessWidget {
  const AccountButton({super.key, this.compact = false});

  /// Icon-sized version for the phone header.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: AuthService.user,
      builder: (context, user, _) {
        if (user == null) {
          final route = ModalRoute.of(context)?.settings.name ?? '/';
          return TextButton.icon(
            onPressed: () => AuthService.signIn(returnTo: route),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.navy,
              shape: const StadiumBorder(),
              minimumSize: const Size(44, 44),
              padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
              textStyle: AppStyles.navLink,
            ),
            icon: const Icon(Icons.account_circle_outlined, size: 22),
            label: compact
                ? const SizedBox.shrink()
                : Text(Translations.accountSignIn, style: AppStyles.navLink),
          );
        }
        return Tooltip(
          message: Translations.accountTitle,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => AppRoutes.open(context, AppRoutes.account),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Avatar(user: user, size: 34),
                  if (!compact) ...[
                    const SizedBox(width: 8),
                    Text(user.shortName, style: AppStyles.navLink),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user, required this.size});

  final AppUser user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.panel, shape: BoxShape.circle),
      child: Text(
        user.initial,
        style: AppStyles.label.copyWith(
          color: Colors.white,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}

/// The visitor's profile and practice history.
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;
    return Title(
      title: '${Translations.accountTitle} | ${Translations.siteName}',
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
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: ValueListenableBuilder<AppUser?>(
                      valueListenable: AuthService.user,
                      builder: (context, user, _) => user == null
                          ? const _SignedOut()
                          : _SignedIn(user: user),
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
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppStyles.softShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: GameColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights_rounded,
              color: GameColors.accent,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            Translations.accountSignedOutTitle,
            textAlign: TextAlign.center,
            style: AppStyles.title.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            Translations.accountSignedOutBody,
            textAlign: TextAlign.center,
            style: AppStyles.body,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: () =>
                    AuthService.signIn(returnTo: AppRoutes.account),
                style: AppStyles.primaryButtonLarge,
                child: Text(Translations.accountSignIn),
              ),
              OutlinedButton(
                onPressed: () => AuthService.signIn(
                  returnTo: AppRoutes.account,
                  signUp: true,
                ),
                style: AppStyles.secondaryButton,
                child: Text(Translations.accountCreate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignedIn extends StatelessWidget {
  const _SignedIn({required this.user});

  final AppUser user;

  String get _firstName {
    final n = user.shortName.trim();
    if (n.isEmpty) return n;
    return n[0].toUpperCase() + n.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileHeader(user: user, firstName: _firstName),
        const SizedBox(height: 16),
        ValueListenableBuilder<int>(
          valueListenable: store.changes,
          builder: (context, _, _) => FutureBuilder<List<GameSession>>(
            future: store.history(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _History(sessions: snapshot.data!);
            },
          ),
        ),
        const SizedBox(height: 16),
        const _BookCard(),
        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: AuthService.signOut,
            style: TextButton.styleFrom(foregroundColor: AppColors.mutedText),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(Translations.accountSignOut),
          ),
        ),
      ],
    );
  }
}

/// Warm banner with the visitor's initial, a greeting and their email.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.firstName});

  final AppUser user;
  final String firstName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC8643F), Color(0xFF8E3B22)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8E3B22).withValues(alpha: .35),
            blurRadius: 30,
            offset: const Offset(0, 14),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .5),
                width: 2,
              ),
            ),
            child: Text(
              user.initial,
              style: AppStyles.title.copyWith(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.accountHello(firstName),
                  style: AppStyles.title.copyWith(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (user.email != null)
                  Text(
                    user.email!,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: .85),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small nudge back to booking a call.
class _BookCard extends StatelessWidget {
  const _BookCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: GameColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.event_available_rounded,
              color: GameColors.accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.accountBookTitle,
                  style: AppStyles.label.copyWith(fontSize: 16),
                ),
                Text(Translations.accountBookBody, style: AppStyles.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => openSitePage('/#book'),
            style: FilledButton.styleFrom(
              backgroundColor: GameColors.accent,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(Translations.accountBookCta),
          ),
        ],
      ),
    );
  }
}

/// The four games as colourful tiles that open each one.
class _GameTiles extends StatelessWidget {
  const _GameTiles();

  static const _gradients = [
    [Color(0xFFC8643F), Color(0xFF8E3B22)],
    [Color(0xFF3F6F8E), Color(0xFF23455E)],
    [Color(0xFF7A4E9A), Color(0xFF4A2C66)],
    [Color(0xFFD49A4E), Color(0xFF9C6420)],
  ];

  @override
  Widget build(BuildContext context) {
    final games = GameCatalog.games.where((g) => g.available).toList();
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 118,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (var i = 0; i < games.length; i++)
          Material(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradients[i % _gradients.length],
                ),
              ),
              child: InkWell(
                onTap: () => AppRoutes.open(context, games[i].route!),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          games[i].icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        games[i].title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.label.copyWith(
                          color: Colors.white,
                          fontSize: 15.5,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _History extends StatelessWidget {
  const _History({required this.sessions});

  final List<GameSession> sessions;

  static String _minutes(Duration d) {
    final m = (d.inSeconds / 60).round();
    return Translations.minutesShort(m < 1 && d.inSeconds > 0 ? 1 : m);
  }

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(Translations.accountStartTitle, style: AppStyles.title),
            const SizedBox(height: 4),
            Text(Translations.accountNoHistory, style: AppStyles.bodySmall),
            const SizedBox(height: 16),
            const _GameTiles(),
          ],
        ),
      );
    }
    final total = sessions.fold(Duration.zero, (sum, s) => sum + s.spoken);
    final games = {for (final g in GameCatalog.games) g.id: g};
    final byGame = <String, List<GameSession>>{};
    for (final s in sessions) {
      byGame.putIfAbsent(s.gameId, () => []).add(s);
    }
    final dateFormat = MaterialLocalizations.of(context);

    Widget stat(String value, String label) => Expanded(
      child: _Card(
        child: Column(
          children: [
            Text(
              value,
              style: AppStyles.display.copyWith(
                fontSize: 36,
                color: GameColors.accent,
              ),
            ),
            Text(label, style: AppStyles.bodySmall),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            stat('${sessions.length}', Translations.accountRounds),
            const SizedBox(width: 16),
            stat(_minutes(total), Translations.accountSpeakingTime),
          ],
        ),
        const SizedBox(height: 20),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(Translations.accountByGame, style: AppStyles.title),
              const SizedBox(height: 8),
              for (final entry in byGame.entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    games[entry.key]?.icon ?? Icons.sports_esports_outlined,
                    color: GameColors.accent,
                  ),
                  title: Text(
                    games[entry.key]?.title ?? entry.key,
                    style: AppStyles.label.copyWith(fontSize: 16),
                  ),
                  trailing: Text(
                    '${Translations.roundsCount(entry.value.length)} · '
                    '${_minutes(entry.value.fold(Duration.zero, (a, s) => a + s.spoken))}',
                    style: AppStyles.bodySmall,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(Translations.accountRecent, style: AppStyles.title),
              const SizedBox(height: 8),
              for (final s in sessions.take(10))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    games[s.gameId]?.icon ?? Icons.sports_esports_outlined,
                    color: AppColors.mutedText,
                  ),
                  title: Text(
                    s.topic ?? games[s.gameId]?.title ?? s.gameId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.body.copyWith(fontSize: 15),
                  ),
                  subtitle: Text(
                    '${games[s.gameId]?.title ?? s.gameId} · '
                    '${dateFormat.formatShortDate(s.playedAt)}',
                    style: AppStyles.bodySmall.copyWith(fontSize: 13),
                  ),
                  trailing: Text(_minutes(s.spoken), style: AppStyles.label),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows [child] only to signed-in visitors; everyone else gets a prompt
/// to create a free account (games are for members).
class SignInGate extends StatelessWidget {
  const SignInGate({super.key, required this.child, this.returnTo});

  final Widget child;

  /// Where to come back to after signing in (defaults to this page).
  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: AuthService.user,
      builder: (context, user, _) {
        if (user != null) return child;
        final route =
            returnTo ??
            ModalRoute.of(context)?.settings.name ??
            AppRoutes.games;
        return _Card(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: GameColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_open_rounded,
                  color: GameColors.accent,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                Translations.gamesGateTitle,
                textAlign: TextAlign.center,
                style: AppStyles.title.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                Translations.gamesGateBody,
                textAlign: TextAlign.center,
                style: AppStyles.body,
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final game in GameCatalog.games.where(
                    (g) => g.available,
                  ))
                    Chip(
                      avatar: Icon(
                        game.icon,
                        size: 18,
                        color: GameColors.accent,
                      ),
                      label: Text(game.title),
                      backgroundColor: AppColors.offWhite,
                      side: BorderSide(color: AppColors.border),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  FilledButton(
                    onPressed: () =>
                        AuthService.signIn(returnTo: route, signUp: true),
                    style: AppStyles.primaryButtonLarge,
                    child: Text(Translations.gamesGateSignUp),
                  ),
                  OutlinedButton(
                    onPressed: () => AuthService.signIn(returnTo: route),
                    style: AppStyles.secondaryButton,
                    child: Text(Translations.gamesGateSignIn),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
