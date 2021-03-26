import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/ui/property.dart';
import 'package:flutter_miniprogram/ui/text_widget_parser.dart';

class Component {
  /// 子组件
  List<Component> children = [];

  /// 属性
  List<Property> properties = [];

  /// 父组件
  Component parent,

  /// 组件名称
  String name;

  Component({@required this.name, @required this.parent});

  /// 添加子组件
  void addChild(Component component) {
    children.add(component);
  }

  /// 添加属性值
  void addProperties(String key, dynamic value) {
    properties.add(Property.map(key, value));
  }

  Future<Widget> parseWidget() async {
    print(children.length);
    switch (name) {
      case "Text":
        return TextWidgetParser.parse(this);
        break;
      default:
        return null;
        break;
    }
  }
}
