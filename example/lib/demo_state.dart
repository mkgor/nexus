import 'package:example/reactive_object.dart';
import 'package:nexus/nexus.dart';
import 'package:nexus_codegen/nexus_codegen.dart';

part 'demo_state.g.dart';

class DemoState = DemoStateBase with _$DemoStateBaseMixin;

@NexusState()
abstract class DemoStateBase extends NexusController {


  @Reactive()
  int _counter = 0;

  int get counter => _counter;

  @Reactive()
  bool flag = false;

  @Reactive(disableReactions: true)
  ReactiveList<int> intList = ReactiveList<int>();

  @Reactive()
  ReactiveSet<String> stringList = ReactiveSet<String>();

  @Reactive()
  User reactiveUser = User("John", 56);

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
    _counter += 1;
    map['John']!['age'] = map['John']!['age']! + value;

    reactiveUser.weight++;
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
      }
    );

    removeReaction(variableName: '_counter', reactionId: 'react_on_modify');
  }

  DemoStateBase({String? stateId}) : super(stateId: stateId);
}