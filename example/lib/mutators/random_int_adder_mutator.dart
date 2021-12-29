import 'dart:math';

import 'package:nexus/nexus.dart';

class RandomIntAdderMutator extends Mutator<int, int> {
  const RandomIntAdderMutator();

  @override
  int mutate(int value) {
    return value + Random().nextInt(1000);
  }
}