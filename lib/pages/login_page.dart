import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
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
    return Column(
      children: [
        Button(
          child: Text("Sample"),
          onPressed: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return ContentDialog(
                  title: const Text("Sample"),
                  content: const Text('Sample'),
                  actions: [
                    Button(
                      child: const Text('Sample'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FilledButton(
                        child: const Text('Sample'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                );
              },
            );
          },
        ),
        Button(
            child: const Text('Sign in'),
            onPressed: () async {
              List<String> info = await acc.signIn();
              print(acc.signedIn);
              widget.setInfo(info[0], info[1]);
            }),
        Button(
          child: const Text('Logout'),
          onPressed: () async {
            await acc.signOut();
            widget.setInfo('', '');
          },
        ),
      ],
    );
  }
}
