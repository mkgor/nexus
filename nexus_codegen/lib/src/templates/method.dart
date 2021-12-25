import 'package:analyzer/dart/element/element.dart';
import 'package:nexus_codegen/src/templates/params.dart';
import 'package:nexus_codegen/src/templates/utils.dart';

import '../utils.dart';
import 'comma_list.dart';

class MethodTemplate {
  MethodTemplate.fromElement(
      ExecutableElement method,
      LibraryScopedNameFinder typeNameFinder,
      ) {
    // ignore: prefer_function_declarations_over_variables
    final param = (ParameterElement element) => ParamTemplate(
        name: element.name,
        type: typeNameFinder.findParameterTypeName(element),
        defaultValue: element.defaultValueCode,
        hasRequiredKeyword: element.isRequiredNamed);

    final positionalParams = method.parameters
        .where((param) => param.isPositional && !param.isOptionalPositional)
        .toList();

    final optionalParams =
    method.parameters.where((param) => param.isOptionalPositional).toList();

    final namedParams =
    method.parameters.where((param) => param.isNamed).toList();

    this
      ..name = method.name
      ..returnType = typeNameFinder.findReturnTypeName(method)
      ..setTypeParams(method.typeParameters
          .map((type) => typeParamTemplate(type, typeNameFinder)))
      ..positionalParams = positionalParams.map(param)
      ..optionalParams = optionalParams.map(param)
      ..namedParams = namedParams.map(param)
      ..returnTypeArgs = SurroundedCommaList(
          '<', '>', typeNameFinder.findReturnTypeArgumentTypeNames(method));
  }

  late String name;
  late String returnType;
  late SurroundedCommaList<String> returnTypeArgs;

  late SurroundedCommaList<TypeParamTemplate> _typeParams;
  late SurroundedCommaList<String> _typeArgs;

  late CommaList<ParamTemplate> _positionalParams;
  late SurroundedCommaList<ParamTemplate> _optionalParams;
  late SurroundedCommaList<ParamTemplate> _namedParams;

  late CommaList<String> _positionalArgs;
  late CommaList<String> _optionalArgs;
  late CommaList<NamedArgTemplate> _namedArgs;

  setTypeParams(Iterable<TypeParamTemplate> params) {
    _typeParams = SurroundedCommaList('<', '>', params.toList());
    _typeArgs =
        SurroundedCommaList('<', '>', params.map((p) => p.asArgument).toList());
  }

  // ignore: avoid_setters_without_getters
  set positionalParams(Iterable<ParamTemplate> params) {
    _positionalParams = CommaList(params.toList());
    _positionalArgs = CommaList(params.map((p) => p.asArgument).toList());
  }

  // ignore: avoid_setters_without_getters
  set optionalParams(Iterable<ParamTemplate> params) {
    _optionalParams = SurroundedCommaList('[', ']', params.toList());
    _optionalArgs = CommaList(params.map((p) => p.asArgument).toList());
  }

  // ignore: avoid_setters_without_getters
  set namedParams(Iterable<ParamTemplate> params) {
    _namedParams = SurroundedCommaList('{', '}', params.toList());
    _namedArgs = CommaList(params.map((p) => p.asNamedArgument).toList());
  }


  CommaList<ParamTemplate> get positionalParamsList => _positionalParams;

  CommaList get params =>
      CommaList([_positionalParams, _optionalParams, _namedParams]);

  CommaList get args => CommaList([_positionalArgs, _optionalArgs, _namedArgs]);

  SurroundedCommaList<TypeParamTemplate> get typeParams => _typeParams;

  SurroundedCommaList<String> get typeArgs => _typeArgs;

  SurroundedCommaList<ParamTemplate> get optionalParamsList => _optionalParams;

  SurroundedCommaList<ParamTemplate> get namedParamsList => _namedParams;

  CommaList<String> get positionalArgs => _positionalArgs;

  CommaList<String> get optionalArgs => _optionalArgs;

  CommaList<NamedArgTemplate> get namedArgs => _namedArgs;
}