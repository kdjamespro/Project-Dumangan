import 'package:fluent_ui/fluent_ui.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:project_dumangan/pages/data_page.dart';

class GmailAccount {
  GoogleSignInAccount? account;
  final _scopes = [
    'email',
    'openid',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://mail.google.com/',
    'https://www.googleapis.com/auth/gmail.send',
  ];
  bool _isLoggedIn;

  GmailAccount._create() : _isLoggedIn = false;

  static Future<GmailAccount> create() async {
    var account = GmailAccount._create();
    await account._register();
    return account;
  }

  bool get signedIn => _isLoggedIn;

  Future<void> _register() async {
    await GoogleSignInDart.register(
      clientId:
          '197134437934-d2p2baat8qcaba6f2suttk4ciil212gp.apps.googleusercontent.com',
    );
    print('Registered');
  }

  Future<List<String>> signIn() async {
    List<String> userInfo = [];

    account = await GoogleSignIn(scopes: _scopes).signIn();
    if (account != null) {
      String email = account?.email ?? '';
      String imageUrl = account?.photoUrl ?? '';
      print(await account?.authHeaders);
      userInfo.add(imageUrl);
      userInfo.add(email);
    }
    _isLoggedIn = await _checkSignedIn();
    return userInfo;
  }

  Future<bool> _checkSignedIn() async {
    return await GoogleSignIn().isSignedIn();
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
  }

  Future<bool> sendEmail(String subject, String userMessage,
      String participantEmail, File cert) async {
    bool successful = false;
    final email = account!.email;
    final auth = await account!.authentication;
    final token = auth.accessToken!;
    print(token);
    final smtpServer = gmailSaslXoauth2(email, token);

    final message = Message()
      ..from = Address(email)
      ..recipients = [
        participantEmail,
      ]
      ..subject = subject
      ..text = userMessage
      ..attachments = [FileAttachment(cert)];

    try {
      await send(message, smtpServer);
      successful = true;
      print('Email Sent');
    } on MailerException catch (e) {
      successful = false;
      print(e);
    }
    return successful;
  }

  Future sendAnnouncements(
      String subject, String userMessage, String participantEmail) async {
    bool successful = false;
    final email = account!.email;
    final auth = await account!.authentication;
    final token = auth.accessToken!;
    final smtpServer = gmailSaslXoauth2(email, token);

    final message = Message()
      ..from = Address(email)
      ..recipients = [
        participantEmail,
      ]
      ..subject = subject
      ..text = userMessage;

    try {
      await send(message, smtpServer);
      successful = true;
      print('Email Sent');
    } on MailerException catch (e) {
      successful = false;
      print(e);
    }
    return successful;
  }
}
