import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/nexus.dart';

void main() {
  test("Controller stateId test", () {
    var state = DemoState();

    expect(state.stateId is String, true);
    expect(state.stateId!.length > 8, true);

    var stateWithCustomId = DemoState(stateId: "testId");

    expect(stateWithCustomId.stateId is String, true);
    expect(stateWithCustomId.stateId, "testId");
  });

  test("Controller markNeedsUpdate test", () {
    var state = DemoState();

    state.markNeedsUpdate();

    expect(state.dirty, false);

    state.performAction(() {
      state.markNeedsUpdate();

      expect(state.dirty, true);
    });

    expect(state.dirty, false);
  });

  test("Controller dispose test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateDisposed,
    ];

    var iterator = 0;
    var state = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: state);

    state.registerBuilder(builder.createState());

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    expect(state.builders.length, 1);

    state.dispose();

    expect(state.builders.length, 0);

    expect(state.logStreamController.isClosed, true);
  });

  test("Controller reactions test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.reactionRegistered,
      EventType.reactionInitiated,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.reactionRegistered,
      EventType.reactionRemoved,
      EventType.reactionInitiated,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.reactionRemoved,
    ];

    var iterator = 0;
    var state = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: state);

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    state.addReaction(
        variableName: '_counter',
        reactionId: 'test-reaction',
        reaction: (oldVal, newVal) {
          expect(oldVal, 0);
          expect(newVal, 1);
        });

    state.performAction(() => state.counter += 1);

    state.addReaction(
        variableName: '_counter',
        reactionId: 'test-reaction2',
        reaction: (oldVal, newVal) {
          expect(oldVal, 1);
          expect(newVal, 2);
        });

    state.removeReaction(variableName: '_counter', reactionId: 'test-reaction');

    state.performAction(() => state.counter += 1);

    state.removeReaction(variableName: '_counter', reactionId: 'test-reaction2');
  });

  test("Controller actions test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.performedAction,
      EventType.stateUpdated,
    ];

    var iterator = 0;
    var state = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: state);

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    state.increment();

    expect(state.counter, 1);
  });

  test("Controller async actions test", () async {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.performedAsyncAction,
      EventType.stateUpdated,
    ];

    var iterator = 0;
    var state = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: state);

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    state.asyncIncrement(Duration(milliseconds: 100));

    expect(state.counter, 0);

    await Future.delayed(Duration(milliseconds: 150), () {
      expect(state.counter, 1);
    });
  });
}

class DemoState extends NexusController {
  var _counter = 0;

  get counter => _counter;

  set counter(newValue) {
    if (_counter != newValue) {
      var oldValue = _counter;
      _counter = newValue;

      markNeedsUpdate();

      initiateReactionsForVariable('_counter', oldValue, newValue);
    }
  }

  void increment() {
    performAction(() => _counter += 1);
  }

  Future asyncIncrement(Duration delay) async {
    return performAsyncAction(() async {
      Future.delayed(delay, () => _counter += 1);
    });
  }

  DemoState({String? stateId}) : super(stateId: stateId);
}

