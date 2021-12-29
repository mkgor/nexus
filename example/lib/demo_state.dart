import 'package:example/guards/name_length_guard.dart';
import 'package:example/mutators/patronymic_name_mutator.dart';
import 'package:example/mutators/random_int_adder_mutator.dart';
import 'package:example/reactive_object.dart';
import 'package:nexus/nexus.dart';
import 'package:nexus_codegen/nexus_codegen.dart';

import 'mutators/last_name_mutator.dart';

part 'demo_state.g.dart';

class DemoState = DemoStateBase with _$DemoStateBaseMixin;

@NexusState()
abstract class DemoStateBase extends NexusController {
  @Reactive()
  int _counter = 0;

  int get counter => _counter;

  @Reactive()
  bool flag = false;

  @Reactive(
    disableReactions: true,
    guards: [NameLengthGuard()],
    mutators: [
      RandomIntAdderMutator(),
    ],
    dataSafeMutations: false
  )
  ReactiveList<int> intList = ReactiveList<int>();

  @Reactive()
  ReactiveSet<String> stringList = ReactiveSet<String>();

  @Reactive()
  User reactiveUser = User("John", 56);

  @Reactive(
    guards: [NameLengthGuard()],
    mutators: [LastNameMutator(), PatronymicNameMutator()],
  )
  String fullName = "Joh";

  @Reactive()
  late ReactiveMap<String, ReactiveMap<String, int>> map =
      ReactiveMap<String, ReactiveMap<String, int>>.of({
    'John': ReactiveMap<String, int>.of(
      {
        "age": 12,
        "weight": 80,
      },
      controller: this,
    ),
    'Jim': ReactiveMap<String, int>.of(
      {
        "age": 16,
        "weight": 85,
      },
      controller: this,
    ),
  });

  @action
  void increment(int value) {
    intList.add(value);
  }

  @override
  void init() {
    super.init();

    print("Demo state have id: $stateId");

    NexusStreamSingleton().stream.listen((event) {
      print("Event type: ${event.type} ${event.payload.stateId}");

      switch (event.type) {
        case EventType.stateInitialized:
        // TODO: Handle this case.
          break;
        case EventType.stateUpdated:
          StateUpdatedPayload payload = event.payload as StateUpdatedPayload;

          print("Variable ${payload.variableName} was updated! Old value: ${payload.oldValue} new value: ${payload.newValue}");
          break;
        case EventType.stateDisposed:
        // TODO: Handle this case.
          break;
        case EventType.reactionRegistered:
        // TODO: Handle this case.
          break;
        case EventType.reactionInitiated:
        // TODO: Handle this case.
          break;
        case EventType.reactionRemoved:
        // TODO: Handle this case.
          break;
        case EventType.performedAction:
          // TODO: Handle this case.
          break;
        case EventType.performedAsyncAction:
          // TODO: Handle this case.
          break;
      }
    });

    addReaction(
        variableName: '_counter',
        reactionId: 'react_on_modify',
        reaction: (oldValue, newValue) {
          print("Old value was: $oldValue, new value: $newValue");
        });

    removeReaction(variableName: '_counter', reactionId: 'react_on_modify');
  }

  DemoStateBase({String? stateId}) : super(stateId: stateId);
}