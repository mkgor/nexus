import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'controller.dart';

extension ListExtension<T> on List<T> {
  ReactiveList<T> toReactive(
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

extension SetExtension<T> on Set<T> {
  ReactiveSet<T> toReactive(
          {NexusController? controller,
          String? variableName,
          bool disableReactions = false}) =>
      ReactiveSet<T>.of(
        this,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
      );
}

extension MapExtension<K, V> on Map<K, V> {
  ReactiveMap<K, V> toReactive(
          {NexusController? controller,
          String? variableName,
          bool disableReactions = false}) =>
      ReactiveMap<K, V>.of(
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
  T operator [](int index) => _list[index];

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
  bool operator ==(dynamic other) {
    return other is ReactiveList<T> ? listEquals<T>(_list, other._list) : false;
  }

  @override
  void add(T value) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.add(value);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);

    _controller?.markNeedsUpdate();
  }

  @override
  void addAll(Iterable<T> iterable) {
    if (iterable.isNotEmpty) {
      late List _oldList;

      if (!_disableReactions) _oldList = List.from(_list);

      _list.addAll(iterable);

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, _oldList, _list);
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void clear() {
    if (_list.isNotEmpty) {
      late List _oldList;

      if (!_disableReactions) _oldList = List.from(_list);

      _list.clear();

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, _oldList, _list);

      _controller?.markNeedsUpdate();
    }
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    if (end > start) {
      late List _oldList;

      if (!_disableReactions) _oldList = List.from(_list);

      _list.fillRange(start, end, fillValue);

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, _oldList, _list);
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void insert(int index, T element) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.insert(index, element);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    if (iterable.isNotEmpty) {
      late List _oldList;

      if (!_disableReactions) _oldList = List.from(_list);

      _list.insertAll(index, iterable);

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, _oldList, _list);
      _controller?.markNeedsUpdate();
    }
  }

  @override
  bool remove(Object? value) {
    if (value != null) {
      var result = false;

      final index = _list.indexOf(value as T);

      if (index >= 0) {
        late List _oldList;

        if (!_disableReactions) _oldList = List.from(_list);

        _list.remove(value);

        if (!_disableReactions)
          _controller?.initiateReactionsForVariable(
              _variableName, _oldList, _list);
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

    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.removeAt(index);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();

    return value;
  }

  @override
  T removeLast() {
    T value = _list.last;

    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.removeLast();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();

    return value;
  }

  @override
  void removeRange(int start, int end) {
    if (end > start) {
      late List _oldList;

      if (!_disableReactions) _oldList = List.from(_list);

      _list.removeRange(start, end);

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, _oldList, _list);
      _controller?.markNeedsUpdate();
    }
  }

  @override
  void removeWhere(bool Function(T element) test) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.removeWhere(test);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.replaceRange(start, end, replacements);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.retainWhere(test);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.setAll(index, iterable);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.setRange(start, end, iterable);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void shuffle([Random? random]) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.shuffle(random);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.sort(compare);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  @override
  int get length => _list.length;

  @override
  int get hashCode => _list.hashCode;

  @override
  set length(int value) {
    late List _oldList;

    if (!_disableReactions) _oldList = List.from(_list);

    _list.length = value;

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldList, _list);
    _controller?.markNeedsUpdate();
  }
}

class ReactiveSet<T> with SetMixin<T> {
  ReactiveSet(
      {NexusController? controller,
      String? variableName,
      bool? disableReactions})
      : _set = Set<T>(),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false;

  ReactiveSet.of(Iterable<T> elements,
      {NexusController? controller,
      String? variableName,
      bool? disableReactions})
      : _set = Set<T>.from(elements),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false;

  ReactiveSet<T> wrap<T>(
          {required NexusController controller,
          String? variableName,
          bool? disableReactions}) =>
      ReactiveSet<T>.of(
        _set as Iterable<T>,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
      );

  final Set<T> _set;

  bool _disableReactions = false;

  NexusController? _controller;

  String? _variableName;

  @override
  bool add(T value) {
    var _result = false;

    late Set _oldSet;

    if (!_disableReactions) _oldSet = Set.from(_set);

    _result = _set.add(value);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldSet, _set);

    _controller?.markNeedsUpdate();

    return _result;
  }

  @override
  bool contains(Object? element) => _set.contains(element);

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  int get length => _set.length;

  @override
  T? lookup(Object? element) => _set.lookup(element);

  @override
  bool remove(Object? value) {
    var _result = false;

    late Set _oldSet;

    if (!_disableReactions) _oldSet = Set.from(_set);

    _result = _set.remove(value);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldSet, _set);

    _controller?.markNeedsUpdate();

    return _result;
  }

  @override
  Set<T> toSet() => _set;

  @override
  void clear() {
    late Set _oldSet;

    if (!_disableReactions) _oldSet = Set.from(_set);

    _set.clear();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldSet, _set);

    _controller?.markNeedsUpdate();
  }
}

class ReactiveMap<K, V> with MapMixin<K, V> {
  ReactiveMap(
      {NexusController? controller,
      String? variableName,
      bool? disableReactions})
      : _map = <K, V>{},
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false;

  ReactiveMap.of(Map<K, V> elements,
      {NexusController? controller,
      String? variableName,
      bool? disableReactions})
      : _map = Map<K, V>.from(elements),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false;

  ReactiveMap<K, V> wrap<K, V>(
          {required NexusController controller,
          String? variableName,
          bool? disableReactions}) =>
      ReactiveMap<K, V>.of(
        _map as Map<K, V>,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
      );

  final Map<K, V> _map;

  bool _disableReactions = false;

  NexusController? _controller;

  String? _variableName;

  @override
  V? operator [](Object? key) => _map[(key as K?)];

  @override
  void operator []=(K key, V value) {
    final oldValue = _map[key];

    if (oldValue != value) {
      _map[key] = value;
      _controller?.markNeedsUpdate();

      if (!_disableReactions)
        _controller?.initiateReactionsForVariable(
            _variableName, oldValue, value);
    }
  }

  @override
  void clear() {
    late Map _oldMap;

    if (!_disableReactions) _oldMap = Map.from(_map);

    _map.clear();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldMap, _map);

    _controller?.markNeedsUpdate();
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) {
    late Map _oldMap;

    if (!_disableReactions) _oldMap = Map.from(_map);

    V? result = _map.remove(key);

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _oldMap, _map);

    _controller?.markNeedsUpdate();

    return result;
  }

  @override
  Map<RK, RV> cast<RK, RV>() => ReactiveMap.of(super.cast()).wrap(
        controller: _controller!,
        variableName: _variableName,
        disableReactions: _disableReactions,
      );

  @override
  int get length => _map.length;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool containsKey(Object? key) => _map.containsKey(key);

  @override
  bool containsValue(Object? value) => _map.containsValue(value);
}