import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:args/args.dart';
import 'package:flutter_dynamic/CustomAstVisitor.dart';

void main(List<String> arguments) {
  exitCode = 0;
  final argParser = ArgParser()..addFlag("file", negatable: false, abbr: 'f');

  var argResults = argParser.parse(arguments);
  final values = argResults.rest;
  if (values.isEmpty) {
    stdout.writeln('No file found');
  } else {
    astGenerate(values[0]);
  }
}

/// 生成 AST 语法描述 Json 文件
Future astGenerate(String path) async {
  if (path.isEmpty) {
    stdout.writeln("No file found");
  } else {
    await _handleError(path);
    if (exitCode == 2) {
      try {
        var parseResult =
            parseFile(path: path, featureSet: FeatureSet.fromEnableFlags([]));
        var compilationUnit = parseResult.unit;
        // 遍历AST
        Map astMap = compilationUnit.accept(CustomAstVisitor());
        stdout.writeln(jsonEncode(astMap));
      } catch (e) {
        stdout.writeln('Parse file error: ${e.toString()}');
      }
    }
  }
}

Future _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}

class DemoAstVisitor extends GeneralizingAstVisitor<Map> {
  @override
  Map visitNode(AstNode node) {
    // 输出遍历 AST Node 节点内容
    stdout.writeln("${node.runtimeType}<---->${node.toSource()}");
    return super.visitNode(node);
  }
}
