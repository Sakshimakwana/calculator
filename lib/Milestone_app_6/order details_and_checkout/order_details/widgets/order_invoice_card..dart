import 'package:flutter/material.dart';

class MilestoneApp6OrderInvoiceCard extends StatelessWidget {
  final Map<String, dynamic> invoice;
  final bool isGeneratingInvoice;
  final VoidCallback onGenerateInvoice;
  final String Function(String) formatDate;

  const MilestoneApp6OrderInvoiceCard({
    super.key,
    required this.invoice,
    required this.isGeneratingInvoice,
    required this.onGenerateInvoice,
    required this.formatDate,
  });

  String _string(Map<String, dynamic>? map, String key) {
    return map?[key]?.toString().trim() ?? '';
  }

  double? _doubleValue(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE8E9EC),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDF0),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFFEF5B6B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _smallSuccessBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF9EE),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          color: Color(0xFF238B45),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _billRow(
    String title,
    String value, {
    bool bold = false,
    double fontSize = 13.5,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
              color: bold ? Colors.black87 : Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoiceNumber = _string(invoice, 'invoice_number');
    final generatedAt = _string(invoice, 'generated_at');
    final invoiceTotal = _doubleValue(invoice['total']);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _sectionTitle(
                  Icons.description_outlined,
                  'Invoice',
                ),
              ),
              if (invoiceNumber.isNotEmpty) _smallSuccessBadge('Generated'),
            ],
          ),
          const SizedBox(height: 15),
          if (invoiceNumber.isNotEmpty) ...[
            _billRow(
              'Invoice Number',
              invoiceNumber,
            ),
            if (generatedAt.isNotEmpty) ...[
              const SizedBox(height: 9),
              _billRow(
                'Generated At',
                formatDate(generatedAt),
              ),
            ],
            if (invoiceTotal != null) ...[
              const SizedBox(height: 9),
              _billRow(
                'Invoice Total',
                '₹${invoiceTotal.toStringAsFixed(2)}',
                bold: true,
              ),
            ],
            const SizedBox(height: 14),
          ] else
            const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Text(
                'Invoice has not been generated yet.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black54,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: isGeneratingInvoice ? null : onGenerateInvoice,
              icon: isGeneratingInvoice
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.receipt_long_outlined,
                      size: 19,
                    ),
              label: Text(
                invoiceNumber.isEmpty ? 'Generate Invoice' : 'Refresh Invoice',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF5B6B),
                side: const BorderSide(
                  color: Color(0xFFEF5B6B),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
