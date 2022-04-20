import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '/model/archive_list.dart';
import 'editor.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ArchiveList.create(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (context) => snapshot.data as ArchiveList,
              child: const ScaffoldPage(
                content: Editor(),
                padding: EdgeInsets.all(0),
              ),
            );
          }
          return Container();
        });
  }
}
