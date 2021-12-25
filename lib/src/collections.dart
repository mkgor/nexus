import 'dart:collection';
import 'dart:math';

import 'controller.dart';

extension ListExtension<T> on List<T> {
  ReactiveList<T> toReactiveList(
          {NexusController? controller,
          String? variableName,
          bool disableReactions = false}) =>
      ReactiveList<T>.of(
        this,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
      );
}

class ReactiveList<T> with ListMixin<T> {
  ReactiveList(
      {NexusController? controller,
      String? variableName,
      bool? disableReactions})
      : _list = <T>[],
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false;

  ReactiveList.of(Iterable<T> elements,
      {NexusController? controller,
      String? variableName,
      bool? disableReactions})
      : _list = List<T>.from(elements),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false;

  ReactiveList<T> wrap<T>(
          {required NexusController controller,
          String? variableName,
          bool? disableReactions}) =>
      ReactiveList<T>.of(
        _list as Iterable<T>,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
      );

  final List<T> _list;

  bool _disableReactions = false;

  NexusController? _controller;

  String? _variableName;

  @override
  List<T> operator +(List<T> other) {
    var result = _list + other;

    _controller?.markNeedsUpdate();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _list, result);

    return result;
  }

  @override
  T operator [](int index) {
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    final oldValue = _list[index];

    if (oldValue != value) {
      _list[index] = value;
      _controller?.markNeedsUpdate();

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, oldValue, value);
    }
  }

  @override
  void add(T value) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..add(value));
    _controller?.markNeedsUpdate();
  }

  @override
  void addAll(Iterable<T> iterable) {
    if (iterable.isNotEmpty) {
      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, List.from(_list), _list..addAll(iterable));
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void clear() {
    if (_list.isNotEmpty) {
      _list.clear();
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    if (end > start) {
      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(_variableName,
            List.from(_list), _list..fillRange(start, end, fillValue));
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void insert(int index, T element) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..insert(index, element));
    _controller?.markNeedsUpdate();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    if (iterable.isNotEmpty) {
      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, List.from(_list), _list..insertAll(index, iterable));
      _controller?.markNeedsUpdate();
    }
  }

  @override
  bool remove(Object? value) {
    if (value != null) {
      var result = false;

      final index = _list.indexOf(value as T);

      if (index >= 0) {
        if (!_disableReactions)
          _controller?.initiateReactionsForVariable(
              _variableName, List.from(_list), _list..remove(value));
        _controller?.markNeedsUpdate();

        result = true;
      }

      return result;
    } else {
      return false;
    }
  }

  @override
  T removeAt(int index) {
    T value = _list[index];
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..removeAt(index));
    _controller?.markNeedsUpdate();

    return value;
  }

  @override
  T removeLast() {
    T value = _list.last;
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..removeLast());
    _controller?.markNeedsUpdate();

    return value;
  }

  @override
  void removeRange(int start, int end) {
    if (end > start) {
      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, List.from(_list), _list..removeRange(start, end));
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void removeWhere(bool Function(T element) test) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..removeWhere(test));
    _controller?.markNeedsUpdate();
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, List.from(_list),
          _list..replaceRange(start, end, replacements));
    _controller?.markNeedsUpdate();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..removeWhere(test));
    _controller?.markNeedsUpdate();
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..setAll(index, iterable));
    _controller?.markNeedsUpdate();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, List.from(_list),
          _list..setRange(start, end, iterable));
    _controller?.markNeedsUpdate();
  }

  @override
  void shuffle([Random? random]) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..shuffle(random));
    _controller?.markNeedsUpdate();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
          _variableName, List.from(_list), _list..sort(compare));
    _controller?.markNeedsUpdate();
  }

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() {
    // TODO: implement toSet
    throw UnimplementedError();
  }

  @override
  int get length => _list.length;

  @override
  set length(int value) {
    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(
        _variableName,
        List.from(_list),
        _list..length = value,
      );
    _controller?.markNeedsUpdate();
  }
}
