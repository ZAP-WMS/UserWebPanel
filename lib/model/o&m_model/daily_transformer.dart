import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyTransformerModel {
  DailyTransformerModel({
    required this.trNo,
    required this.pc,
    required this.ec,
    required this.ol,
    required this.oc,
    required this.wtiTemp,
    required this.otiTemp,
    required this.brk,
    required this.cta,
  });
  int? trNo;
  String? pc;
  String? ec;
  dynamic ol;
  String? oc;
  String? wtiTemp;
  String? otiTemp;
  String? brk;
  String? cta;

  factory DailyTransformerModel.fromjson(Map<String, dynamic> json) {
    return DailyTransformerModel(
        trNo: json['trNo'],
        pc: json['pc'],
        ec: json['ec'],
        ol: json['ol'],
        oc: json['oc'],
        wtiTemp: json['wtiTemp'],
        otiTemp: json['otiTemp'],
        brk: json['brk'],
        cta: json['cta']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'trNo', value: trNo),
      DataGridCell(columnName: 'pc', value: pc),
      DataGridCell(columnName: 'ec', value: ec),
      DataGridCell(columnName: 'ol', value: ol),
      DataGridCell(columnName: 'oc', value: oc),
      DataGridCell(columnName: 'wtiTemp', value: wtiTemp),
      DataGridCell(columnName: 'otiTemp', value: otiTemp),
      DataGridCell(columnName: 'brk', value: brk),
      DataGridCell(columnName: 'cta', value: cta),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
