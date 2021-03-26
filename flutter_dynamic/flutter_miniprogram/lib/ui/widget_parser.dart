import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/ui/component.dart';
import 'package:flutter_miniprogram/ui/property.dart';
import 'package:xml/xml.dart';

class WidgetParser {
  Future<Widget> parse(String content) async {
    XmlDocument document = XmlDocument.parse(content);
    XmlElement rootElement = document.rootElement;
    if (rootElement == null) {
      return Future.error("xxxx");
    }
    print(rootElement.name);
    Component rootComponent = await _parseElement(rootElement, null);
    return _parseComponent(rootComponent);
  }

  Future<Component> _parseElement(
      XmlElement xmlElement, Component parentComponent) async {
    Component component =
        Component(parent: parentComponent, name: xmlElement.name.toString());
    for (XmlAttribute attribute in xmlElement.attributes) {
      print("attribute = $attribute");
      component.addProperties(attribute.name.toString(), attribute.value);
    }
    for (XmlNode node in xmlElement.children) {
      if (node is XmlText) {
        component.addProperties(Property.KEY_INNER_HTML, node.text);
      } else if (node is XmlElement) {
        component.addChild(await _parseElement(node, component));
      }
    }
    return Future.value(component);
  }

  Future<Widget> _parseComponent(Component rootComponent) async {
    return rootComponent.parseWidget();
  }
}
