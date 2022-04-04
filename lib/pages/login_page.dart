import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.setInfo}) : super(key: key);
  Function setInfo;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var client = http.Client();
  String id = '';
  late AccessToken token;
  late var account;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Button(child: const Text('Sign in'), onPressed: signIn),
          Button(child: const Text('Send Email'), onPressed: _sendEmail),
          Button(
            child: const Text('Logout'),
            onPressed: signOut,
          ),
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
      'https://www.googleapis.com/auth/userinfo.profile',
    ];

    obtainAccessCredentialsViaUserConsent(
            id, scopes, client, (url) => _lauchAuthInBrowser(url))
        .then((AccessCredentials credentials) {
      token = credentials.accessToken;

      client.close();
    });
  }

  Future _sendEmail() async {
    final email = account.email;
    final auth = await account.authentication;
    final token = auth.accessToken!;
    print(token);
    final smtpServer = gmailSaslXoauth2(email, token);

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

  Future<void> register() async {
    await GoogleSignInDart.register(
      clientId:
          '197134437934-d2p2baat8qcaba6f2suttk4ciil212gp.apps.googleusercontent.com',
    );
    print('Registered');
  }

  void signOut() async {
    print(await GoogleSignIn().isSignedIn());
    await GoogleSignIn().signOut();
    widget.setInfo('', '');
    print(await GoogleSignIn().isSignedIn());
  }

  void signIn() async {
    await register();
    var scopes = [
      'email',
      'openid',
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://mail.google.com/',
    ];
    account = await GoogleSignIn(scopes: scopes).signIn();
    if (account != null) {
      String email = account?.email ?? '';
      String imageUrl = account?.photoUrl ?? '';
      widget.setInfo(imageUrl, email);
    }
    print(await account?.authHeaders);
  }
}
