import 'package:flutter/material.dart';

import '../contact/contact_submit_handler.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'primary_button.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key, required this.handler});

  final ContactSubmitHandler handler;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  String? _status;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  bool _validEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  Future<void> _submit() async {
    setState(() => _status = null);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _submitting = true);
    final result = await widget.handler.submit(
      ContactFormData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        message: _message.text.trim(),
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _submitting = false;
      _status = result.userMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: Translations.contactNameLabel,
              hintText: Translations.contactNameHint,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return Translations.contactNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: Translations.contactEmailLabel,
              hintText: Translations.contactEmailHint,
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) {
                return Translations.contactEmailRequired;
              }
              if (!_validEmail(trimmed)) {
                return Translations.contactEmailInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _message,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: Translations.contactMessageLabel,
              hintText: Translations.contactMessageHint,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return Translations.contactMessageRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: Translations.ctaSendMessage,
            onPressed: _submitting ? null : _submit,
          ),
          const SizedBox(height: 12),
          Text(Translations.contactFormNote, style: AppStyles.bodySmall),
          if (_status != null) ...[
            const SizedBox(height: 12),
            Text(
              _status!,
              style: AppStyles.bodySmall.copyWith(color: AppColors.navy),
            ),
          ],
        ],
      ),
    );
  }
}
