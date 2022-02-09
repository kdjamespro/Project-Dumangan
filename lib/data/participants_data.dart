import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/participant.dart';

class ParticipantsData extends DataGridSource {
  ParticipantsData() {
    participants = participantList
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(
                  columnName: 'First Name', value: e.firstName),
              DataGridCell<String>(columnName: 'Last Name', value: e.lastName),
              DataGridCell<String>(columnName: 'Email', value: e.email),
            ]))
        .toList();
  }
  List<DataGridRow> participants = [];

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        label: Text('id'),
        columnName: 'id',
        width: double.nan,
      ),
      GridColumn(
          label: Text('First Name'),
          columnName: 'First Name',
          width: double.nan),
      GridColumn(
          label: Text('Last Name'), columnName: 'Last Name', width: double.nan),
      GridColumn(
          label: Text('Email'),
          columnName: 'email',
          columnWidthMode: ColumnWidthMode.lastColumnFill),
    ];
    return columns;
  }

  @override
  List<DataGridRow> get rows => participants;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
