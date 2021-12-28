import 'package:flutter/material.dart';
import 'package:nexus/src/state_event.dart';
import 'package:nexus/src/stream_singleton.dart';

import '../async_action.dart';
import '../widgets/builder.dart';

typedef NexusReaction = void Function(dynamic, dynamic);

abstract class NexusController {
  NexusController() {
    init();
  }

  List<State<NexusBuilder>> _builderStateList = [];

  Map<String, Map<String, NexusReaction>> _reactions = {};

  bool _dirty = false;

  bool get dirty => _dirty;

  BuildContext get context => _builderStateList.last.context;

  set builderStateList(State<NexusBuilder> builderState) {
    _builderStateList.add(builderState);
  }

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
  }

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
  }

  void initiateReactionsForVariable(
    String? variableName,
    dynamic oldValue,
    dynamic newValue,
  ) {
    if (variableName == null || !_reactions.containsKey(variableName)) {
      return;
    }

    _reactions[variableName]?.forEach((key, value) {
      try {
        value.call(oldValue, newValue);
      } on StackOverflowError {
        throw Exception("Caught StackOverflowError when acting reaction, it may be "
            "caused by modifying reactive variables in reaction (reactionId: $key)");
      }
    });
  }

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

    onUpdate.call();
  }

  void performAction(Function fn) {
    final _actionResult = fn.call();

    if (dirty) update();

    return _actionResult;
  }

  void performAsyncAction(Future Function() fn) async {
    final _nexusAsyncAction = NexusAsyncAction(this);

    final _actionResult = await _nexusAsyncAction.run(fn);

    return _actionResult;
  }

  void markNeedsUpdate() => _dirty = true;

  void init() => {};

  void onUpdate() => {};

  @mustCallSuper
  void dispose() {
    _builderStateList.clear();
  }
}
