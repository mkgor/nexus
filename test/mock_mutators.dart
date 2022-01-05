import 'package:nexus/nexus.dart';

class IntMockMutator extends Mutator<int, int> {
  const IntMockMutator();

  @override
  int mutate(int value) => value + 1;
}
class StringMockMutator extends Mutator<String, String> {
  const StringMockMutator();

  @override
  String mutate(String value) => value + " mutated";
}