import 'package:flutter/material.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';

class MilestoneApp6CartPromoSection extends StatefulWidget {
  final MilestoneApp6State state;
  final TextEditingController promoController;

  const MilestoneApp6CartPromoSection({
    super.key,
    required this.state,
    required this.promoController,
  });

  @override
  State<MilestoneApp6CartPromoSection> createState() =>
      _MilestoneApp6CartPromoSectionState();
}

class _MilestoneApp6CartPromoSectionState
    extends State<MilestoneApp6CartPromoSection> {
  MilestoneApp6State get state => widget.state;

  TextEditingController get promoController =>
      widget.promoController;

  void _applyPromoCode() {
    final code = promoController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a promo code.'),
        ),
      );
      return;
    }

    final success = state.applyPromoCode(code);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Promo code applied successfully!'
              : 'Invalid promo code.',
        ),
      ),
    );

    setState(() {});
  }

  void _removePromoCode() {
    state.clearPromo();
    promoController.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Apply Coupon',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: promoController,
                  textCapitalization:
                  TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _applyPromoCode,
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),

          if (state.appliedPromoCode != null) ...[
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    '${state.appliedPromoCode} applied • 10% OFF',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: _removePromoCode,
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}