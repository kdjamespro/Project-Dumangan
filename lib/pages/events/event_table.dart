import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventTable extends StatefulWidget {
  const EventTable({Key? key}) : super(key: key);

  @override
  State<EventTable> createState() => _EventTableState();
}

class _EventTableState extends State<EventTable> {
  @override
  Widget build(BuildContext context) {
    SelectedEvent event = context.read<SelectedEvent>();
    MyDatabase db = context.read<MyDatabase>();
    return FutureBuilder(
        future: db.getEventList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: ProgressRing(
                  strokeWidth: 8.0,
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              List<EventsTableData> eventsList =
                  snapshot.data as List<EventsTableData>;
              return mat.Material(
                color: FluentTheme.of(context).scaffoldBackgroundColor,
                child: mat.Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16.0),
                  child: PaginatedDataTable2(
                    source: TableSource(eventList: eventsList),
                    header: Text(
                      'Event\'s Participants',
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    columns: const [
                      DataColumn2(label: Text('Event Name')),
                      DataColumn2(label: Text('Event Date')),
                      DataColumn2(label: Text('Event Absentees')),
                      DataColumn2(label: Text('Event Attendees')),
                    ],
                  ),
                ),
              );
            default:
              return Container();
          }
        });
  }
}

class TableSource extends mat.DataTableSource {
  List<EventsTableData> eventList;
  TableSource({required this.eventList});

  @override
  mat.DataRow? getRow(int index) {
    final event = eventList[index];
    return mat.DataRow.byIndex(
      index: index,
      cells: [
        mat.DataCell(
          Container(
            child: Text(event.name),
          ),
        ),
        mat.DataCell(
          Container(
            child: Text(DateFormat.yMd().format(event.date)),
          ),
        ),
        mat.DataCell(
          Container(
            child: Text(event.absentees.toString()),
          ),
        ),
        mat.DataCell(
          Container(
            child: Text(event.participants.toString()),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => eventList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
