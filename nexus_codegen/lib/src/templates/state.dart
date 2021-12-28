import 'package:nexus_codegen/src/templates/action.dart';
import 'package:nexus_codegen/src/templates/reactive.dart';

class StateTemplate {
  final String name;
  final String superclass;
  final List<ReactiveTemplate>? reactiveTemplates;
  final List<ActionTemplate>? actionTemplates;

  StateTemplate({
    required this.name,
    required this.superclass,
    this.reactiveTemplates,
    this.actionTemplates
  });

  @override
  String toString() {
    return """
mixin _\$${name}Mixin on $name, $superclass {
  ${reactiveTemplates != null ? reactiveTemplates?.join("\n").toString() : ""}\n
  ${actionTemplates != null ? actionTemplates?.join("\n").toString() : ""}
}
""";
  }
}
