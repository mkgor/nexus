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

    expect(state.dirty, true);

    state.update();

    expect(state.dirty, false);
  });

  test("Controller reactions test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.reactionRegistered,
      EventType.stateUpdated,
      EventType.reactionInitiated,
      EventType.reactionRemoved,
    ];

    var iterator = 0;
    var state = DemoState();

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

    state.counter += 1;

    state.removeReaction(variableName: '_counter', reactionId: 'test-reaction');
  });

  test("Controller actions test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.performedAction,
      EventType.stateUpdated,
    ];

    var iterator = 0;
    var state = DemoState();

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
