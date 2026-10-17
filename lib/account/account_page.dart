import 'dart:convert';

import 'package:flutter/material.dart';

import '../games/game_catalog.dart';
import '../games/game_theme.dart';
import '../games/games_hub_page.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'auth_service.dart';
import 'auth_storage.dart';
import 'avatar_store.dart';
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
    return ValueListenableBuilder<String?>(
      valueListenable: AvatarStore.photo,
      builder: (context, photo, _) => AvatarCircle(
        user: user,
        photo: photo,
        size: size,
        color: AppColors.panel,
      ),
    );
  }
}

/// A round profile picture: the uploaded photo, then the Google photo,
/// then the first letter of the visitor's name.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.user,
    required this.photo,
    required this.size,
    required this.color,
    this.border,
  });

  final AppUser user;
  final String? photo;
  final double size;
  final Color color;
  final BoxBorder? border;

  static final Map<String, MemoryImage> _decoded = {};

  static ImageProvider? imageFor(String? photo, String? googleUrl) {
    if (photo != null && photo.startsWith('data:image')) {
      return _decoded.putIfAbsent(photo, () {
        final comma = photo.indexOf(',');
        return MemoryImage(base64Decode(photo.substring(comma + 1)));
      });
    }
    if (googleUrl != null && googleUrl.isNotEmpty) {
      return NetworkImage(googleUrl);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final image = imageFor(photo, user.photoUrl);
    final letter = Text(
      user.initial,
      style: AppStyles.label.copyWith(
        color: Colors.white,
        fontSize: size * 0.42,
        fontWeight: FontWeight.w800,
      ),
    );
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: image == null ? color : null,
        shape: BoxShape.circle,
        image: image == null
            ? null
            : DecorationImage(
                image: image,
                fit: BoxFit.cover,
                onError: (_, _) {},
              ),
      ),
      foregroundDecoration: border == null
          ? null
          : BoxDecoration(shape: BoxShape.circle, border: border),
      child: image == null ? letter : null,
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
                child: RepaintBoundary(
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

/// Warm banner with the visitor's photo, a greeting and their email.
class _ProfileHeader extends StatefulWidget {
  const _ProfileHeader({required this.user, required this.firstName});

  final AppUser user;
  final String firstName;

  @override
  State<_ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<_ProfileHeader> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    AvatarStore.refresh();
  }

  /// Opens the phone's own photo picker straight away (on iPhone it offers
  /// Photo Library, Take Photo or Choose File), so there is only one menu.
  void _pick() {
    final pending = pickSquarePhoto();
    _save(pending);
  }

  void _remove() => _save(Future.value(null), removing: true);

  Future<void> _save(Future<String?> pending, {bool removing = false}) async {
    final photo = await pending;
    if (!mounted || (photo == null && !removing)) return;
    setState(() => _busy = true);
    final saved = await AvatarStore.save(photo);
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          saved
              ? Translations.accountPhotoSaved
              : Translations.accountPhotoLocal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Container(
      padding: const EdgeInsets.all(22),
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
            blurRadius: 14,
            offset: const Offset(0, 14),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: Translations.accountPhotoChange,
            child: GestureDetector(
              onTap: _busy ? null : _pick,
              child: SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: AvatarStore.photo,
                      builder: (context, photo, _) => AvatarCircle(
                        user: user,
                        photo: photo,
                        size: 72,
                        color: Colors.white.withValues(alpha: .18),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    if (_busy)
                      const Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    PositionedDirectional(
                      end: -2,
                      bottom: -2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          size: 16,
                          color: Color(0xFF8E3B22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translations.accountHello(widget.firstName),
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
                ValueListenableBuilder<String?>(
                  valueListenable: AvatarStore.photo,
                  builder: (context, photo, _) => photo == null
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: _busy ? null : _remove,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              Translations.accountPhotoRemove,
                              style: AppStyles.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
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
