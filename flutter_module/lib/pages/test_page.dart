import 'package:flutter/material.dart';
import 'package:flutter_module/router/nav_key.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "你好",
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {},
        ),
      ),
      body: FlatButton(
        onPressed: () {
          NavKey.navKey.currentState.pushNamed("/test_page2");
        },
        child: Text(
          "xxxxx",
        ),
      ),
    );
  }
}
