import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/pages/mp_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter 小程序验证"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return MPPage();
            }));
          },
          child: Text("跳转"),
        ),
      ),
    );
  }
}
