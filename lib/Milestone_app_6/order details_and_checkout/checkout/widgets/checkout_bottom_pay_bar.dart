import 'package:app_matic_tech_flutter_app/Milestone_app_6/theme/milestone_app_6_colors.dart';
import 'package:flutter/material.dart';

class CheckoutBottomPayBar extends StatelessWidget {
  final double totalPayment;
  final String? selectedPaymentMethod;
  final bool isLoading;
  final Future<bool> Function() onPayPressed;

  const CheckoutBottomPayBar({
    super.key,
    required this.totalPayment,
    required this.selectedPaymentMethod,
    required this.isLoading,
    required this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isCod = selectedPaymentMethod == 'cod';

    final String buttonLabel = isLoading
        ? (isCod ? 'Processing...' : 'Preparing payment...')
        : (isCod ? 'Place Order' : 'Pay Now');

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '₹${totalPayment.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: MilestoneApp6Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    await onPayPressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MilestoneApp6Colors.red,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                    MilestoneApp6Colors.red.withOpacity(0.65),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 19,
                        width: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          buttonLabel,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Text(
                    buttonLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}