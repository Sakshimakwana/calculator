import 'dart:convert';
import 'dart:io';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../Login/auth_storage/auth_storage.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../Login/state/milestone_app_6_auth_store.dart';
import '../state/milestone_app_6_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/generate_invoice_animation/invoice_generation_animation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:async';

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

  // ============================================================
  // INVOICE ANIMATION
  // ============================================================

  final GlobalKey<InvoiceGenerationAnimationState>
  _invoiceAnimationKey =
  GlobalKey<InvoiceGenerationAnimationState>();

  // ============================================================
  // ORDER
  // ============================================================

  Map<String, dynamic>? _order;

  // ============================================================
  // DELIVERY
  // ============================================================

  Map<String, dynamic>? _delivery;

  bool _isLoadingDeliveryStatus = false;

  Timer? _deliveryStatusTimer;

  // ============================================================
  // INVOICE
  // ============================================================

  bool _invoicePdfReady = false;

  File? _invoicePdfFile;

  bool _isGeneratingInvoice = false;

  Map<String, dynamic>? _invoice;

  String? _invoiceError;

  // ============================================================
  // SCREEN STATE
  // ============================================================

  bool _isLoading = true;

  bool _isRefreshing = false;

  bool _isCancelling = false;

  String? _errorMessage;



  String _paymentMethodPreview() {
    final payment =
    _map(_order?['order_payment']);

    final apiMethod =
    _string(payment, 'method');

    if (apiMethod.isNotEmpty) {
      return 'Payment: $apiMethod';
    }

    if (widget.paymentType.isNotEmpty) {
      return 'Payment: ${widget.paymentType}';
    }

    return 'Payment confirmed';
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await _loadOrderDetails();

      if (!mounted) return;

      _startDeliveryStatusPolling();
    });
  }
  @override
  void dispose() {
    _deliveryStatusTimer?.cancel();
    super.dispose();
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
// GET DELIVERY STATUS
// GET /deliveries
//
// Finds the delivery record belonging to this order.
// ============================================================

  Future<void> _loadDeliveryStatus() async {
    final int? orderId = _parsedOrderId;

    if (orderId == null || _isLoadingDeliveryStatus) {
      return;
    }

    _isLoadingDeliveryStatus = true;

    try {
      final headers = await _headers();

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/deliveries',
      );

      debugPrint('');
      debugPrint('========================================');
      debugPrint('          DELIVERY STATUS API');
      debugPrint('========================================');
      debugPrint('METHOD: GET');
      debugPrint('ORDER ID: $orderId');
      debugPrint('URL: $uri');
      debugPrint('========================================');

      final response = await http
          .get(
        uri,
        headers: headers,
      )
          .timeout(
        const Duration(seconds: 30),
      );

      debugPrint(
        'DELIVERIES STATUS: ${response.statusCode}',
      );

      debugPrint(
        'DELIVERIES RESPONSE: ${response.body}',
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
            fallback: 'Unable to load delivery status.',
          ),
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception(
          'Invalid deliveries response.',
        );
      }

      final responseMap =
      Map<String, dynamic>.from(decoded);

      final rawData = responseMap['data'];

      if (rawData is! List) {
        throw Exception(
          'Delivery data is not available.',
        );
      }

      Map<String, dynamic>? matchedDelivery;

      for (final item in rawData) {
        if (item is! Map) {
          continue;
        }

        final delivery =
        Map<String, dynamic>.from(item);

        final deliveryOrderId =
        int.tryParse(
          delivery['order_id']?.toString() ?? '',
        );

        final nestedOrder =
        _map(delivery['order']);

        final nestedOrderId =
        int.tryParse(
          nestedOrder['id']?.toString() ?? '',
        );

        if (deliveryOrderId == orderId ||
            nestedOrderId == orderId) {
          matchedDelivery = delivery;
          break;
        }
      }

      if (!mounted) return;

      if (matchedDelivery != null) {
        setState(() {
          _delivery = matchedDelivery;
        });

        // ----------------------------------------------------------
        // IMPORTANT
        //
        // Delivery API contains nested order.status.
        // Keep _order status synchronized with that value.
        // ----------------------------------------------------------

        final nestedOrder =
        _map(matchedDelivery['order']);

        final backendOrderStatus =
        nestedOrder['status']?.toString().trim();

        if (backendOrderStatus != null &&
            backendOrderStatus.isNotEmpty) {
          setState(() {
            _order = {
              ...?_order,
              'status': backendOrderStatus,
            };
          });
        }

        debugPrint('');
        debugPrint('DELIVERY FOUND');
        debugPrint(
          'DELIVERY ID: ${matchedDelivery['id']}',
        );
        debugPrint(
          'DELIVERY STATUS: ${matchedDelivery['status']}',
        );
        debugPrint(
          'ORDER STATUS: ${nestedOrder['status']}',
        );
        debugPrint('========================================');
      } else {
        debugPrint(
          'No delivery record found for order $orderId',
        );
      }
    } catch (e) {
      debugPrint(
        'DELIVERY STATUS ERROR: $e',
      );
    } finally {
      _isLoadingDeliveryStatus = false;
    }
  }
// ============================================================
// DELIVERY STATUS POLLING
// ============================================================

  void _startDeliveryStatusPolling() {
    _deliveryStatusTimer?.cancel();

    _deliveryStatusTimer = Timer.periodic(
      const Duration(seconds: 10),
          (_) async {
        if (!mounted) return;

        final currentStatus =
            _currentOrderStatus;

        // Stop polling once order reaches final state.
        if (currentStatus == 'delivered' ||
            currentStatus == 'cancelled' ||
            currentStatus == 'canceled') {
          _deliveryStatusTimer?.cancel();
          return;
        }

        await _loadOrderDetails(
          refresh: true,
        );
      },
    );
  }
  String get _currentOrderStatus {
    final orderStatus = _normalizedStatus(
      _string(_order, 'status'),
    );

    if (orderStatus.isNotEmpty) {
      return orderStatus;
    }

    final deliveryStatus = _normalizedStatus(
      _string(_delivery, 'status'),
    );

    return deliveryStatus;
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
      if (!mounted) return;

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
      // ============================================================
      // 1. GET ORDER DETAILS
      // GET /orders/{orderId}
      // ============================================================

      final headers = await _headers();

      final Uri orderUri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.orderInfo(id)}',
      );

      debugPrint('');
      debugPrint('========================================');
      debugPrint('             ORDER INFO API');
      debugPrint('========================================');
      debugPrint('METHOD: GET');
      debugPrint('ORDER ID: $id');
      debugPrint('URL: $orderUri');
      debugPrint('========================================');

      final response = await http
          .get(
        orderUri,
        headers: headers,
      )
          .timeout(
        const Duration(seconds: 30),
      );

      debugPrint(
        'ORDER INFO STATUS: ${response.statusCode}',
      );

      debugPrint(
        'ORDER INFO RESPONSE: ${response.body}',
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
            fallback: 'Unable to load order details.',
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

      // Save order information first.
      Map<String, dynamic> orderData =
      Map<String, dynamic>.from(rawData);

      // ============================================================
      // 2. GET DELIVERY DETAILS
      // GET /deliveries
      // ============================================================

      Map<String, dynamic>? matchedDelivery;

      try {
        final Uri deliveryUri = Uri.parse(
          '${ApiConstants.baseUrl}/deliveries',
        );

        debugPrint('');
        debugPrint('========================================');
        debugPrint('          DELIVERY STATUS API');
        debugPrint('========================================');
        debugPrint('METHOD: GET');
        debugPrint('ORDER ID: $id');
        debugPrint('URL: $deliveryUri');
        debugPrint('========================================');

        final deliveryResponse = await http
            .get(
          deliveryUri,
          headers: headers,
        )
            .timeout(
          const Duration(seconds: 30),
        );

        debugPrint(
          'DELIVERY STATUS: '
              '${deliveryResponse.statusCode}',
        );

        debugPrint(
          'DELIVERY RESPONSE: '
              '${deliveryResponse.body}',
        );

        if (deliveryResponse.statusCode == 401) {
          throw Exception(
            'Session expired. Please login again.',
          );
        }

        if (deliveryResponse.statusCode >= 200 &&
            deliveryResponse.statusCode < 300) {
          final deliveryDecoded =
          jsonDecode(deliveryResponse.body);

          if (deliveryDecoded is Map) {
            final deliveryMap =
            Map<String, dynamic>.from(
              deliveryDecoded,
            );

            final deliveryData =
            deliveryMap['data'];

            if (deliveryData is List) {
              // ----------------------------------------------------
              // Find delivery belonging to current order.
              // ----------------------------------------------------

              for (final item in deliveryData) {
                if (item is! Map) {
                  continue;
                }

                final delivery =
                Map<String, dynamic>.from(item);

                final deliveryOrderId =
                int.tryParse(
                  delivery['order_id']?.toString() ?? '',
                );

                final nestedOrder =
                _map(delivery['order']);

                final nestedOrderId =
                int.tryParse(
                  nestedOrder['id']?.toString() ?? '',
                );

                if (deliveryOrderId == id ||
                    nestedOrderId == id) {
                  matchedDelivery = delivery;
                  break;
                }
              }
            }
          }
        }
      } catch (deliveryError) {
        // ----------------------------------------------------------
        // Do NOT fail the complete Order Details screen if the
        // delivery API has a temporary problem.
        // ----------------------------------------------------------

        debugPrint(
          'DELIVERY API ERROR: $deliveryError',
        );
      }

      // ============================================================
      // 3. SYNCHRONIZE DELIVERY + ORDER STATUS
      // ============================================================

      if (matchedDelivery != null) {
        final deliveryStatus =
        _normalizedStatus(
          matchedDelivery['status']?.toString() ?? '',
        );

        final nestedOrder =
        _map(matchedDelivery['order']);

        final nestedOrderStatus =
        _normalizedStatus(
          nestedOrder['status']?.toString() ?? '',
        );

        debugPrint('');
        debugPrint('========================================');
        debugPrint('        DELIVERY STATUS RESULT');
        debugPrint('========================================');
        debugPrint(
          'DELIVERY ID: '
              '${matchedDelivery['id']}',
        );
        debugPrint(
          'DELIVERY STATUS: $deliveryStatus',
        );
        debugPrint(
          'ORDER STATUS: $nestedOrderStatus',
        );
        debugPrint(
          'ORDER ID: $id',
        );
        debugPrint('========================================');

        // ----------------------------------------------------------
        // Backend source of truth:
        //
        // assigned
        //   -> order.status = placed
        //
        // picked
        //   -> order.status = out_for_delivery
        //
        // delivered
        //   -> order.status = delivered
        // ----------------------------------------------------------

        // Keep the real order status from /orders/{id}.
        // Delivery status is stored separately and is used by the
        // four-step delivery tracker. This is important because the
        // backend can return:
        // assigned -> order.status = placed
        // picked   -> order.status = out_for_delivery
        // delivered -> order.status = delivered
        if (orderData['status'] == null ||
            orderData['status'].toString().trim().isEmpty) {
          if (nestedOrderStatus.isNotEmpty) {
            orderData['status'] = nestedOrderStatus;
          } else {
            switch (deliveryStatus) {
              case 'assigned':
                orderData['status'] = 'placed';
                break;
              case 'picked':
                orderData['status'] = 'out_for_delivery';
                break;
              case 'delivered':
                orderData['status'] = 'delivered';
                break;
            }
          }
        }

        // Keep complete delivery information
        // available to the Order Details screen.
        orderData['delivery'] =
            matchedDelivery;
      } else {
        debugPrint(
          'No delivery record found for order $id',
        );
      }

      // ============================================================
      // 4. UPDATE UI
      // ============================================================

      if (!mounted) return;

      setState(() {
        _order = orderData;
        _delivery = matchedDelivery;

        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });

      // ============================================================
      // 5. DEBUG LOGS
      // ============================================================

      debugPrint('');
      debugPrint('========================================');
      debugPrint('          ORDER DETAILS SUCCESS');
      debugPrint('========================================');

      debugPrint(
        'ORDER ID: ${_value(_order, 'id')}',
      );

      debugPrint(
        'FINAL ORDER STATUS: '
            '${_value(_order, 'status')}',
      );

      debugPrint(
        'DELIVERY STATUS: '
            '${_delivery?['status'] ?? 'No delivery'}',
      );

      debugPrint(
        'PAYMENT FROM API: '
            '${_mapValue(
          _order?['order_payment'],
          'method',
        )}',
      );

      debugPrint(
        'SELECTED PAYMENT FROM CHECKOUT: '
            '${widget.paymentType}',
      );

      debugPrint('========================================');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = e
            .toString()
            .replaceFirst(
          'Exception: ',
          '',
        );
      });

      debugPrint(
        'ORDER INFO ERROR: $e',
      );
    }
  }
  Widget _buildInvoiceAnimationOverlay() {
    if (!_isGeneratingInvoice) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: InvoiceGenerationOverlay(
        animationKey: _invoiceAnimationKey,
        invoice: _invoice ?? <String, dynamic>{},
        order: _order,
        isPdfReady: _invoicePdfReady,
        onViewPdf: _viewInvoicePdf,
        onDownload: _downloadInvoicePdf,
        generatingText: _invoicePdfReady
            ? 'Invoice PDF ready'
            : 'Generating invoice...',
      ),
    );
  }

  Widget _invoiceActionButtons() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _viewInvoicePdf,
              icon: const Icon(
                Icons.picture_as_pdf_rounded,
                size: 18,
              ),
              label: const Text(
                'View PDF',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                const Color(0xFFE53950),
                backgroundColor:
                Colors.white,
                side: const BorderSide(
                  color: Color(0xFFE53950),
                  width: 1.2,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: ElevatedButton.icon(
              onPressed:
              _downloadInvoicePdf,
              icon: const Icon(
                Icons.download_rounded,
                size: 18,
              ),
              label: const Text(
                'Download',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFE53950),
                foregroundColor:
                Colors.white,
                elevation: 4,
                shadowColor:
                const Color(0x55E53950),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAnimatedInvoicePaperContent() {
    final invoice = _invoice ?? {};

    final restaurant = _map(
      _order?['restaurant'],
    );

    final customer = _map(
      _order?['customer'],
    );

    final address = _map(
      _order?['delivery_address'],
    );

    final restaurantName =
    _string(restaurant, 'name').isNotEmpty
        ? _string(restaurant, 'name')
        : 'Restaurant';

    final invoiceNumber =
    _string(invoice, 'invoice_number').isNotEmpty
        ? _string(invoice, 'invoice_number')
        : 'INV-${widget.orderId ?? '-'}';

    final orderNumber =
    _string(_order ?? {}, 'id').isNotEmpty
        ? _string(_order ?? {}, 'id')
        : widget.orderId ?? '-';

    final customerName =
    _string(customer, 'full_name').isNotEmpty
        ? _string(customer, 'full_name')
        : _string(
      _map(invoice['user']),
      'full_name',
    );

    final city = _string(
      address,
      'city',
    );

    final state = _string(
      address,
      'state',
    );

    final addressLine = _string(
      address,
      'address_line',
    );

    final deliveryFee =
        _doubleValue(invoice['delivery_fee']) ??
            _doubleValue(
              _order?['delivery_fee'],
            ) ??
            0;

    final total =
        _doubleValue(invoice['total']) ??
            _doubleValue(
              _order?['total'],
            ) ??
            0;

    final items = _order?['order_items'] is List
        ? List<dynamic>.from(
      _order!['order_items'],
    )
        : _order?['items'] is List
        ? List<dynamic>.from(
      _order!['items'],
    )
        : <dynamic>[];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // ============================================================
          // HEADER
          // ============================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      'ORDER INVOICE',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53950),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                  const Color(0xFFFFEEF1),
                  borderRadius:
                  BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 16,
                  color:
                  Color(0xFFE53950),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Container(
            height: 1,
            color: Colors.black12,
          ),

          const SizedBox(height: 5),

          // ============================================================
          // ORDER DETAILS
          // ============================================================

          _invoicePreviewRow(
            'Invoice',
            invoiceNumber,
          ),

          _invoicePreviewRow(
            'Order',
            '#$orderNumber',
          ),

          _invoicePreviewRow(
            'Customer',
            customerName.isEmpty
                ? '-'
                : customerName,
          ),

          if (city.isNotEmpty ||
              state.isNotEmpty)
            _invoicePreviewRow(
              'Location',
              [
                city,
                state,
              ].where((e) => e.isNotEmpty).join(', '),
            ),

          // ============================================================
          // ADDRESS
          // ============================================================

          if (addressLine.isNotEmpty) ...[
            const SizedBox(height: 4),

            const Text(
              'DELIVERY ADDRESS',
              style: TextStyle(
                fontSize: 7,
                fontWeight:
                FontWeight.w900,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              [
                addressLine,
                city,
                state,
              ]
                  .where(
                    (e) => e.isNotEmpty,
              )
                  .join(', '),
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 7.2,
                height: 1.15,
                color: Colors.black87,
              ),
            ),
          ],

          const SizedBox(height: 5),

          Container(
            height: 1,
            color: Colors.black12,
          ),

          const SizedBox(height: 5),

          // ============================================================
          // ITEMS
          // ============================================================

          const Text(
            'ITEMS',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w900,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 3),

          if (items.isNotEmpty)
            ...items.take(3).map(
                  (rawItem) {
                final item =
                _map(rawItem);

                final menuItem =
                _map(item['menu_item']);

                final name =
                _string(
                  menuItem,
                  'name',
                );

                final quantity =
                    _intValue(
                      item['quantity'],
                    ) ??
                        1;

                final price =
                    _doubleValue(
                      item[
                      'price_at_purchase'
                      ],
                    ) ??
                        _doubleValue(
                          menuItem['price'],
                        ) ??
                        0;

                final itemTotal =
                    _doubleValue(
                      item['total_price'],
                    ) ??
                        price * quantity;

                return _invoiceItemPreviewRow(
                  name.isEmpty
                      ? 'Food Item'
                      : name,
                  quantity,
                  itemTotal,
                );
              },
            )
          else
            const Text(
              'Food items',
              style: TextStyle(
                fontSize: 7.5,
                color: Colors.black87,
              ),
            ),

          const SizedBox(height: 4),

          Container(
            height: 1,
            color: Colors.black12,
          ),

          const SizedBox(height: 4),

          // ============================================================
          // AMOUNTS
          // ============================================================

          _invoicePreviewAmountRow(
            'Delivery',
            deliveryFee,
          ),

          _invoicePreviewAmountRow(
            'Total',
            total,
            bold: true,
          ),

          const SizedBox(height: 4),

          // ============================================================
          // PAYMENT STATUS
          // ============================================================

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color:
              const Color(0xFFF2FFF6),
              borderRadius:
              BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 13,
                  color: Colors.green,
                ),

                const SizedBox(width: 4),

                Expanded(
                  child: Text(
                    _paymentMethodPreview(),
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 7.5,
                      fontWeight:
                      FontWeight.w800,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Center(
            child: Text(
              _invoicePdfReady
                  ? '✓ Invoice Ready'
                  : 'Generating invoice...',
              style: TextStyle(
                fontSize: 7,
                fontWeight:
                FontWeight.w800,
                color: _invoicePdfReady
                    ? Colors.green
                    : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _invoicePreviewRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 1,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 6.2,
                color: Colors.black45,
              ),
            ),
          ),

          const SizedBox(width: 3),

          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 6.4,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _invoiceItemPreviewRow(
      String name,
      int quantity,
      double amount,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 1.5,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 6.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            '×$quantity',
            style: const TextStyle(
              fontSize: 6.1,
              color: Colors.black45,
            ),
          ),

          const SizedBox(width: 4),

          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 6.3,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
  Widget _invoicePreviewAmountRow(
      String title,
      double amount, {
        bool bold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: bold ? 7 : 6.3,
                fontWeight: bold
                    ? FontWeight.w900
                    : FontWeight.w500,
              ),
            ),
          ),

          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: bold ? 7.2 : 6.3,
              fontWeight: bold
                  ? FontWeight.w900
                  : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _downloadInvoicePdf() async {
    if (_invoicePdfFile == null) {
      return;
    }

    try {
      final bytes =
      await _invoicePdfFile!.readAsBytes();

      await FileSaver.instance.saveToDownloads(
        name: 'invoice_${widget.orderId}',
        bytes: bytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
        subfolder: 'Invoices',
      );

      if (!mounted) return;

      setState(() {
        _isGeneratingInvoice = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invoice downloaded successfully.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to save invoice: $e',
          ),
        ),
      );
    }
  }
  // ============================================================
  // GENERATE INVOICE
  // GET /orders/{orderId}/invoice
  // ============================================================

  Future<void> _generateInvoice() async {
    final orderId = int.tryParse(widget.orderId ?? '');

    if (orderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid order ID'),
        ),
      );
      return;
    }

    // ============================================================
    // RESET OLD INVOICE AND OPEN THE ANIMATION OVERLAY
    // ============================================================

    setState(() {
      _isGeneratingInvoice = true;
      _invoicePdfReady = false;
      _invoicePdfFile = null;
      _invoiceError = null;
      _invoice = null;
    });

    try {
      final token = await AuthStorage.token;

      // ==========================================================
      // INVOICE API
      // ==========================================================

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}'
              '${ApiConstants.generateInvoice(orderId)}',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token?.trim()}',
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('INVOICE API STATUS: ${response.statusCode}');
      debugPrint('INVOICE API RESPONSE: ${response.body}');

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final Map<String, dynamic> json =
        jsonDecode(response.body);

        if (json['success'] == true) {
          // ========================================================
          // 1. SAVE REAL API DATA
          // ========================================================

          final invoiceData =
          Map<String, dynamic>.from(
            json['data'] ?? {},
          );

          if (invoiceData.isEmpty) {
            throw Exception(
              'Invoice data is empty.',
            );
          }

          if (!mounted) return;

          setState(() {
            _invoice = invoiceData;
          });

          // ========================================================
          // 2. START CODE-BASED ANIMATION AFTER DATA IS PAINTED
          // ========================================================
          // addPostFrameCallback runs after the current frame has
          // been rendered, so the real API data and animation begin
          // together instead of using a guessed delay.

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            _invoiceAnimationKey.currentState?.start();
          });

          // ========================================================
          // 3. GENERATE PDF WHILE ANIMATION IS RUNNING
          // ========================================================

          debugPrint('GENERATING INVOICE PDF...');

          final pdfFile = await _generateInvoicePdf();

          debugPrint('PDF CREATED: ${pdfFile.path}');

          if (!mounted) return;

          // ========================================================
          // 4. PDF READY - KEEP OVERLAY OPEN
          // ========================================================

          setState(() {
            _invoicePdfFile = pdfFile;
            _invoicePdfReady = true;
            _isGeneratingInvoice = true;
          });
        } else {
          throw Exception(
            json['message'] ??
                'Failed to generate invoice',
          );
        }
      } else {
        throw Exception(
          'Invoice API failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _invoiceError = e.toString();
        _invoicePdfReady = false;
        _isGeneratingInvoice = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invoice generation failed: $e',
          ),
        ),
      );
    }
  }

  void _viewInvoicePdf() {
    final file = _invoicePdfFile;

    if (file == null || !file.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invoice PDF is not available.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvoicePdfViewerScreen(
          pdfFile: file,
        ),
      ),
    );
  }
// ============================================================
// GENERATE INVOICE PDF
// ============================================================

  Future<File> _generateInvoicePdf() async {
    final invoice = _invoice ?? <String, dynamic>{};

    // ============================================================
    // DATA
    // ============================================================

    final restaurant = _map(_order?['restaurant']);

    final restaurantName = _string(restaurant, 'name').isNotEmpty
        ? _string(restaurant, 'name')
        : 'Restaurant';

    final restaurantAddress = _string(restaurant, 'address');

    final invoiceNumber = _string(invoice, 'invoice_number').isNotEmpty
        ? _string(invoice, 'invoice_number')
        : 'INV-${widget.orderId ?? '-'}';

    final generatedAt = _string(invoice, 'generated_at').isNotEmpty
        ? _string(invoice, 'generated_at')
        : _string(_order ?? <String, dynamic>{}, 'created_at');

    final formattedDate =
    generatedAt.isNotEmpty ? _formatDate(generatedAt) : '-';

    final customer = _map(_order?['customer']);
    final invoiceUser = _map(invoice['user']);

    final customerName =
    _string(customer, 'full_name').isNotEmpty
        ? _string(customer, 'full_name')
        : _string(invoiceUser, 'full_name');

    final customerEmail =
    _string(customer, 'email').isNotEmpty
        ? _string(customer, 'email')
        : _string(invoiceUser, 'email');

    final customerPhone =
    _string(customer, 'phone_number').isNotEmpty
        ? _string(customer, 'phone_number')
        : _string(invoiceUser, 'phone_number');

    final address = _map(_order?['delivery_address']);

    final deliveryAddress = [
      _string(address, 'address_line'),
      _string(address, 'city'),
      _string(address, 'state'),
      _string(address, 'pincode'),
    ].where((e) => e.trim().isNotEmpty).join(', ');

    final backendPayment = _map(_order?['order_payment']);

    final backendMethod = _string(backendPayment, 'method');

    final paymentMethod = backendMethod.isNotEmpty
        ? _formatPaymentMethod(backendMethod)
        : widget.paymentType.trim().isNotEmpty
        ? widget.paymentType.trim()
        : 'Payment';

    final rawItems = _order?['order_items'];

    final List<Map<String, dynamic>> items = rawItems is List
        ? rawItems
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList()
        : <Map<String, dynamic>>[];

    // ------------------------------------------------------------
    // Item helpers
    // ------------------------------------------------------------

    String itemName(Map<String, dynamic> item) {
      final menuItem = _map(item['menu_item']);
      final food = _map(item['food']);
      final product = _map(item['product']);

      final candidates = <dynamic>[
        item['name'],
        item['item_name'],
        item['menu_item_name'],
        item['food_name'],
        item['product_name'],
        item['title'],
        menuItem['name'],
        menuItem['item_name'],
        menuItem['title'],
        food['name'],
        food['item_name'],
        food['title'],
        product['name'],
        product['item_name'],
        product['title'],
      ];

      for (final value in candidates) {
        final valueText = value?.toString().trim() ?? '';
        if (valueText.isNotEmpty && valueText.toLowerCase() != 'null') {
          return valueText;
        }
      }

      return 'Food Item';
    }

    double itemPrice(Map<String, dynamic> item) {
      final menuItem = _map(item['menu_item']);

      return _doubleValue(item['price_at_purchase']) ??
          _doubleValue(item['price']) ??
          _doubleValue(item['unit_price']) ??
          _doubleValue(menuItem['price']) ??
          0;
    }

    int itemQuantity(Map<String, dynamic> item) {
      return _intValue(item['quantity']) ??
          _intValue(item['qty']) ??
          _intValue(item['count']) ??
          1;
    }

    double calculateItemTotal(Map<String, dynamic> item) {
      final price = itemPrice(item);
      final quantity = itemQuantity(item);

      return _doubleValue(item['total_price']) ??
          _doubleValue(item['total']) ??
          _doubleValue(item['subtotal']) ??
          price * quantity;
    }

    final itemTotal = items.fold<double>(
      0,
          (sum, item) => sum + calculateItemTotal(item),
    );

    final deliveryFee =
        _doubleValue(invoice['delivery_fee']) ??
            _doubleValue(_order?['delivery_fee']) ??
            widget.shipping;

    final discount =
        _doubleValue(invoice['discount']) ??
            _doubleValue(_order?['discount']) ??
            widget.discount;

    final orderTotal =
        _doubleValue(invoice['total']) ??
            _doubleValue(invoice['grand_total']) ??
            _doubleValue(_order?['total']) ??
            widget.totalPayment;

    // ============================================================
    // FONTS
    // ============================================================

    final regularFont = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/NotoSans-Regular.ttf',
      ),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/NotoSans-Bold.ttf',
      ),
    );

    // ============================================================
    // LOGO
    //
    // Put your application logo at:
    // assets/images/tomato_logo.png
    //
    // If the asset is not available, the PDF still generates
    // without crashing.
    // ============================================================

    pw.MemoryImage? logoImage;

    try {
      final logoData = await rootBundle.load(
        'assets/images/tomato_logo.png',
      );

      logoImage = pw.MemoryImage(
        logoData.buffer.asUint8List(),
      );
    } catch (_) {
      logoImage = null;
    }

    // ============================================================
    // PDF
    // BLACK + WHITE ONLY
    // ============================================================

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: regularFont,
        bold: boldFont,
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(
          34,
          32,
          34,
          30,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // LOGO
                  if (logoImage != null)
                    pw.Container(
                      width: 58,
                      height: 58,
                      padding: const pw.EdgeInsets.all(7),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: 1,
                        ),
                        borderRadius:
                        pw.BorderRadius.circular(8),
                      ),
                      child: pw.Image(
                        logoImage!,
                        fit: pw.BoxFit.contain,
                      ),
                    )
                  else
                    pw.Container(
                      width: 58,
                      height: 58,
                      alignment: pw.Alignment.center,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.black,
                          width: 1,
                        ),
                        borderRadius:
                        pw.BorderRadius.circular(8),
                      ),
                      child: pw.Text(
                        'T',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                  pw.SizedBox(width: 14),

                  // RESTAURANT
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          restaurantName,
                          maxLines: 2,
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight:
                            pw.FontWeight.bold,
                          ),
                        ),
                        if (restaurantAddress.isNotEmpty)
                          pw.Padding(
                            padding:
                            const pw.EdgeInsets.only(
                              top: 3,
                            ),
                            child: pw.Text(
                              restaurantAddress,
                              maxLines: 2,
                              style: const pw.TextStyle(
                                fontSize: 8.5,
                                color:
                                PdfColors.grey700,
                              ),
                            ),
                          ),
                        pw.SizedBox(height: 7),
                        pw.Text(
                          'ORDER INVOICE',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight:
                            pw.FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(width: 14),

                  // INVOICE META
                  pw.Column(
                    crossAxisAlignment:
                    pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight:
                          pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        invoiceNumber,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight:
                          pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Order #${widget.orderId ?? '-'}',
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        formattedDate,
                        style: const pw.TextStyle(
                          fontSize: 7.5,
                          color:
                          PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 14),

              pw.Divider(
                color: PdfColors.black,
                thickness: 1.2,
              ),

              pw.SizedBox(height: 12),

              // ==================================================
              // BILL TO / DELIVERY TO
              // ==================================================

              pw.Row(
                crossAxisAlignment:
                pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _pdfInfoBox(
                      title: 'BILL TO',
                      children: [
                        _pdfBoldText(
                          customerName.isEmpty
                              ? 'Customer'
                              : customerName,
                        ),
                        if (customerPhone.isNotEmpty)
                          _pdfSmallText(
                            customerPhone,
                          ),
                        if (customerEmail.isNotEmpty)
                          _pdfSmallText(
                            customerEmail,
                          ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 12),
                  pw.Expanded(
                    child: _pdfInfoBox(
                      title: 'DELIVERY TO',
                      children: [
                        _pdfBoldText(
                          address['label']
                              ?.toString()
                              .trim()
                              .isNotEmpty ==
                              true
                              ? address['label']
                              .toString()
                              : 'Delivery Address',
                        ),
                        if (deliveryAddress.isNotEmpty)
                          _pdfSmallText(
                            deliveryAddress,
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),

              // ==================================================
              // ORDERED ITEMS
              // ==================================================

              pw.Text(
                'ORDERED ITEMS',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.7,
                ),
              ),

              pw.SizedBox(height: 6),

              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.grey400,
                    width: .7,
                  ),
                ),
                child: pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(5),
                    1: pw.FlexColumnWidth(1.1),
                    2: pw.FlexColumnWidth(2),
                    3: pw.FlexColumnWidth(2.2),
                  },
                  children: [
                    pw.TableRow(
                      decoration:
                      const pw.BoxDecoration(
                        color: PdfColors.grey200,
                      ),
                      children: [
                        _pdfHeaderCell('ITEM'),
                        _pdfHeaderCell('QTY'),
                        _pdfHeaderCell(
                          'PRICE',
                          right: true,
                        ),
                        _pdfHeaderCell(
                          'AMOUNT',
                          right: true,
                        ),
                      ],
                    ),
                    ...items.map(
                          (item) {
                        final name = itemName(item);
                        final quantity =
                        itemQuantity(item);
                        final price =
                        itemPrice(item);
                        final total = calculateItemTotal(item);

                        return pw.TableRow(
                          children: [
                            _pdfCell(
                              name,
                            ),
                            _pdfCell(
                              quantity.toString(),
                              center: true,
                            ),
                            _pdfCell(
                              '₹${price.toStringAsFixed(2)}',
                              right: true,
                            ),
                            _pdfCell(
                              '₹${total.toStringAsFixed(2)}',
                              right: true,
                              bold: true,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 14),

              // ==================================================
              // PAYMENT + TOTALS
              // ==================================================

              pw.Row(
                crossAxisAlignment:
                pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _pdfInfoBox(
                      title: 'PAYMENT',
                      children: [
                        _pdfBoldText(
                          paymentMethod,
                        ),
                        _pdfSmallText(
                          'Order #${widget.orderId ?? '-'}',
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(width: 24),

                  pw.SizedBox(
                    width: 220,
                    child: pw.Column(
                      children: [
                        _pdfAmountRow(
                          'Item Total',
                          itemTotal,
                        ),
                        _pdfAmountRow(
                          'Delivery Fee',
                          deliveryFee,
                        ),
                        if (discount != 0)
                          _pdfAmountRow(
                            'Discount',
                            -discount,
                          ),
                        pw.SizedBox(height: 4),
                        pw.Divider(
                          color: PdfColors.black,
                        ),
                        pw.SizedBox(height: 5),
                        pw.Row(
                          mainAxisAlignment:
                          pw.MainAxisAlignment
                              .spaceBetween,
                          children: [
                            pw.Text(
                              'GRAND TOTAL',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight:
                                pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              '₹${orderTotal.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight:
                                pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // ==================================================
              // FOOTER
              // ==================================================

              pw.Divider(
                color: PdfColors.grey400,
              ),

              pw.SizedBox(height: 6),

              pw.Center(
                child: pw.Text(
                  'Thank you for ordering with us!',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight:
                    pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 3),

              pw.Center(
                child: pw.Text(
                  'This is a computer-generated invoice and does not require a signature.',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    final directory =
    await getTemporaryDirectory();

    final file = File(
      '${directory.path}/invoice_${widget.orderId}.pdf',
    );

    await file.writeAsBytes(
      bytes,
      flush: true,
    );

    return file;
  }
  pw.Widget _pdfBoldText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        bottom: 2,
      ),
      child: pw.Text(
        text,
        maxLines: 2,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }
  pw.Widget _pdfSmallText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(
        bottom: 2,
      ),
      child: pw.Text(
        text,
        maxLines: 3,
        style: const pw.TextStyle(
          fontSize: 7.5,
          color: PdfColors.grey700,
        ),
      ),
    );
  }
  pw.Widget _pdfHeaderCell(
      String text, {
        bool center = false,
        bool right = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      child: pw.Align(
        alignment: right
            ? pw.Alignment.centerRight
            : center
            ? pw.Alignment.center
            : pw.Alignment.centerLeft,
        child: pw.Text(
          text,
          textAlign: right
              ? pw.TextAlign.right
              : center
              ? pw.TextAlign.center
              : pw.TextAlign.left,
          style: pw.TextStyle(
            fontSize: 7,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
  }
  pw.Widget _pdfCell(
      String text, {
        bool center = false,
        bool right = false,
        bool bold = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 7,
      ),
      child: pw.Align(
        alignment: right
            ? pw.Alignment.centerRight
            : center
            ? pw.Alignment.center
            : pw.Alignment.centerLeft,
        child: pw.Text(
          text,
          maxLines: 2,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: bold
                ? pw.FontWeight.bold
                : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  pw.Widget _pdfInfoBox({
    required String title,
    required List<pw.Widget> children,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(9),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColor.fromHex('#E5E5E5'),
          width: .7,
        ),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment:
        pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#D9233E'),
            ),
          ),
          pw.SizedBox(height: 5),
          ...children,
        ],
      ),
    );
  }
  pw.Widget _pdfSectionTitle(
      String title,
      ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(
        bottom: 5,
      ),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.black,
            width: 0.8,
          ),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfAmountRow(
      String title,
      double amount, {
        PdfColor? valueColor,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: pw.Row(
        mainAxisAlignment:
        pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            '₹${amount.abs().toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 8,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
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
                : () => _loadOrderDetails(refresh: true),
            tooltip: 'Refresh order',
            icon: _isRefreshing
                ? const SizedBox(
              width: 19,
              height: 19,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
      ),

      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            _buildBody(),


            _buildInvoiceAnimationOverlay(),
          ],
        ),
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

  Widget  _statusCard() {

    final int currentStep = 0;

    final List<_OrderStatusStep> steps = [
      _OrderStatusStep(
        title: 'Order\nPlaced',
        shortTitle: 'Order Placed',
        icon: Icons.receipt_long_rounded,
      ),
      _OrderStatusStep(
        title: 'Partner\nAssigned',
        shortTitle: 'Partner Assigned',
        icon: Icons.delivery_dining_rounded,
      ),
      _OrderStatusStep(
        title: 'Out for\nDelivery',
        shortTitle: 'Out for Delivery',
        icon: Icons.two_wheeler_rounded,
      ),
      _OrderStatusStep(
        title: 'Delivered',
        shortTitle: 'Delivered',
        icon: Icons.home_rounded,
      ),
    ];

    final String currentMessage;

    switch (currentStep) {
      case 0:
        currentMessage = 'Your order is confirmed';
        break;
      case 1:
        currentMessage = 'A delivery partner has been assigned';
        break;
      case 2:
        currentMessage = 'Your order is on the way';
        break;
      case 3:
        currentMessage = 'Your order has been delivered';
        break;
      default:
        currentMessage = 'Your order is being processed';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------------
          // HEADER
          // ----------------------------------------------------------
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        'Order Status',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF171717),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        'Track your order in real time',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF929292),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // // LIVE BADGE
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 11,
              //     vertical: 7,
              //   ),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFFFF0F3),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Container(
              //         width: 7,
              //         height: 7,
              //         decoration: const BoxDecoration(
              //           color: Color(0xFFE91E4D),
              //           shape: BoxShape.circle,
              //         ),
              //       ),
              //       const SizedBox(width: 6),
              //       const Text(
              //         'LIVE',
              //         style: TextStyle(
              //           color: Color(0xFFE91E4D),
              //           fontSize: 11,
              //           fontWeight: FontWeight.w800,
              //           letterSpacing: 0.5,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 28),

          // ----------------------------------------------------------
          // STATUS TIMELINE
          // ----------------------------------------------------------
          SizedBox(
            height: 122,
            child: Stack(
              children: [
                // BACKGROUND LINE
                Positioned(
                  left: 28,
                  right: 28,
                  top: 23,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9E9E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // COMPLETED / ACTIVE LINE
                if (currentStep > 0)
                  Positioned(
                    left: 28,
                    right: 28,
                    top: 23,
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: currentStep / 3,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9435F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                // STEPS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    steps.length,
                        (index) {
                      final bool isCompleted = index < currentStep;
                      final bool isCurrent = index == currentStep;

                      return Expanded(
                        child: Column(
                          children: [
                            // ICON
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: isCurrent ? 48 : 44,
                              height: isCurrent ? 48 : 44,
                              decoration: BoxDecoration(
                                color: isCompleted || isCurrent
                                    ? const Color(0xFFE9435F)
                                    : const Color(0xFFF1F1F1),
                                shape: BoxShape.circle,
                                border: isCurrent
                                    ? Border.all(
                                  color: const Color(0xFFFFC4CE),
                                  width: 5,
                                )
                                    : null,
                                boxShadow: isCurrent
                                    ? [
                                  BoxShadow(
                                    color: const Color(0xFFE9435F)
                                        .withOpacity(0.22),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ]
                                    : null,
                              ),
                              child: Icon(
                                isCompleted
                                    ? Icons.check_rounded
                                    : steps[index].icon,
                                size: 21,
                                color: isCompleted || isCurrent
                                    ? Colors.white
                                    : const Color(0xFF9B9B9B),
                              ),
                            ),

                            const SizedBox(height: 11),

                            // TITLE
                            SizedBox(
                              height: 34,
                              child: Text(
                                steps[index].title,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.15,
                                  fontWeight: isCurrent
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isCompleted || isCurrent
                                      ? const Color(0xFFE9435F)
                                      : const Color(0xFF888888),
                                ),
                              ),
                            ),

                            // CURRENT BADGE
                            if (isCurrent)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEEF1),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: const Text(
                                  'CURRENT',
                                  style: TextStyle(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFE9435F),
                                    letterSpacing: 0.4,
                                  ),
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
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------------
          // CURRENT STATUS MESSAGE
          // ----------------------------------------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F8),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: const Color(0xFFFFDCE2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8EC),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFFE9435F),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[currentStep].shortTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF202020),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        currentMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B8B8B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFFAAAAAA),
                  ),
                ),
              ],
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


// ============================================================
// INVOICE PDF VIEWER
// ============================================================
//
// This viewer is intentionally kept in the same Dart file because
// MilestoneApp6OrderDetailsScreen already calls InvoicePdfViewerScreen.
// The generated PDF itself is black/white; the viewer also uses a
// white application background so no pink/purple UI is introduced.
// ============================================================

class InvoicePdfViewerScreen extends StatelessWidget {
  final File pdfFile;

  const InvoicePdfViewerScreen({
    super.key,
    required this.pdfFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Invoice PDF',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SfPdfViewer.file(
          pdfFile,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
        ),
      ),
    );
  }
}
class _OrderStatusStep {
  final String title;
  final String shortTitle;
  final IconData icon;

  const _OrderStatusStep({
    required this.title,
    required this.shortTitle,
    required this.icon,
  });
}
