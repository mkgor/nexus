import 'dart:async';
import 'controller/controller.dart';

import 'package:nexus/src/events.dart';

/// Nexus global event bus used to track all controller's life cycles,
///
/// If you want to track specified controller, use [NexusController.logStream]
class NexusGlobalEventBus {
  static final NexusGlobalEventBus _singleton =
      NexusGlobalEventBus._internal();

  factory NexusGlobalEventBus() {
    return _singleton;
  }

  NexusGlobalEventBus._internal();

  final StreamController<NexusStateEvent> streamController =
      StreamController<NexusStateEvent>();

  late Stream<NexusStateEvent> _stream = streamController.stream.asBroadcastStream();

  Stream<NexusStateEvent> get stream => _stream;

  void emit(EventType type, dynamic payload) => streamController.add(NexusStateEvent(type: type, payload: payload));
  void close() => streamController.close();
}
