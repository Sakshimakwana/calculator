
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfWidgets {
  static pw.Widget boldText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
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

  static pw.Widget smallText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
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

  static pw.Widget headerCell(
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

  static pw.Widget cell(
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
            fontWeight:
            bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  static pw.Widget infoBox({
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
        crossAxisAlignment: pw.CrossAxisAlignment.start,
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

  static pw.Widget sectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(bottom: 5),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColor.fromHex('#D9233E'),
            width: 0.8,
          ),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('#D9233E'),
        ),
      ),
    );
  }

  static pw.Widget amountRow(
      String title,
      double amount, {
        PdfColor? valueColor,
      }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
}
