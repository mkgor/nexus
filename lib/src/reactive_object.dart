import 'package:nexus/nexus.dart';

/// Abstract class for custom reactive objects.
///
/// You should pass controller to update UI, when modifying custom reactive object's
/// reactive property
abstract class ReactiveObject {
  NexusController? controller;

  ReactiveObject({this.controller});
}