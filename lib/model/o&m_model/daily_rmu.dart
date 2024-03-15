import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyrmuModel {
  DailyrmuModel({
    required this.rmuNo,
    required this.sgp,
    required this.vpi,
    required this.crd,
    required this.rec,
    required this.arm,
    required this.cbts,
    required this.cra,
  });
  int? rmuNo;
  String? sgp;
  String? vpi;
  String? crd;
  dynamic rec;
  String? arm;
  String? cbts;
  String? cra;

  factory DailyrmuModel.fromjson(Map<String, dynamic> json) {
    return DailyrmuModel(
      rmuNo: json['rmuNo'],
      sgp: json['sgp'],
      vpi: json['vpi'],
      crd: json['crd'],
      rec: json['rec'],
      arm: json['arm'],
      cbts: json['cbts'],
      cra: json['cra'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'rmuNo', value: rmuNo),
      DataGridCell(columnName: 'sgp', value: sgp),
      DataGridCell(columnName: 'vpi', value: vpi),
       DataGridCell(columnName: 'crd', value: crd),
      DataGridCell(columnName: 'rec', value: rec),
      DataGridCell(columnName: 'arm', value: arm),
      DataGridCell(columnName: 'cbts', value: cbts),
      DataGridCell(columnName: 'cra', value: cra),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
