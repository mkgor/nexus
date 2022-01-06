import 'package:flutter/material.dart';
import 'package:nexus/nexus.dart';
import 'package:nexus/src/controller/content_state_controller.dart';

/// Base class for any controller, which is responsible for loading and showing
/// some content
///
/// It contains [ContentStateController], which allows us to manage content state value
///
/// For convenience, a special widget was implemented - [ProcessableWidget]
/// It is just [StatelessWidget] which contains [NexusBuilder] and simplifies
/// working with ProcessableNexusController and shows different widgets for
/// every status of content's loading
///
abstract class ProcessableNexusController extends NexusController {
  late final ContentStateController _contentStateController =
      ContentStateController(this);

  /// Content state controller, use it to change content loading status
  ContentStateController get contentStateController => _contentStateController;

  /// Current content loading status
  ContentState get contentState => _contentStateController.value;
}
