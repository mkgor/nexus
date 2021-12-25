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

  @action
  void increment(int value) {
    counter += value;

    intList = [1,2,3].toReactiveList();
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
