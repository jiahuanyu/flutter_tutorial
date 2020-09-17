import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_module/pages/test_page.dart';
import 'package:flutter_module/pages/test_page2.dart';

class Routes {
  static final _routes = {
    "/test_page": (BuildContext context, {argument}) => TestPage(),
    "/test_page2": (BuildContext context) => TestPage2(),
  };

// ignore: top_level_function_literal_block
  static final onGenerateRoute = (RouteSettings settings) {
    // 统一处理
    final String routeFullName = settings.name;
    final String routeName = _getRouteName(routeFullName);
    final Map<String, dynamic> routeUriParams = _getRouteParams(routeFullName);
    print(
        "routeName = $routeName, routeUriParams = $routeUriParams, routeParams = ${settings.arguments}");
    // 获取路由路径上的参数
    final Function pageContentBuilder = _routes[routeName];
    if (pageContentBuilder != null) {
      if (routeUriParams != null) {
        final Route route = MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: routeUriParams));
        return route;
      } else if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute(
            builder: (context) => pageContentBuilder(context));
        return route;
      }
    }
    return null;
  };

  static String _getRouteName(String route) {
    String pageName = route;
    if (route.indexOf("?") != -1)
      //截取?之前的字符串 表明后面带有业务参数
      pageName = route.substring(0, route.indexOf("?"));
    return pageName;
  }

  static Map<String, dynamic> _getRouteParams(String route) {
    Map<String, dynamic> nativeParams;
    if (route.indexOf("?") != -1) {
      print(
          "full route name = " + Uri.parse(route).queryParameters['arguments']);
      nativeParams = json.decode(Uri.parse(route).queryParameters['arguments']);
      print("nativeParams = $nativeParams");
    }
    return nativeParams;
  }
}
