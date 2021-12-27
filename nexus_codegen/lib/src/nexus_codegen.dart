library nexus_codegen;

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:nexus_codegen/src/annotations.dart';
import 'package:nexus_codegen/src/templates/action.dart';
import 'package:nexus_codegen/src/templates/method.dart';
import 'package:nexus_codegen/src/templates/reactive.dart';
import 'package:nexus_codegen/src/templates/reactive_collection.dart';
import 'package:nexus_codegen/src/templates/state.dart';
import 'package:nexus_codegen/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class NexusGenerator extends GeneratorForAnnotation<NexusState> {
  @override
  generateForAnnotatedElement(Element element,
      ConstantReader annotation,
      BuildStep buildStep,) {
    if (element is! ClassElement) {
      return;
    }

    final visitor =
    StateVisitor(nameFinder: LibraryScopedNameFinder(element.library));

    element
      ..accept(visitor)
      ..visitChildren(visitor);

    if (element.supertype?.element != null) {
      return StateTemplate(
          name: element.name,
          reactiveTemplates: visitor.reactiveFields,
          actionTemplates: visitor.actions)
          .toString();
    } else {
      throw Exception(
          "Check your state structure, your ${element.name} does not "
              "have super class which implement state's logic");
    }
  }
}

class StateVisitor extends SimpleElementVisitor {
  final LibraryScopedNameFinder nameFinder;

  final List<ReactiveTemplate> _reactiveFields = [];
  final List<ActionTemplate> _actions = [];

  StateVisitor({required this.nameFinder});

  List<ReactiveTemplate> get reactiveFields => _reactiveFields;

  List<ActionTemplate> get actions => _actions;

  @override
  void visitFieldElement(FieldElement element) {
    if (_isAnnotationExists(element, "Reactive")) {
      var _typeWithoutGeneric = _getTypeWithoutGeneric(element.type);

      var template;

      ConstantReader _reactiveAnnotation;

      _reactiveAnnotation = ConstantReader(
          element.metadata.firstWhere((meta) =>
          meta.element?.displayName ==
              "Reactive").computeConstantValue());

      var _isReactionsDisabled = _reactiveAnnotation.read("disableReactions").boolValue;

      if (["ReactiveList", "ReactiveSet", "ReactiveMap"].contains(_typeWithoutGeneric)) {
        template = ReactiveCollectionTemplate(
            type: element.type.getDisplayString(withNullability: true),
            name: element.name,
            genericType: _getGeneric(element.type),
            disableReactions: _isReactionsDisabled,
        );
      } else {
        template = ReactiveTemplate(
          type: element.type.getDisplayString(withNullability: true),
          name: element.name,
          disableReactions: _isReactionsDisabled
        );
      }

      _reactiveFields.add(template);
    }
    return;
  }

  @override
  void visitMethodElement(MethodElement element) {
    if (_isAnnotationExists(element, action)) {
      final template = ActionTemplate(
        type: element.type.getDisplayString(withNullability: false),
        actionName: element.name,
        method: MethodTemplate.fromElement(element, nameFinder),
        isAsync: element.isAsynchronous,
      );

      _actions.add(template);
    }

    return;
  }

  bool _isAnnotationExists(Element element, String name) {
    if (element.metadata.isEmpty) {
      return false;
    }

    bool result = false;

    for (var meta in element.metadata) {
      if (meta.element?.displayName == name) {
        result = true;
        break;
      }
    }

    return result;
  }

  String _getTypeWithoutGeneric(DartType type) {
    return type
        .getDisplayString(withNullability: true)
        .replaceAll(RegExp(r"<.*>"), "");
  }

  String? _getGeneric(DartType type) {
    String _typeString = type.getDisplayString(withNullability: true);

    if (_typeString.contains(RegExp("<"))) {
      return RegExp(r"<.*>").firstMatch(_typeString)?.group(0);
    } else {
      return null;
    }
  }
}
