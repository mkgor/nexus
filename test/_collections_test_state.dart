import 'package:nexus/nexus.dart';
import 'package:nexus_codegen/nexus_codegen.dart';

import 'mock_mutators.dart';

part '_collections_test_state.g.dart';

class DemoState = DemoStateBase with _$DemoStateBaseMixin;

@NexusState()
abstract class DemoStateBase extends NexusController {
  @Reactive()
  var list = ReactiveList<int?>();

  @Reactive(mutators: [IntMockMutator()], dataSafeMutations: false)
  var listWithMutators = ReactiveList<int?>();

  @Reactive()
  var nonNullableList = ReactiveList<int>();

  @Reactive()
  var set = ReactiveSet<int>();

  @Reactive(mutators: [IntMockMutator()], dataSafeMutations: false)
  var setWithMutators = ReactiveSet<int>();

  @Reactive()
  var map = ReactiveMap<num, String>();

  @Reactive(mutators: [StringMockMutator()], dataSafeMutations: false)
  var mapWithMutators = ReactiveMap<num, String>();
}