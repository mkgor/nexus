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
}

class NexusStateEvent {
  final EventType type;
  final EventPayload payload;

  NexusStateEvent({
    required this.type,
    required this.payload,
  });
}

abstract class EventPayload {
  final String? stateId;

  DateTime? eventTime;

  EventPayload({required this.stateId, this.eventTime}) {
    eventTime ??= DateTime.now();
  }
}

class StateInitializedPayload extends EventPayload {
  final BuildContext? context;

  StateInitializedPayload(
    String? stateId, {
    this.context,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class StateUpdatedPayload<T> extends EventPayload {
  final BuildContext? context;

  StateUpdatedPayload(
    String? stateId, {
    this.context,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class StateDisposedPayload extends EventPayload {
  final BuildContext? context;

  StateDisposedPayload(
    String? stateId, {
    this.context,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class ReactionRegisteredPayload extends EventPayload {
  final String reactionId;
  final String variableName;

  ReactionRegisteredPayload(
    String? stateId, {
    required this.reactionId,
    required this.variableName,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class ReactionInitiatedPayload<T> extends EventPayload {
  final String reactionId;
  final String variableName;
  final T oldValue;
  final T newValue;

  ReactionInitiatedPayload(
    String? stateId, {
    required this.oldValue,
    required this.newValue,
    required this.reactionId,
    required this.variableName,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class ReactionRemovedPayload extends EventPayload {
  final String reactionId;
  final String variableName;

  ReactionRemovedPayload(
    String? stateId, {
    required this.reactionId,
    required this.variableName,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class PerformedActionPayload<T> extends EventPayload {
  final T result;

  PerformedActionPayload(
    String? stateId, {
    required this.result,
    DateTime? eventTime,
  }) : super(stateId: stateId, eventTime: eventTime);
}

class PerformedAsyncActionPayload<T> extends PerformedActionPayload<T> {
  PerformedAsyncActionPayload(
    String? stateId, {
    required T result,
    DateTime? eventTime,
  }) : super(stateId, result: result, eventTime: eventTime);
}
