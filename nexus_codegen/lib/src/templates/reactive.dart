class ReactiveTemplate {
  final String type;
  final String name;
  final bool disableReactions;
  final bool generateForReactiveObject;

  ReactiveTemplate({
    required this.type,
    required this.name,
    required this.disableReactions,
    required this.generateForReactiveObject
  });

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
""";
  }
}
