import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_module/router/nav_key.dart';
import 'package:flutter_module/router/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.black,
      ),
      initialRoute: window.defaultRouteName,
      onGenerateRoute: Routes.onGenerateRoute,
      navigatorKey: NavKey.navKey,
    );
  }
}
