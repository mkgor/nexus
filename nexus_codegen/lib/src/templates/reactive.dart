import 'package:analyzer/dart/constant/value.dart';

class ReactiveTemplate {
  final String type;
  final String name;
  final bool disableReactions;
  final bool generateForReactiveObject;
  final List<DartObject> mutators;
  final List<DartObject> guards;
  final bool mutatorsFirst;

  ReactiveTemplate(
      {required this.type,
      required this.name,
      required this.disableReactions,
      required this.generateForReactiveObject,
      this.mutators = const [],
      this.guards = const [],
      this.mutatorsFirst = true});

  @override
  String toString() {
    return """
@override
set $name($type newValue) {
  if($name != newValue) {
     var oldValue = $name;
     super.$name = newValue;

     ${generateForReactiveObject ? "controller?." : ""}markNeedsUpdate();
     
     ${!disableReactions ? "${generateForReactiveObject ? "controller?." : ""}initiateReactionsForVariable('$name', oldValue, newValue);" : ""}
   }
}

${mutators!.isNotEmpty || guards!.isNotEmpty ? _buildGetter() : ""}
""";
  }

  String _buildGetter() {
    return """
@override
get $name {
var result = super.$name;

${mutatorsFirst ? buildMutators() + "\n" + buildGuards() : buildGuards() + "\n" + buildMutators()}
return result;
}      
    """;
  }

  String buildMutators() {
    return """
    /// Mutators
${mutators != null && mutators!.isNotEmpty ? mutators?.map((e) {
            return "result = ${e.type.toString()}().mutate(result);";
          }).join("\n") : ""}
    """;
  }

  String buildGuards([String handleValue = "result"]) {
    return """
    /// Guards
${guards != null && guards!.isNotEmpty ? guards?.map((e) {
            return "${e.type.toString()}().handle($handleValue);";
          }).join("\n") : ""}
          """;
  }
}
