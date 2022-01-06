import 'package:flutter/material.dart';
import 'controller/controller.dart';
import 'widgets/builder.dart';

/// The following events reflect the life cycle of the controller
enum EventType {
  /// Controller has been initialized and ready to work
  stateInitialized,

  ///[NexusController.update] method was called and all [NexusBuilder]
  /// dependent on the given controller have been rebuilt
  stateUpdated,

  /// Controller has been disposed, further work with it is impossible
  stateDisposed,

  /// New reaction has been registered
  reactionRegistered,

  /// Some changes in the reactive variable was recorded which has a registered
  /// reaction. All reactions are started and in progress / completed
  reactionInitiated,

  /// Reaction has been removed
  reactionRemoved,

  /// Synchronous action performed
  performedAction,

  /// Asynchronous action performed
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
