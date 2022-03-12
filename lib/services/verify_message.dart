import 'package:fluent_ui/fluent_ui.dart';

Future<bool> showVerificationMessage(
    {required BuildContext context,
    required String title,
    required String message}) async {
  bool? result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return ContentDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          Button(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          FilledButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              }),
        ],
      );
    },
  );
  if (result == null) {
    return false;
  }
  return result;
}
