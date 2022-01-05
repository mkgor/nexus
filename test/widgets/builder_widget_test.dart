import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/nexus.dart';

import '../_collections_test_state.dart';

void main() {
  testWidgets("Nexus builder test", (WidgetTester tester) async {
    var state = DemoState();

    await tester.pumpWidget(NexusBuilder(builder: (ctx) => Container(), controller: state));

    expect(state.builders.length, 1);
  });
}