import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/nexus.dart';

void main() {
  test("Content state controller tests", () async {
    bool stateInitialized = false;

    var state = DemoState();

    expect(state.contentState, ContentState.initial);

    state.contentStateController.loading();

    var eventsStack = [
      EventType.stateInitialized,
      EventType.stateUpdated,
      EventType.stateUpdated,
      EventType.stateUpdated,
      EventType.stateUpdated,
      EventType.stateUpdated,
    ];

    var iterator = 0;

    state.logStream.listen((event) {
      var expectedEvent = eventsStack[iterator];

      expect(event.type, expectedEvent);

      iterator++;
    });

    expect(state.contentState, ContentState.loading);

    state.contentStateController.loaded();

    expect(state.contentState, ContentState.loaded);

    state.contentStateController.error();

    expect(state.contentState, ContentState.error);

    state.contentStateController.empty();

    expect(state.contentState, ContentState.empty);

    state.contentStateController.initial();

    expect(state.contentState, ContentState.initial);
  });
}

class DemoState extends ProcessableNexusController {

}