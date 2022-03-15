import 'package:data_table_2/data_table_2.dart';
import 'package:drift/drift.dart' as drift;
import 'package:email_validator/email_validator.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/model/participant.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:project_dumangan/widget/columns_table.dart';
import 'package:project_dumangan/widget/crosschecking_table.dart';
import 'package:provider/provider.dart';

import '/bloc/cross_checking_bloc.dart';
import '/model/crosscheck_mapping.dart';
import '/services/verify_message.dart';
import '/services/warning_message.dart';
import 'file_uploader.dart';

class CertPage extends StatelessWidget {
  const CertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SelectedEvent event = context.read<SelectedEvent>();
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
  int _rowsPerPage1 = 10;
  int _rowsPerPage = 10;
  final _formKey = GlobalKey<FormState>();

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
    super.build(context);
    return StreamBuilder(
        stream: Provider.of<MyDatabase>(context, listen: false)
            .getParticipants(context.read<SelectedEvent>().eventId),
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
              int tableItemsCount = dataSource.rowCount;
              int defaultRowsPerPage = 10;
              bool isItemLessThanRowsPerPage =
                  tableItemsCount < defaultRowsPerPage;
              _rowsPerPage = isItemLessThanRowsPerPage
                  ? tableItemsCount
                  : defaultRowsPerPage;
              print(dataSource.rowCount);
              return mat.Material(
                color: FluentTheme.of(context).scaffoldBackgroundColor,
                child: mat.Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16.0),
                  child: PaginatedDataTable2(
                    header: Text(
                      'Event\'s Participants',
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    actions: [
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text(
                                  'Add New Participants',
                                  style: FluentTheme.of(context)
                                      .typography
                                      .subtitle,
                                ),
                                TextFormBox(
                                    placeholder:
                                        'Type participant\'s full name',
                                    header: 'Full Name',
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: fullNameController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Full Name is required';
                                      }

                                      if (text.length < 4) {
                                        return 'Full Name is too short';
                                      }
                                      return null;
                                    }),
                                TextFormBox(
                                    placeholder: 'Type participant\'s email',
                                    header: 'Email',
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: emailController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Email is required';
                                      }
                                      if (!EmailValidator.validate(text)) {
                                        return 'Email is not valid';
                                      }
                                      return null;
                                    }),
                                TextFormBox(
                                  placeholder:
                                      'Type participant\'s organization',
                                  header: 'Organization',
                                  controller: organizationController,
                                ),
                                FilledButton(
                                    child: const Text('Add New Participants'),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        int eventId = context
                                            .read<SelectedEvent>()
                                            .eventId;
                                        await context
                                            .read<MyDatabase>()
                                            .addParticipant(
                                                ParticipantsTableCompanion(
                                              eventsId: drift.Value(eventId),
                                              fullName: drift.Value(
                                                  fullNameController.text),
                                              email: drift.Value(
                                                  emailController.text),
                                              organization: drift.Value(
                                                  organizationController.text),
                                              attended: const drift.Value(true),
                                            ));
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
                                            title:
                                                'Incomplete/Incorrect Fields',
                                            message:
                                                'Please fill up the proper information for full name and email');
                                      }
                                    })
                              ],
                            ),
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
                    ],
                    columns: const [
                      DataColumn2(label: Text('Id')),
                      DataColumn2(label: Text('Full Name')),
                      DataColumn2(label: Text('Email')),
                      DataColumn2(label: Text('Organization')),
                      DataColumn2(label: Text('Attended')),
                    ],
                    source: dataSource,
                    onRowsPerPageChanged: isItemLessThanRowsPerPage
                        ? null
                        : (rowCount) {
                            setState(() {
                              if (rowCount != null) {
                                print(rowCount);
                                _rowsPerPage1 = rowCount;
                              }
                            });
                          },
                    rowsPerPage: isItemLessThanRowsPerPage
                        ? _rowsPerPage
                        : _rowsPerPage1,
                    showCheckboxColumn: true,
                  ),
                ),
              );
          }
          return DataTable2(
            columns: const [
              DataColumn2(label: Text('Id')),
              DataColumn2(label: Text('Full Name')),
              DataColumn2(label: Text('Email')),
              DataColumn2(label: Text('Organization')),
              DataColumn2(label: Text('Attended')),
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
  int get rowCount => dataList.length;

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => selectedRows.length;
}
