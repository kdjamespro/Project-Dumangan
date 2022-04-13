import 'package:fluent_ui/fluent_ui.dart';

Future<void> showWarningMessage(
    {required BuildContext context,
    required String title,
// <<<<<<< HEAD
//     required String message}) {
//   showDialog(
//     barrierDismissible: true,
// =======
    required String message}) async {
  await showDialog(
// >>>>>>> 4256ad7f65315b9c276985ecc4add0f4c5117cbf
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
