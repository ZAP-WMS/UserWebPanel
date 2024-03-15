import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyAcdbModel {
  DailyAcdbModel({
    required this.incomerNo,
    required this.vi,
    // required this.state,
    // required this.depotName,
    required this.vr,
    required this.ar,
    required this.acdbSwitch,
    required this.mccbHandle,
    required this.ccb,
    required this.arm,
  });

  int? incomerNo;
  String? vi;
  dynamic vr;
  String? ar;
  String? acdbSwitch;
  String? mccbHandle;
  String? ccb;
  String? arm;

  factory DailyAcdbModel.fromjson(Map<String, dynamic> json) {
    return DailyAcdbModel(
      incomerNo: json['incomerNo'],
      vi: json['vi'],
      vr: json['vr'],
      ar: json['ar'],
      acdbSwitch: json['acdbSwitch'],
      mccbHandle: json['mccbHandle'],
      ccb: json['ccb'],
      arm: json['arm'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'incomerNo', value: incomerNo),
      DataGridCell(columnName: 'vi', value: vi),
      DataGridCell(columnName: 'vr', value: vr),
      DataGridCell(columnName: 'ar', value: ar),
      DataGridCell(columnName: 'acdbSwitch', value: acdbSwitch),
      DataGridCell(columnName: 'mccbHandle', value: mccbHandle),
      DataGridCell(columnName: 'ccb', value: ccb),
      DataGridCell(columnName: 'arm', value: arm),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
