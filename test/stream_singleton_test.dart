import 'package:flutter_test/flutter_test.dart';
import 'package:nexus/nexus.dart';

void main() {
  test("Stream close test", () {
    NexusStreamSingleton().close();

    expect(NexusStreamSingleton().streamController.isClosed, true);
  });
}