import 'package:flutter/material.dart';

import '../contact/booking_request_sender.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'booking/booking_embed.dart';
import 'contact_link.dart';
import 'primary_button.dart';
import 'section_container.dart';
import 'section_header.dart';
import 'site_card.dart';

/// Where visitors schedule their free intro call.
///
/// With [Translations.bookingUrl] set, the online scheduling page is embedded.
/// Otherwise visitors pick a day and time and send it as a request.
class BookingSection extends StatelessWidget {
  const BookingSection({
    super.key,
    required this.onRequest,
    this.bookingUrl = Translations.bookingUrl,
  });

  /// Sends a time request; resolves to true once it reached the inbox.
  final Future<bool> Function(BookingRequest request) onRequest;
  final String bookingUrl;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final scheduler = SiteCard(
      hoverLift: false,
      padding: EdgeInsets.all(wide ? 32 : 20),
      child: bookingUrl.isNotEmpty
          ? BookingEmbed(url: bookingUrl)
          : _TimeRequestForm(onRequest: onRequest),
    );

    const contact = _ContactCard();

    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              eyebrow: Translations.eyebrowContact,
              title: Translations.bookingHeadline,
              intro: Translations.bookingIntro,
            ),
            const SizedBox(height: 40),
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: scheduler),
                  const SizedBox(width: 24),
                  Expanded(child: contact),
                ],
              )
            else ...[
              scheduler,
              const SizedBox(height: 20),
              contact,
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeRequestForm extends StatefulWidget {
  const _TimeRequestForm({required this.onRequest});

  final Future<bool> Function(BookingRequest request) onRequest;

  @override
  State<_TimeRequestForm> createState() => _TimeRequestFormState();
}

class _TimeRequestFormState extends State<_TimeRequestForm> {
  static List<String> get _weekdays => Translations.isArabic
      ? [
          'الإثنين',
          'الثلاثاء',
          'الأربعاء',
          'الخميس',
          'الجمعة',
          'السبت',
          'الأحد',
        ]
      : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static List<String> get _months => Translations.isArabic
      ? [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ]
      : [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
  static const _timeIcons = [
    Icons.wb_twilight_rounded,
    Icons.wb_sunny_outlined,
    Icons.nightlight_outlined,
  ];
  static List<String> get _times => [
    Translations.bookingTimeMorning,
    Translations.bookingTimeAfternoon,
    Translations.bookingTimeEvening,
  ];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _reason = TextEditingController();
  final _description = TextEditingController();
  late final List<DateTime> _days = _upcomingDays();
  DateTime? _day;
  String? _time;
  bool _showChoiceError = false;
  bool _sending = false;
  bool _sent = false;
  bool _failed = false;

  static List<DateTime> _upcomingDays() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [for (var i = 1; i <= 14; i++) today.add(Duration(days: i))];
  }

  String _label(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}';

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _reason.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final choicesOk = _day != null && _time != null;
    setState(() {
      _showChoiceError = !choicesOk;
      _failed = false;
    });
    final fieldsOk = _formKey.currentState!.validate();
    if (!choicesOk || !fieldsOk) {
      return;
    }
    setState(() => _sending = true);
    final sent = await widget.onRequest(
      BookingRequest(
        name: _name.text.trim(),
        contact: _contact.text.trim(),
        reason: _reason.text.trim(),
        description: _description.text.trim(),
        preferredTime: '${_label(_day!)}, $_time',
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _sending = false;
      _sent = sent;
      _failed = !sent;
    });
  }

  void _reset() {
    _name.clear();
    _contact.clear();
    _reason.clear();
    _description.clear();
    setState(() {
      _day = null;
      _time = null;
      _sent = false;
      _failed = false;
    });
  }

  Widget _sentMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.tealSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, color: AppColors.teal, size: 32),
        ),
        const SizedBox(height: 20),
        Text(Translations.bookingSentTitle, style: AppStyles.title),
        const SizedBox(height: 8),
        Text(Translations.bookingSentBody, style: AppStyles.body),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _reset,
          child: Text(Translations.bookingSendAnother),
        ),
      ],
    );
  }

  Widget _stepLabel(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.panel,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: AppStyles.label.copyWith(
                color: AppColors.onNavy,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(text, style: AppStyles.label.copyWith(fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) {
      return _sentMessage();
    }
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Translations.bookingFormTitle, style: AppStyles.title),
          const SizedBox(height: 4),
          Text(Translations.pricingIntroMeta, style: AppStyles.bodySmall),
          const SizedBox(height: 24),
          _stepLabel('1', Translations.bookingPickDay),
          // One swipeable row of day cards: easy to tap on a phone and
          // never wraps into ragged lines.
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final d = _days[i];
                return _DayTile(
                  key: ValueKey('day-$i'),
                  weekday: _weekdays[d.weekday - 1],
                  day: d.day,
                  month: _months[d.month - 1],
                  selected: _day == d,
                  onTap: () => setState(() => _day = d),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _stepLabel('2', Translations.bookingPickTime),
          Row(
            children: [
              for (var i = 0; i < _times.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _TimeTile(
                    label: _times[i],
                    icon: _timeIcons[i],
                    selected: _time == _times[i],
                    onTap: () => setState(() => _time = _times[i]),
                  ),
                ),
              ],
            ],
          ),
          if (_showChoiceError && (_day == null || _time == null)) ...[
            const SizedBox(height: 8),
            Text(
              Translations.bookingChoiceRequired,
              style: AppStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 24),
          _stepLabel('3', Translations.bookingYourDetails),
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: Translations.contactNameLabel,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? Translations.contactNameRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contact,
            decoration: InputDecoration(
              labelText: Translations.bookingContactLabel,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? Translations.bookingContactRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _reason,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: Translations.bookingReasonLabel,
              hintText: Translations.bookingReasonHint,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? Translations.bookingReasonRequired
                : null,
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _description,
            minLines: 3,
            maxLines: 6,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: Translations.bookingDescriptionLabel,
              hintText: Translations.bookingDescriptionHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: _sending
                ? Translations.bookingSending
                : Translations.bookingSubmit,
            onPressed: _sending ? null : _submit,
            large: true,
          ),
          const SizedBox(height: 10),
          if (_failed) ...[
            Text(
              Translations.bookingSendFailed,
              style: AppStyles.bodySmall.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 6),
          ],
          Text(Translations.bookingNote, style: AppStyles.bodySmall),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    final style = AppStyles.body.copyWith(
      color: AppColors.onNavy,
      fontSize: 16,
    );
    Widget line(IconData icon, String text, {bool selectable = true}) => Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.tealLight),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: selectable
              ? SelectableText(text, style: style)
              : Text(text, style: style),
        ),
      ],
    );

    return SiteCard(
      elevated: true,
      hoverLift: false,
      color: AppColors.panel,
      borderColor: AppColors.panel,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            Translations.bookingPreferToTalk,
            style: AppStyles.title.copyWith(color: AppColors.onNavy),
          ),
          const SizedBox(height: 20),
          line(Icons.mail_outline_rounded, Translations.contactEmail),
          const SizedBox(height: 14),
          line(Icons.phone_outlined, Translations.contactPhoneDisplay),
          const SizedBox(height: 14),
          line(
            Icons.place_outlined,
            Translations.heroLocation,
            selectable: false,
          ),
          const SizedBox(height: 24),
          ContactLink(
            uri: ContactLink.email(subject: Translations.contactJoinSubject),
            builder: (context, open) =>
                PrimaryButton(label: Translations.ctaEmailUs, onPressed: open),
          ),
          const SizedBox(height: 10),
          ContactLink(
            uri: ContactLink.phone,
            builder: (context, open) => OutlinedButton(
              style: AppStyles.secondaryButton.copyWith(
                foregroundColor: WidgetStatePropertyAll(AppColors.onNavy),
                overlayColor: WidgetStatePropertyAll(
                  Colors.white.withValues(alpha: 0.08),
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.4,
                  ),
                ),
              ),
              onPressed: open,
              child: Text(Translations.ctaCallUs),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    super.key,
    required this.weekday,
    required this.day,
    required this.month,
    required this.selected,
    required this.onTap,
  });

  final String weekday;
  final int day;
  final String month;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.onTeal : AppColors.navy;
    return Semantics(
      button: true,
      selected: selected,
      label: '$weekday $month $day',
      child: Material(
        color: selected ? AppColors.teal : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? AppColors.teal : AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 72,
            child: ExcludeSemantics(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      weekday.toUpperCase(),
                      style: AppStyles.label.copyWith(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: selected ? fg : AppColors.mutedText,
                      ),
                    ),
                  ),
                  Text(
                    '$day',
                    style: AppStyles.title.copyWith(fontSize: 22, color: fg),
                  ),
                  Text(
                    month,
                    style: AppStyles.bodySmall.copyWith(
                      fontSize: 12,
                      height: 1.2,
                      color: selected ? fg : AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  /// e.g. "Morning (9am-12pm)"; shown as a name with the hours underneath.
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final split = label.indexOf(' (');
    final name = split < 0 ? label : label.substring(0, split);
    final hours = split < 0 ? '' : label.substring(split + 2, label.length - 1);
    final fg = selected ? AppColors.onTeal : AppColors.navy;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? AppColors.teal : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? AppColors.teal : AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                children: [
                  Icon(icon, size: 22, color: selected ? fg : AppColors.teal),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: AppStyles.label.copyWith(color: fg),
                  ),
                  if (hours.isNotEmpty)
                    Text(
                      hours,
                      textAlign: TextAlign.center,
                      style: AppStyles.bodySmall.copyWith(
                        fontSize: 12,
                        height: 1.3,
                        color: selected ? fg : AppColors.mutedText,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
