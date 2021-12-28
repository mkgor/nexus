import 'package:nexus_codegen/src/templates/reactive.dart';

class ReactiveObjectTemplate extends ReactiveTemplate {
  ReactiveObjectTemplate({
    required String type,
    required String name,
    required bool disableReactions,
  }) : super(
          type: type,
          name: name,
          disableReactions: disableReactions,
          generateForReactiveObject: false,
        );

  @override
  String toString() {
    return """
    @override
    get $name => super.$name..controller = this;
    
    @override
  set $name($type newValue) {
  if($name != newValue) {
     var oldValue = $name;
     super.$name = newValue..controller = this;

     markNeedsUpdate();
     
     ${!disableReactions ? "initiateReactionsForVariable('$name', oldValue, newValue);" : ""}
   }
}""";
  }
}
