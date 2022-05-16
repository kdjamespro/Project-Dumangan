import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _expanderKey = GlobalKey<ExpanderState>();
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expander(
                      header: const Text('What is Project Dumangan?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          text: '               This application, codenamed ',
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Project Dumangan',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' is an application developed by '),
                            TextSpan(
                                text: 'Unitek,',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                                text:
                                    ' a team of aspiring computer scientists, for '),
                            TextSpan(
                                text: 'Asst. Prof. Analiza A. Yanga, MHist,',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(text: ' the current adviser of '),
                            TextSpan(
                                text: 'UST UNESCO Club. ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'The codename has been derived from Dumangan, the Tagalog sky-god of good harvest in Philippine Mythology. That said, the inspiration comes from the belief of the team that this software is the jumpstart to their future careers. Furthermore, the application aims to automate the process of generating and sending certificates for events with flexibility and ease-of-use in mind and make it easier for those who work in the Creatives team of any organization. Lastly, this project is done in fulfillment of the course requirement for the courses '),
                            TextSpan(
                                text: 'Software Engineering 1',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(text: ' and '),
                            TextSpan(
                                text: 'Software Engineering 2',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                                text:
                                    ' under the B.S. Computer Science program of the College of Information and Computing Sciences in the University of Santo Tomas.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expander(
                      header: const Text(
                          'How do you use the cross checking feature?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Step 1: Select an event\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    '     - On the left most part of the app, please locate the event item on the side menu.\n'),
                            TextSpan(
                                text:
                                    '     - Select an event from the event cards (blue squares) on the bottom part of the app. If there is no event card present, you can add an event by filling in the forms with the event data.\n'),
                            TextSpan(
                                text:
                                    'Step 2: Navigate to the Cross-check menu item\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    '     - On the left most part of the app, you can find a check icon on the side menu, then click it. \n'),
                            TextSpan(
                                text: 'Step 3: Enable Cross-checking \n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    '     - On the upper part of the app, there would be a toggle button that is by default turned off, with the toggle button being gray in color and has a label (Cross-Checking Disabled). Click it to enable cross-checking, the toggle button would be color blue and would have a label of (Cross-Checking Enabled). \n'),
                            TextSpan(
                                text: 'Step 4: Upload Files\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    '     - Two rectangular drop boxes would be available, you can click or drag your Registration and Evaluation data in a (.csv) format to it. Then click the blue upload button on the bottom part of the application. \n'),
                            TextSpan(
                                text: 'Step 5: Map the Columns \n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'This maps the column header of the registration data and the evaluation/attendance to let the system know where the column header be read. \n',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                              text:
                                  '     - You will be presented with a table with the following columns: File Columns, Values and Map to. \n',
                            ),
                            TextSpan(
                              text:
                                  '     - Under the (Map to) header, there would be drop down menus, click it and kindly map the value on the drop down with the values on the (File Column) header.\n',
                            ),
                            TextSpan(
                              text:
                                  '     - If a row is not needed, you can click the trash bin icon under the (Remove) header, to remove unnecessary rows.\n',
                            ),
                            TextSpan(
                              text:
                                  '     - When you are finished on the mapping of the columns, you can now click the blue (Match File) button on the upper part of the application. \n',
                            ),
                            TextSpan(
                                text: 'Step 6: Cross-check\n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'This maps the column header of the registration data and the evaluation/attendance for the actual cross-checking process. \n',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                              text:
                                  '     - You will be presented with a table with the following columns: File Columns, Values and Map to. \n',
                            ),
                            TextSpan(
                              text:
                                  '     - Under the (Map to) header, there would be drop down menus, click it and kindly map the value on the drop down with the values on the (File Column) header.\n',
                            ),
                            TextSpan(
                              text:
                                  '     - If a row is not needed, you can click the trash bin icon under the (Remove) header, to remove unnecessary rows.\n',
                            ),
                            TextSpan(
                              text:
                                  '     - When you are finished on the mapping of the columns, you can now click the blue (Cross-check) button on the upper part of the application\n',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expander(
                      header: const Text('How do you edit certificates?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'Step 1: Set the desired paper size of the certificate from the Document Size menu.\n'),
                            TextSpan(
                                text:
                                    'Step 2: Upload the certificate template which can be found in the Template menu.\n'),
                            TextSpan(
                                text: 'Note: ',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                                text:
                                    'The uploaded certificate template will automatically fit the editor canvas so make sure that the template matches the paper size dimension.\n'),
                            TextSpan(
                                text:
                                    'Step 3: Select the dynamic attributes (information that will be dynamically replaced for each participant based on the uploaded data) that will be used for the certificate generation.\n'),
                            TextSpan(
                                text:
                                    'Step 4: Adjust the desired location and font style of the attributes.\n'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expander(
                      header: const Text('How do you generate certificates?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '     After editing your certificates, simply press the “Generate Certificates” button, located at the templates panel in the editor page, choose where the generated certificates will be saved, and wait for the process to complete.\n'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expander(
                      header: const Text(
                          'How to send the generated certificate to the participants?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'Step 1: Login using a valid gmail account\n'),
                            TextSpan(
                                text:
                                    'Step 2: Make sure that there is an existing certificates for each participants\n'),
                            TextSpan(
                                text:
                                    'Step 3: Click the floating send button on the bottom right portion of the certificate viewing page.\n'),
                            TextSpan(
                                text:
                                    'Step 4: Compose the subject and body of the email that will be sent. \n'),
                            TextSpan(
                                text:
                                    'Step 5: Click the send button and wait until the sending process is complete. \n'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expander(
                      header: const Text(
                          'What email addresses are valid when signing in to send the certificates or announcements?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: const TextSpan(
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'The application requires the user to sign in with their valid UST email address. Our application is only approved by google using the organizational email addresses within UST. \n'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: mat.Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(203, 202, 202, 1.0)
                                .withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(
                                2, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "For more detailed instructions",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton(
                                    child: Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                              FluentIcons.download_document),
                                        ),
                                        SizedBox(width: 10),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Download User Manual'),
                                        ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      String docuUrl =
                                          'https://docs.google.com/document/d/1DzG9lUjqhI7S_2r4RNClD6TS9O8E2OxaOmI2lpotPME/edit?usp=sharing';
                                      if (await canLaunch(docuUrl)) {
                                        await launch(docuUrl);
                                      } else {
                                        showWarningMessage(
                                            context: context,
                                            title: 'Document Launching Error',
                                            message:
                                                'The system encountered an error in launching the document');
                                      }
                                    }),
                                Container(
                                  child: SvgPicture.asset(
                                    "assets/images/file_download.svg",
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void close() {
    _expanderKey.currentState?.open = false;
  }
}
