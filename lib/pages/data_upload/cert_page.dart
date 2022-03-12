import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/model/participant.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:project_dumangan/widget/columns_table.dart';
import 'package:project_dumangan/widget/crosschecking_table.dart';
import 'package:provider/provider.dart';

import '/bloc/cross_checking_bloc.dart';
import '/model/crosscheck_mapping.dart';
import '/services/verify_message.dart';
import 'file_uploader.dart';

class CertPage extends StatelessWidget {
  CertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CrossCheckingBloc>(
      create: (context) => CrossCheckingBloc(
          db: Provider.of<MyDatabase>(context, listen: false)),
      child: ScaffoldPage(
        content: BlocBuilder<CrossCheckingBloc, CrossCheckingState>(
            builder: (context, state) {
          if (state is CrossCheckingLoading) {
            return const Center(
              child: mat.CircularProgressIndicator(
                strokeWidth: 8,
              ),
            );
          } else if (state is CrossCheckingAttribute) {
            return ColumnsTable(
              data: state.data,
              crossCheck: state.isEnabled,
              file: state.crossCheckFile,
            );
          } else if (state is CrossCheckingMapping) {
            return CrossCheckingTable(
              data: state.data,
              crossCheck: state.isEnabled,
              crossCheckData: state.crossCheckingData,
            );
          } else if (state is CrossCheckingFinished) {
            return Table();
          } else {
            return const FileUploader();
          }
        }),
      ),
    );
  }
}

class Table extends StatefulWidget {
  const Table({Key? key}) : super(key: key);

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table>
    with AutomaticKeepAliveClientMixin<Table> {
  @override
  bool get wantKeepAlive => true;
  List selectedRow = [];
  bool isLoaded = false;
  final FlyoutController flyoutController = FlyoutController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    organizationController.dispose();
    flyoutController.dispose();
    super.dispose();
  }

  TableSource dataSource = TableSource(dataList: [], selectedRows: []);

  void clearController() {
    fullNameController.clear();
    emailController.clear();
    organizationController.clear();
  }

  void getData(List data) {
    List participantsList = [];
    for (var row in data) {
      participantsList.add(Participant(
        id: row.id,
        fullName: row.fullName,
        email: row.email,
        attended: row.attended,
        organization: row.organization ?? '',
      ));

      dataSource = TableSource(dataList: participantsList, selectedRows: []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Provider.of<MyDatabase>(context, listen: false).getParticipants(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: ProgressRing(),
              );
            case ConnectionState.active:
              List<ParticipantsTableData> data =
                  snapshot.data as List<ParticipantsTableData>;
              getData(data);
              return mat.Material(
                color: FluentTheme.of(context).scaffoldBackgroundColor,
                child: mat.Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: mat.PaginatedDataTable(
                      header: Row(children: [
                        Text(
                          'Participants',
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
                        const Spacer(),
                        Flyout(
                          contentWidth: 500,
                          controller: flyoutController,
                          content: FlyoutContent(
                              child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            height: 400,
                            child: Column(
                              children: [
                                Text(
                                  'Add New Participants',
                                  style: FluentTheme.of(context)
                                      .typography
                                      .subtitle,
                                ),
                                TextFormBox(
                                  header: 'Full Name*',
                                  controller: fullNameController,
                                ),
                                TextFormBox(
                                  header: 'Email*',
                                  controller: emailController,
                                ),
                                TextFormBox(
                                  header: 'Organization',
                                  controller: organizationController,
                                ),
                                FilledButton(
                                    child: const Text('Add New Participants'),
                                    onPressed: () {
                                      if (fullNameController.text.isNotEmpty &&
                                          emailController.text.isNotEmpty) {
                                        clearController();
                                        flyoutController.open = false;
                                        showSnackbar(
                                            context,
                                            const Snackbar(
                                              content: Text(
                                                  'New Participants Added'),
                                            ));
                                      } else {
                                        showWarningMessage(
                                            context: context,
                                            title: 'Incomplete Field',
                                            message:
                                                'Please fill up full name and email');
                                      }
                                    })
                              ],
                            ),
                          )),
                          child: Tooltip(
                            message: 'Add new participants',
                            child: IconButton(
                                onPressed: () {
                                  flyoutController.open = true;
                                },
                                icon: const Icon(FluentIcons.add)),
                          ),
                        ),
                        Tooltip(
                          message: 'Delete selected rows',
                          child: IconButton(
                              onPressed: () async {
                                int selectedCount =
                                    dataSource.selectedRows.length;
                                if (selectedCount > 0) {
                                  bool proceed = await showVerificationMessage(
                                      context: context,
                                      title: 'Deleting Data',
                                      message:
                                          'Do you want to delete the $selectedCount selected rows?');
                                  if (proceed) {
                                    for (var row in dataSource.selectedRows) {
                                      await Provider.of<MyDatabase>(context,
                                              listen: false)
                                          .deleteParticipant(row.id);
                                    }
                                    showSnackbar(
                                        context,
                                        Snackbar(
                                          content: Text(
                                              'Sucessfully Deleted $selectedCount rows'),
                                        ));
                                  }
                                } else {
                                  showSnackbar(
                                      context,
                                      const Snackbar(
                                        content: Text(
                                            'Please select first rows you want to delete'),
                                      ));
                                }
                              },
                              icon: const Icon(FluentIcons.delete)),
                        ),
                        Tooltip(
                          message: 'Delete all data in table',
                          child: IconButton(
                              onPressed: () async {
                                bool proceed = await showVerificationMessage(
                                    context: context,
                                    title: 'Deleting Data',
                                    message:
                                        'Do you want to delete your existing data?');
                                if (proceed) {
                                  Provider.of<AttributeMapping>(context,
                                          listen: false)
                                      .removeAll();
                                  Provider.of<CrossCheckMapping>(context,
                                          listen: false)
                                      .removeAll();
                                  await Provider.of<MyDatabase>(context,
                                          listen: false)
                                      .deleteParticipants(1);
                                  context
                                      .read<CrossCheckingBloc>()
                                      .add(CrossChekingInitialize());
                                }
                              },
                              icon: const Icon(FluentIcons.delete_table)),
                        ),
                      ]),
                      columns: const [
                        mat.DataColumn(label: Text('Id')),
                        mat.DataColumn(label: Text('Full Name')),
                        mat.DataColumn(label: Text('Email')),
                        mat.DataColumn(label: Text('Organization')),
                        mat.DataColumn(label: Text('Attended')),
                      ],
                      source: dataSource,
                      rowsPerPage: 10,
                      showCheckboxColumn: true,
                    ),
                  ),
                ),
              );
          }
          return mat.DataTable(
            columns: const [
              mat.DataColumn(label: Text('Id')),
              mat.DataColumn(label: Text('Full Name')),
              mat.DataColumn(label: Text('Email')),
              mat.DataColumn(label: Text('Organization')),
              mat.DataColumn(label: Text('Attended')),
            ],
            rows: [],
          );
        });
  }
}

class TableSource extends mat.DataTableSource {
  List selectedRows;
  List dataList;
  TableSource({required this.dataList, required this.selectedRows});

  @override
  mat.DataRow? getRow(int index) {
    final participant = dataList[index];
    return mat.DataRow.byIndex(
      selected: participant.selected,
      onSelectChanged: (bool? selected) {
        if (participant.selected != selected) {
          selected == true
              ? selectedRows.add(participant)
              : selectedRows.remove(participant);
          participant.selected = selected;
          notifyListeners();
        }
      },
      index: index,
      cells: [
        mat.DataCell(
          Container(
            child: Text(dataList[index].id.toString()),
          ),
        ),
        mat.DataCell(
          Container(
            child: Text(dataList[index].fullName),
          ),
        ),
        mat.DataCell(
          Container(
            child: Text(dataList[index].email),
          ),
        ),
        mat.DataCell(
          Container(
            child: Text(dataList[index].organization),
          ),
        ),
        mat.DataCell(
          Container(
            child: dataList[index].attended
                ? Text(
                    'Present',
                    style: TextStyle(color: Colors.green),
                  )
                : Text(
                    'Absent',
                    style: TextStyle(color: Colors.red),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement rowCount
  int get rowCount => dataList.length;

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
