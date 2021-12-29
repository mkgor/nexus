import 'dart:async';

import 'package:nexus/src/events.dart';

class NexusStreamSingleton {
  static final NexusStreamSingleton _singleton =
      NexusStreamSingleton._internal();

  factory NexusStreamSingleton() {
    return _singleton;
  }

  NexusStreamSingleton._internal();

  final StreamController<NexusStateEvent> streamController =
      StreamController<NexusStateEvent>();

  late Stream<NexusStateEvent> _stream = streamController.stream.asBroadcastStream();

  Stream<NexusStateEvent> get stream => _stream;

  void emit(EventType type, dynamic payload) => streamController.add(NexusStateEvent(type: type, payload: payload));
  void close() => streamController.close();
}
