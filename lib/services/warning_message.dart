import 'package:fluent_ui/fluent_ui.dart';

void showWarningMessage(
    {required BuildContext context,
    required String title,
    required String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return ContentDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          Button(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );
    },
  );
}
