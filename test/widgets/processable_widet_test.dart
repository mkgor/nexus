import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/nexus.dart';

void main() {
  testWidgets("Processable widget test", (WidgetTester tester) async {
    var state = TestProcessableState();

    await tester.pumpWidget(
      MaterialApp(
        home: TestProcessableWidget(state),
      ),
    );

    final emptyFinder = find.text("Empty");
    final errorFinder = find.text("Error");
    final initialFinder = find.text("Initial");
    final loadedFinder = find.text("Loaded");
    final loadingFinder = find.text("Loading");

    expect(initialFinder, findsOneWidget);

    state.performAction(() => state.contentStateController.loading());

    await tester.pump();

    expect(loadingFinder, findsOneWidget);

    state.performAction(() => state.contentStateController.loaded());

    await tester.pump();

    expect(loadedFinder, findsOneWidget);

    state.performAction(() => state.contentStateController.error());

    await tester.pump();

    expect(errorFinder, findsOneWidget);

    state.performAction(() => state.contentStateController.empty());

    await tester.pump();

    expect(emptyFinder, findsOneWidget);
  });
}

class TestProcessableWidget extends ProcessableWidget {
  TestProcessableWidget(ProcessableNexusController controller)
      : super(controller: controller);

  @override
  Widget empty(BuildContext context) {
    return const Center(child: Text("Empty"));
  }

  @override
  Widget error(BuildContext context) {
    return const Center(child: Text("Error"));
  }

  @override
  Widget initial(BuildContext context) {
    return const Center(child: Text("Initial"));
  }

  @override
  Widget loaded(BuildContext context) {
    return const Center(child: Text("Loaded"));
  }

  @override
  Widget loading(BuildContext context) {
    return const Center(child: Text("Loading"));
  }
}

class TestProcessableState extends ProcessableNexusController {}
