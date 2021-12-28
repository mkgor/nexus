import 'package:nexus/nexus.dart';

abstract class ReactiveObject {
  NexusController? controller;

  ReactiveObject({this.controller});
}