import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class InvoicePdfService {
  Future<File> generate({
    required Map<String, dynamic>? order,
    required Map<String, dynamic>? invoice,
    required String? orderId,
    required String paymentType,
    required double shipping,
    required double discount,
    required double totalPayment,
  }) async {
    final invoiceData = invoice ?? <String, dynamic>{};

    final restaurant = _asMap(order?['restaurant']);
    final customer = _asMap(order?['customer']);
    final address = _asMap(order?['delivery_address']);
    final payment = _asMap(order?['order_payment']);

    final restaurantName =
    _stringValue(restaurant, 'name').isNotEmpty
        ? _stringValue(restaurant, 'name')
        : 'Restaurant';

    final invoiceNumber =
    _stringValue(invoiceData, 'invoice_number').isNotEmpty
        ? _stringValue(invoiceData, 'invoice_number')
        : 'INV-${orderId ?? '-'}';

    final paymentMethod =
    _stringValue(payment, 'method').isNotEmpty
        ? _stringValue(payment, 'method')
        : paymentType;

    final rawItems = order?['order_items'];
    final items = rawItems is List
        ? rawItems
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList()
        : <Map<String, dynamic>>[];

    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: regularFont,
        bold: boldFont,
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          pw.Text(
            restaurantName,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 20,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text('INVOICE: $invoiceNumber'),
          pw.Text('Order ID: ${orderId ?? '-'}'),
          pw.Divider(),
          pw.Text(
            'CUSTOMER DETAILS',
            style: pw.TextStyle(font: boldFont),
          ),
          pw.Text(
            'Name: ${_stringValue(customer, 'full_name')}',
          ),
          pw.Text(
            'Email: ${_stringValue(customer, 'email')}',
          ),
          pw.Text(
            'Phone: ${_stringValue(customer, 'phone_number')}',
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'DELIVERY ADDRESS',
            style: pw.TextStyle(font: boldFont),
          ),
          pw.Text(
            [
              address['address_line'],
              address['city'],
              address['state'],
              address['pincode'],
            ]
                .where((value) =>
            value != null &&
                value.toString().trim().isNotEmpty)
                .join(', '),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'ORDER ITEMS',
            style: pw.TextStyle(font: boldFont),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: const ['Item', 'Qty', 'Price', 'Amount'],
            data: items.map((item) {
              final name = _itemName(item);
              final quantity = _intValue(item['quantity']) ?? 1;
              final price = _itemPrice(item);
              final amount =
                  _doubleValue(item['total_price']) ??
                      price * quantity;

              return [
                name,
                quantity.toString(),
                'Rs. ${price.toStringAsFixed(2)}',
                'Rs. ${amount.toStringAsFixed(2)}',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              font: boldFont,
              fontSize: 9,
            ),
            cellStyle: const pw.TextStyle(fontSize: 8),
            border: pw.TableBorder.all(
              color: PdfColors.grey400,
              width: 0.5,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Divider(),
          _amountRow(
            'Delivery',
            _doubleValue(invoiceData['delivery_fee']) ?? shipping,
          ),
          _amountRow(
            'Discount',
            _doubleValue(invoiceData['discount']) ?? discount,
          ),
          _amountRow(
            'Total',
            _doubleValue(invoiceData['total']) ?? totalPayment,
            bold: true,
          ),
          pw.SizedBox(height: 12),
          pw.Text('Payment method: $paymentMethod'),
          pw.SizedBox(height: 18),
          pw.Center(
            child: pw.Text(
              'Thank you for your order!',
              style: pw.TextStyle(font: boldFont),
            ),
          ),
        ],
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/invoice_${orderId ?? 'order'}.pdf',
    );

    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  pw.Widget _amountRow(
      String label,
      double amount, {
        bool bold = false,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight:
              bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            'Rs. ${amount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontWeight:
              bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  String _stringValue(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null || value.toString().trim().toLowerCase() == 'null') {
      return '';
    }
    return value.toString().trim();
  }

  double? _doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  int? _intValue(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  String _itemName(Map<String, dynamic> item) {
    final menuItem = _asMap(item['menu_item']);

    for (final value in [
      item['name'],
      item['item_name'],
      item['menu_item_name'],
      menuItem['name'],
      menuItem['item_name'],
    ]) {
      final name = value?.toString().trim() ?? '';
      if (name.isNotEmpty && name.toLowerCase() != 'null') {
        return name;
      }
    }

    return 'Food Item';
  }

  double _itemPrice(Map<String, dynamic> item) {
    final menuItem = _asMap(item['menu_item']);

    return _doubleValue(item['price_at_purchase']) ??
        _doubleValue(item['price']) ??
        _doubleValue(item['unit_price']) ??
        _doubleValue(menuItem['price']) ??
        0;
  }
}