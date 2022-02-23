import 'package:fluent_ui/fluent_ui.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  var client = http.Client();
  String id = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Button(child: Text('Sign in'), onPressed: _loginWindowsDesktop),
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
      client.close();
    });
  }
}
