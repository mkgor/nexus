import 'package:nexus/nexus.dart';
import 'package:nexus_codegen/nexus_codegen.dart';

part 'processable_state.g.dart';

class ProcessableState = ProcessableStateBase with _$ProcessableStateBaseMixin;

@NexusState()
abstract class ProcessableStateBase extends ProcessableNexusController {
  @action
  Future changeMode() async {
    contentStateController.loading();

    await Future.delayed(const Duration(milliseconds: 500));

    contentStateController.loaded();

    await Future.delayed(const Duration(milliseconds: 500));

    contentStateController.error();

    await Future.delayed(const Duration(milliseconds: 500));

    contentStateController.empty();

    await Future.delayed(const Duration(milliseconds: 500));

    contentStateController.initial();
  }

  @override
  void init() {
    super.init();

    print("Processable state have id: $stateId");
  }
}