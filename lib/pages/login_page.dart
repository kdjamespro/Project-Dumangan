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
import 'package:flutter_svg/flutter_svg.dart';

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
    return Stack(alignment: Alignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SvgPicture.asset("lib/image/conference.svg",
                  width: 500, height: 500)),
          Expanded(
              child: SvgPicture.asset("lib/image/certificate.svg",
                  width: 500, height: 500)),
        ],
      ),
      Center(
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: Button(
                  child: const Align(
                      alignment: Alignment.center, child: Text("Sample")),
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
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 200,
                height: 50,
                child: Button(
                    child: const Align(
                        alignment: Alignment.center, child: Text('Sign in')),
                    onPressed: () async {
                      List<String> info = await acc.signIn();
                      print(acc.signedIn);
                      widget.setInfo(info[0], info[1]);
                    }),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 200,
                height: 50,
                child: Button(
                  child: const Align(
                      alignment: Alignment.center, child: Text('Logout')),
                  onPressed: () async {
                    await acc.signOut();
                    widget.setInfo('', '');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
