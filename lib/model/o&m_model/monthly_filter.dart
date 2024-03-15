import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MonthlyFilterModel {
  MonthlyFilterModel({
    required this.cn,
    required this.fcd,
    required this.dgcd,
  });

  int? cn;
  String? fcd;
  dynamic dgcd;

  factory MonthlyFilterModel.fromjson(Map<String, dynamic> json) {
    return MonthlyFilterModel(
      cn: json['cn'],
      fcd: json['fcd'],
      dgcd: json['dgcd'],
    );
  }

  DataGridRow dataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell(columnName: 'cn', value: cn),
      DataGridCell(columnName: 'fcd', value: fcd),
      DataGridCell(columnName: 'dgcd', value: dgcd),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
