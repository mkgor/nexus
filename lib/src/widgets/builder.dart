import 'package:flutter/widgets.dart';

import '../controller/controller.dart';

/// Nexus builder is the most important widget in UI layer, it will rebuild
/// on every reactive data modification
class NexusBuilder extends StatefulWidget {
  final NexusController controller;
  final WidgetBuilder builder;

  NexusBuilder({Key? key, required this.builder, required this.controller}) : super(key: key);

  @override
  _NexusBuilderState createState() => _NexusBuilderState();
}

class _NexusBuilderState extends State<NexusBuilder> {
  @override
  void initState() {
    super.initState();

    widget.controller.registerBuilder(this);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}