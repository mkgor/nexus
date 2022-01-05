import 'package:nexus/nexus.dart';
import 'package:nexus_codegen/nexus_codegen.dart';

part '_collections_test_state.g.dart';

class DemoState = DemoStateBase with _$DemoStateBaseMixin;

@NexusState()
abstract class DemoStateBase extends NexusController {
  @Reactive()
  var list = ReactiveList<int>();

  @Reactive()
  var set = ReactiveSet<int>();

  @Reactive()
  var map = ReactiveMap<int, String>();
}