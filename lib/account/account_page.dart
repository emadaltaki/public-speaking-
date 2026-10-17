import 'package:flutter/material.dart';

import '../games/game_catalog.dart';
import '../games/game_theme.dart';
import '../games/games_hub_page.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'auth_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final store = ProgressStore.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(user: user, size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName?.isNotEmpty == true
                          ? user.displayName!
                          : user.shortName,
                      style: AppStyles.title.copyWith(fontSize: 22),
                    ),
                    if (user.email != null)
                      Text(
                        user.email!,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: AuthService.signOut,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: AppColors.teal,
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(Translations.accountSignOut),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
          children: [
            Icon(
              Icons.sports_esports_outlined,
              size: 36,
              color: GameColors.accent,
            ),
            const SizedBox(height: 12),
            Text(
              Translations.accountNoHistory,
              textAlign: TextAlign.center,
              style: AppStyles.body,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => AppRoutes.open(context, AppRoutes.games),
              style: AppStyles.primaryButton,
              child: Text(Translations.navGames),
            ),
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
