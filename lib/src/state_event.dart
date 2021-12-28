import 'package:flutter/material.dart';

enum EventType {
  stateInitialized,
  stateUpdated,
  stateDisposed,
  reactionRegistered,
  reactionInitiated,
  reactionRemoved,
  performedAction,
  performedAsyncAction,
  builderMounted,
  builderUnmounted
}

class NexusStateEvent {
  final EventType type;
  final dynamic payload;

  NexusStateEvent({required this.type, this.payload});
}

class StateInitializedPayload {
  final int stateHash;
  final BuildContext context;
  final DateTime initializedAt;

  StateInitializedPayload({
    required this.stateHash,
    required this.context,
    required this.initializedAt,
  });
}

class StateUpdatedPayload {
  final int stateHash;
  final BuildContext context;
  final DateTime updatedAt;

  StateUpdatedPayload({
    required this.stateHash,
    required this.context,
    required this.updatedAt,
  });
}

