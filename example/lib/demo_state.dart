import 'package:nexus/nexus.dart';
import 'package:nexus_codegen/nexus_codegen.dart';

part 'demo_state.g.dart';

class DemoState = DemoStateBase with _$DemoStateBaseMixin;

@NexusState()
abstract class DemoStateBase extends NexusController {
  @Reactive()
  int counter = 0;

  @Reactive()
  bool flag = false;

  @Reactive(disableReactions: true)
  ReactiveList<int> intList = ReactiveList<int>();

  @Reactive()
  ReactiveSet<String> stringList = ReactiveSet<String>();

  @Reactive()
  ReactiveMap<String, Map<String, String>> map =
      ReactiveMap<String, Map<String, String>>.of({
        'john': {
          'age': "12",
          'weight': "85"
        },
        'michael': {
          'age': "14",
          'weight': "90"
        }
      });

  @action
  void increment(int value) {

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
