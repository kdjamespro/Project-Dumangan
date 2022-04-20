import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:project_dumangan/model/gmail_account.dart';
import 'package:provider/provider.dart';
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
  bool signedIn = false;
  @override
  Widget build(BuildContext context) {
    GmailAccount acc = context.read<GmailAccount>();
    signedIn = acc.signedIn;
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: Container(
        margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(2, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(203, 202, 202, 1.0)
                        .withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(2, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      signedIn
                          ? 'Login Sucessful! You can now send certificate to participants using your gmail account'
                          : "To authorize the distribution of certifcates or announcements,\nplease login to your (ust.edu.ph) account. Thank you.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Visibility(
                      visible: !signedIn,
                      child: FilledButton(
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 60),
                            child: Text(
                              'Sign in',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onPressed: () async {
                            List<String> info = await acc.signIn();
                            if (acc.signedIn) {
                              widget.setInfo(info[0], info[1]);
                              setState(() {
                                signedIn = acc.signedIn;
                              });
                            }
                          }),
                    ),
                  ),
                  Visibility(
                    visible: signedIn,
                    child: FilledButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 60),
                        child: Text(
                          'Logout',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      onPressed: () async {
                        await acc.signOut();
                        widget.setInfo('', '');
                        setState(() {
                          signedIn = acc.signedIn;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100),
              child: SvgPicture.asset(
                "assets/images/sync.svg",
                height: 300,
                width: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
