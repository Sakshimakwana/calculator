import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
        title: const Text(
          'Invoice PDF',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SfPdfViewer.file(
        pdfFile,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}