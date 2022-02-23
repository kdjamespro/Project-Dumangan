import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/participants_data.dart';
import 'file_uploader.dart';

class CertPage extends StatelessWidget {
  CertPage({Key? key}) : super(key: key);
  bool fileExists = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: ListView(
        children: [
          FileUploader(),
          Table(),
        ],
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
