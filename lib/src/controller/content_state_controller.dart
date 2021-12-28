import 'package:nexus/nexus.dart';

enum ContentState { initial, loading, loaded, error, empty }

class ContentStateController {
  final NexusController _controller;

  ContentStateController(NexusController controller) : _controller = controller;

  ContentState _value = ContentState.initial;

  ContentState get value => _value;

  void initial() => _changeMode(ContentState.initial);

  void loading() => _changeMode(ContentState.loading);

  void loaded() => _changeMode(ContentState.loaded);

  void error() => _changeMode(ContentState.error);

  void empty() => _changeMode(ContentState.empty);

  void _changeMode(ContentState mode) {
    if (_value != mode) {
      var oldValue = _value;

      _value = mode;

      _controller.markNeedsUpdate();
      _controller.initiateReactionsForVariable(
          'contentState', oldValue, _value);
    }
  }
}
