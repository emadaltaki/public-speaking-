import 'package:flutter/material.dart';

import '../contact/booking_request_sender.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'booking/booking_embed.dart';
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
    required this.onEmail,
    required this.onCall,
    this.bookingUrl = Translations.bookingUrl,
  });

  /// Sends a time request; resolves to true once it reached the inbox.
  final Future<bool> Function(BookingRequest request) onRequest;
  final VoidCallback onEmail;
  final VoidCallback onCall;
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

    final contact = _ContactCard(onEmail: onEmail, onCall: onCall);

    return ColoredBox(
      color: AppColors.lightBlue,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
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
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
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
  static const _times = [
    Translations.bookingTimeMorning,
    Translations.bookingTimeAfternoon,
    Translations.bookingTimeEvening,
  ];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
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
          decoration: const BoxDecoration(
            color: AppColors.tealSoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.teal,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        Text(Translations.bookingSentTitle, style: AppStyles.title),
        const SizedBox(height: 8),
        Text(Translations.bookingSentBody, style: AppStyles.body),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _reset,
          child: const Text(Translations.bookingSendAnother),
        ),
      ],
    );
  }

  Widget _choice({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelStyle: AppStyles.label.copyWith(
        color: selected ? AppColors.onTeal : AppColors.navy,
        fontSize: 14,
      ),
      selectedColor: AppColors.teal,
      backgroundColor: Colors.white,
      side: BorderSide(color: selected ? AppColors.teal : AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
            decoration: const BoxDecoration(
              color: AppColors.navy,
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in _days)
                _choice(
                  label: _label(d),
                  selected: _day == d,
                  onTap: () => setState(() => _day = d),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _stepLabel('2', Translations.bookingPickTime),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in _times)
                _choice(
                  label: t,
                  selected: _time == t,
                  onTap: () => setState(() => _time = t),
                ),
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
            decoration: const InputDecoration(
              labelText: Translations.contactNameLabel,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? Translations.contactNameRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contact,
            decoration: const InputDecoration(
              labelText: Translations.bookingContactLabel,
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? Translations.bookingContactRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            minLines: 3,
            maxLines: 6,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
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
  const _ContactCard({required this.onEmail, required this.onCall});

  final VoidCallback onEmail;
  final VoidCallback onCall;

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
      color: AppColors.navy,
      borderColor: AppColors.navy,
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
          PrimaryButton(label: Translations.ctaEmailUs, onPressed: onEmail),
          const SizedBox(height: 10),
          OutlinedButton(
            style: AppStyles.secondaryButton.copyWith(
              foregroundColor: const WidgetStatePropertyAll(AppColors.onNavy),
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
            onPressed: onCall,
            child: const Text(Translations.ctaCallUs),
          ),
        ],
      ),
    );
  }
}
