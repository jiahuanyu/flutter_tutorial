import 'package:flutter/material.dart';
import 'package:flutter_miniprogram/ui/component.dart';
import 'package:flutter_miniprogram/ui/property.dart';

class TextWidgetParser {
  static Text parse(Component component) {
    return Text(
      component.properties
          .firstWhere((element) => element.key == Property.KEY_INNER_HTML,
              orElse: () => null)
          ?.getValue(),
      style: TextStyle(
        color: component.properties
            .firstWhere((element) => element.key == Property.KEY_COLOR,
                orElse: () => null)
            ?.getValue(),
      ),
    );
  }
}
