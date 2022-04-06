import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nexus/src/events.dart';
import 'package:nexus/src/stream_singleton.dart';

import '../async_action.dart';
import '../widgets/builder.dart';

/// The [NexusReaction] function is needed to handle reactions to changes in
/// reactive variables. [NexusController] will call this function and pass the
/// old value of the reactive variable into it as the first argument, and pass
/// the new value as the second argument
typedef NexusReaction = void Function(dynamic, dynamic);

/// Generates random string for stateId
String _getRandomString(int length) {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(
        _rnd.nextInt(_chars.length),
      ),
    ),
  );
}

/// Base class for any Nexus state controller, each controller must
/// inherit from it. [NexusController] contains methods for updating
/// UI, works with synchronous and asynchronous actions, reactions and controls
/// all widgets that depend on it [NexusBuilder].
///
/// The controller also contains a stream for tracking its life cycle - [NexusController.logStream]
///
/// The following events reflect the life cycle of the controller
///
/// [EventType.stateInitialized] - the controller has been initialized and ready to work
///
/// [EventType.stateUpdated] - the [NexusController.update] method was called and all [NexusBuilder]
/// dependent on the given controller have been rebuilt
///
/// [EventType.stateDisposed] - the controller has been disposed, further work with it is impossible
///
/// [EventType.reactionRegistered] - a new reaction has been registered
///
/// [EventType.reactionInitiated] - a change in the reactive variable was recorded
/// which has a registered reaction. All reactions are started and in progress / completed
///
/// [EventType.reactionRemoved] - the reaction has been removed
///
/// [EventType.performedAction] - synchronous action performed
///
/// [EventType.performedAsyncAction] - asynchronous action performed
///
/// Each event contains [NexusController.stateId] - a unique identifier
/// controller.
///
/// Also, for convenience, the controller has some lifecycle hooks such as
/// [NexusController.init] - executed when the controller is initialized, when overriding it is mandatory
/// need to call super.init ()
///
/// [NexusController.onUpdate] - executed when initiating a reaction, takes two arguments:
/// old variable value and new value
///
/// [NexusController.dispose] - executed when the controller is disposing, when overriding it is mandatory
/// need to call super.dispose ()
///
abstract class NexusController {
  /// Unique identifier of controller
  late String? stateId;

  /// Default constructor for [NexusController]
  ///
  /// Sets the random stateId if it is not passed by constructor's argument
  ///
  /// Calls the [NexusController.init] hook after setting stateId
  NexusController({this.stateId}) {
    stateId ??= _getRandomString(32);

    init();
  }

  /// Log stream
  late final _logStream = _logStreamController.stream.asBroadcastStream();

  /// Stream controller for logStream (stream for tracking life cycle of [NexusController]]
  final _logStreamController = StreamController<NexusStateEvent>();

  /// Map, which contains all registered reactions
  ///
  /// Key of map is a name of variable
  /// Value is a map which contains reactionId as key and reaction function as value
  final _reactions = Map<String, Map<String, NexusReaction>>();

  /// List of all [NexusBuilder]s which are depends on current controller
  ///
  /// [NexusController] will update all builders from that list if [NexusController.update]
  /// was called
  final _builderStateList = <State>[];

  /// Flag for controller, which means, that some reactive data was update, but
  /// UI wasn't rebuilt
  var _dirty = false;

  /// Flag for controller, which means, that controller is performing some action
  /// at the moment, and UI should be updated after action is finished
  var _performingAction = false;

  /// Getter for 'logStream'
  get logStream => _logStream;

  /// Getter for 'dirty'
  get dirty => _dirty;

  /// Getter for actual [BuildContext]. Returns context of last registered [NexusBuilder]
  get context =>
      _builderStateList.isNotEmpty ? _builderStateList.last.context : null;

  /// Getter for builders, needs for testing
  @visibleForTesting
  List<State> get builders => _builderStateList;

  /// Log stream controller getter, needs for testing
  @visibleForTesting
  StreamController get logStreamController => _logStreamController;

  /// Adds builder to controller's builder list. Any builder which added to controller
  /// will be rebuild if [NexusController.update] method invoked
  void registerBuilder(State builderState) {
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

    NexusGlobalEventBus().emit(
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
    }

    NexusGlobalEventBus().emit(
      EventType.reactionRemoved,
      ReactionRemovedPayload(
        stateId,
        reactionId: reactionId,
        variableName: variableName,
      ),
    );
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

    if (!_reactions.containsKey(variableName) || oldValue == newValue) {
      return;
    }

    _reactions[variableName]?.forEach((key, value) {
      try {
        NexusGlobalEventBus().emit(
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
    List<State> _unmountedBuildersList = [];

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

    NexusGlobalEventBus().emit(
      EventType.stateUpdated,
      StateUpdatedPayload(
        stateId,
        context: context,
      ),
    );
  }

  /// Performs synchronous action
  ///
  /// Runs arbitrary code in current zone and returns its result
  E performAction<E>(Function fn) {
    _performingAction = true;

    final _actionResult = fn.call();

    if (dirty) update();

    _performingAction = false;

    NexusGlobalEventBus().emit(
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
  Future<E> performAsyncAction<E>(Future Function() fn) async {
    _performingAction = true;

    final _nexusAsyncAction = NexusAsyncAction(this);

    final _actionResult = await _nexusAsyncAction.run(fn);

    _performingAction = false;

    NexusGlobalEventBus().emit(
      EventType.performedAsyncAction,
      PerformedAsyncActionPayload(
        stateId,
        result: _actionResult,
      ),
    );

    return _actionResult;
  }

  /// Marks that the controller needs update or updates state directly if
  /// reactive variable updating directly from UI
  ///
  /// Method, which annotated by @action is finished its work,
  /// [NexusController.update] will be invoked
  ///
  /// It allows to modify several reactive variables, but update state once
  void markNeedsUpdate() {
    if(_performingAction) {
      _dirty = true;
    } else {
      update();
    }
  }

  /// Calling when NexusController initializing
  @mustCallSuper
  void init() {
    NexusGlobalEventBus().stream.listen((event) {
      if(event.payload.stateId == stateId && !_logStreamController.isClosed)
        _logStreamController.add(event);
    });

    NexusGlobalEventBus().emit(
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

    NexusGlobalEventBus().emit(
      EventType.stateDisposed,
      StateDisposedPayload(stateId, context: context),
    );

    _logStreamController.close();
  }
}
