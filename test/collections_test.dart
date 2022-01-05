import 'dart:collection';

import 'package:flutter/material.dart';
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
    ];

    var iterator = 0;
    var state = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: state);

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      // print(event.type);

      iterator++;
    });

    state.performAction(() => state.list.add(1));

    expect(state.list.length, 1);
    expect(state.list[0], 1);

    state.performAction(() => state.list.removeAt(0));

    expect(state.list.length, 0);

    state.performAction(() => state.list.insertAll(0, [1,2,3,4,5]));

    expect(state.list.length, 5);
    expect(state.list[3], 4);
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
    ];

    var iterator = 0;
    var setState = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: setState);

    setState.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      // print(event.type);

      iterator++;
    });

    setState.performAction(() => setState.set.add(1));
    setState.performAction(() => setState.set.add(1));

    expect(setState.set.length, 1);
    expect(setState.set.elementAt(0), 1);

    setState.performAction(() => setState.set.remove(1));

    expect(setState.set.length, 0);

    setState.performAction(() => setState.set.addAll([1,2,3,4,5]));

    expect(setState.set.length, 5);
    expect(setState.set.elementAt(3), 4);
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
    ];

    var iterator = 0;
    var state = DemoState();
    var builder = NexusBuilder(builder: (ctx) => Container(), controller: state);

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];
      //
      expect(event.type, expectedEvent);

      iterator++;
    });

    state.performAction(() => state.map[1] = "Test");

    expect(state.map.length, 1);
    expect(state.map[1], "Test");

    state.performAction(() => state.map.remove(1));

    expect(state.map.length, 0);

    state.performAction(() => state.map.addAll({1: "Test", 2: "Test 2"}));

    expect(state.map.length, 2);
    expect(state.map[2], "Test 2");
  });
}
