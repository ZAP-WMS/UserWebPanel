import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../datasource/detailedeng_datasource.dart';
import '../model/detailed_engModel.dart';
import '../widget/style.dart';

class RfcDrawing extends StatefulWidget {
  const RfcDrawing({super.key});

  @override
  State<RfcDrawing> createState() => _RfcDrawingState();
}

class _RfcDrawingState extends State<RfcDrawing> {
  List<DetailedEngModel> DetailedProject = <DetailedEngModel>[];
  late DetailedEngSource _detailedDataSource;
  late DataGridController _dataGridController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: SfDataGridTheme(
          data: SfDataGridThemeData(headerColor: lightblue),
          child: SfDataGrid(
              source: _detailedDataSource,
              allowEditing: true,
              frozenColumnsCount: 2,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell,
              columnWidthMode: ColumnWidthMode.auto,
              editingGestureType: EditingGestureType.tap,
              controller: _dataGridController,
              columns: [
                GridColumn(
                  columnName: 'SiNo',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: true,
                  width: 80,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('SI No.',
                        overflow: TextOverflow.values.first,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)
                        //    textAlign: TextAlign.center,
                        ),
                  ),
                ),
                GridColumn(
                  columnName: 'button',
                  width: 130,
                  allowEditing: false,
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Upload Drawing ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)),
                  ),
                ),
                GridColumn(
                  columnName: 'Title',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: true,
                  width: 300,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('Description',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.values.first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)),
                  ),
                ),
                GridColumn(
                  columnName: 'Number',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: true,
                  width: 130,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('Drawing Number',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.values.first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)
                        //    textAlign: TextAlign.center,
                        ),
                  ),
                ),
                GridColumn(
                  columnName: 'PreparationDate',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: false,
                  width: 150,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('Preparation Date',
                        overflow: TextOverflow.values.first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)
                        //    textAlign: TextAlign.center,
                        ),
                  ),
                ),
                GridColumn(
                  columnName: 'SubmissionDate',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: false,
                  width: 150,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('Submission Date',
                        overflow: TextOverflow.values.first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)
                        //    textAlign: TextAlign.center,
                        ),
                  ),
                ),
                GridColumn(
                  columnName: 'ApproveDate',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: false,
                  width: 150,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('Approve Date',
                        overflow: TextOverflow.values.first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)
                        //    textAlign: TextAlign.center,
                        ),
                  ),
                ),
                GridColumn(
                  columnName: 'ReleaseDate',
                  autoFitPadding: const EdgeInsets.symmetric(horizontal: 16),
                  allowEditing: false,
                  width: 150,
                  label: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.center,
                    child: Text('Release Date',
                        overflow: TextOverflow.values.first,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white)
                        //    textAlign: TextAlign.center,
                        ),
                  ),
                ),
              ]),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (() {
          DetailedProject.add(DetailedEngModel(
            siNo: 1,
            title: 'EV Layout',
            number: 12345,
            preparationDate: DateFormat().add_yMd().format(DateTime.now()),
            submissionDate: DateFormat().add_yMd().format(DateTime.now()),
            approveDate: DateFormat().add_yMd().format(DateTime.now()),
            releaseDate: DateFormat().add_yMd().format(DateTime.now()),
          ));
          _detailedDataSource.buildDataGridRows();
          _detailedDataSource.updateDatagridSource();
        }),
      ),
    );
  }
}
