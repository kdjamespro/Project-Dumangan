import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:project_dumangan/model/gmail_account.dart';
import 'package:project_dumangan/pages/data_upload/cert_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.setInfo}) : super(key: key);
  final Function setInfo;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var client = http.Client();
  String id = '';
  late AccessToken token;

  @override
  Widget build(BuildContext context) {
    GmailAccount acc = context.read<GmailAccount>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FilledButton(
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 40),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  onPressed: () async {
                    List<String> info = await acc.signIn();
                    print(acc.signedIn);
                    widget.setInfo(info[0], info[1]);
                    MotionToast.success(
                            dismissable: true,
                            animationDuration: const Duration(seconds: 1),
                            animationCurve: Curves.easeOut,
                            toastDuration: const Duration(seconds: 3),
                            description:
                                const Text('Account successfully logged in'))
                        .show(context);
                  }),
            ),
            Button(
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 40),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () async {
                await acc.signOut();
                widget.setInfo('', '');
                MotionToast.info(
                        dismissable: true,
                        animationDuration: const Duration(seconds: 1),
                        animationCurve: Curves.easeOut,
                        toastDuration: const Duration(seconds: 2),
                        description:
                            const Text('Account successfully logged out'))
                    .show(context);
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 100),
          child: SvgPicture.asset(
            "lib/image/Login2.svg",
            height: 300,
            width: 300,
          ),
        ),
      ],
    );
  }
}
