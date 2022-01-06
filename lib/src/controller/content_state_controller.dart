import 'package:nexus/nexus.dart';

/// Enum of possible states of content loading
enum ContentState {
  /// Initial content loading state, by default [ContentStateController.value]
  /// is [ContentState.initial]
  initial,

  /// Content loading state, show some loading indicator or loading overlay while
  /// your [ContentState] is [ContentState.loading]
  loading,

  /// Content was load successful and have some data
  loaded,

  /// Loading was finished with error
  error,

  /// Means that some request was successful, but there is no data, or we received
  /// empty list
  empty,
}

/// Content state controller is needed for convenient control and display of state
/// loading content. You don't need to create it manually, it's already built in
/// [ProcessableNexusController], you just need to refer to the [ProcessableNexusController.contentStateController] field
/// and call the method corresponding to the current state of loading the content
///
/// ```
/// void loadContent() async {
///   contentStateController.loading();
///
///   var result = await dataSource.getContent();
///
///   if(result != null) {
///     contentStateController.loaded();
///   } else {
///     contentStateController.error();
///   }
/// }
/// ```
///
class ContentStateController {
  final NexusController _controller;

  /// If you are trying to create [ContentStateController] instance manually,
  /// don't forget to pass [NexusController] which is need to be updated by changing
  /// [ContentState]
  ///
  ContentStateController(NexusController controller) : _controller = controller;

  ContentState _value = ContentState.initial;

  /// Getter for content state's value
  ///
  ContentState get value => _value;

  /// Changes content state value to "initial" and updates UI
  ///
  void initial() => _changeMode(ContentState.initial);

  /// Changes content state value to "loading" and updates UI
  ///
  void loading() => _changeMode(ContentState.loading);

  /// Changes content state value to "loaded" and updates UI
  ///
  void loaded() => _changeMode(ContentState.loaded);

  /// Changes content state value to "error" and updates UI
  ///
  void error() => _changeMode(ContentState.error);

  /// Changes content state value to "empty" and updates UI
  ///
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
