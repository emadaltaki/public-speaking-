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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.cardRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: AppStyles.cardRadius,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppStyles.minTapSize),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.item.question, style: AppStyles.title.copyWith(fontSize: 18)),
                    ),
                    Icon(
                      _open ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.navy,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.item.answer, style: AppStyles.body),
              ),
            ),
        ],
      ),
    );
  }
}
