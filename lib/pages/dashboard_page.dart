import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import '../widget/drop_down.dart';
import 'event_info.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return mat.SafeArea(
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        home: mat.SingleChildScrollView(
          child: Container(
            color: FluentTheme.of(context).scaffoldBackgroundColor,
            padding:
                const EdgeInsets.only(left: 16, bottom: 8, right: 16, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mat.Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Your Dashboard",
                    style: FluentTheme.of(context).typography.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: mat.Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: mat.Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromRGBO(203, 202, 202, 1.0)
                                    .withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    2, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          width: double.infinity,
                          height: 150,
                          padding: EdgeInsets.all(4),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DashStats(context,
                                    "Total Number of Participants", "120"),
                                DashStats(
                                    context, "Total Number of Absentees", "0"),
                                DashStats(
                                    context,
                                    "Total Number of Certificates Generated",
                                    "120"),
                                // DashStats(
                                //     context, "Average Rate of Events", "4.5"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 20),
                        // padding: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: mat.Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(203, 202, 202, 1.0)
                                  .withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(
                                  1, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: mat.Material(
                            color: mat.Colors.white,
                            child: DataTable(
                              columns: <DataColumn>[
                                ColumnData("Event Name"),
                                ColumnData("Event Date"),
                                ColumnData("Event Absentees"),
                                ColumnData("Event Attendees"),
                              ],
                              rows: <DataRow>[
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name for the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name for the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name for the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name for the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                                RowData(
                                    context,
                                    "This is a sample Event Name rrrrrrrrrrrr rrrrrrrrrrrrrrr rrrrrrrr rrrrrrrrrrrrrrrrrrrr rrrrrrrrrrrrrrrrrrrrrrrfor the table (2022)",
                                    "March 20, 2022",
                                    "0",
                                    "250"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  mat.DataRow RowData(BuildContext context, String eventName, String eventDate,
      String numAbsent, String numPresent) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          mat.GestureDetector(
            onTap: () {
              print("Hello");
              Navigator.push(
                context,
                mat.MaterialPageRoute(builder: (context) => const EventInfo()),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Text(
                '$eventName',
                style: TextStyle(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ),
        DataCell(
          Text('$eventDate'),
        ),
        DataCell(Text('$numAbsent')),
        DataCell(Text('$numPresent')),
      ],
    );
  }

  mat.DataColumn ColumnData(String name) {
    return DataColumn(
      label: Text(
        name,
        style: FluentTheme.of(context).typography.bodyStrong,
      ),
    );
  }

  Expanded DashStats(BuildContext context, String header, String number) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$header", style: FluentTheme.of(context).typography.bodyLarge),
          SizedBox(
            height: 20,
          ),
          Text(
            "$number",
            style: FluentTheme.of(context).typography.titleLarge,
          ),
        ],
      ),
    );
  }
}
