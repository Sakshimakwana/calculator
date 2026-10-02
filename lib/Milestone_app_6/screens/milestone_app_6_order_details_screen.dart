import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/storage/auth_storage.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../state/milestone_app_6_auth_store.dart';
import '../state/milestone_app_6_state.dart';

class MilestoneApp6OrderDetailsScreen extends StatefulWidget {
  final MilestoneApp6State state;
  final MilestoneApp6AuthStore auth;

  // Kept for router compatibility. The backend is the source of truth
  // for order items after the order has been created.
  final List<MilestoneApp6CartItem> items;

  // IMPORTANT: this is the method selected by the user in Checkout.
  // Example: Online Payment / Cash on Delivery.
  final String paymentType;

  final double subtotal;
  final double shipping;
  final double discount;
  final double totalPayment;
  final double minimumPayment;
  final double amountPaidNow;
  final String? orderId;

  const MilestoneApp6OrderDetailsScreen({
    super.key,
    required this.state,
    required this.auth,
    required this.items,
    required this.paymentType,
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.totalPayment,
    required this.minimumPayment,
    required this.amountPaidNow,
    this.orderId,
  });

  @override
  State<MilestoneApp6OrderDetailsScreen> createState() =>
      _MilestoneApp6OrderDetailsScreenState();
}

class _MilestoneApp6OrderDetailsScreenState
    extends State<MilestoneApp6OrderDetailsScreen> {
  Map<String, dynamic>? _order;
  Map<String, dynamic>? _invoice;

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isGeneratingInvoice = false;
  bool _isCancelling = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Do not call an OrderController method directly from initState when
    // that method calls notifyListeners(). That can notify Provider while
    // the route is still being built. Flutter reports this as:
    // "setState() or markNeedsBuild() called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadOrderDetails();
    });
  }

  // ============================================================
  // ORDER ID
  // ============================================================

  int? get _parsedOrderId {
    final value = int.tryParse(
      widget.orderId?.trim() ?? '',
    );

    if (value == null || value <= 0) {
      return null;
    }

    return value;
  }

  // ============================================================
  // API HEADERS
  // ============================================================

  Future<Map<String, String>> _headers() async {
    final String? token = await AuthStorage.token;

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'Authentication token is missing. Please login again.',
      );
    }

    return {
      'Authorization': 'Bearer ${token.trim()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // ============================================================
  // GET ORDER INFO
  // GET /orders/{orderId}
  // ============================================================

  Future<void> _loadOrderDetails({
    bool refresh = false,
  }) async {
    final int? id = _parsedOrderId;

    if (id == null) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = 'Invalid order ID.';
      });
      return;
    }

    if (refresh) {
      setState(() {
        _isRefreshing = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final headers = await _headers();

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.orderInfo(id)}',
      );

      debugPrint('');
      debugPrint('========================================');
      debugPrint('             ORDER INFO API');
      debugPrint('========================================');
      debugPrint('METHOD: GET');
      debugPrint('ORDER ID: $id');
      debugPrint('URL: $uri');
      debugPrint('========================================');

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      debugPrint('ORDER INFO STATUS: ${response.statusCode}');
      debugPrint('ORDER INFO RESPONSE: ${response.body}');

      if (response.statusCode == 401) {
        throw Exception(
          'Session expired. Please login again.',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          _apiMessage(
            response.body,
            fallback:
            'Unable to load order details.',
          ),
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception(
          'Invalid order response.',
        );
      }

      final responseMap =
      Map<String, dynamic>.from(decoded);

      final rawData = responseMap['data'];

      if (rawData is! Map) {
        throw Exception(
          responseMap['message']?.toString() ??
              'Order details not found.',
        );
      }

      if (!mounted) return;

      setState(() {
        _order = Map<String, dynamic>.from(
          rawData,
        );
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });

      debugPrint('ORDER INFO SUCCESS');
      debugPrint('ORDER ID: ${_value(_order, 'id')}');
      debugPrint('STATUS: ${_value(_order, 'status')}');
      debugPrint(
        'PAYMENT FROM API: ${_mapValue(_order?['order_payment'], 'method')}',
      );
      debugPrint(
        'SELECTED PAYMENT FROM CHECKOUT: ${widget.paymentType}',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });

      debugPrint('ORDER INFO ERROR: $e');
    }
  }

  // ============================================================
  // GENERATE INVOICE
  // GET /orders/{orderId}/invoice
  // ============================================================

  Future<void> _generateInvoice() async {
    final int? id = _parsedOrderId;

    if (id == null || _isGeneratingInvoice) {
      return;
    }

    setState(() {
      _isGeneratingInvoice = true;
    });

    try {
      final headers = await _headers();

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}'
            '${ApiConstants.generateInvoice(id)}',
      );

      debugPrint('');
      debugPrint('========================================');
      debugPrint('           GENERATE INVOICE API');
      debugPrint('========================================');
      debugPrint('METHOD: GET');
      debugPrint('ORDER ID: $id');
      debugPrint('URL: $uri');
      debugPrint('========================================');

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      debugPrint(
        'INVOICE STATUS: ${response.statusCode}',
      );
      debugPrint(
        'INVOICE RESPONSE: ${response.body}',
      );

      if (response.statusCode == 401) {
        throw Exception(
          'Session expired. Please login again.',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          _apiMessage(
            response.body,
            fallback:
            'Unable to generate invoice.',
          ),
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception(
          'Invalid invoice response.',
        );
      }

      final responseMap =
      Map<String, dynamic>.from(decoded);

      final rawData = responseMap['data'];

      if (rawData is! Map) {
        throw Exception(
          responseMap['message']?.toString() ??
              'Invoice data not found.',
        );
      }

      if (!mounted) return;

      setState(() {
        _invoice = Map<String, dynamic>.from(
          rawData,
        );
        _isGeneratingInvoice = false;
      });

      _showSnackBar(
        responseMap['message']?.toString() ??
            'Invoice generated successfully.',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isGeneratingInvoice = false;
      });

      _showSnackBar(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        error: true,
      );
    }
  }

  // ============================================================
  // CANCEL ORDER
  // PATCH /orders/{orderId}/cancel
  // ============================================================

  Future<void> _cancelOrder() async {
    final int? id = _parsedOrderId;

    if (id == null || _isCancelling) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Cancel Order?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Are you sure you want to cancel this order? '
                'This action cannot be undone.',
            style: TextStyle(
              height: 1.4,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Keep Order'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                const Color(0xFFD62828),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text(
                'Cancel Order',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isCancelling = true;
    });

    try {
      final headers = await _headers();

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}'
            '${ApiConstants.cancelOrder(id)}',
      );

      debugPrint('');
      debugPrint('========================================');
      debugPrint('             CANCEL ORDER API');
      debugPrint('========================================');
      debugPrint('METHOD: PATCH');
      debugPrint('ORDER ID: $id');
      debugPrint('URL: $uri');
      debugPrint('========================================');

      final response = await http
          .patch(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      debugPrint(
        'CANCEL STATUS: ${response.statusCode}',
      );
      debugPrint(
        'CANCEL RESPONSE: ${response.body}',
      );

      if (response.statusCode == 401) {
        throw Exception(
          'Session expired. Please login again.',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          _apiMessage(
            response.body,
            fallback:
            'Unable to cancel order.',
          ),
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception(
          'Invalid cancellation response.',
        );
      }

      final responseMap =
      Map<String, dynamic>.from(decoded);

      final rawData = responseMap['data'];

      if (rawData is Map) {
        setState(() {
          _order = Map<String, dynamic>.from(
            rawData,
          );
        });
      }

      if (!mounted) return;

      setState(() {
        _isCancelling = false;
      });

      _showSnackBar(
        responseMap['message']?.toString() ??
            'Order cancelled successfully.',
      );

      // Refresh so every field shown on screen comes
      // from the backend after cancellation.
      await _loadOrderDetails(
        refresh: true,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isCancelling = false;
      });

      _showSnackBar(
        e.toString().replaceFirst(
          'Exception: ',
          '',
        ),
        error: true,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF6F7F9),
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading || _isRefreshing
                ? null
                : () => _loadOrderDetails(
              refresh: true,
            ),
            tooltip: 'Refresh order',
            icon: _isRefreshing
                ? const SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _loadingView();
    }

    if (_errorMessage != null || _order == null) {
      return _errorView();
    }

    return RefreshIndicator(
      onRefresh: () => _loadOrderDetails(
        refresh: true,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool tablet =
              constraints.maxWidth >= 700;
          final double horizontal = tablet
              ? 34
              : 18;

          return SingleChildScrollView(
            physics:
            const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              horizontal,
              12,
              horizontal,
              36,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    _heroHeader(),
                    const SizedBox(height: 16),
                    _statusCard(),
                    const SizedBox(height: 14),
                    _restaurantCard(),
                    const SizedBox(height: 14),
                    _deliveryCard(),
                    const SizedBox(height: 14),
                    _itemsCard(),
                    const SizedBox(height: 14),
                    _billCard(),
                    const SizedBox(height: 14),
                    _paymentCard(),
                    const SizedBox(height: 14),
                    _invoiceCard(),
                    const SizedBox(height: 14),
                    if (_canCancel) _cancelButton(),
                    if (_canCancel)
                      const SizedBox(height: 12),
                    _continueButton(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HERO HEADER
  // ============================================================

  Widget _heroHeader() {
    final id = _string(_order, 'id');
    final createdAt = _string(_order, 'created_at');
    final status = _string(_order, 'status');

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEF5B6B),
            Color(0xFFE84458),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF5B6B)
                .withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order placed successfully',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Order #$id',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (createdAt.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _statusPill(
            status,
            compact: true,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusCard() {
    final status = _normalizedStatus(
      _string(_order, 'status'),
    );

    if (status == 'cancelled' ||
        status == 'canceled') {
      return _card(
        child: Row(
          children: [
            _circleIcon(
              Icons.cancel_rounded,
              const Color(0xFFD62828),
              const Color(0xFFFFE9E9),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD62828),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'This order has been cancelled successfully.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.black54,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final steps = [
      ('Placed', true),
      (
      'Preparing',
      status == 'preparing' ||
          status == 'out_for_delivery' ||
          status == 'out for delivery' ||
          status == 'delivered',
      ),
      (
      'Out for delivery',
      status == 'out_for_delivery' ||
          status == 'out for delivery' ||
          status == 'delivered',
      ),
      ('Delivered', status == 'delivered'),
    ];

    return _card(
      padding: const EdgeInsets.fromLTRB(
        15,
        18,
        15,
        18,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.track_changes_rounded,
            'Order Status',
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(
              steps.length,
                  (index) {
                final active = steps[index].$2;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 39,
                              height: 39,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active
                                    ? const Color(0xFFEF5B6B)
                                    : const Color(0xFFF0F1F3),
                              ),
                              child: Icon(
                                active
                                    ? Icons.check_rounded
                                    : Icons.circle_outlined,
                                size: active ? 22 : 18,
                                color: active
                                    ? Colors.white
                                    : const Color(0xFFB5B8BE),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              steps[index].$1,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 10.5,
                                height: 1.2,
                                fontWeight: active
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: active
                                    ? Colors.black87
                                    : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index != steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.only(
                              bottom: 31,
                            ),
                            color: steps[index + 1].$2
                                ? const Color(0xFFEF5B6B)
                                : const Color(0xFFE4E5E8),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RESTAURANT
  // ============================================================

  Widget _restaurantCard() {
    final restaurant = _map(_order?['restaurant']);
    final name = _string(restaurant, 'name');
    final image = _string(restaurant, 'image_url');
    final address = _string(restaurant, 'address');

    if (name.isEmpty &&
        image.isEmpty &&
        address.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.storefront_rounded,
            'Restaurant',
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _networkImage(
                image,
                width: 68,
                height: 68,
                radius: 15,
                fallbackIcon:
                Icons.restaurant_rounded,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty
                          ? 'Restaurant'
                          : name,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        address,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY
  // ============================================================

  Widget _deliveryCard() {
    final address =
    _map(_order?['delivery_address']);
    final customer =
    _map(_order?['customer']).isNotEmpty
        ? _map(_order?['customer'])
        : _map(_order?['user']);

    final fullAddress = _addressText(address);
    final customerName = _string(
      customer,
      'full_name',
    );
    final phone = _string(
      customer,
      'phone_number',
    );
    final instructions = _string(
      _order,
      'delivery_instructions',
    );

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.location_on_rounded,
            'Delivery Details',
          ),
          const SizedBox(height: 16),
          _detailRow(
            Icons.person_outline_rounded,
            'Customer',
            customerName.isEmpty
                ? 'Customer'
                : customerName,
            secondary: phone,
          ),
          const SizedBox(height: 15),
          _detailRow(
            Icons.home_outlined,
            address['label']?.toString().trim().isEmpty ??
                true
                ? 'Delivery Address'
                : address['label'].toString(),
            fullAddress.isEmpty
                ? 'Address not available'
                : fullAddress,
          ),
          if (instructions.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F8),
                borderRadius:
                BorderRadius.circular(13),
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notes_rounded,
                    size: 19,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      instructions,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // ITEMS
  // ============================================================

  Widget _itemsCard() {
    final rawItems = _order?['order_items'];
    final List<Map<String, dynamic>> items =
    rawItems is List
        ? rawItems
        .whereType<Map>()
        .map(
          (e) => Map<String, dynamic>.from(e),
    )
        .toList()
        : <Map<String, dynamic>>[];

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.shopping_bag_outlined,
            'Ordered Items',
            trailing:
            '${items.length} item${items.length == 1 ? '' : 's'}',
          ),
          const SizedBox(height: 15),
          if (items.isEmpty)
            const Text(
              'No ordered items found.',
              style: TextStyle(
                color: Colors.black54,
              ),
            )
          else
            ...List.generate(
              items.length,
                  (index) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                  index == items.length - 1
                      ? 0
                      : 10,
                ),
                child: _itemTile(items[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _itemTile(
      Map<String, dynamic> item,
      ) {
    final menuItem =
    _map(item['menu_item']);

    final String name = _string(
      menuItem,
      'name',
    );
    final String image = _string(
      menuItem,
      'image_url',
    );
    final int quantity =
        _intValue(item['quantity']) ?? 1;
    final double price =
        _doubleValue(item['price_at_purchase']) ??
            _doubleValue(menuItem['price']) ??
            0;
    final double total =
        _doubleValue(item['total_price']) ??
            price * quantity;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE9EAED),
        ),
      ),
      child: Row(
        children: [
          _networkImage(
            image,
            width: 70,
            height: 70,
            radius: 13,
            fallbackIcon: Icons.fastfood_rounded,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty
                      ? 'Food item'
                      : name,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${price.toStringAsFixed(2)} × $quantity',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BILL
  // ============================================================

  Widget _billCard() {
    final orderTotal =
        _doubleValue(_order?['total']) ??
            widget.totalPayment;
    final deliveryFee =
        _doubleValue(_order?['delivery_fee']) ??
            widget.shipping;

    final rawItems = _order?['order_items'];
    final List<Map<String, dynamic>> items =
    rawItems is List
        ? rawItems
        .whereType<Map>()
        .map(
          (e) => Map<String, dynamic>.from(e),
    )
        .toList()
        : <Map<String, dynamic>>[];

    final itemTotal = items.fold<double>(
      0,
          (sum, item) {
        final menuItem =
        _map(item['menu_item']);
        final price =
            _doubleValue(item['price_at_purchase']) ??
                _doubleValue(menuItem['price']) ??
                0;
        final quantity =
            _intValue(item['quantity']) ?? 1;
        return sum + price * quantity;
      },
    );

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.receipt_long_outlined,
            'Bill Summary',
          ),
          const SizedBox(height: 17),
          _billRow(
            'Item Total',
            '₹${itemTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _billRow(
            'Delivery Fee',
            '₹${deliveryFee.toStringAsFixed(2)}',
          ),
          if (widget.discount > 0) ...[
            const SizedBox(height: 10),
            _billRow(
              'Discount',
              '-₹${widget.discount.toStringAsFixed(2)}',
              valueColor:
              const Color(0xFF238B45),
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Divider(height: 1),
          ),
          _billRow(
            'Total',
            '₹${orderTotal.toStringAsFixed(2)}',
            bold: true,
            fontSize: 18,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT
  // ============================================================

  Widget _paymentCard() {
    final backendPayment =
    _map(_order?['order_payment']);

    final backendMethod = _string(
      backendPayment,
      'method',
    );

    // IMPORTANT:
    // If backend order info returns order_payment: null,
    // use the exact payment method selected on Checkout.
    final selectedMethod =
    backendMethod.isNotEmpty
        ? _formatPaymentMethod(
      backendMethod,
    )
        : widget.paymentType.trim().isNotEmpty
        ? widget.paymentType.trim()
        : 'Payment';

    final backendStatus = _string(
      backendPayment,
      'status',
    );

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.account_balance_wallet_outlined,
            'Payment Details',
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F9),
              borderRadius:
              BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE9ED),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    selectedMethod
                        .toLowerCase()
                        .contains('cash')
                        ? Icons.payments_outlined
                        : Icons.credit_card_rounded,
                    color: const Color(0xFFEF5B6B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        selectedMethod,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (backendStatus.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${_capitalize(backendStatus)}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF238B45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          Text(
            selectedMethod
                .toLowerCase()
                .contains('cash')
                ? 'You will pay when your order is delivered.'
                : 'Your selected online payment method is shown here.',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INVOICE
  // ============================================================

  Widget _invoiceCard() {
    final invoice = _invoice ??
        _map(_order?['invoice']);

    final invoiceNumber = _string(
      invoice,
      'invoice_number',
    );
    final generatedAt = _string(
      invoice,
      'generated_at',
    );
    final invoiceTotal =
    _doubleValue(invoice['total']);

    return _card(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _sectionTitle(
                  Icons.description_outlined,
                  'Invoice',
                ),
              ),
              if (invoiceNumber.isNotEmpty)
                _smallSuccessBadge('Generated'),
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
                _formatDate(generatedAt),
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
              onPressed: _isGeneratingInvoice
                  ? null
                  : _generateInvoice,
              icon: _isGeneratingInvoice
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
                invoiceNumber.isEmpty
                    ? 'Generate Invoice'
                    : 'Refresh Invoice',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                const Color(0xFFEF5B6B),
                side: const BorderSide(
                  color: Color(0xFFEF5B6B),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CANCEL BUTTON
  // ============================================================

  Widget _cancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 51,
      child: OutlinedButton.icon(
        onPressed: _isCancelling
            ? null
            : _cancelOrder,
        icon: _isCancelling
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFD62828),
          ),
        )
            : const Icon(
          Icons.cancel_outlined,
          size: 20,
        ),
        label: Text(
          _isCancelling
              ? 'Cancelling Order...'
              : 'Cancel Order',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor:
          const Color(0xFFD62828),
          side: const BorderSide(
            color: Color(0xFFD62828),
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONTINUE BUTTON
  // ============================================================

  Widget _continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: FilledButton.icon(
        onPressed: () {
          context.go('/home');
        },
        icon: const Icon(
          Icons.home_outlined,
        ),
        label: const Text(
          'Continue Shopping',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor:
          const Color(0xFFEF5B6B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _loadingView() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 17),
          Text(
            'Loading order details...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _circleIcon(
              Icons.error_outline_rounded,
              const Color(0xFFD62828),
              const Color(0xFFFFE9E9),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load order',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _errorMessage ??
                  'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 19),
            FilledButton.icon(
              onPressed: () =>
                  _loadOrderDetails(),
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor:
                const Color(0xFFEF5B6B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COMMON WIDGETS
  // ============================================================

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding =
    const EdgeInsets.all(17),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
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

  Widget _sectionTitle(
      IconData icon,
      String title, {
        String? trailing,
      }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDF0),
            borderRadius:
            BorderRadius.circular(11),
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
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 11.5,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _detailRow(
      IconData icon,
      String label,
      String value, {
        String? secondary,
      }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21,
          color: Colors.black54,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (secondary != null &&
                  secondary.trim().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  secondary,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
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
              fontWeight: bold
                  ? FontWeight.w900
                  : FontWeight.w500,
              color: bold
                  ? Colors.black87
                  : Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold
                ? FontWeight.w900
                : FontWeight.w700,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(
      String status, {
        bool compact = false,
      }) {
    final normalized =
    _normalizedStatus(status);
    final cancelled = normalized == 'cancelled' ||
        normalized == 'canceled';

    final color = cancelled
        ? const Color(0xFFD62828)
        : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: compact
            ? Colors.white.withOpacity(0.18)
            : const Color(0xFFEAF9EE),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        _capitalize(status),
        style: TextStyle(
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w800,
          color: compact
              ? color
              : const Color(0xFF238B45),
        ),
      ),
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

  Widget _circleIcon(
      IconData icon,
      Color iconColor,
      Color background,
      ) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 27,
      ),
    );
  }

  Widget _networkImage(
      String url, {
        required double width,
        required double height,
        required double radius,
        required IconData fallbackIcon,
      }) {
    final imageUrl = url.trim();

    if (imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F1F3),
          borderRadius:
          BorderRadius.circular(radius),
        ),
        child: Icon(
          fallbackIcon,
          color: Colors.black38,
        ),
      );
    }

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(radius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF0F1F3),
            child: Icon(
              fallbackIcon,
              color: Colors.black38,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  bool get _canCancel {
    final status = _normalizedStatus(
      _string(_order, 'status'),
    );

    return status != 'cancelled' &&
        status != 'canceled' &&
        status != 'delivered' &&
        status != 'completed';
  }

  Map<String, dynamic> _map(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  String _mapValue(
      dynamic value,
      String key,
      ) {
    final map = _map(value);
    return _string(map, key);
  }

  String _string(
      Map<String, dynamic>? map,
      String key,
      ) {
    final value = map?[key];
    return value?.toString().trim() ?? '';
  }

  String _value(
      Map<String, dynamic>? map,
      String key,
      ) {
    return _string(map, key);
  }

  int? _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(
      value?.toString() ?? '',
    );
  }

  double? _doubleValue(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(
      value?.toString() ?? '',
    );
  }

  String _addressText(
      Map<String, dynamic> address,
      ) {
    final parts = <String>[];

    final addressLine = _string(
      address,
      'address_line',
    );
    final city = _string(address, 'city');
    final state = _string(address, 'state');
    final pincode = _string(
      address,
      'pincode',
    );

    if (addressLine.isNotEmpty) {
      parts.add(addressLine);
    }
    if (city.isNotEmpty) {
      parts.add(city);
    }
    if (state.isNotEmpty) {
      parts.add(state);
    }
    if (pincode.isNotEmpty) {
      parts.add(pincode);
    }

    return parts.join(', ');
  }

  String _normalizedStatus(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('-', '_');
  }

  String _capitalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Unknown';

    return trimmed
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
          ? word
          : word[0].toUpperCase() +
          word.substring(1),
    )
        .join(' ');
  }

  String _formatPaymentMethod(String value) {
    final normalized = value
        .trim()
        .toLowerCase();

    if (normalized == 'razorpay' ||
        normalized == 'online') {
      return 'Online Payment';
    }

    if (normalized == 'cod' ||
        normalized == 'cash_on_delivery' ||
        normalized == 'cash on delivery') {
      return 'Cash on Delivery';
    }

    return _capitalize(value);
  }

  String _formatDate(String value) {
    if (value.trim().isEmpty) {
      return '';
    }

    try {
      final parsed = DateTime.parse(
        value,
      ).toLocal();

      final day = parsed.day
          .toString()
          .padLeft(2, '0');
      final month = parsed.month
          .toString()
          .padLeft(2, '0');
      final year = parsed.year.toString();
      final hour = parsed.hour
          .toString()
          .padLeft(2, '0');
      final minute = parsed.minute
          .toString()
          .padLeft(2, '0');

      return '$day/$month/$year • $hour:$minute';
    } catch (_) {
      return value;
    }
  }

  String _apiMessage(
      String body, {
        required String fallback,
      }) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map &&
          decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {}

    return fallback;
  }

  void _showSnackBar(
      String message, {
        bool error = false,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error
              ? const Color(0xFFD62828)
              : const Color(0xFF238B45),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      );
  }
}
