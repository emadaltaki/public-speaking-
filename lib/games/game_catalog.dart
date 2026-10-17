import 'package:flutter/material.dart';

import '../translations/translations.dart';

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
  static const String account = '/account';

  /// Opens [route], unless it is already the page on screen or a page change
  /// is already under way (stops repeat taps from stacking the same page).
  static void open(BuildContext context, String route) {
    final current = ModalRoute.of(context);
    if (current == null || !current.isCurrent) return;
    if (current.settings.name == route) return;
    Navigator.of(context).pushNamed(route);
  }
}

class GameCatalog {
  GameCatalog._();

  static GameInfo get tripleStep => GameInfo(
    id: 'triple-step',
    title: Translations.l('Triple Step', 'الخطوة الثلاثية'),
    tagline: Translations.l(
      'Speak on a topic while weaving in surprise words.',
      'تحدّث عن موضوع وأدخل كلمات مفاجئة في كلامك.',
    ),
    description: Translations.l(
      'Get a topic and keep talking. Random words pop up one at a time, and you work each one into your speech.',
      'تحصل على موضوع وتستمر في الحديث. تظهر كلمات عشوائية واحدة تلو الأخرى، وتدخل كل واحدة في كلامك.',
    ),
    icon: Icons.record_voice_over_rounded,
    skills: [
      Translations.l('Impromptu', 'ارتجال'),
      Translations.l('Focus', 'تركيز'),
      Translations.l('Flow', 'انسيابية'),
    ],
    route: AppRoutes.tripleStep,
    howToPlay: [
      HowToStep(
        Icons.tune_rounded,
        Translations.l(
          'Pick how many words and how long.',
          'اختر عدد الكلمات والمدة.',
        ),
      ),
      HowToStep(
        Icons.record_voice_over_rounded,
        Translations.l(
          'You get a topic. Start talking about it.',
          'تحصل على موضوع. ابدأ الحديث عنه.',
        ),
      ),
      HowToStep(
        Icons.bolt_rounded,
        Translations.l(
          'A new word pops up every few seconds. Use it in your speech.',
          'تظهر كلمة جديدة كل بضع ثوانٍ. استخدمها في كلامك.',
        ),
      ),
      HowToStep(
        Icons.flag_rounded,
        Translations.l(
          'Keep going until the timer ends.',
          'استمر حتى ينتهي المؤقت.',
        ),
      ),
    ],
    tip: Translations.l(
      "It's fine if a word doesn't fit. Make it fit. That's the fun!",
      'لا بأس إن لم تناسب الكلمة. اجعلها تناسب، هذه هي المتعة!',
    ),
  );

  static GameInfo get conductor => GameInfo(
    id: 'conductor',
    title: Translations.l('The Conductor', 'قائد الأوركسترا'),
    tagline: Translations.l(
      'Follow the pitch from 1 (low) to 10 (high).',
      'اتبع طبقة الصوت من 1 (منخفض) إلى 10 (مرتفع).',
    ),
    description: Translations.l(
      'Talk on a topic while a pitch number changes at random. Move your voice up and down to match it and build vocal variety.',
      'تحدّث عن موضوع بينما يتغيّر رقم طبقة الصوت عشوائيًا. ارفع صوتك واخفضه ليطابقه وتبني تنوّعًا في صوتك.',
    ),
    icon: Icons.graphic_eq_rounded,
    skills: [
      Translations.l('Pitch', 'طبقة الصوت'),
      Translations.l('Vocal variety', 'تنوّع الصوت'),
      Translations.l('Control', 'تحكّم'),
    ],
    route: AppRoutes.conductor,
    howToPlay: [
      HowToStep(
        Icons.record_voice_over_rounded,
        Translations.l(
          'You get a topic. Talk about it.',
          'تحصل على موضوع. تحدّث عنه.',
        ),
      ),
      HowToStep(
        Icons.looks_one_rounded,
        Translations.l(
          'A number from 1 to 10 shows on screen.',
          'يظهر رقم من 1 إلى 10 على الشاشة.',
        ),
      ),
      HowToStep(
        Icons.graphic_eq_rounded,
        Translations.l(
          '1 = low, deep voice. 10 = high, bright voice.',
          '1 = صوت منخفض وعميق. 10 = صوت مرتفع ومشرق.',
        ),
      ),
      HowToStep(
        Icons.swap_vert_rounded,
        Translations.l(
          'When the number changes, change your voice to match.',
          'عندما يتغيّر الرقم، غيّر صوتك ليطابقه.',
        ),
      ),
    ],
    tip: Translations.l(
      "Exaggerate! It feels silly, but it's how you build range.",
      'بالغ! قد يبدو الأمر مضحكًا، لكنه طريقتك لتوسيع مدى صوتك.',
    ),
  );

  static GameInfo get podcast => GameInfo(
    id: 'podcast',
    title: Translations.l('The Podcast Game', 'لعبة البودكاست'),
    tagline: Translations.l(
      'One topic, a group, and the mic keeps jumping.',
      'موضوع واحد ومجموعة، والميكروفون يتنقّل باستمرار.',
    ),
    description: Translations.l(
      'Everyone shares one topic. A name lights up on screen and that person speaks until the name switches to someone else.',
      'يتشارك الجميع موضوعًا واحدًا. يظهر اسم على الشاشة فيتحدث صاحبه حتى ينتقل الاسم إلى شخص آخر.',
    ),
    icon: Icons.podcasts_rounded,
    skills: [
      Translations.l('Group', 'جماعي'),
      Translations.l('Listening', 'إصغاء'),
      Translations.l('Quick thinking', 'سرعة بديهة'),
    ],
    route: AppRoutes.podcast,
    howToPlay: [
      HowToStep(
        Icons.group_add_rounded,
        Translations.l('Add everyone who is playing.', 'أضف كل من يلعب.'),
      ),
      HowToStep(
        Icons.topic_rounded,
        Translations.l(
          'The whole group gets one topic.',
          'تحصل المجموعة كلها على موضوع واحد.',
        ),
      ),
      HowToStep(
        Icons.mic_rounded,
        Translations.l(
          'The name on screen is who talks now.',
          'صاحب الاسم الظاهر على الشاشة هو من يتحدث الآن.',
        ),
      ),
      HowToStep(
        Icons.shuffle_rounded,
        Translations.l(
          'When the name changes, the new person picks up where the last one stopped.',
          'عندما يتغيّر الاسم، يكمل الشخص الجديد من حيث توقّف السابق.',
        ),
      ),
    ],
    tip: Translations.l(
      'Listen closely so you can continue the story when it is your turn.',
      'أصغِ جيدًا لتتمكن من إكمال القصة عندما يأتي دورك.',
    ),
  );

  static GameInfo get autocomplete => GameInfo(
    id: 'autocomplete',
    title: Translations.l('Autocomplete', 'الإكمال التلقائي'),
    tagline: Translations.l(
      'Rapid fire: finish the sentence out loud, fast.',
      'أسئلة سريعة: أكمل الجملة بصوت عالٍ وبسرعة.',
    ),
    description: Translations.l(
      'A sentence starter appears, sometimes silly, sometimes deep. Finish it out loud before the timer runs out. Then the next one!',
      'تظهر بداية جملة، مضحكة أحيانًا وعميقة أحيانًا. أكملها بصوت عالٍ قبل انتهاء المؤقت. ثم التالية!',
    ),
    icon: Icons.bolt_rounded,
    skills: [
      Translations.l('Rapid fire', 'أسئلة سريعة'),
      Translations.l('Creativity', 'إبداع'),
      Translations.l('Confidence', 'ثقة'),
    ],
    route: AppRoutes.autocomplete,
    howToPlay: [
      HowToStep(
        Icons.short_text_rounded,
        Translations.l(
          'A half-finished sentence appears.',
          'تظهر جملة غير مكتملة.',
        ),
      ),
      HowToStep(
        Icons.record_voice_over_rounded,
        Translations.l(
          'Finish it out loud. Any answer works, even a silly one.',
          'أكملها بصوت عالٍ. أي إجابة مقبولة، حتى المضحكة.',
        ),
      ),
      HowToStep(
        Icons.timer_outlined,
        Translations.l('Beat the little timer.', 'اسبق المؤقت الصغير.'),
      ),
      HowToStep(
        Icons.skip_next_rounded,
        Translations.l(
          'A new sentence comes right away. Keep going!',
          'تأتي جملة جديدة فورًا. استمر!',
        ),
      ),
    ],
    tip: Translations.l(
      "Don't stop to think of the perfect answer. Say the first thing!",
      'لا تتوقف للتفكير في الإجابة المثالية. قل أول ما يخطر لك!',
    ),
  );

  static List<GameInfo> get games => [
    tripleStep,
    conductor,
    podcast,
    autocomplete,
    GameInfo(
      id: 'coming-soon',
      title: Translations.l('More games soon', 'ألعاب أخرى قريبًا'),
      tagline: Translations.l(
        'New speaking games are on the way.',
        'ألعاب تحدّث جديدة في الطريق.',
      ),
      description: Translations.l(
        'We are building more ways to practice. Check back soon.',
        'نعمل على طرق جديدة للتدرّب. عد قريبًا.',
      ),
      icon: Icons.auto_awesome_rounded,
      skills: [],
    ),
  ];
}
