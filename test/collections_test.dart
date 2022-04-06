import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/nexus.dart';
import 'package:nexus/src/events.dart';

import '_collections_test_state.dart';

void main() {
  test("Reactive List test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
    ];

    var iterator = 0;
    var state = DemoState();

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    /// Testing list extension
    var list = <int>[].toReactive(controller: state);

    state.performAction(() => list.add(1));

    expect(list.length, 1);
    expect(list.first, 1);

    state.performAction(() => state.list.add(1));

    expect(state.list.length, 1);
    expect(state.list.first, 1);

    state.performAction(() => state.list.removeAt(0));

    expect(state.list.length, 0);

    state.performAction(() => state.list.insertAll(0, [1, 2, 3, 4, 5]));

    expect(state.list.length, 5);
    expect(state.list[3], 4);

    state.performAction(() => state.list = state.list + [1, 2, 3]);

    expect(state.list.length, 8);

    state.performAction(() => state.list[0] = 111);

    expect(state.list.first, 111);

    state.performAction(() => state.list.addAll([1, 3, 5]));

    expect(state.list.length, 11);

    state.performAction(() => state.list.clear());

    expect(state.list.length, 0);

    state.performAction(() {
      state.list.addAll([1, 2, 3, 4]);
      state.list.fillRange(0, 4, 42);
    });

    expect(state.list.first, 42);
    expect(state.list.last, 42);

    state.performAction(() {
      state.nonNullableList.addAll([1, 2, 3, 4, 5]);
    });

    expect(() {
      state.nonNullableList.fillRange(0, 4, null);
    }, throwsException);

    state.performAction(() {
      state.list.insert(0, 1);
    });

    expect(state.list.first, 1);

    state.performAction(() {
      state.list.remove(1);
    });

    expect(state.list.first, 42);

    state.performAction(() {
      state.list.clear();
      state.list.addAll([1, 2, 3, 4, 5]);
      state.list.removeLast();
    });

    expect(state.list.length, 4);
    expect(state.list.last, 4);

    state.performAction(() {
      state.list.removeRange(0, 2);
    });

    expect(state.list.length, 2);
    expect(state.list.first, 3);

    state.performAction(() {
      state.list.clear();
      state.list.addAll(List.generate(10, (index) => index));

      state.list.removeWhere((element) => element! % 2 == 0);
    });

    expect(state.list, [1, 3, 5, 7, 9]);

    state.performAction(() {
      state.list.replaceRange(1, 4, [1, 2, 3]);
    });

    expect(state.list, [1, 1, 2, 3, 9]);

    state.performAction(() {
      state.list.clear();
      state.list.addAll(List.generate(10, (index) => index));

      state.list.retainWhere((element) => element! % 2 == 0);
    });

    expect(state.list, [0, 2, 4, 6, 8]);

    state.performAction(() {
      state.list.setAll(2, [1, 2, 3]);
    });

    expect(state.list, [0, 2, 1, 2, 3]);

    state.performAction(() {
      state.list.setRange(0, 3, [2, 3, 4]);
    });

    expect(state.list, [2, 3, 4, 2, 3]);

    var _oldList = List.from(state.list);

    state.performAction(() {
      state.list.shuffle();
    });

    expect(_oldList != state.list, true);

    state.performAction(() {
      state.list.sort();
    });

    expect(state.list, [2, 2, 3, 3, 4]);

    expect(state.list.toList(), [2, 2, 3, 3, 4]);

    expect(state.list.toSet(), [2, 3, 4]);

    var _set = state.list.toReactiveSet();

    expect(_set, [2, 3, 4]);
    expect(_set.runtimeType.toString(), "ReactiveSet<int?>");

    expect(state.list.hashCode.runtimeType, int);

    state.performAction(() {
      state.list.length = 10;
    });

    expect(state.list.length, 10);

    state.performAction(() {
      state.nonNullableList.length = 0;
    });

    expect(
      () => state.performAction(
        () {
          state.nonNullableList.length = 1;
        },
      ),
      throwsException,
    );
  });

  test("Reactive Set test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
    ];

    var iterator = 0;
    var setState = DemoState();

    setState.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    var set = Set<int>().toReactive(controller: setState);

    setState.performAction(() => set.add(1));

    expect(set.length, 1);
    expect(set.elementAt(0), 1);

    setState.performAction(() => setState.set.add(1));
    setState.performAction(() => setState.set.add(1));

    expect(setState.set.length, 1);
    expect(setState.set.elementAt(0), 1);

    setState.performAction(() => setState.set.remove(1));

    expect(setState.set.length, 0);

    setState.performAction(() => setState.set.addAll([1,2,3,4,5]));

    expect(setState.set.length, 5);
    expect(setState.set.elementAt(3), 4);

    expect(setState.set.lookup(2), 2);
    expect(setState.set.contains(2), true);

    expect(setState.set.toSet(), [1,2,3,4,5]);

    setState.performAction(() {
      setState.set.clear();
    });

    expect(setState.set, []);
  });

  test("Reactive Map test", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
    ];

    var iterator = 0;
    var state = DemoState();

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    var map = <int, String>{}.toReactive(controller: state);

    state.performAction(() => map[1] = "Test");

    expect(map[1], "Test");

    state.performAction(() => state.map[1] = "Test");

    expect(state.map.length, 1);
    expect(state.map[1], "Test");

    state.performAction(() => state.map.remove(1));

    expect(state.map.length, 0);

    state.performAction(() => state.map.addAll({1: "Test", 2: "Test 2"}));

    expect(state.map.length, 2);
    expect(state.map[2], "Test 2");

    state.performAction(() => state.map.clear());

    expect(state.map.length, 0);

    state.performAction(() => state.map.addAll({1: "Test", 2: "Test 2"}));

    expect(state.map.keys, [1,2]);

    expect(state.map.cast<int, String>(), {1: "Test", 2: "Test 2"});

    expect(state.map.containsValue("Test"), true);
    expect(state.map.containsValue("Something else"), false);

    expect(state.map.isNotEmpty, true);

    state.performAction(() => state.map.clear());

    expect(state.map.isEmpty, true);
  });



  /// Same tests, but with mutators
  test("Reactive List test (with mutators)", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
    ];

    var iterator = 0;
    var state = DemoState();

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    state.performAction(() => state.listWithMutators.add(1));

    expect(state.listWithMutators.length, 1);
    expect(state.listWithMutators.first, 2);

    state.performAction(() => state.listWithMutators.removeAt(0));

    expect(state.listWithMutators.length, 0);

    state.performAction(() => state.listWithMutators.insertAll(0, [1, 2, 3, 4, 5]));

    expect(state.listWithMutators.length, 5);
    expect(state.listWithMutators[3], 5);

    state.performAction(() => state.listWithMutators = state.listWithMutators + [1, 2, 3]);

    expect(state.listWithMutators.length, 8);

    state.performAction(() => state.listWithMutators[0] = 111);

    expect(state.listWithMutators.first, 112);

    state.performAction(() => state.listWithMutators.addAll([1, 3, 5]));

    expect(state.listWithMutators.length, 11);

    state.performAction(() => state.listWithMutators.clear());

    expect(state.listWithMutators.length, 0);

    state.performAction(() {
      state.listWithMutators.addAll([1, 2, 3, 4]);
      state.listWithMutators.fillRange(0, 4, 42);
    });

    expect(state.listWithMutators.first, 43);
    expect(state.listWithMutators.last, 43);

    state.performAction(() {
      state.listWithMutators.insert(0, 1);
    });

    expect(state.listWithMutators.first, 2);

    state.performAction(() {
      state.listWithMutators.remove(2);
    });

    expect(state.listWithMutators.first, 43);

    state.performAction(() {
      state.listWithMutators.clear();
      state.listWithMutators.addAll([1, 2, 3, 4, 5]);
      state.listWithMutators.removeLast();
    });

    expect(state.listWithMutators.length, 4);
    expect(state.listWithMutators.last, 5);

    state.performAction(() {
      state.listWithMutators.removeRange(0, 2);
    });

    expect(state.listWithMutators.length, 2);
    expect(state.listWithMutators.first, 4);

    state.performAction(() {
      state.listWithMutators.clear();
      state.listWithMutators.addAll(List.generate(10, (index) => index));

      state.listWithMutators.removeWhere((element) => element! % 2 == 0);
    });

    // Remove where works only for data UNSAFE mutations
    // if data safe mutations = true, result will be [2,4,6,8,10]
    expect(state.listWithMutators, [1,3,5,7,9]);

    state.performAction(() {
      state.listWithMutators.replaceRange(1, 4, [1, 2, 3]);
    });

    expect(state.listWithMutators, [1, 2, 3, 4, 9]);

    state.performAction(() {
      state.listWithMutators.clear();
      state.listWithMutators.addAll(List.generate(10, (index) => index));

      state.listWithMutators.retainWhere((element) => element! % 2 == 0);
    });

    expect(state.listWithMutators, [2, 4, 6, 8, 10]);

    state.performAction(() {
      state.listWithMutators.setAll(2, [1, 2, 3]);
    });

    expect(state.listWithMutators, [2, 4, 2, 3, 4]);

    state.performAction(() {
      state.listWithMutators.setRange(0, 3, [2, 3, 4]);
    });

    expect(state.listWithMutators, [3, 4, 5, 3, 4]);

    var _oldList = List.from(state.listWithMutators);

    state.performAction(() {
      state.listWithMutators.shuffle();
    });

    expect(_oldList != state.listWithMutators, true);

    state.performAction(() {
      // Works only for data UNSAFE mutations
      state.listWithMutators.sort();
    });

    expect(state.listWithMutators, [3, 3, 4, 4, 5]);

    expect(state.listWithMutators.toList(), [3, 3, 4, 4, 5]);

    expect(state.listWithMutators.toSet(), [3, 4, 5]);

    var _set = state.listWithMutators.toReactiveSet();

    expect(_set, [3,4,5]);
    expect(_set.runtimeType.toString(), "ReactiveSet<int?>");

    expect(state.listWithMutators.hashCode.runtimeType, int);

    state.performAction(() {
      state.listWithMutators.length = 10;
    });

    expect(state.listWithMutators.length, 10);

    expect(
      () => state.performAction(
        () {
          state.nonNullableList.length = 1;
        },
      ),
      throwsException,
    );
  });

  test("Reactive Set test (with mutators)", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
    ];

    var iterator = 0;
    var setState = DemoState();

    setState.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    setState.performAction(() => setState.setWithMutators.add(1));
    setState.performAction(() => setState.setWithMutators.add(1));

    expect(setState.setWithMutators.length, 1);
    expect(setState.setWithMutators.elementAt(0), 2);

    setState.performAction(() => setState.setWithMutators.remove(2));

    expect(setState.setWithMutators.length, 0);

    setState.performAction(() => setState.setWithMutators.addAll([1,2,3,4,5]));

    expect(setState.setWithMutators.length, 5);
    expect(setState.setWithMutators.elementAt(3), 5);

    expect(setState.setWithMutators.lookup(2), 2);
    expect(setState.setWithMutators.contains(2), true);

    expect(setState.setWithMutators.toSet(), [2,3,4,5,6]);

    setState.performAction(() {
      setState.setWithMutators.clear();
    });

    expect(setState.setWithMutators, []);
  });

  test("Reactive Map test (with mutators)", () {
    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
      EventType.stateUpdated,
      EventType.performedAction,
    ];

    var iterator = 0;
    var state = DemoState();

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    state.performAction(() => state.mapWithMutators[1] = "Test");

    expect(state.mapWithMutators.length, 1);
    expect(state.mapWithMutators[1], "Test mutated");

    state.performAction(() => state.mapWithMutators.remove(1));

    expect(state.mapWithMutators.length, 0);

    state.performAction(() => state.mapWithMutators.addAll({1: "Test", 2: "Test 2"}));

    expect(state.mapWithMutators.length, 2);
    expect(state.mapWithMutators[2], "Test 2 mutated");

    state.performAction(() => state.mapWithMutators.clear());

    expect(state.mapWithMutators.length, 0);

    state.performAction(() => state.mapWithMutators.addAll({1: "Test", 2: "Test 2"}));

    expect(state.mapWithMutators.keys, [1,2]);

    expect(state.mapWithMutators.cast<int, String>(), {1: "Test mutated", 2: "Test 2 mutated"});

    expect(state.mapWithMutators.containsValue("Test mutated"), true);
    expect(state.mapWithMutators.containsValue("Test"), false);

    expect(state.mapWithMutators.isNotEmpty, true);

    state.performAction(() => state.mapWithMutators.clear());

    expect(state.mapWithMutators.isEmpty, true);
  });
}
