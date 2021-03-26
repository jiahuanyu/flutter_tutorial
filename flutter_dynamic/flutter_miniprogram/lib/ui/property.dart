import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/ui/color_property.dart' as p;

class Property {
  static const KEY_INNER_HTML = "innerHtml";
  static const KEY_COLOR = "color";

  String key;

  @protected
  dynamic value;

  Property(this.key, this.value);

  static Property map(String key, dynamic value) {
    if (key == KEY_COLOR) {
      return p.ColorProperty(key, value);
    }
    return Property(key, value);
  }

  dynamic getValue() {
    return value;
  }
}
