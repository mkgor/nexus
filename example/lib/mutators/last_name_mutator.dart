import 'package:nexus/nexus.dart';

class LastNameMutator implements Mutator<String, String> {
  const LastNameMutator();

  @override
  String mutate(value) {
    return value + " Doe";
  }
}