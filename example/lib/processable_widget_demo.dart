import 'package:flutter/material.dart';
import 'package:nexus/nexus.dart';

class ProcessableWidgetDemo extends ProcessableWidget {
  ProcessableWidgetDemo({
    Key? key,
    required ProcessableNexusController controller,
  }) : super(key: key, controller: controller);

  @override
  Widget empty(BuildContext context) {
    return const Center(child: Text("Empty"));
  }

  @override
  Widget error(BuildContext context) {
    return const Center(child: Text("Error"));
  }

  @override
  Widget initial(BuildContext context) {
    return const Center(child: Text("Initial"));
  }

  @override
  Widget loaded(BuildContext context) {
    return const Center(child: Text("Loaded"));
  }

  @override
  Widget loading(BuildContext context) {
    return const Center(child: Text("Loading"));
  }
}
