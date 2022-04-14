import 'package:flutter/widgets.dart';

import '../controller/controller.dart';

bool _isControllerObservedBefore(
    BuildContext? context, NexusController controller) {
  if (context == null) return false;

  var singleBuilderAncestor =
  context.findAncestorStateOfType<State<NexusBuilder>>();
  var multiBuilderAncestor =
  context.findAncestorStateOfType<State<MultiNexusBuilder>>();

  if (singleBuilderAncestor != null) {
    if (singleBuilderAncestor.widget.controller.stateId == controller.stateId) {
      return true;
    }
  }

  if (multiBuilderAncestor != null) {
    for (var ancestorController in multiBuilderAncestor.widget.controllers) {
      if (ancestorController.stateId == controller.stateId) {
        return true;
      }
    }
  }

  return _isControllerObservedBefore(
      singleBuilderAncestor?.context, controller) ||
      _isControllerObservedBefore(multiBuilderAncestor?.context, controller);
}

/// Nexus builder is the most important widget in UI layer, it will rebuild
/// on every reactive data modification
class NexusBuilder extends StatefulWidget {
  final NexusController controller;
  final WidgetBuilder builder;

  NexusBuilder({Key? key, required this.builder, required this.controller})
      : super(key: key);

  @override
  _NexusBuilderState createState() => _NexusBuilderState();
}

class _NexusBuilderState extends State<NexusBuilder> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    if (!_isControllerObservedBefore(context, widget.controller)) {
      widget.controller.registerBuilder(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.builder(context);
  }

  @override
  bool get wantKeepAlive => widget.controller.mounted;
}


class MultiNexusBuilder extends StatefulWidget {
  final List<NexusController> controllers;
  final WidgetBuilder builder;

  MultiNexusBuilder({Key? key, required this.builder, required this.controllers}) : super(key: key);

  @override
  _MultiNexusBuilderState createState() => _MultiNexusBuilderState();
}

class _MultiNexusBuilderState extends State<MultiNexusBuilder> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    widget.controllers.forEach((element) {
      if (!_isControllerObservedBefore(context, element)) {
        element.registerBuilder(this);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.builder(context);
  }

  @override
  bool get wantKeepAlive {
    for(var controller in widget.controllers) {
      if(controller.mounted)
        return true;
    }

    return false;
  }
}