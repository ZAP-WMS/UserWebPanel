import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailySfuModel {
  DailySfuModel(
      {required this.sfuNo,
    required  this.fuc,
      // required this.state,
      // required this.depotName,
      required this.icc,
      required this.ictc,
      required this.occ,
      required this.octc,
      required this.ec,
      required this.cg,
      required this.dl,
      required this.vi});
  int? sfuNo;
  String? fuc;
  String? icc;
  dynamic ictc;
  String? occ;
  String? octc;
  String? ec;
  String? cg;
  String? dl;
  String? vi;

  factory DailySfuModel.fromjson(Map<String, dynamic> json) {
    return DailySfuModel(
        sfuNo: json['sfuNo'],
        fuc: json['fuc'],
        icc: json['icc'],
        ictc: json['ictc'],
        occ: json['occ'],
        octc: json['octc'],
        ec: json['ec'],
        cg: json['cg'],
        dl: json['dl'],
        vi: json['vi']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'sfuNo', value: sfuNo),
      DataGridCell(columnName: 'fuc', value: fuc),
      DataGridCell(columnName: 'icc', value: icc),
      DataGridCell(columnName: 'ictc', value: ictc),
      DataGridCell(columnName: 'occ', value: occ),
      DataGridCell(columnName: 'octc', value: octc),
      DataGridCell(columnName: 'ec', value: ec),
      DataGridCell(columnName: 'cg', value: cg),
      DataGridCell(columnName: 'dl', value: dl),
      DataGridCell(columnName: 'vi', value: vi),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
