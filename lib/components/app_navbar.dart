import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 76),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.gutter,
                vertical: 8,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppStyles.maxContentWidth,
                  ),
                  child: Row(
                    children: [
                      SkipToContentLink(onActivate: widget.onSkipToContent),
                      const SpeechMarkLogo(size: 32),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          Translations.siteName,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.title.copyWith(
                            color: AppColors.onNavy,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (wide)
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 2,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              for (final item in widget.items)
                                TextButton(
                                  onPressed: item.onPressed,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.onNavy,
                                    minimumSize: const Size(44, 44),
                                  ),
                                  child: Text(item.label),
                                ),
                              PrimaryButton(
                                label: Translations.navJoinUs,
                                onPressed: widget.onJoinUs,
                              ),
                            ],
                          ),
                        )
                      else ...[
                        const Spacer(),
                        IconButton(
                          tooltip: _menuOpen
                              ? Translations.closeMenu
                              : Translations.openMenu,
                          onPressed: () {
                            setState(() => _menuOpen = !_menuOpen);
                          },
                          icon: Icon(
                            _menuOpen ? Icons.close : Icons.menu,
                            color: AppColors.onNavy,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!wide && _menuOpen)
            ColoredBox(
              color: AppColors.navy,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final item in widget.items)
                      TextButton(
                        onPressed: () {
                          item.onPressed();
                          _closeMenu();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.onNavy,
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size(44, 48),
                        ),
                        child: Text(item.label),
                      ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: Translations.navJoinUs,
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
