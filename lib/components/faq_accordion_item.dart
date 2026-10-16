import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';

class FaqAccordionItem extends StatefulWidget {
  const FaqAccordionItem({super.key, required this.item});

  final FaqItem item;

  @override
  State<FaqAccordionItem> createState() => _FaqAccordionItemState();
}

class _FaqAccordionItemState extends State<FaqAccordionItem> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _open ? AppColors.offWhite : Colors.white,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall + 4),
        border: Border.all(
          color: _open
              ? AppColors.teal.withValues(alpha: 0.5)
              : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(AppStyles.radiusSmall + 4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppStyles.minTapSize,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.question,
                        style: AppStyles.title.copyWith(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedRotation(
                      turns: _open ? 0.125 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _open ? AppColors.teal : AppColors.tealSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: _open ? AppColors.onTeal : AppColors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 72, 22),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.item.answer,
                  style: AppStyles.body.copyWith(color: AppColors.mutedText),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
