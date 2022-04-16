import 'package:fluent_ui/fluent_ui.dart';

Future<void> showWarningMessage(
    {required BuildContext context,
    required String title,
    required String message}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return ContentDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          SizedBox(
            width: 100,
            child: FilledButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
                return;
              },
              style: FluentTheme.of(context).buttonTheme.filledButtonStyle,
            ),
          )
        ],
      );
    },
  );
}
