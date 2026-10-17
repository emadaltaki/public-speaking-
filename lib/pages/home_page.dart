import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/anxiety_section.dart';
import '../components/app_navbar.dart';
import '../components/community_gallery.dart';
import '../components/booking_section.dart';
import '../components/faq_section.dart';
import '../components/hero_section.dart';
import '../components/how_it_works_section.dart';
import '../components/pricing_section.dart';
import '../components/sessions_section.dart';
import '../components/site_footer.dart';
import '../components/testimonials_section.dart';
import '../contact/booking_request_sender.dart';
import '../games/game_catalog.dart';
import '../contact/contact_submit_handler.dart';
import '../contact/mailto_contact_submit_handler.dart';
import '../theme/colors.dart';
import '../translations/translations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.contactHandler,
    this.bookingSender,
    this.homeKey,
    this.whyKey,
    this.sessionsKey,
    this.communityKey,
    this.faqKey,
    this.contactKey,
  });

  final ContactSubmitHandler? contactHandler;
  final BookingRequestSender? bookingSender;
  final GlobalKey? homeKey;
  final GlobalKey? whyKey;
  final GlobalKey? sessionsKey;
  final GlobalKey? communityKey;
  final GlobalKey? faqKey;
  final GlobalKey? contactKey;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GlobalKey _homeKey = widget.homeKey ?? GlobalKey();
  late final GlobalKey _whyKey = widget.whyKey ?? GlobalKey();
  late final GlobalKey _sessionsKey = widget.sessionsKey ?? GlobalKey();
  late final GlobalKey _communityKey = widget.communityKey ?? GlobalKey();
  late final GlobalKey _faqKey = widget.faqKey ?? GlobalKey();
  late final GlobalKey _contactKey = widget.contactKey ?? GlobalKey();
  late final ContactSubmitHandler _handler =
      widget.contactHandler ?? const MailtoContactSubmitHandler();
  late final BookingRequestSender _bookingSender =
      widget.bookingSender ?? FormSubmitBookingSender();

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) {
      return;
    }
    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.02,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Browsers can't tell us whether a mail app opened, so always show the
  /// address too in case the visitor has no email app set up.
  void _showEmailFallback() {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 10),
          content: Text(
            '${Translations.emailFallbackTitle} ${Translations.emailFallbackBody}',
          ),
          action: SnackBarAction(
            label: Translations.emailFallbackCopy,
            onPressed: () {
              Clipboard.setData(
                const ClipboardData(text: Translations.contactEmail),
              );
            },
          ),
        ),
      );
  }

  /// Every "book" button leads to the scheduling section.
  Future<void> _bookIntro() => _scrollTo(_contactKey);

  /// Sends the booking request straight to the inbox; if that fails, falls
  /// back to an email draft so the request isn't lost.
  Future<bool> _requestTime(BookingRequest request) async {
    if (await _bookingSender.send(request)) {
      return true;
    }
    await _handler.openEmailClient(
      subject: request.subject,
      body: request.body,
    );
    _showEmailFallback();
    return false;
  }

  void _openGames() => Navigator.of(context).pushNamed(AppRoutes.games);

  void _showPrivacy() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Translations.privacyTitle),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(child: Text(Translations.privacyBody)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(Translations.privacyClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppNavbar(
            onSkipToContent: () => _scrollTo(_homeKey),
            onJoinUs: () => _scrollTo(_contactKey),
            items: [
              NavItem(
                label: Translations.navWhy,
                onPressed: () => _scrollTo(_whyKey),
              ),
              NavItem(
                label: Translations.navSessions,
                onPressed: () => _scrollTo(_sessionsKey),
              ),
              NavItem(
                label: Translations.navCommunity,
                onPressed: () => _scrollTo(_communityKey),
              ),
              NavItem(label: Translations.navGames, onPressed: _openGames),
              NavItem(
                label: Translations.navFaq,
                onPressed: () => _scrollTo(_faqKey),
              ),
              NavItem(
                label: Translations.navContact,
                onPressed: () => _scrollTo(_contactKey),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // Each section repaints on its own, which keeps scrolling
                // smooth on phones.
                children: [
                  KeyedSubtree(
                    key: _homeKey,
                    child: HeroSection(
                      onJoin: _bookIntro,
                      onLearnSessions: () => _scrollTo(_sessionsKey),
                    ),
                  ),
                  KeyedSubtree(key: _whyKey, child: const AnxietySection()),
                  const HowItWorksSection(),
                  KeyedSubtree(
                    key: _sessionsKey,
                    child: const SessionsSection(),
                  ),
                  PricingSection(
                    onJoin: () => _scrollTo(_contactKey),
                    onBookIntro: _bookIntro,
                  ),
                  KeyedSubtree(
                    key: _communityKey,
                    child: const CommunityGallery(),
                  ),
                  const TestimonialsSection(),
                  KeyedSubtree(key: _faqKey, child: const FaqSection()),
                  KeyedSubtree(
                    key: _contactKey,
                    child: BookingSection(onRequest: _requestTime),
                  ),
                  SiteFooter(
                    links: [
                      FooterLink(
                        label: Translations.navHome,
                        onPressed: () => _scrollTo(_homeKey),
                      ),
                      FooterLink(
                        label: Translations.footerMission,
                        onPressed: () => _scrollTo(_whyKey),
                      ),
                      FooterLink(
                        label: Translations.navSessions,
                        onPressed: () => _scrollTo(_sessionsKey),
                      ),
                      FooterLink(
                        label: Translations.footerCommunity,
                        onPressed: () => _scrollTo(_communityKey),
                      ),
                      FooterLink(
                        label: Translations.navGames,
                        onPressed: _openGames,
                      ),
                      FooterLink(
                        label: Translations.navFaq,
                        onPressed: () => _scrollTo(_faqKey),
                      ),
                      FooterLink(
                        label: Translations.navContact,
                        onPressed: () => _scrollTo(_contactKey),
                      ),
                      FooterLink(
                        label: Translations.footerPrivacy,
                        onPressed: _showPrivacy,
                      ),
                    ],
                  ),
                ].map((section) => RepaintBoundary(child: section)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
