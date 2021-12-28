import 'dart:async';

import 'package:nexus/src/state_event.dart';

class NexusStreamSingleton {
  static final NexusStreamSingleton _singleton =
      NexusStreamSingleton._internal();

  factory NexusStreamSingleton() {
    return _singleton;
  }

  NexusStreamSingleton._internal();

  final StreamController<NexusStateEvent> streamController =
      StreamController<NexusStateEvent>();

  Stream<NexusStateEvent> get stream => streamController.stream;

  void emit(EventType type, dynamic payload) => streamController.add(NexusStateEvent(type: type, payload: payload));
  void close() => streamController.close();
}
