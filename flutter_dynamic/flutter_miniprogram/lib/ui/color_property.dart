import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/ui/property.dart';

class ColorProperty extends Property {
  ColorProperty(String key, value) : super(key, value);

  @override
  dynamic getValue() {
    return Color(int.parse(value));
  }
}
