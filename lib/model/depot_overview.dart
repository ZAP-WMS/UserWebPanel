import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DepotOverviewModel {
  DepotOverviewModel({
    required this.srNo,
    required this.date,
    required this.riskDescription,
    required this.typeRisk,
    required this.impactRisk,
    required this.owner,
    required this.migrateAction,
    required this.contigentAction,
    required this.progressAction,
    required this.reason,
    required this.targetDate,
    required this.status,
  });
  dynamic srNo;
  String? date;
  String? owner;
  String? riskDescription;
  dynamic typeRisk;
  dynamic impactRisk;
  String? migrateAction;
  String? contigentAction;
  String? progressAction;
  String? reason;
  String? targetDate;
  dynamic status;

  factory DepotOverviewModel.fromJson(Map<String, dynamic> json) {
    return DepotOverviewModel(
        srNo: json['srNo'],
        date: json['Date'],
        owner: json['Owner'],
        migrateAction: json['MigratingRisk'],
        progressAction: json['ProgressionAction'],
        riskDescription: json['RiskDescription'],
        targetDate: json['TargetDate'],
        reason: json['Reason'],
        status: json['Status'],
        typeRisk: json['TypeRisk'],
        impactRisk: json['impactRisk'],
        contigentAction: json['ContigentAction']);
  }

  DataGridRow getDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<dynamic>(columnName: 'srNo', value: srNo),
      DataGridCell<String>(columnName: 'Date', value: date),
      DataGridCell<String>(
          columnName: 'RiskDescription', value: riskDescription),
      DataGridCell<dynamic>(columnName: 'TypeRisk', value: typeRisk),
      DataGridCell<String>(columnName: 'impactRisk', value: impactRisk),
      DataGridCell<String>(columnName: 'Owner', value: owner),
      DataGridCell<String>(columnName: 'MigratingRisk', value: migrateAction),
      DataGridCell<String>(
          columnName: 'ContigentAction', value: contigentAction),
      DataGridCell<String>(
          columnName: 'ProgressionAction', value: progressAction),
      DataGridCell<dynamic>(columnName: 'Reason', value: reason),
      DataGridCell(columnName: 'TargetDate', value: targetDate),
      DataGridCell<dynamic>(columnName: 'Status', value: status),
      const DataGridCell(columnName: 'Add', value: null),
      const DataGridCell(columnName: 'Delete', value: null)
    ]);
  }
}
