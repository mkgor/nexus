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
    // ignore_for_file: constant_identifier_names, unnecessary_this,public_member_api_docs, non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

class ${name}Properties {
  ${reactiveTemplates?.map((e) => "static const ${e.name.startsWith("_") ? "\$${e.name}" : e.name} = '${e.name}';").join("\n")}
}

mixin _\$${name}Mixin on $name, $superclass {
  ${reactiveTemplates != null ? reactiveTemplates?.join("\n").toString() : ""}\n
  ${actionTemplates != null ? actionTemplates?.join("\n").toString() : ""}
}
""";
  }
}
