import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../model/participant.dart';

class ParticipantsData extends DataGridSource {
  List dataList;
  ParticipantsData({required this.dataList}) {
    participants = participantList
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'Full Name', value: e.fullName),
              DataGridCell<String>(columnName: 'Email', value: e.email),
              DataGridCell<String>(columnName: 'Organization', value: e.email)
            ]))
        .toList();
  }
  List<DataGridRow> participants = [];

  List<GridColumn> getColumns() {
    List<GridColumn> columns;
    columns = <GridColumn>[
      GridColumn(
        label: const Text('id'),
        columnName: 'id',
        width: double.nan,
      ),
      GridColumn(
          label: const Text('Full Name'),
          columnName: 'Full Name',
          width: double.nan),
      GridColumn(
          label: const Text('Email'),
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
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
