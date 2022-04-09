import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/model/progress_controller.dart';
import 'package:project_dumangan/services/verify_message.dart';
import 'package:provider/provider.dart';

class LoadingDialog {
  bool isShowing = false;
  late BuildContext dialogContext;
  LoadingDialog();

  void showLoadingScreen({
    required BuildContext context,
    required String title,
  }) {
    ProgressController loader = context.read<ProgressController>();
    showDialog(
      context: context,
      builder: (_) {
        isShowing = true;
        dialogContext = context;
        return ContentDialog(
          title: Text(title),
          content: ChangeNotifierProvider.value(
            value: loader,
            child: Consumer<ProgressController>(
                builder: (context, loading, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProgressBar(
                      value: (loading.progress / loading.overall) * 100),
                  Text(
                      'Cetificates Generated: ${loading.progress} / ${loading.overall}'),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  void hideLoadingScreen() {
    if (isShowing) {
      Navigator.pop(dialogContext);
    }
  }
  

  //   return Column(
  //   children: [
  //     ProgressBar(value: value.progress / value.overall),
  //   ],
  // );
}
