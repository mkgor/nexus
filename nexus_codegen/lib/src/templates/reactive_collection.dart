import 'package:analyzer/dart/constant/value.dart';
import 'package:nexus_codegen/src/templates/reactive.dart';

class ReactiveCollectionTemplate extends ReactiveTemplate {
  final String? genericType;
  final bool dataSafeMutations;

  ReactiveCollectionTemplate(
      {required String type,
      required String name,
      required bool disableReactions,
      required bool generateForReactiveObject,
      List<DartObject> mutators = const [],
      List<DartObject> guards = const [],
      this.genericType,
      this.dataSafeMutations = true})
      : super(
          type: type,
          name: name,
          disableReactions: disableReactions,
          generateForReactiveObject: generateForReactiveObject,
          mutators: mutators,
          guards: guards,
        );

  @override
  String toString() {
    return """
  bool _\$${name}Gate = false;

  $type _getWrapped$name() {
    _\$${name}Gate = true;

    final result = this.$name.wrap${genericType ?? "<dynamic>"}(controller: this, 
    variableName: '$name', 
    disableReactions: $disableReactions, dataSafeMutations: $dataSafeMutations,
    ${mutators.isNotEmpty ? "mutators: [${mutators.map((e) => e.type.toString() + "()").toList().join(", ")}]," : ""});

    _\$${name}Gate = false;

    return result;
  }

  late $type _\$$name = _getWrapped$name();
   
  @override
  get $name {
    if (!_\$${name}Gate) {
      ${guards.isNotEmpty ? buildGuards("_\$$name") : ""}
      return _\$$name;
    } else {
      return super.$name;
    }
  }
  
  @override
  set $name($type newValue) {
    if ($name != newValue) {
      var oldValue = $name;
      super.$name = newValue;
      _\$$name = _getWrapped$name();

      ${generateForReactiveObject ? "controller?." : ""}markNeedsUpdate();

      ${generateForReactiveObject ? "controller?." : ""}initiateReactionsForVariable('$name', oldValue, newValue);
    }
  }""";
  }
}
