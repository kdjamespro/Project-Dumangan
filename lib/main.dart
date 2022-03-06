import 'dart:core';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:project_dumangan/pages/EditorSample.dart';

import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/pages/archive_page.dart';
import 'package:project_dumangan/pages/help_page.dart';
import 'package:project_dumangan/pages/setting_page.dart';

import 'package:provider/provider.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3_library_windows/sqlite3_library_windows.dart';

import 'model/fontstyle_controller.dart';
import 'pages/data_page.dart';
import 'pages/data_upload/cert_page.dart';
import 'pages/editor/editor_page.dart';
import 'pages/event_page.dart';
import 'pages/login_page.dart';
import 'services/file_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  open.overrideFor(OperatingSystem.windows, openSQLiteOnWindows);
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => FileHandler(platform: FilePicker.platform)),
      ChangeNotifierProvider(create: (context) => FontStyleController()),
      Provider<MyDatabase>(
        create: (context) => MyDatabase(),
        dispose: (context, db) => db.close(),
      ),
    ],
    child: const MyApp(),
  ));
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = Size(window.physicalSize.height, 540);
    win.maximize();
    win.alignment = Alignment.center;
    win.title = 'Project Dumangan';
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: ThemeData(brightness: Brightness.light, accentColor: Colors.blue),
      debugShowCheckedModeBanner: false,
      title: 'Project Dumangan',
      home: const MyHomePage(title: 'Project Dumangan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: MoveWindow(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.title),
          ),
        ),
        actions: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [Spacer(), WindowButtons()],
        ),
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
          displayMode: PaneDisplayMode.compact,
          size: const NavigationPaneSize(
            openWidth: 180,
            openMinWidth: 100,
            openMaxWidth: 180,
          ),
          selected: index,
          onChanged: (i) => setState(() => index = i),
          items: [
            // It doesn't look good when resizing from compact to open
            PaneItemHeader(
                header: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Controls'),
            )),

            PaneItem(
              icon: const Icon(FluentIcons.add_event),
              title: const Text('Add Event'),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.check_mark),
              title: const Text('Generate'),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.edit),
              title: const Text('Edit'),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.edit),
              title: const Text('Edit'),
            ),

            PaneItem(
              icon: const Icon(FluentIcons.send),
              title: const Text('Send'),
            ),

            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
            ),

            PaneItem(
              icon: const Icon(FluentIcons.archive),
              title: const Text('Archive'),
            ),

            PaneItem(
              icon: const Icon(FluentIcons.help),
              title: const Text('Help'),
            ),
          ],
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.signin),
              title: const Text('Sign In'),
            ),
          ]),
      content: NavigationBody(
        transitionBuilder: ((child, animation) => EntrancePageTransition(
              child: child,
              animation: animation,
            )),
        index: index,
        children: [
          EventPage(),
          CertPage(),
          EditorPage(),
          EditorSample(),
          DataPage(),
          Settigs_page(),
          ArchivePage(),
          HelpPage(),
          LoginPage(),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    assert(debugCheckHasFluentLocalizations(context));
    final ThemeData theme = FluentTheme.of(context);
    final buttonColors = WindowButtonColors(
      iconNormal: theme.inactiveColor,
      iconMouseDown: theme.inactiveColor,
      iconMouseOver: theme.inactiveColor,
      mouseOver: ButtonThemeData.buttonColor(
          theme.brightness, {ButtonStates.hovering}),
      mouseDown: ButtonThemeData.buttonColor(
          theme.brightness, {ButtonStates.pressing}),
    );
    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red,
      mouseDown: Colors.red.dark,
      iconNormal: theme.inactiveColor,
      iconMouseOver: Colors.red.basedOnLuminance(),
      iconMouseDown: Colors.red.dark.basedOnLuminance(),
    );
    return Row(children: [
      Tooltip(
        message: FluentLocalizations.of(context).minimizeWindowTooltip,
        child: MinimizeWindowButton(colors: buttonColors),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).restoreWindowTooltip,
        child: WindowButton(
          colors: buttonColors,
          iconBuilder: (context) {
            if (appWindow.isMaximized) {
              return RestoreIcon(color: context.iconColor);
            }
            return MaximizeIcon(color: context.iconColor);
          },
          onPressed: appWindow.maximizeOrRestore,
        ),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).closeWindowTooltip,
        child: CloseWindowButton(
          colors: closeButtonColors,
          animate: false,
        ),
      ),
    ]);
  }
}
