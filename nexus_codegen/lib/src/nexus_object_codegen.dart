import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:nexus_codegen/src/templates/reactive.dart';
import 'package:nexus_codegen/src/templates/reactive_collection.dart';
import 'package:nexus_codegen/src/templates/state.dart';
import 'package:nexus_codegen/src/utils.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/src/builder/build_step.dart';

import '../nexus_codegen.dart';

class NexusObjectGenerator extends GeneratorForAnnotation<NexusObject> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      return;
    }

    final visitor =
        ObjectVisitor(nameFinder: LibraryScopedNameFinder(element.library));

    element
      ..accept(visitor)
      ..visitChildren(visitor);

    if (element.supertype?.element != null &&
        element.supertype?.element.name == "ReactiveObject") {
      return StateTemplate(
        name: element.name,
        superclass: "ReactiveObject",
        reactiveTemplates: visitor.reactiveFields,
      ).toString();
    } else {
      throw Exception(
          "Check your object structure, your ${element.name} does not "
          "have super class which implement object's logic");
    }
  }
}

class ObjectVisitor extends SimpleElementVisitor {
  final LibraryScopedNameFinder nameFinder;

  final List<ReactiveTemplate> _reactiveFields = [];

  ObjectVisitor({required this.nameFinder});

  List<ReactiveTemplate> get reactiveFields => _reactiveFields;

  @override
  void visitFieldElement(FieldElement element) {
    if (_isAnnotationExists(element, "Reactive")) {
      var _typeWithoutGeneric = _getTypeWithoutGeneric(element.type);

      var template;

      ConstantReader _reactiveAnnotation;

      _reactiveAnnotation = ConstantReader(element.metadata
          .firstWhere((meta) => meta.element?.displayName == "Reactive")
          .computeConstantValue());

      var _isReactionsDisabled =
          _reactiveAnnotation.read("disableReactions").boolValue;

      if (["ReactiveList", "ReactiveSet", "ReactiveMap"]
          .contains(_typeWithoutGeneric)) {
        template = ReactiveCollectionTemplate(
          type: element.type.getDisplayString(withNullability: true),
          name: element.name,
          genericType: getGenericFromType(element.type),
          disableReactions: _isReactionsDisabled,
          generateForReactiveObject: true,
        );
      } else {
        template = ReactiveTemplate(
          type: element.type.getDisplayString(withNullability: true),
          name: element.name,
          disableReactions: _isReactionsDisabled,
          generateForReactiveObject: true,
        );
      }

      _reactiveFields.add(template);
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
}
