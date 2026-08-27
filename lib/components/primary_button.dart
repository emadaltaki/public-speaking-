import 'package:flutter/material.dart';

import '../theme/styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.large = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: large ? AppStyles.primaryButtonLarge : AppStyles.primaryButton,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
