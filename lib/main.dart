import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'pages/cert_page.dart';
import 'pages/data_page.dart';
import 'pages/editor_page.dart';
import 'pages/event_page.dart';
import 'pages/login_page.dart';

void main() async {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = const Size(410, 540);
    win.size = const Size(755, 545);
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
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      title: 'Project Dumangan',
      home: MyHomePage(title: 'Project Dumangan'),
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
              header: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Controls'),
          )),

          PaneItem(
            icon: const Icon(FluentIcons.reset),
            title: const Text('Reset'),
          ),

          PaneItem(
            icon: const Icon(FluentIcons.archive),
            title: const Text('Generate'),
          ),

          PaneItem(
            icon: const Icon(FluentIcons.send),
            title: const Text('Send'),
          ),
        ],
      ),
      content: NavigationBody(
        transitionBuilder: ((child, animation) => EntrancePageTransition(
              child: child,
              animation: animation,
            )),
        index: index,
        children: [
          EventPage(),
          CertPage(),
          DataPage(),
          EditorPage(),
          LoginPage()
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
        child: CloseWindowButton(colors: closeButtonColors),
      ),
    ]);
  }
}
