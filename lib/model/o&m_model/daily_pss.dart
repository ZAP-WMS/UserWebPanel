import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyPssModel {
  DailyPssModel(
      {required this.pssNo,
      required this.pbc,
      required this.ec,
      required this.sgp,
      required this.pdl,
      required this.wtiTemp,
      required this.otiTemp,
      required this.vpiPresence,
      required this.viMCCb,
      required this.vr,
      required this.ar,
      required this.mccbHandle});
  int? pssNo;
  String? pbc;
  String? ec;
  dynamic sgp;
  String? pdl;
  String? wtiTemp;
  String? otiTemp;
  String? vpiPresence;
  String? viMCCb;
  String? vr;
  String? ar;
  String? mccbHandle;

  factory DailyPssModel.fromjson(Map<String, dynamic> json) {
    return DailyPssModel(
        pssNo: json['pssNo'],
        pbc: json['pbc'],
        ec: json['ec'],
        sgp: json['sgp'],
        pdl: json['pdl'],
        wtiTemp: json['wtiTemp'],
        otiTemp: json['otiTemp'],
        vpiPresence: json['vpiPresence'],
        viMCCb: json['viMCCb'],
        vr: json['vr'],
        ar: json['ar'],
        mccbHandle: json['mccbHandle']);
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'pssNo', value: pssNo),
      DataGridCell(columnName: 'pbc', value: pbc),
      DataGridCell(columnName: 'ec', value: ec),
      DataGridCell(columnName: 'pdl', value: pdl),
      DataGridCell(columnName: 'sgp', value: sgp),
      DataGridCell(columnName: 'wtiTemp', value: wtiTemp),
      DataGridCell(columnName: 'otiTemp', value: otiTemp),
      DataGridCell(columnName: 'vpiPresence', value: vpiPresence),
      DataGridCell(columnName: 'viMCCb', value: viMCCb),
      DataGridCell(columnName: 'vr', value: vr),
      DataGridCell(columnName: 'ar', value: ar),
      DataGridCell(columnName: 'mccbHandle', value: mccbHandle),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
