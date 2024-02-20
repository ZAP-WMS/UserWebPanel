import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../widget/custom_appbar.dart';

class ResourceAllocation extends StatefulWidget {
  String? cityName;
  String? depoName;

  ResourceAllocation(
      {super.key, required this.depoName, required this.cityName});

  @override
  State<ResourceAllocation> createState() => _ResourceAllocationState();
}

class _ResourceAllocationState extends State<ResourceAllocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CustomAppBar(
            text:
                '${widget.cityName} / ${widget.depoName} / Resource Allocation ',
            haveSynced: false,
          ),
          preferredSize: Size.fromHeight(50)

          // actions: [
          //   ElevatedButton(
          //       onPressed: () {
          //         PdfPreview(
          //           build: (format) => _generatePdf(format, 'title'),
          //         );
          //       },
          //       child: const Text('print'))
          // ],
          ),
      body: const Center(
        child: Text(
          'Hierarchy & Designation flow \n Under Process',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.nunitoExtraLight();

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          children: [
            pw.SizedBox(
              width: double.infinity,
              child: pw.FittedBox(
                child: pw.Text(title, style: pw.TextStyle(font: font)),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Flexible(child: pw.FlutterLogo())
          ],
        );
      },
    ),
  );

  return pdf.save();
}
