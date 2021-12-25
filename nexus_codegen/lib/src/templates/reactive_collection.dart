import 'package:nexus_codegen/src/templates/reactive.dart';

class ReactiveCollectionTemplate extends ReactiveTemplate {
  final String? genericType;

  ReactiveCollectionTemplate({
    required String type,
    required String name,
    required bool disableReactions,
    this.genericType,
  }) : super(type: type, name: name, disableReactions: disableReactions);

  @override
  String toString() {
    return """
  bool _\$${name}Gate = false;

  $type _getWrapped$name() {
    _\$${name}Gate = true;

    final result = this.$name.wrap${genericType ?? "<dynamic>"}(controller: this, variableName: '$name', disableReactions: $disableReactions);

    _\$${name}Gate = false;

    return result;
  }

  late $type _\$$name = _getWrapped$name();
  
  @override
  get $name => !_\$${name}Gate ? _\$$name : super.$name;

  @override
  set $name($type newValue) {
    if ($name != newValue) {
      var oldValue = $name;
      super.$name = newValue;
      _\$$name = _getWrapped$name();

      markNeedsUpdate();

      initiateReactionsForVariable('$name', oldValue, newValue);
    }
  }""";
  }
}
