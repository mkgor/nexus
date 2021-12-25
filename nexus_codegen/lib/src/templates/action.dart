import 'package:nexus_codegen/src/templates/method.dart';

class ActionTemplate {
  final String type;
  final String actionName;

  final MethodTemplate method;
  final bool isAsync;

  ActionTemplate({
    required this.type,
    required this.actionName,
    required this.method,
    this.isAsync = false,
  });

  String get argumentsString {
    List<String> _result = [];

    _result.addAll(method.positionalParamsList.templates.map((e) => e.name));
    _result.addAll(method.optionalParamsList.templates.map((e) => e.name));
    _result.addAll(method.namedParamsList.templates.map((e) => "${e.name}: ${e.name}"));

    if(_result.isNotEmpty) {
      return _result.join(", ");
    } else {
      return "";
    }
  }

  @override
  // ignore: prefer_single_quotes
  String toString() => """
    @override
    ${isAsync ? "Future" : method.returnType} ${method.name}${method.typeParams}(${method.params}) ${isAsync ? "async" : ""} {
      return perform${isAsync ? "Async" : ""}Action(() => super.${method.name}($argumentsString));
    }""";
}
