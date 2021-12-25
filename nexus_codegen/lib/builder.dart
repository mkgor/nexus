import 'package:build/build.dart';
import 'package:nexus_codegen/src/nexus_codegen.dart';
import 'package:source_gen/source_gen.dart';

Builder nexusCodeGenerator(BuilderOptions options) => SharedPartBuilder([NexusGenerator()], 'nexus_codegenerator');