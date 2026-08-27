import 'package:flutter/material.dart';

import '../theme/styles.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: AppStyles.secondaryButton,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
