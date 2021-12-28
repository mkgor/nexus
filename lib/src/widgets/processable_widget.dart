import 'package:flutter/material.dart';
import 'package:nexus/nexus.dart';
import 'package:nexus/src/controller/content_state_controller.dart';
import 'package:nexus/src/controller/processable_controller.dart';

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

  Widget initial(BuildContext context);

  Widget loading(BuildContext context);

  Widget loaded(BuildContext context);

  Widget error(BuildContext context);

  Widget empty(BuildContext context);

  void init() => {};
}
