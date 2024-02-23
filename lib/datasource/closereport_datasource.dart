import 'package:assingment/model/close_report.dart';
import 'package:assingment/overview/closure_report.dart';
import 'package:assingment/widget/style.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../KeysEvents/upload.dart';
import '../KeysEvents/view_AllFiles.dart';

class CloseReportDataSource extends DataGridSource {
  String cityName;
  String depoName;
  dynamic userId;
  BuildContext mainContext;

  List data = [];
  CloseReportDataSource(this._montlyproject, this.mainContext, this.depoName,
      this.cityName, this.userId) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _montlyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<CloseReportModel> _montlyproject = [];

  List<DataGridRow> dataGridRows = [];
  final _dateFormatter = DateFormat.yMd();

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    String Pagetitle = 'Closure Report';
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: dataGridCell.columnName == 'Upload'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: blue),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UploadDocument(
                            pagetitle: 'ClosureReport',
                            customizetype: const ['pdf'],
                            cityName: cityName,
                            depoName: depoName,
                            fldrName: '${dataGridRows.indexOf(row) + 1}',
                            userId: userId,
                            // pagetitle: Pagetitle,
                          ),
                        ));
                      },
                      child: const Text('Upload'));
                })
              : dataGridCell.columnName == 'View'
                  ? LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                      return Row(
                        children: [
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(backgroundColor: blue),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewAllPdf(
                                      title: 'ClosureReport',
                                      cityName: cityName,
                                      depoName: depoName,
                                      userId: userId,
                                      docId:
                                          '${dataGridRows.indexOf(row) + 1}'),
                                ),
                              );
                            },
                            child: const Text('View'),
                          ),
                          Container(
                            child:
                                isShowPinClosureList[dataGridRows.indexOf(row)]
                                    ? Icon(
                                        Icons.attach_file_outlined,
                                        color: blue,
                                        size: 18,
                                      )
                                    : Container(),
                          ),
                          Text(
                            globalIndexClosureList[dataGridRows.indexOf(row)] !=
                                    0
                                ? globalIndexClosureList[
                                            dataGridRows.indexOf(row)] >
                                        9
                                    ? '${globalIndexClosureList[dataGridRows.indexOf(row)]}+'
                                    : '${globalIndexClosureList[dataGridRows.indexOf(row)]}'
                                : '',
                            style: TextStyle(color: blue, fontSize: 11),
                          )
                        ],
                      );
                    })
                  : Text(
                      dataGridCell.value.toString(),
                      textAlign: TextAlign.center,
                    ));
    }).toList());
  }

  void updateDatagridSource() {
    notifyListeners();
  }

  void updateDataGrid({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'SiNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: 'SiNo', value: newCellValue);
      _montlyproject[dataRowIndex].siNo = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'content', value: newCellValue);
      _montlyproject[dataRowIndex].content = newCellValue;
    }
    // else {
    //   dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //       DataGridCell<String>(columnName: 'Attachment', value: newCellValue);
    //   _montlyproject[dataRowIndex].attachment = newCellValue;
    // }
  }

  @override
  bool canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'SiNo';
    //  ||
    // column.columnName == 'StartDate' ||
    // column.columnName == 'EndDate' ||
    // column.columnName == 'ActualStart' ||
    // column.columnName == 'ActualEnd' ||
    // column.columnName == 'ActualDuration' ||
    // column.columnName == 'Delay' ||
    // column.columnName == 'Unit' ||
    // column.columnName == 'QtyScope' ||
    // column.columnName == 'QtyExecuted' ||
    // column.columnName == 'BalancedQty' ||
    // column.columnName == 'Progress' ||
    // column.columnName == 'Weightage';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp),
        ],
        keyboardType: isNumericType
            ? TextInputType.number
            : isDateTimeType
                ? TextInputType.datetime
                : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }

  RegExp _getRegExp(
      bool isNumericKeyBoard, bool isDateTimeBoard, String columnName) {
    return isNumericKeyBoard
        ? RegExp('[0-9]')
        : isDateTimeBoard
            ? RegExp('[0-9/]')
            : RegExp('[a-zA-Z0-9 ]');
  }
}
