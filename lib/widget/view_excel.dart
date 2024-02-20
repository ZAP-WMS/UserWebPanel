import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:syncfusion_flutter_xlsio/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelViewer extends StatefulWidget {
  @override
  _ExcelViewerState createState() => _ExcelViewerState();
}

class _ExcelViewerState extends State<ExcelViewer> {
  Uint8List? _bytes;

  @override
  void initState() {
    print('Hello excel');
    super.initState();
    loadExcel();
  }

  Future<void> loadExcel() async {
    // Replace `assets/excel_file.xlsx` with the path to your Excel file.
    ByteData data = await rootBundle.load('assets/excel_file.xlsx');
    setState(() {
      _bytes = data.buffer.asUint8List();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Viewer'),
      ),
      body: Center(
        child: _bytes != null
            ? Text('data')
            // SfSpreadsheet(fileBytes: _bytes)
            : CircularProgressIndicator(),
      ),
    );
  }
}
