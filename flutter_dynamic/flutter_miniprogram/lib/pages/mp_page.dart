import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/ui/widget_parser.dart';

class MPPage extends StatefulWidget {
  @override
  _MPPageState createState() => _MPPageState();
}

class _MPPageState extends State<MPPage> {
  static const TEST_CONTENT = """<Text color="0xffff0000">你好世界</Text>""";
  Widget _widget;

  @override
  void initState() {
    super.initState();
    () async {
      _widget = await WidgetParser().parse(TEST_CONTENT);
      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试"),
      ),
      body: _widget ??
          Center(
            child: CircularProgressIndicator(),
          ),
    );
  }
}
