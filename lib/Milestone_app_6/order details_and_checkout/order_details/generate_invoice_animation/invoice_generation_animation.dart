import 'package:flutter/material.dart';

/// Code-only invoice generation animation.
///
/// Flow:
/// 1. Overlay opens.
/// 2. Parent waits for invoice API.
/// 3. Parent assigns real invoice data.
/// 4. Parent calls `start()`.
/// 5. The invoice paper grows vertically while the real API data is
///    displayed inside the same paper.
/// 6. PDF buttons appear when the parent says the PDF is ready.
///
/// No Lottie JSON is required.
class InvoiceGenerationOverlay extends StatelessWidget {
  const InvoiceGenerationOverlay({
    super.key,
    required this.animationKey,
    required this.invoice,
    this.order,
    required this.isPdfReady,
    required this.onViewPdf,
    required this.onDownload,
    this.generatingText = 'Generating invoice...',
  });

  final GlobalKey<InvoiceGenerationAnimationState> animationKey;
  final Map<String, dynamic> invoice;
  final Map<String, dynamic>? order;
  final bool isPdfReady;
  final VoidCallback onViewPdf;
  final VoidCallback onDownload;
  final String generatingText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.58),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 24,
            ),
            child: InvoiceGenerationAnimation(
              key: animationKey,
              invoice: invoice,
              order: order,
              isPdfReady: isPdfReady,
              onViewPdf: onViewPdf,
              onDownload: onDownload,
              generatingText: generatingText,
            ),
          ),
        ),
      ),
    );
  }
}

class InvoiceGenerationAnimation extends StatefulWidget {
  const InvoiceGenerationAnimation({
    super.key,
    required this.invoice,
    this.order,
    required this.isPdfReady,
    required this.onViewPdf,
    required this.onDownload,
    this.generatingText = 'Generating invoice...',
  });

  final Map<String, dynamic> invoice;
  final Map<String, dynamic>? order;
  final bool isPdfReady;
  final VoidCallback onViewPdf;
  final VoidCallback onDownload;
  final String generatingText;

  @override
  State<InvoiceGenerationAnimation> createState() =>
      InvoiceGenerationAnimationState();
}

class InvoiceGenerationAnimationState extends State<InvoiceGenerationAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _paperHeight;
  late final Animation<double> _paperScale;
  late final Animation<double> _paperSlide;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _headerOpacity;
  late final Animation<double> _itemsOpacity;
  late final Animation<double> _totalOpacity;
  late final Animation<double> _buttonOpacity;

  bool _started = false;

  bool get isStarted => _started;

  bool get isCompleted => _controller.isCompleted;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
      value: 0,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _paperHeight = Tween<double>(
      begin: 165,
      end: 650,
    ).animate(curved);

    _paperScale = Tween<double>(
      begin: 0.86,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _paperSlide = Tween<double>(
      begin: 55,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _headerOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.05,
        0.38,
        curve: Curves.easeIn,
      ),
    );

    _itemsOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.22,
        0.65,
        curve: Curves.easeIn,
      ),
    );

    _totalOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.52,
        0.82,
        curve: Curves.easeIn,
      ),
    );

    _buttonOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.78,
        1.0,
        curve: Curves.easeIn,
      ),
    );

    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.10,
        0.90,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Call this ONLY after the invoice API has returned and the parent
  /// has assigned the real invoice data.
  void start() {
    if (!mounted || _started || widget.invoice.isEmpty) return;

    setState(() {
      _started = true;
    });

    _controller.forward(from: 0);
  }

  /// Useful when another invoice is generated from the same screen.
  void restart() {
    if (!mounted) return;

    _controller.reset();

    setState(() {
      _started = false;
    });

    if (widget.invoice.isNotEmpty) {
      start();
    }
  }

  @override
  void didUpdateWidget(covariant InvoiceGenerationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

// If a new invoice object is supplied before start(), do not
// automatically start here. The parent controls the exact
// API-data/animation synchronization.
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 430,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _paperSlide.value),
                child: Transform.scale(
                  scale: _paperScale.value,
                  child: _buildPaper(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildStatus(),
        ],
      ),
    );
  }

  Widget _buildPaper() {
    return ClipPath(
      clipper: InvoicePaperClipper(),
      child: Container(
        width: double.infinity,
        height: _paperHeight.value,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 28,
              spreadRadius: 2,
              offset: Offset(0, 12),
              color: Colors.black26,
            ),
          ],
        ),
        child: Opacity(
          opacity: _started ? _contentOpacity.value : 1,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_started)
                    _buildPreparingState()
                  else ...[
                    FadeTransition(
                      opacity: _headerOpacity,
                      child: _buildHeader(),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _itemsOpacity,
                      child: _buildItems(),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _totalOpacity,
                      child: _buildTotals(),
                    ),
                    const SizedBox(height: 14),
                    FadeTransition(
                      opacity: _totalOpacity,
                      child: _buildThankYou(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreparingState() {
    return SizedBox(
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Preparing your invoice...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Waiting for invoice data',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final invoiceNumber = _firstString([
      widget.invoice['invoice_number'],
      widget.invoice['invoice_no'],
      widget.invoice['number'],
    ], fallback: 'INV-${_orderId()}');

    final generatedAt = _firstString([
      widget.invoice['generated_at'],
      widget.invoice['created_at'],
      widget.order?['created_at'],
    ]);

    final restaurant = _map(widget.order?['restaurant']);

    final restaurantName = _firstString([
      widget.invoice['restaurant_name'],
      restaurant['name'],
      widget.order?['restaurant_name'],
    ], fallback: 'Restaurant');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INVOICE',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurantName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
              child: Text(
                invoiceNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),
        const SizedBox(height: 10),
        if (generatedAt.isNotEmpty) _infoRow('Date', _formatDate(generatedAt)),
        _infoRow(
          'Order',
          '#${_orderId()}',
        ),
        if (_customerName().isNotEmpty) _infoRow('Customer', _customerName()),
      ],
    );
  }

  Widget _buildItems() {
    final items = _items();

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: const Text(
          'Invoice items',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'ITEMS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Item',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 38,
                    child: Text(
                      'Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 76,
                    child: Text(
                      'Amount',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              const SizedBox(height: 4),
              ...items.map(_buildItemRow),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
// ------------------------------------------------------------
// ORDER ITEM NAME
//
// The order API can return the food name either directly on the
// order item or inside `menu_item`.
// ------------------------------------------------------------
    final menuItem = _map(item['menu_item']);
    final food = _map(item['food']);
    final product = _map(item['product']);

    final name = _firstString([
      item['name'],
      item['item_name'],
      item['menu_item_name'],
      item['food_name'],
      item['product_name'],
      item['title'],

// Nested API objects
      menuItem['name'],
      menuItem['item_name'],
      menuItem['title'],
      food['name'],
      food['item_name'],
      food['title'],
      product['name'],
      product['item_name'],
      product['title'],
    ], fallback: 'Item');

// ------------------------------------------------------------
// QUANTITY
// ------------------------------------------------------------
    final quantity = _number(
      item['quantity'] ?? item['qty'] ?? item['count'] ?? menuItem['quantity'],
    );

// ------------------------------------------------------------
// PRICE
// ------------------------------------------------------------
    final price = _number(
      item['price'] ??
          item['unit_price'] ??
          item['price_at_purchase'] ??
          item['amount'] ??
          menuItem['price'] ??
          menuItem['unit_price'],
    );

// ------------------------------------------------------------
// TOTAL
// ------------------------------------------------------------
    final total = _number(
      item['total'] ??
          item['total_price'] ??
          item['subtotal'] ??
          item['item_total'] ??
          (price * quantity),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text(
              _formatNumber(quantity),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(
            width: 76,
            child: Text(
              _money(total),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals() {
    final subtotal = _firstNumber([
      widget.invoice['subtotal'],
      widget.invoice['sub_total'],
      widget.order?['subtotal'],
    ]);

    final deliveryFee = _firstNumber([
      widget.invoice['delivery_fee'],
      widget.order?['delivery_fee'],
    ]);

    final discount = _firstNumber([
      widget.invoice['discount'],
      widget.order?['discount'],
    ]);

    final tax = _firstNumber([
      widget.invoice['tax'],
      widget.invoice['tax_amount'],
      widget.order?['tax'],
    ]);

    final total = _firstNumber([
      widget.invoice['total'],
      widget.invoice['grand_total'],
      widget.order?['total'],
    ]);

    return Column(
      children: [
        _amountRow('Subtotal', subtotal),
        if (deliveryFee != 0) _amountRow('Delivery fee', deliveryFee),
        if (tax != 0) _amountRow('Tax', tax),
        if (discount != 0) _amountRow('Discount', -discount),
        const SizedBox(height: 5),
        const Divider(height: 1),
        const SizedBox(height: 8),
        _amountRow(
          'TOTAL',
          total,
          bold: true,
          large: true,
        ),
      ],
    );
  }

  Widget _buildThankYou() {
    return Column(
      children: [
        const SizedBox(height: 4),
        Text(
          'Thank you for your order!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Please keep this invoice for your records.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    if (!_started) {
      return Text(
        widget.generatingText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return FadeTransition(
      opacity: _buttonOpacity,
      child: widget.isPdfReady
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onViewPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('View PDF'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onDownload,
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 9),
                Text(
                  'Preparing PDF...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(
    String title,
    double amount, {
    bool bold = false,
    bool large = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: large ? 14 : 10,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            _money(amount),
            style: TextStyle(
              fontSize: large ? 15 : 10,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _items() {
    final candidates = [
      widget.invoice['items'],
      widget.invoice['invoice_items'],
      widget.invoice['order_items'],
      widget.order?['items'],
      widget.order?['order_items'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<Map>()
            .map(
              (e) => Map<String, dynamic>.from(e),
            )
            .toList();
      }
    }

    return const [];
  }

  String _customerName() {
    final customer = _map(widget.invoice['customer']);
    final orderCustomer = _map(widget.order?['customer']);

    return _firstString([
      widget.invoice['customer_name'],
      widget.invoice['name'],
      customer['name'],
      orderCustomer['name'],
      widget.order?['customer_name'],
      widget.order?['name'],
    ]);
  }

  String _orderId() {
    return _firstString([
      widget.invoice['order_id'],
      widget.order?['id'],
    ], fallback: '-');
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  String _firstString(
    List<dynamic> values, {
    String fallback = '',
  }) {
    for (final value in values) {
      if (value == null) continue;

      final text = value.toString().trim();

      if (text.isNotEmpty && text != 'null') {
        return text;
      }
    }

    return fallback;
  }

  double _firstNumber(List<dynamic> values) {
    for (final value in values) {
      final number = _number(value);

      if (number != 0) {
        return number;
      }
    }

    return 0;
  }

  double _number(dynamic value) {
    if (value is num) return value.toDouble();

    return double.tryParse(
          value?.toString().replaceAll(',', '').trim() ?? '',
        ) ??
        0;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  String _money(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    final local = date.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
  }
}

/// Makes the bottom of the invoice look like a real paper receipt.
///
/// The top remains rectangular while the bottom has small triangular
/// cuts, giving the same "receipt/invoice paper" feeling as a Lottie
/// receipt animation.
class InvoicePaperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const toothWidth = 14.0;
    const toothHeight = 7.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height);

    double x = size.width;

    while (x > 0) {
      final nextX = (x - toothWidth).clamp(0.0, size.width);

      path.lineTo(
        nextX + toothWidth / 2,
        size.height - toothHeight,
      );
      path.lineTo(
        nextX,
        size.height,
      );

      x = nextX;
    }

    path
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
