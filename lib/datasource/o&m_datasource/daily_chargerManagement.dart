import 'package:assingment/KeysEvents/upload.dart';
import 'package:assingment/KeysEvents/view_AllFiles.dart';
import 'package:assingment/overview/daily_project.dart';
import 'package:assingment/provider/summary_provider.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../model/o&m_model/daily_charger.dart';

class DailyChargerManagementDataSource extends DataGridSource {
  String cityName;
  String depoName;
  String userId;
  String selectedDate;
  BuildContext mainContext;

  List data = [];
  DailyChargerManagementDataSource(this._dailyproject, this.mainContext,
      this.cityName, this.depoName, this.selectedDate, this.userId) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows = _dailyproject
        .map<DataGridRow>((dataGridRow) => dataGridRow.dataGridRow())
        .toList();
  }

  @override
  List<DailyChargerModel> _dailyproject = [];

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
    // DateTime? rangeEndDate = DateTime.now();
    // DateTime? date;
    // DateTime? endDate;
    // DateTime? rangeStartDate1 = DateTime.now();
    // DateTime? rangeEndDate1 = DateTime.now();
    // DateTime? date1;
    // DateTime? endDate1;
    final int dataRowIndex = dataGridRows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      void addRowAtIndex(int index, DailyChargerManagementDataSource rowData) {
        //   _dailyproject.insert(index, rowData);
        buildDataGridRows();
        notifyListeners();
        // notifyListeners(DataGridSourceChangeKind.rowAdd, rowIndexes: [index]);
      }

      void removeRowAtIndex(int index) {
        _dailyproject.removeAt(index);
        buildDataGridRows();
        notifyListeners();
      }

      String Pagetitle = 'Daily Report';

      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: (dataGridCell.columnName == 'view')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                mainContext,
                                MaterialPageRoute(
                                  builder: (context) => ViewAllPdf(
                                    title: Pagetitle,
                                    cityName: cityName,
                                    depoName: depoName,
                                    userId: userId,
                                    date: row.getCells()[0].value.toString(),
                                    docId: globalRowIndex.isNotEmpty
                                        ? globalRowIndex[
                                            dataGridRows.indexOf(row)]
                                        : dataGridRows.indexOf(row) + 1,
                                  ),
                                ));
                          },
                          child: Text('View', style: tablefonttext)),
                    ),
                    Container(
                      child: isShowPinIcon[dataGridRows.indexOf(row)]
                          ? Icon(
                              Icons.attach_file_outlined,
                              color: blue,
                              size: 18,
                            )
                          : Container(),
                    ),
                    Text(
                      globalItemLengthList[dataGridRows.indexOf(row)] != 0
                          ? globalItemLengthList[dataGridRows.indexOf(row)] > 9
                              ? '${globalItemLengthList[dataGridRows.indexOf(row)]}+'
                              : '${globalItemLengthList[dataGridRows.indexOf(row)]}'
                          : '',
                      style: tablefonttext,
                    )
                  ],
                )
              : (dataGridCell.columnName == 'upload')
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          mainContext,
                          MaterialPageRoute(
                            builder: (context) => UploadDocument(
                              pagetitle: Pagetitle,
                              customizetype: const [
                                'jpg',
                                'jpeg',
                                'png',
                                'pdf'
                              ],
                              cityName: cityName,
                              depoName: depoName,
                              userId: userId,
                              date: selectedDate,
                              fldrName: '${dataGridRows.indexOf(row) + 1}',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Upload',
                        style: tablefonttext,
                      ),
                    )
                  : (dataGridCell.columnName == 'Add')
                      ? ElevatedButton(
                          onPressed: () {
                            // isShowPinIcon.add(false);
                            // addRowAtIndex(
                            //     dataRowIndex + 1,
                            //     DailyManagementProjectModel(
                            //         sfuNo: sfuNo,
                            //         icc: icc,
                            //         ictc: ictc,
                            //         occ: occ,
                            //         octc: octc,
                            //         ec: ec,
                            //         cg: cg,
                            //         dl: dl,
                            //         vi: vi)
                            //         );
                          },
                          child: Text(
                            'Add',
                            style: tablefonttext,
                          ))
                      : (dataGridCell.columnName == 'Delete')
                          ? IconButton(
                              onPressed: () async {
                                // FirebaseFirestore.instance
                                //     .collection('DailyProjectReport')
                                //     .doc(depoName)
                                //     .collection('Daily Data')
                                //     .doc(DateFormat.yMMMMd().format(DateTime.now()))
                                //     .update({
                                //   'data': FieldValue.arrayRemove([0])
                                // });
                                removeRowAtIndex(dataRowIndex);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: red,
                                size: 15,
                              ))
                          : Text(
                              dataGridCell.value.toString(),
                              textAlign: TextAlign.center,
                              style: tablefonttext,
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
    if (column.columnName == 'CN') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'CN', value: newCellValue);
      _dailyproject[dataRowIndex].cn = newCellValue;
    } else if (column.columnName == 'DC') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'DC', value: newCellValue);
      _dailyproject[dataRowIndex].dc = newCellValue;
    } else if (column.columnName == 'CGCA') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'CGCA', value: newCellValue);
      _dailyproject[dataRowIndex].cgca = newCellValue;
    } else if (column.columnName == 'CGCB') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'CGCB', value: newCellValue);
      _dailyproject[dataRowIndex].cgcb = newCellValue;
    } else if (column.columnName == 'CGCCA') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'CGCCA', value: newCellValue);
      _dailyproject[dataRowIndex].cgcca = newCellValue;
    } else if (column.columnName == 'CGCCB') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'CGCCB', value: newCellValue);
      _dailyproject[dataRowIndex].cgccb = newCellValue;
    } else if (column.columnName == 'dl') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'dl', value: newCellValue);
      _dailyproject[dataRowIndex].dl = newCellValue;
    } else if (column.columnName == 'ARM') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'ARM', value: newCellValue);
      _dailyproject[dataRowIndex].arm = newCellValue;
    } else if (column.columnName == 'EC') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'EC', value: newCellValue);
      _dailyproject[dataRowIndex].ec = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'CC', value: newCellValue);
      _dailyproject[dataRowIndex].cc = newCellValue;
    }
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

    final bool isNumericType = column.columnName == 'sfuNo';

    final bool isDateTimeType = column.columnName == 'StartDate' ||
        column.columnName == 'EndDate' ||
        column.columnName == 'ActualStart' ||
        column.columnName == 'ActualEnd';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        style: tablefonttext,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5, right: 5),
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
            newCellValue;
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
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }
}
