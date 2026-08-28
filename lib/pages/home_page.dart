import 'package:flutter/material.dart';

import '../components/anxiety_section.dart';
import '../components/app_navbar.dart';
import '../components/community_gallery.dart';
import '../components/contact_section.dart';
import '../components/faq_section.dart';
import '../components/hero_section.dart';
import '../components/how_it_works_section.dart';
import '../components/mission_section.dart';
import '../components/pricing_section.dart';
import '../components/sessions_section.dart';
import '../components/site_footer.dart';
import '../components/testimonials_section.dart';
import '../components/trust_section.dart';
import '../components/what_to_expect_section.dart';
import '../contact/contact_submit_handler.dart';
import '../contact/mailto_contact_submit_handler.dart';
import '../theme/colors.dart';
import '../translations/translations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.contactHandler,
    this.homeKey,
    this.whyKey,
    this.sessionsKey,
    this.communityKey,
    this.faqKey,
    this.contactKey,
  });

  final ContactSubmitHandler? contactHandler;
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

  Future<void> _talkToUs() {
    return _handler.openEmailClient(
      subject: 'Speak Up Fearless — I would like to join',
    );
  }

  Future<void> _bookIntro() {
    return _handler.openEmailClient(
      subject: Translations.pricingIntroEmailSubject,
      body: Translations.pricingIntroEmailBody,
    );
  }

  Future<void> _callUs() {
    return _handler.openPhoneClient();
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
                label: Translations.navHome,
                onPressed: () => _scrollTo(_homeKey),
              ),
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
            child: SelectionArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KeyedSubtree(
                      key: _homeKey,
                      child: HeroSection(
                        onJoin: () => _scrollTo(_contactKey),
                        onLearnSessions: () => _scrollTo(_sessionsKey),
                      ),
                    ),
                    KeyedSubtree(
                      key: _whyKey,
                      child: const AnxietySection(),
                    ),
                    const MissionSection(),
                    const HowItWorksSection(),
                    KeyedSubtree(
                      key: _sessionsKey,
                      child: const SessionsSection(),
                    ),
                    PricingSection(
                      onJoin: () => _scrollTo(_contactKey),
                      onTalk: _talkToUs,
                      onBookIntro: _bookIntro,
                    ),
                    KeyedSubtree(
                      key: _communityKey,
                      child: const CommunityGallery(),
                    ),
                    const TestimonialsSection(),
                    const TrustSection(),
                    const WhatToExpectSection(),
                    KeyedSubtree(
                      key: _faqKey,
                      child: const FaqSection(),
                    ),
                    KeyedSubtree(
                      key: _contactKey,
                      child: ContactSection(
                        handler: _handler,
                        onTalkToUs: _talkToUs,
                        onCallUs: _callUs,
                      ),
                    ),
                    SiteFooter(
                      onEmail: _talkToUs,
                      onPhone: _callUs,
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
                          label: Translations.navFaq,
                          onPressed: () => _scrollTo(_faqKey),
                        ),
                        FooterLink(
                          label: Translations.navContact,
                          onPressed: () => _scrollTo(_contactKey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
