import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  var client = http.Client();
  String id = '';
  late AccessToken token;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Button(child: Text('Sign in'), onPressed: _loginWindowsDesktop),
          Button(child: Text('Send Email'), onPressed: _sendEmail),
        ],
      ),
    );
  }

  void _lauchAuthInBrowser(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not lauch $url';
  }

  void _loginWindowsDesktop() {
    var id = ClientId(
      '197134437934-d2p2baat8qcaba6f2suttk4ciil212gp.apps.googleusercontent.com',
      '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',
    );
    var scopes = [
      'email',
      'openid',
      'https://mail.google.com/',
    ];

    obtainAccessCredentialsViaUserConsent(
            id, scopes, client, (url) => _lauchAuthInBrowser(url))
        .then((AccessCredentials credentials) {
      token = credentials.accessToken;

      client.close();
    });
  }

  Future _sendEmail() async {
    final email = 'kennethdwight.probadora.iics@ust.edu.ph';
    final smtpServer = gmailSaslXoauth2(email, token.data);

    final message = Message()
      ..from = Address(email, 'Kenneth')
      ..recipients = [
        'kennethdwight.probadora.iics@ust.edu.ph',
        'jamesprobadora@gmail.com',
      ]
      ..subject = 'Test Send'
      ..text = 'Test Email Send'
      ..attachments = [
        FileAttachment(File('D:\\Downloads\\Probadora_SW # 7.pdf'))
      ];

    try {
      await send(message, smtpServer);
      print('Email Sent');
    } on MailerException catch (e) {
      print(e);
    }
  }
}
