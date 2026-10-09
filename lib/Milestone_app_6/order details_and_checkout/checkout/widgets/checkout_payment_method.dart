
import 'package:flutter/material.dart';

class CheckoutPaymentMethod extends StatelessWidget {
  final String? selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodChanged;

  const CheckoutPaymentMethod({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _paymentOption(
            context,
            title: 'Cash on Delivery',
            subtitle: 'Pay when your order arrives',
            value: 'cod',
            icon: Icons.money,
          ),
          const SizedBox(height: 10),
          _paymentOption(
            context,
            title: 'Online Payment',
            subtitle: 'Pay securely online',
            value: 'online',
            icon: Icons.credit_card,
          ),
        ],
      ),
    );
  }

  Widget _paymentOption(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String value,
        required IconData icon,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedPaymentMethod == value;

    return InkWell(
      onTap: () => onPaymentMethodChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : theme.dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.06)
              : theme.cardColor,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : theme.iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (newValue) {
                if (newValue != null) {
                  onPaymentMethodChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
