import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class CustomAstVisitor extends SimpleAstVisitor<Map> {
  /// 遍历节点
  Map _safelyVisitNode(AstNode node) {
    if (node != null) {
      return node.accept(this);
    }
    return null;
  }

  /// 遍历节点列表
  List<Map> _safelyVisitNodeList(NodeList<AstNode> nodes) {
    List<Map> maps = [];
    if (nodes != null) {
      nodes.forEach((element) {
        Map res = _safelyVisitNode(element);
        if (res != null) {
          maps.add(res);
        }
      });
    }
    return maps;
  }

  /// 构造根节点
  Map _buildAstRoot(List<Map> body) {
    if (body.isNotEmpty) {
      return {
        "type": "Program",
        "body": body,
      };
    } else {
      return null;
    }
  }

  /// 构造 FunctionDeclaration
  Map _buildAstFunctionDeclaration(Map id, Map expression) {
    return {
      "type": "FunctionDeclaration",
      "id": id,
      "expression": expression,
    };
  }

  /// 构造函数参数了类型 TypeName
  Map _buildAstTypeName(String name) {
    return {
      "type": "TypeName",
      "name": name,
    };
  }

  /// 构建标示符定义
  Map _buildAstSimpleIdentifier(String name) {
    return {
      "type": "Identifier",
      "name": name,
    };
  }

  /// 构建函数表达式
  Map _buildAstFunctionExpression(Map params, Map body, {bool isAsync: false}) {
    return {
      "type": "FunctionExpression",
      "parameters": params,
      "body": body,
      "isAsync": isAsync,
    };
  }

  /// 构建函数参数
  Map _buildAstSimpleFormalParameter(Map type, String name) {
    return {
      "type": "SimpleFormalParameter",
      "paramType": type,
      "name": name,
    };
  }

  /// 构造函数体
  Map _buildAstBlock(List body) {
    return {
      "type": "BlockStatement",
      "body": body,
    };
  }

  /// 构建变量声明
  Map _buildAstVariableDeclarationList(
      Map typeAnnotation, List<Map> declarations) {
    return {
      "type": "VariableDeclarationList",
      "typeAnnotation": typeAnnotation,
      "declarations": declarations,
    };
  }

  /// 构造运算表达式结构
  Map _buildAstBinaryExpression(Map left, Map right, String lexeme) {
    return {
      "type": "BinaryExpression",
      "operator": lexeme,
      "left": left,
      "right": right,
    };
  }

  /// 构建数值定义
  Map _buildAstIntegerLiteral(int value) {
    return {
      "type": "NumericLiteral",
      "value": value,
    };
  }

  /// 构造返回数据定义
  Map _buildAstReturnStatement(Map argument) => {
        "type": "ReturnStatement",
        "argument": argument,
      };

  /// CompilationUnitImpl
  @override
  Map visitCompilationUnit(CompilationUnit node) {
    return _buildAstRoot(_safelyVisitNodeList(node.declarations));
  }

  /// FunctionDeclarationImpl
  @override
  Map visitFunctionDeclaration(FunctionDeclaration node) {
    return _buildAstFunctionDeclaration(
        _safelyVisitNode(node.name), _safelyVisitNode(node.functionExpression));
  }

  /// TypeNameImpl
  @override
  Map visitTypeName(TypeName node) {
    return _buildAstTypeName(node.name.name);
  }

  /// SimpleIdentifierImpl
  @override
  Map visitSimpleIdentifier(SimpleIdentifier node) {
    return _buildAstSimpleIdentifier(node.name);
  }

  /// FunctionExpressionImpl
  @override
  Map visitFunctionExpression(FunctionExpression node) {
    return _buildAstFunctionExpression(
        _safelyVisitNode(node.parameters), _safelyVisitNode(node.body),
        isAsync: node.body.isAsynchronous);
  }

  /// SimpleFormalParameterImpl
  @override
  Map visitSimpleFormalParameter(SimpleFormalParameter node) {
    return _buildAstSimpleFormalParameter(
        _safelyVisitNode(node.type), node.identifier.name);
  }

  /// BlockFunctionBodyImpl
  @override
  Map visitBlockFunctionBody(BlockFunctionBody node) {
    return _safelyVisitNode(node.block);
  }

  /// BlockImpl
  @override
  Map visitBlock(Block node) {
    return _buildAstBlock(_safelyVisitNodeList(node.statements));
  }

  /// VariableDeclarationStatementImpl
  @override
  Map visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    return _safelyVisitNode(node.variables);
  }

  /// VariableDeclarationListImpl
  @override
  Map visitVariableDeclarationList(VariableDeclarationList node) {
    return _buildAstVariableDeclarationList(
        _safelyVisitNode(node.type), _safelyVisitNodeList(node.variables));
  }

  /// BinaryExpressionImpl
  @override
  Map visitBinaryExpression(BinaryExpression node) {
    return _buildAstBinaryExpression(_safelyVisitNode(node.leftOperand),
        _safelyVisitNode(node.rightOperand), node.operator.lexeme);
  }

  /// IntegerLiteralImpl
  @override
  Map visitIntegerLiteral(IntegerLiteral node) {
    return _buildAstIntegerLiteral(node.value);
  }

  /// ReturnStatementImpl
  @override
  Map visitReturnStatement(ReturnStatement node) {
    return _buildAstReturnStatement(_safelyVisitNode(node.expression));
  }
}
