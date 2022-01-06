import 'package:flutter/material.dart';
import 'package:nexus/nexus.dart';
import 'package:nexus/src/controller/content_state_controller.dart';
import 'package:nexus/src/controller/processable_controller.dart';

/// For convenience, a special widget was implemented - [ProcessableWidget]
/// It is just [StatelessWidget] which contains [NexusBuilder] and simplifies
/// working with ProcessableNexusController and shows different widgets for
/// every status of content's loading
///
/// You should implement your own ProcessableWidget to work with ProcessableNexusController
///
/// It contains methods for each content loading status
///
/// Check example to get a representation of how to work with this widget
abstract class ProcessableWidget<T extends ProcessableNexusController>
    extends StatelessWidget {
  final T controller;

  ProcessableWidget({Key? key, required this.controller})
      : super(key: key) {
    init.call();
  }

  @override
  Widget build(BuildContext context) {
    return NexusBuilder(
      builder: (context) {
        switch (controller.contentState) {
          case ContentState.initial:
            return initial(context);
          case ContentState.loading:
            return loading(context);
          case ContentState.loaded:
            return loaded(context);
          case ContentState.error:
            return error(context);
          case ContentState.empty:
            return empty(context);
          default:
            throw Exception("Unknown content state");
        }
      },
      controller: controller,
    );
  }

  /// Will be shown if content state is [ContentState.initial]
  Widget initial(BuildContext context);

  /// Will be shown if content state is [ContentState.loading]
  Widget loading(BuildContext context);

  /// Will be shown if content state is [ContentState.loaded]
  Widget loaded(BuildContext context);

  /// Will be shown if content state is [ContentState.error]
  Widget error(BuildContext context);

  /// Will be shown if content state is [ContentState.empty]
  Widget empty(BuildContext context);

  void init() => {};
}
