import 'package:nexus/src/mutator.dart';
import 'package:nexus/src/guard.dart';

class NexusState {
  const NexusState();
}

class NexusObject {
  const NexusObject();
}

class Reactive {
  final bool disableReactions;
  final List<Mutator> mutators;
  final List<Guard> guards;
  final bool mutatorsFirst;
  final bool dataSafeMutations;

  const Reactive({
    this.disableReactions = false,
    this.mutators = const <Mutator>[],
    this.guards = const <Guard>[],
    this.mutatorsFirst = true,
    this.dataSafeMutations = true,
  });
}

const action = "action";
