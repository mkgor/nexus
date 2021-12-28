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
  }

  @override
  void init() {
    super.init();

    addReaction(
      variableName: 'intList',
      reactionId: 'react_on_modify',
      reaction: (oldValue, newValue) {
        print("Old value was: $oldValue, new value: $newValue");
      }
    );
  }

  @override
  void onUpdate() {
    super.onUpdate();

    print('State was updated!');
  }
}
