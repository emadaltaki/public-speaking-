import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'nav_link_button.dart';
import 'primary_button.dart';
import 'skip_to_content_link.dart';
import 'speech_mark_logo.dart';

class NavItem {
  const NavItem({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
}

class AppNavbar extends StatefulWidget {
  const AppNavbar({
    super.key,
    required this.items,
    required this.onJoinUs,
    required this.onSkipToContent,
  });

  final List<NavItem> items;
  final VoidCallback onJoinUs;
  final VoidCallback onSkipToContent;

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  bool _menuOpen = false;

  void _closeMenu() {
    if (_menuOpen) {
      setState(() => _menuOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.navBreakpoint;
    if (wide && _menuOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _closeMenu());
    }

    return Material(
      color: AppColors.navy,
      elevation: 3,
      shadowColor: AppColors.navy.withValues(alpha: 0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 84,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: wide
                    ? AppStyles.barGutterWide
                    : AppStyles.barGutterNarrow,
              ),
              child: Row(
                children: [
                  SkipToContentLink(onActivate: widget.onSkipToContent),
                  Expanded(
                    flex: wide ? 3 : 1,
                    child: Row(
                      children: [
                        const SpeechMarkLogo(size: 34),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            Translations.siteName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.title.copyWith(
                              color: AppColors.onNavy,
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  if (wide)
                    Expanded(
                      flex: 7,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            for (final item in widget.items)
                              NavLinkButton(
                                label: item.label,
                                onPressed: item.onPressed,
                              ),
                            const SizedBox(width: 20),
                            PrimaryButton(
                              label: Translations.navJoinUs,
                              onPressed: widget.onJoinUs,
                              large: true,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    IconButton(
                      tooltip: _menuOpen
                          ? Translations.closeMenu
                          : Translations.openMenu,
                      iconSize: 30,
                      onPressed: () {
                        setState(() => _menuOpen = !_menuOpen);
                      },
                      icon: Icon(
                        _menuOpen ? Icons.close : Icons.menu,
                        color: AppColors.onNavy,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!wide && _menuOpen)
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.navyElevated,
                border: Border(
                  top: BorderSide(color: Color(0x33FFFFFF)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppStyles.barGutterNarrow,
                  12,
                  AppStyles.barGutterNarrow,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final item in widget.items)
                      NavLinkButton(
                        label: item.label,
                        alignStart: true,
                        onPressed: () {
                          item.onPressed();
                          _closeMenu();
                        },
                      ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: Translations.navJoinUs,
                      large: true,
                      onPressed: () {
                        widget.onJoinUs();
                        _closeMenu();
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
