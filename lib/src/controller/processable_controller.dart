import 'package:nexus/nexus.dart';
import 'package:nexus/src/controller/content_state_controller.dart';

abstract class ProcessableNexusController extends NexusController {
  late final ContentStateController _contentStateController =
      ContentStateController(this);

  ContentStateController get contentStateController => _contentStateController;

  ContentState get contentState => _contentStateController.value;
}
