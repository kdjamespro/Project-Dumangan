import 'package:flutter/material.dart';

class Settigs_page extends StatefulWidget {
  const Settigs_page({Key? key}) : super(key: key);

  @override
  _Settigs_pageState createState() => _Settigs_pageState();
}

class _Settigs_pageState extends State<Settigs_page>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Center(child: Text("Settings")),
    );
  }
}
