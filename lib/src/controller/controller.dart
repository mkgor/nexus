import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nexus/src/events.dart';
import 'package:nexus/src/stream_singleton.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../async_action.dart';
import '../widgets/builder.dart';

typedef NexusReaction = void Function(dynamic, dynamic);

abstract class NexusController {
  late String? stateId;

  NexusController({this.stateId}) {
    stateId ??=
        md5.convert(utf8.encode(Random().nextInt(10000).toString())).toString();

    init();
  }

  final StreamController<NexusStateEvent> _logStreamController = StreamController();

  Map<String, Map<String, NexusReaction>> _reactions = {};

  List<State<NexusBuilder>> _builderStateList = [];

  bool _dirty = false;

  bool get dirty => _dirty;

  late Stream<NexusStateEvent> _logStream = _logStreamController.stream.asBroadcastStream();

  Stream<NexusStateEvent> get logStream => _logStream;

  BuildContext? get context =>
      _builderStateList.isNotEmpty ? _builderStateList.last.context : null;

  set builderStateList(State<NexusBuilder> builderState) {
    _builderStateList.add(builderState);
  }

  /// Adding reaction for [variableName] with id [reactionId]
  ///
  void addReaction({
    required String variableName,
    required String reactionId,
    required NexusReaction reaction,
  }) {
    if (_reactions.containsKey(variableName)) {
      _reactions[variableName]?[reactionId] = reaction;
    } else {
      _reactions[variableName] = {reactionId: reaction};
    }

    NexusStreamSingleton().emit(
      EventType.reactionRegistered,
      ReactionRegisteredPayload(
        stateId,
        reactionId: reactionId,
        variableName: variableName,
      ),
    );
  }

  /// Removing reaction for [variableName] by [reactionId]
  ///
  void removeReaction({
    required String variableName,
    required String reactionId,
  }) {
    if (!_reactions.containsKey(variableName)) {
      return;
    }

    if (!_reactions[variableName]!.containsKey(reactionId)) {
      return;
    }

    _reactions[variableName]?.remove(reactionId);

    if (_reactions[variableName]!.isEmpty) {
      _reactions.remove(variableName);

      NexusStreamSingleton().emit(
        EventType.reactionRemoved,
        ReactionRemovedPayload(
          stateId,
          reactionId: reactionId,
          variableName: variableName,
        ),
      );
    }
  }

  /// Initiate reactions for variable with name [variableName]
  /// Reactions are list of [NexusReaction]
  ///
  /// All [NexusReaction] calling with old value and new value
  ///
  /// It is not allowed to modify reactive variable in reaction, it will call
  /// [StackOverflowError]
  void initiateReactionsForVariable(
    String? variableName,
    dynamic oldValue,
    dynamic newValue,
  ) {
    if (variableName == null) return;

    onUpdate(oldValue, newValue);

    NexusStreamSingleton().emit(
      EventType.stateUpdated,
      StateUpdatedPayload(
        stateId,
        variableName: variableName,
        context: context,
        oldValue: oldValue,
        newValue: newValue,
      ),
    );

    if (!_reactions.containsKey(variableName) || oldValue == newValue) {
      return;
    }

    _reactions[variableName]?.forEach((key, value) {
      try {
        NexusStreamSingleton().emit(
          EventType.reactionInitiated,
          ReactionInitiatedPayload(
            stateId,
            reactionId: key,
            variableName: variableName,
            oldValue: oldValue,
            newValue: newValue,
          ),
        );

        value.call(oldValue, newValue);
      } on StackOverflowError {
        throw Exception(
            "Caught StackOverflowError when acting reaction, it may be "
            "caused by modifying reactive variables in reaction (reactionId: $key)");
      }
    });
  }

  /// Marks all builder's elements in registered builders list as needs rebuild
  ///
  /// You can call it manually, but it is highly recommended to use nexus_codegen
  /// when constructing reactive state.
  ///
  /// Calling builder widget's rebuild
  void update() {
    List<State<NexusBuilder>> _unmountedBuildersList = [];

    _builderStateList.forEach((state) {
      Element _element = state.context as Element;

      if (state.mounted) {
        _element.markNeedsBuild();
      } else {
        _unmountedBuildersList.add(state);
      }
    });

    _unmountedBuildersList.forEach((element) {
      _builderStateList.remove(element);
    });

    _unmountedBuildersList.clear();

    _dirty = false;
  }

  /// Performs synchronous action
  ///
  /// Runs arbitrary code in current zone and returns its result
  void performAction(Function fn) {
    final _actionResult = fn.call();

    if (dirty) update();

    NexusStreamSingleton().emit(
      EventType.performedAction,
      PerformedActionPayload(
        stateId,
        result: _actionResult,
      ),
    );

    return _actionResult;
  }

  /// Performs asynchronous action
  ///
  /// Runs arbitrary code in zone and returns its result
  void performAsyncAction(Future Function() fn) async {
    final _nexusAsyncAction = NexusAsyncAction(this);

    final _actionResult = await _nexusAsyncAction.run(fn);

    NexusStreamSingleton().emit(
      EventType.performedAsyncAction,
      PerformedAsyncActionPayload(
        stateId,
        result: _actionResult,
      ),
    );

    return _actionResult;
  }

  /// Marks that the controller needs update
  ///
  /// It means when method, which annotated by @action is finished its work,
  /// [NexusController.update] will be invoked
  ///
  /// It allows to modify several reactive variables, but update state once
  void markNeedsUpdate() => _dirty = true;

  /// Calling when NexusController initializing
  @mustCallSuper
  void init() {
    NexusStreamSingleton().stream.listen((event) {
      if(event.payload.stateId == stateId && !_logStreamController.isClosed)
        _logStreamController.add(event);
    });

    NexusStreamSingleton().emit(
      EventType.stateInitialized,
      StateInitializedPayload(
        stateId,
        context: context,
      ),
    );
  }

  /// Calling when updating reactive variable
  ///
  /// Will not be invoked, if reactions are disabled
  @mustCallSuper
  void onUpdate(dynamic oldValue, dynamic newValue) => {};

  /// Called when state is disposing
  ///
  /// Don't forget to call super.dispose() when overriding it
  @mustCallSuper
  void dispose() {
    _builderStateList.clear();

    NexusStreamSingleton().emit(
      EventType.stateDisposed,
      StateDisposedPayload(stateId, context: context),
    );

    _logStreamController.close();
  }
}
