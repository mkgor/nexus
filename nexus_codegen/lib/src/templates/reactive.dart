class ReactiveTemplate {
  final String type;
  final String name;
  final bool disableReactions;

  ReactiveTemplate({
    required this.type,
    required this.name,
    required this.disableReactions
  });

  @override
  String toString() {
    return """
@override
set $name($type newValue) {
  if($name != newValue) {
     var oldValue = $name;
     super.$name = newValue;

     markNeedsUpdate();
     
     ${!disableReactions ? "initiateReactionsForVariable('$name', oldValue, newValue);" : ""}
   }
}""";
  }
}
