import 'package:nexus_codegen/src/templates/action.dart';
import 'package:nexus_codegen/src/templates/reactive.dart';

class StateTemplate {
  final String name;
  final List<ReactiveTemplate>? reactiveTemplates;
  final List<ActionTemplate>? actionTemplates;

  StateTemplate({
    required this.name,
    this.reactiveTemplates,
    this.actionTemplates
  });

  @override
  String toString() {
    return """
mixin _\$${name}Mixin on $name, NexusController {
  ${reactiveTemplates?.join("\n").toString()}\n
  ${actionTemplates?.join("\n").toString()}
}""";
  }
}
