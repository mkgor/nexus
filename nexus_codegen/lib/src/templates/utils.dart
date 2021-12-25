import 'package:analyzer/dart/element/element.dart';
import 'package:nexus_codegen/src/templates/params.dart';

import '../utils.dart';

String surroundNonEmpty(String prefix, String suffix, dynamic content) {
  final contentStr = content.toString();
  return contentStr.isEmpty ? '' : '$prefix$contentStr$suffix';
}

TypeParamTemplate typeParamTemplate(
  TypeParameterElement param,
  LibraryScopedNameFinder typeNameFinder,
) =>
    TypeParamTemplate(
      name: param.name,
      bound: param.bound != null
          ? typeNameFinder.findTypeParameterBoundsTypeName(param)
          : null,
    );
