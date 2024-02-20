import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../model/depot_overview.dart';
import '../widget/style.dart';

class DepotOverviewDatasource extends DataGridSource {
  BuildContext mainContext;

  DepotOverviewDatasource(this._depotOverview, this.mainContext) {
    buildDataGridRows();
  }
  void buildDataGridRows() {
    dataGridRows = _depotOverview
        .map<DataGridRow>((dataGridRow) => dataGridRow.getDataGridRow())
        .toList();
  }

  @override
  List<DepotOverviewModel> _depotOverview = [];

  List<DataGridRow> dataGridRows = [];

  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();

  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 11,
      color: Colors.black87);
  @override
  List<DataGridRow> get rows => dataGridRows;

  List<String> typeRiskMenuItems = [
    'Material Supply',
    'Civil Work',
    'Electrical Work',
    'Statutory Approval'
  ];
  List<String> impactRiskMenuItems = [
    'High',
    'Medium',
    'Low',
  ];
  List<String> statusMenuItems = [
    'Close',
    'Pending',
  ];

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    void addRowAtIndex(int index, DepotOverviewModel rowData) {
      _depotOverview.insert(index, rowData);
      buildDataGridRows();
      notifyListeners();
      // notifyListeners(DataGridSourceChangeKind.rowAdd, rowIndexes: [index]);
    }

    DateTime? rangeStartDate = DateTime.now();
    DateTime? rangeEndDate = DateTime.now();
    DateTime? date;
    DateTime? endDate;
    DateTime? rangeStartDate1 = DateTime.now();
    DateTime? rangeEndDate1 = DateTime.now();
    DateTime? date1;
    DateTime? endDate1;
    DateRangePickerController _datecontroller = DateRangePickerController();
    final int dataRowIndex = dataGridRows.indexOf(row);

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: (dataGridCell.columnName == 'Add')
              ? SizedBox(
                  height: 20,
                  width: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        addRowAtIndex(
                          dataRowIndex + 1,
                          DepotOverviewModel(
                            srNo: 1,
                            date:
                                DateFormat('dd-MM-yyyy').format(DateTime.now()),
                            riskDescription: '',
                            typeRisk: 'Material Supply',
                            impactRisk: 'High',
                            owner: '',
                            migrateAction: ' ',
                            contigentAction: '',
                            progressAction: '',
                            reason: '',
                            targetDate:
                                DateFormat('dd-MM-yyyy').format(DateTime.now()),
                            status: 'Close',
                          ),
                        );
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 11),
                      )),
                )
              : (dataGridCell.columnName == 'Delete')
                  ? IconButton(
                      onPressed: () {
                        dataGridRows.remove(row);
                        notifyListeners();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: red,
                        size: 15,
                      ))
                  : (dataGridCell.columnName == 'Date')
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: mainContext,
                                    builder: (context) => AlertDialog(
                                          title: const Text('All Date'),
                                          content: Container(
                                              height: 400,
                                              width: 500,
                                              child: SfDateRangePicker(
                                                view: DateRangePickerView.month,
                                                showTodayButton: true,
                                                onSelectionChanged:
                                                    (DateRangePickerSelectionChangedArgs
                                                        args) {
                                                  if (args.value
                                                      is PickerDateRange) {
                                                    rangeStartDate =
                                                        args.value.startDate;
                                                    rangeEndDate =
                                                        args.value.endDate;
                                                  }
                                                },
                                                selectionMode:
                                                    DateRangePickerSelectionMode
                                                        .single,
                                                showActionButtons: true,
                                                onSubmit: ((value) {
                                                  date = DateTime.parse(
                                                      value.toString());

                                                  final int dataRowIndex =
                                                      dataGridRows.indexOf(row);
                                                  if (dataRowIndex != null) {
                                                    final int dataRowIndex =
                                                        dataGridRows
                                                            .indexOf(row);
                                                    dataGridRows[dataRowIndex]
                                                            .getCells()[
                                                        1] = DataGridCell<
                                                            String>(
                                                        columnName: 'Date',
                                                        value: DateFormat(
                                                                'dd-MM-yyyy')
                                                            .format(date!));
                                                    _depotOverview[dataRowIndex]
                                                            .date =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(date!);
                                                    notifyListeners();

                                                    Navigator.pop(context);
                                                  }
                                                }),
                                              )),
                                        ));
                              },
                              icon: const Icon(
                                Icons.calendar_today,
                                size: 15,
                              ),
                            ),
                            Text(
                              dataGridCell.value.toString(),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        )
                      : (dataGridCell.columnName == 'TargetDate')
                          ? Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: mainContext,
                                        builder: (context) => AlertDialog(
                                              title: const Text('All Date'),
                                              content: Container(
                                                  height: 400,
                                                  width: 500,
                                                  child: SfDateRangePicker(
                                                    view: DateRangePickerView
                                                        .month,
                                                    showTodayButton: true,
                                                    onSelectionChanged:
                                                        (DateRangePickerSelectionChangedArgs
                                                            args) {
                                                      if (args.value
                                                          is PickerDateRange) {
                                                        rangeStartDate = args
                                                            .value.startDate;
                                                        rangeEndDate =
                                                            args.value.endDate;
                                                      } else {
                                                        final List<
                                                                PickerDateRange>
                                                            selectedRanges =
                                                            args.value;
                                                      }
                                                    },
                                                    selectionMode:
                                                        DateRangePickerSelectionMode
                                                            .single,
                                                    showActionButtons: true,
                                                    onSubmit: ((value) {
                                                      date = DateTime.parse(
                                                          value.toString());

                                                      final int dataRowIndex =
                                                          dataGridRows
                                                              .indexOf(row);
                                                      if (dataRowIndex !=
                                                          null) {
                                                        final int dataRowIndex =
                                                            dataGridRows
                                                                .indexOf(row);
                                                        dataGridRows[
                                                                    dataRowIndex]
                                                                .getCells()[
                                                            10] = DataGridCell<
                                                                String>(
                                                            columnName:
                                                                'TargetDate',
                                                            value: DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(date!));
                                                        _depotOverview[
                                                                    dataRowIndex]
                                                                .targetDate =
                                                            DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(date!);
                                                        notifyListeners();

                                                        Navigator.pop(context);
                                                      }
                                                    }),
                                                  )),
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    size: 15,
                                  ),
                                ),
                                Text(
                                  dataGridCell.value.toString(),
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            )
                          : dataGridCell.columnName == 'TypeRisk'
                              ? DropdownButton<String>(
                                  value: dataGridCell.value,
                                  autofocus: true,
                                  focusColor: Colors.transparent,
                                  underline: const Text(''),
                                  itemHeight: 50,
                                  icon: const Icon(Icons.arrow_drop_down_sharp),
                                  isExpanded: true,
                                  style: textStyle,
                                  onChanged: (String? value) {
                                    final dynamic oldValue = row
                                            .getCells()
                                            .firstWhereOrNull(
                                                (DataGridCell dataCell) =>
                                                    dataCell.columnName ==
                                                    dataGridCell.columnName)
                                            ?.value ??
                                        '';
                                    if (oldValue == value || value == null) {
                                      return;
                                    }

                                    final int dataRowIndex =
                                        dataGridRows.indexOf(row);
                                    dataGridRows[dataRowIndex].getCells()[3] =
                                        DataGridCell<String>(
                                            columnName: 'TypeRisk',
                                            value: value);
                                    _depotOverview[dataRowIndex].typeRisk =
                                        value.toString();
                                    notifyListeners();
                                  },
                                  items: typeRiskMenuItems
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList())
                              : dataGridCell.columnName == 'impactRisk'
                                  ? DropdownButton<String>(
                                      value: dataGridCell.value,
                                      autofocus: true,
                                      focusColor: Colors.transparent,
                                      underline: const SizedBox.shrink(),
                                      icon: const Icon(
                                          Icons.arrow_drop_down_sharp),
                                      isExpanded: true,
                                      style: textStyle,
                                      onChanged: (String? value) {
                                        final dynamic oldValue = row
                                                .getCells()
                                                .firstWhereOrNull(
                                                    (DataGridCell dataCell) =>
                                                        dataCell.columnName ==
                                                        dataGridCell.columnName)
                                                ?.value ??
                                            '';
                                        if (oldValue == value ||
                                            value == null) {
                                          return;
                                        }

                                        final int dataRowIndex =
                                            dataGridRows.indexOf(row);
                                        dataGridRows[dataRowIndex]
                                                .getCells()[4] =
                                            DataGridCell<String>(
                                                columnName: 'impactRisk',
                                                value: value);
                                        _depotOverview[dataRowIndex]
                                            .impactRisk = value.toString();
                                        notifyListeners();
                                      },
                                      items: impactRiskMenuItems
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList())
                                  : dataGridCell.columnName == 'Status'
                                      ? DropdownButton<String>(
                                          value: dataGridCell.value,
                                          autofocus: true,
                                          focusColor: Colors.transparent,
                                          underline: const SizedBox.shrink(),
                                          icon: const Icon(
                                              Icons.arrow_drop_down_sharp),
                                          isExpanded: true,
                                          style: textStyle,
                                          onChanged: (String? value) {
                                            final dynamic oldValue = row
                                                    .getCells()
                                                    .firstWhereOrNull(
                                                        (DataGridCell
                                                                dataCell) =>
                                                            dataCell
                                                                .columnName ==
                                                            dataGridCell
                                                                .columnName)
                                                    ?.value ??
                                                '';
                                            if (oldValue == value ||
                                                value == null) {
                                              return;
                                            }

                                            final int dataRowIndex =
                                                dataGridRows.indexOf(row);
                                            dataGridRows[dataRowIndex]
                                                    .getCells()[11] =
                                                DataGridCell<String>(
                                                    columnName: 'Status',
                                                    value: value);
                                            _depotOverview[dataRowIndex]
                                                .status = value.toString();
                                            notifyListeners();
                                          },
                                          items: statusMenuItems
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList())
                                      : Text(
                                          dataGridCell.value.toString(),
                                          style: const TextStyle(fontSize: 11),
                                          overflow: TextOverflow.ellipsis,
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
    if (column.columnName == 'srNo') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'srNo', value: newCellValue);
      _depotOverview[dataRowIndex].srNo = newCellValue;
    } else if (column.columnName == 'Date') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Date', value: newCellValue);
      _depotOverview[dataRowIndex].date = newCellValue.toString();
    } else if (column.columnName == 'RiskDescription') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'RiskDescription', value: newCellValue);
      _depotOverview[dataRowIndex].riskDescription = newCellValue;
    } else if (column.columnName == 'TypeRisk') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'TypeRisk', value: newCellValue);
      _depotOverview[dataRowIndex].typeRisk = newCellValue;
    } else if (column.columnName == 'impactRisk') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'impactRisk', value: newCellValue);
      _depotOverview[dataRowIndex].impactRisk = newCellValue;
    } else if (column.columnName == 'Owner') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Owner', value: newCellValue);
      _depotOverview[dataRowIndex].owner = newCellValue;
    } else if (column.columnName == 'MigratingRisk') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'MigratingRisk', value: newCellValue);
      _depotOverview[dataRowIndex].migrateAction = newCellValue;
    } else if (column.columnName == 'ContigentAction') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'ContigentAction', value: newCellValue);
      _depotOverview[dataRowIndex].contigentAction = newCellValue;
    } else if (column.columnName == 'ProgressionAction') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(
              columnName: 'ProgressionAction', value: newCellValue);
      _depotOverview[dataRowIndex].progressAction = newCellValue;
    } else if (column.columnName == 'Reason') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Reason', value: newCellValue);
      _depotOverview[dataRowIndex].reason = newCellValue;
    } else if (column.columnName == 'TargetDate') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'TargetDate', value: newCellValue);
      _depotOverview[dataRowIndex].targetDate = newCellValue;
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: 'Status', value: newCellValue);
      _depotOverview[dataRowIndex].status = newCellValue;
    }
    // Future storeData() async {
    //   await FirebaseFirestore.instance.collection('A1').add({
    //     'Weightage':
    //         dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //             DataGridCell<int>(
    //                 columnName: 'Weightage', value: newCellValue as int),
    //   });
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

    final bool isNumericType = column.columnName == 'srNo';
    // column.columnName == 'ActualDuration' ||
    // column.columnName == 'Delay' ||
    // column.columnName == 'Unit' ||
    // column.columnName == 'QtyScope' ||
    // column.columnName == 'QtyExecuted' ||
    // column.columnName == 'BalancedQty' ||
    // column.columnName == 'Progress' ||
    // column.columnName == 'Weightage';

    final bool isDateTimeType =
        column.columnName == 'Date' || column.columnName == 'TargetDate';
    // Holds regular expression pattern based on the column type.
    final RegExp regExp =
        _getRegExp(isNumericType, isDateTimeType, column.columnName);

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
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
              newCellValue = double.parse(value);
            } else if (isDateTimeType) {
              newCellValue = value;
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onTapOutside: (_) {
          if (editingController.text.isEmpty) {
            newCellValue = '';
          } else {
            newCellValue = editingController.text;
            submitCell();
          }
        },
        onEditingComplete: () {
          // newCellValue = newCellValue ?? '';
          submitCell();
        },
        onSubmitted: (String value) {
          newCellValue = value;

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
        ? RegExp('[0-9.]')
        : isDateTimeBoard
            ? RegExp('[0-9-]')
            : RegExp('[a-zA-Z0-9.@!#^&*(){+-}%|<>?_=+,/ )]');
  }
}
