import 'package:nexus/nexus.dart';

class PatronymicNameMutator implements Mutator<String, String> {
  const PatronymicNameMutator();

  @override
  String mutate(value) {
    return value + " Patronymic";
  }
}