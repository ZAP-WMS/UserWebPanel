import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DailyChargerModel {
  DailyChargerModel(
      {required this.cn,
      required this.dc,
      // required this.state,
      // required this.depotName,
      required this.cgca,
      required this.cgcb,
      required this.cgcca,
      required this.cgccb,
      required this.dl,
      required this.arm,
      required this.ec,
      required this.cc});

  int? cn;
  String? dc;
  dynamic cgca;
  String? cgcb;
  String? cgcca;
  String? cgccb;
  String? dl;
  String? arm;
  String? ec;
  String? cc;

  factory DailyChargerModel.fromjson(Map<String, dynamic> json) {
    return DailyChargerModel(
      cn: json['CN'],
      dc: json['DC'],
      cgca: json['CGCA'],
      cgcb: json['CGCB'],
      cgcca: json['CGCCA'],
      cgccb: json['CGCCB'],
      dl: json['dl'],
      arm: json['ARM'],
      ec: json['EC'],
      cc: json['CC'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'CN', value: cn),
      DataGridCell(columnName: 'DC', value: dc),
      DataGridCell(columnName: 'CGCA', value: cgca),
      DataGridCell(columnName: 'CGCB', value: cgcb),
      DataGridCell(columnName: 'CGCCA', value: cgcca),
      DataGridCell(columnName: 'CGCCB', value: cgccb),
      DataGridCell(columnName: 'dl', value: dl),
      DataGridCell(columnName: 'ARM', value: arm),
      DataGridCell(columnName: 'EC', value: ec),
      DataGridCell(columnName: 'CC', value: cc),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
