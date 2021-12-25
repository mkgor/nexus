import 'package:nexus_codegen/src/templates/utils.dart';

class CommaList<T> {
  CommaList(this.templates);

  final List<T> templates;

  @override
  String toString() =>
      templates.map((t) => t.toString()).where((s) => s.isNotEmpty).join(', ');
}

class SurroundedCommaList<T> {
  SurroundedCommaList(this.prefix, this.suffix, this.templates);

  final String prefix;
  final String suffix;
  final List<T> templates;

  @override
  String toString() => surroundNonEmpty(prefix, suffix, CommaList(templates));
}