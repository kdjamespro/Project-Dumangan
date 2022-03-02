import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '/bloc/cross_checking_bloc.dart';
import '/services/verify_message.dart';
import '../../data/participants_data.dart';
import 'file_uploader.dart';

class CertPage extends StatelessWidget {
  CertPage({Key? key}) : super(key: key);
  bool fileExists = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CrossCheckingBloc>(
      create: (context) => CrossCheckingBloc(),
      child: ScaffoldPage(
        content: BlocBuilder<CrossCheckingBloc, CrossCheckingState>(
            builder: (context, state) {
          if (state is CrossCheckingStart) {
            return Container(
              child: const Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: ProgressRing(
                    strokeWidth: 15,
                  ),
                ),
              ),
            );
          } else if (state is CrossCheckingFinished) {
            return Container(
              child: Center(
                child: Column(children: [
                  Button(
                      child: const Text('Delete Data'),
                      onPressed: () async {
                        bool proceed = await showVerificationMessage(
                            context: context,
                            title: 'Deleting Data',
                            message:
                                'Do you want to delete your existing data?');
                        if (proceed) {
                          context
                              .read<CrossCheckingBloc>()
                              .add(CrossChekingEventInitialize());
                        }
                      }),
                  const Table(),
                ]),
              ),
            );
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

class _TableState extends State<Table> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: SfDataGrid(
          source: ParticipantsData(),
          columns: ParticipantsData().getColumns(),
          allowSorting: true,
          columnWidthMode: ColumnWidthMode.fill,
        ),
      ),
    );
  }
}
