import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../nexus.dart';
import 'controller/controller.dart';

extension ListExtension<T> on List<T> {
  ReactiveList<T> toReactive(
          {NexusController? controller,
          String? variableName,
          bool disableReactions = false,
          List<Mutator>? mutators,
          bool dataSafeMutations = true}) =>
      ReactiveList<T>.of(
        this,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
        mutators: mutators,
        dataSafeMutations: dataSafeMutations,
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
      bool? disableReactions,
      List<Mutator>? mutators,
      bool dataSafeMutations = true})
      : _list = <T>[],
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false,
        _mutators = mutators ?? [],
        _dataSafeMutations = dataSafeMutations;

  ReactiveList.of(Iterable<T> elements,
      {NexusController? controller,
      String? variableName,
      bool? disableReactions,
      List<Mutator>? mutators,
      bool dataSafeMutations = true})
      : _list = List<T>.from(elements),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false,
        _mutators = mutators ?? [],
        _dataSafeMutations = dataSafeMutations {
    if (_mutators != null && _mutators!.isNotEmpty) {
      for (var key in _list.asMap().keys) {
        T result = _list[key];

        for (var mutator in _mutators!) {
          result = mutator.mutate(result);
        }

        _list[key] = result;
      }
    }
  }

  ReactiveList<T> wrap<T>(
          {required NexusController controller,
          String? variableName,
          bool? disableReactions,
          List<Mutator>? mutators,
          bool dataSafeMutations = true}) =>
      ReactiveList<T>.of(_list as Iterable<T>,
          controller: controller,
          variableName: variableName,
          disableReactions: disableReactions,
          mutators: mutators,
          dataSafeMutations: dataSafeMutations);

  final List<T> _list;

  final List<Mutator>? _mutators;

  final bool _dataSafeMutations;

  bool _disableReactions = false;

  NexusController? _controller;

  String? _variableName;

  @override
  ReactiveList<T> operator +(List<T> other) {
    var result = _list + other;

    _controller?.markNeedsUpdate();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, _list, result);

    return ReactiveList.of(
      result,
      controller: _controller,
      variableName: _variableName,
      disableReactions: _disableReactions,
      mutators: _mutators,
      dataSafeMutations: _dataSafeMutations,
    );
  }

  @override
  T operator [](int index) {
    if (_dataSafeMutations) {
      T mutatedValue = _list[index];

      if (_mutators != null && _mutators!.isNotEmpty) {
        for (var mutator in _mutators!) {
          mutatedValue = mutator.mutate(mutatedValue);
        }
      }

      return mutatedValue;
    } else {
      return _list[index];
    }
  }

  @override
  void operator []=(int index, T value) {
    final oldValue = _list[index];

    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    value = _performMutations(value);

    if (oldValue != value) {
      _list[index] = value;

      _finalizeCollectionAction(_oldList);
    }
  }

  @override
  bool operator ==(dynamic other) {
    return other is ReactiveList<T> ? listEquals<T>(_list, other._list) : false;
  }

  @override
  void add(T value) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    value = _performMutations(value);

    _list.add(value);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void addAll(Iterable<T> iterable) {

    if (iterable.isNotEmpty) {
      List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

      var _listIterable = _performMutationsOnIterable(iterable);

      _list.addAll(_listIterable);

      _finalizeCollectionAction(_oldList);
    }
  }

  @override
  void clear() {
    if (_list.isNotEmpty) {
      List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

      _list.clear();

      _finalizeCollectionAction(_oldList);
    }
  }

  @override
  void fillRange(int start, int end, [T? fillValue]) {
    if (!_list.runtimeType.toString().contains("?") && fillValue == null) {
      throw Exception(
          "You can't fill list with null value, if its type is non-nullable (type is ${_list.runtimeType})");
    }

    if (end > start) {
      List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

      if(fillValue != null) {
        fillValue = _performMutations(fillValue);
      }

      _list.fillRange(start, end, fillValue);

      _finalizeCollectionAction(_oldList);
    }
  }

  @override
  void insert(int index, T element) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    element = _performMutations(element);

    _list.insert(index, element);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    if (iterable.isNotEmpty) {
      List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

      var _listIterable = _performMutationsOnIterable(iterable);

      _list.insertAll(index, _listIterable);

      _finalizeCollectionAction(_oldList);
    }
  }

  @override
  bool remove(Object? value) {
    if (value != null) {
      var result = false;

      final index = _list.indexOf(value as T);

      if (index >= 0) {
        List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

        _list.remove(value);

        _finalizeCollectionAction(_oldList);

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

    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.removeAt(index);

    _finalizeCollectionAction(_oldList);

    return value;
  }

  @override
  T removeLast() {
    T value = _list.last;

    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.removeLast();

    _finalizeCollectionAction(_oldList);

    return value;
  }

  @override
  void removeRange(int start, int end) {
    if (end > start) {
      List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

      _list.removeRange(start, end);

      _finalizeCollectionAction(_oldList);
    }
  }

  @override
  void removeWhere(bool Function(T element) test) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.removeWhere(test);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacements) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    var _listReplacements = _performMutationsOnIterable(replacements);

    _list.replaceRange(start, end, _listReplacements);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void retainWhere(bool Function(T element) test) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.retainWhere(test);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    var _listIterable = _performMutationsOnIterable(iterable);

    _list.setAll(index, _listIterable);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    var _listIterable = _performMutationsOnIterable(iterable);

    _list.setRange(start, end, _listIterable);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void shuffle([Random? random]) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.shuffle(random);

    _finalizeCollectionAction(_oldList);
  }

  @override
  void sort([int Function(T a, T b)? compare]) {
    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.sort(compare);

    _finalizeCollectionAction(_oldList);
  }

  List<T> get mutatedList {
    if (_mutators != null && _mutators!.isNotEmpty && !_dataSafeMutations) {
      var _tmpList = List<T>.from(_list);

      for (var key in _tmpList.asMap().keys) {
        for (var mutator in _mutators!) {
          _tmpList[key] = mutator.mutate(_tmpList[key]);
        }
      }

      return _tmpList;
    } else {
      return _list;
    }
  }

  List<T> get unmutatedList {
    if (!_dataSafeMutations)
      print(
          "[WARNING] You are trying to get unmutated list, when dataSafeMutations disabled!");

    return _list;
  }

  @override
  List<T> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<T> toSet() => _list.toSet();

  ReactiveSet<T> toReactiveSet() => ReactiveSet.of(
        _list.toSet(),
        controller: _controller,
        variableName: _variableName,
        disableReactions: _disableReactions,
        mutators: _mutators,
        dataSafeMutations: _dataSafeMutations,
      );

  @override
  int get length => _list.length;

  @override
  int get hashCode => _list.hashCode;

  @override
  set length(int value) {
    if (value > _list.length && !_list.runtimeType.toString().contains("?")) {
      throw Exception(
          "You can't increase length of list by its setter, if its type is non-nullable (type is ${_list.runtimeType})");
    }

    List<T> _oldList = _disableReactions ? _list : List<T>.from(_list);

    _list.length = value;

    _finalizeCollectionAction(_oldList);
  }

  T _performMutations(T value) {
    if (_mutators != null && _mutators!.isNotEmpty && !_dataSafeMutations) {
      for (var mutator in _mutators!) {
        value = mutator.mutate(value);
      }
    }

    return value;
  }

  Iterable<T> _performMutationsOnIterable(Iterable<T> iterable) {
    var _listIterable = iterable.toList();

    if (_mutators != null && _mutators!.isNotEmpty && !_dataSafeMutations) {
      for (var key in iterable.toList().asMap().keys) {
        for (var mutator in _mutators!) {
          _listIterable[key] = mutator.mutate(_listIterable[key]);
        }
      }
    }

    return _listIterable;
  }

  void _finalizeCollectionAction(List<T> oldValue) {
    _controller?.markNeedsUpdate();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, oldValue, _list);
  }
}

class ReactiveSet<T> with SetMixin<T> {
  ReactiveSet({
    NexusController? controller,
    String? variableName,
    bool? disableReactions,
    List<Mutator>? mutators,
    bool dataSafeMutations = true,
  })  : _set = Set<T>(),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false,
        _dataSafeMutations = dataSafeMutations,
        _mutators = mutators ?? [];

  ReactiveSet.of(
    Iterable<T> elements, {
    NexusController? controller,
    String? variableName,
    bool? disableReactions,
    List<Mutator>? mutators,
    bool dataSafeMutations = true,
  })  : _set = Set<T>.from(elements),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false,
        _dataSafeMutations = dataSafeMutations,
        _mutators = mutators ?? [] {
    if(dataSafeMutations && mutators != null && mutators.isNotEmpty) {
      print("[WARNING] Data safe mutations does not work for Sets");
    }
  }

  ReactiveSet<T> wrap<T>({
    required NexusController controller,
    String? variableName,
    bool? disableReactions,
    List<Mutator>? mutators,
    bool dataSafeMutations = true,
  }) =>
      ReactiveSet<T>.of(_set as Iterable<T>,
          controller: controller,
          variableName: variableName,
          disableReactions: disableReactions,
          mutators: mutators,
          dataSafeMutations: dataSafeMutations);

  final Set<T> _set;

  final List<Mutator>? _mutators;

  final bool _dataSafeMutations;

  bool _disableReactions = false;

  NexusController? _controller;

  String? _variableName;

  @override
  bool add(T value) {
    var _result = false;

    Set<T> _oldSet = _disableReactions ? _set : Set<T>.from(_set);

    value = _performMutations(value);

    _result = _set.add(value);

    _finalizeCollectionAction(_oldSet);

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

    Set<T> _oldSet = _disableReactions ? _set : Set<T>.from(_set);

    _result = _set.remove(value);

    _finalizeCollectionAction(_oldSet);

    return _result;
  }

  @override
  Set<T> toSet() => _set;

  @override
  void clear() {
    Set<T> _oldSet = _disableReactions ? _set : Set<T>.from(_set);

    _set.clear();

    _finalizeCollectionAction(_oldSet);
  }

  T _performMutations(T value) {
    if (_mutators != null && _mutators!.isNotEmpty && !_dataSafeMutations) {
      for (var mutator in _mutators!) {
        value = mutator.mutate(value);
      }
    }

    return value;
  }

  void _finalizeCollectionAction(Set<T> oldValue) {
    _controller?.markNeedsUpdate();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, oldValue, _set);
  }
}

class ReactiveMap<K, V> with MapMixin<K, V> {
  ReactiveMap({
    NexusController? controller,
    String? variableName,
    bool? disableReactions,
    List<Mutator>? mutators,
    bool dataSafeMutations = true,
  })  : _map = <K, V>{},
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false,
        _mutators = mutators ?? [],
        _dataSafeMutations = dataSafeMutations;

  ReactiveMap.of(
    Map<K, V> elements, {
    NexusController? controller,
    String? variableName,
    bool? disableReactions,
    List<Mutator>? mutators,
    bool dataSafeMutations = true,
  })  : _map = Map<K, V>.from(elements),
        _variableName = variableName,
        _controller = controller,
        _disableReactions = disableReactions ?? false,
        _mutators = mutators ?? [],
        _dataSafeMutations = dataSafeMutations;

  ReactiveMap<K, V> wrap<K, V>({
    required NexusController controller,
    String? variableName,
    bool? disableReactions,
    List<Mutator>? mutators,
    bool dataSafeMutations = true,
  }) =>
      ReactiveMap<K, V>.of(
        _map as Map<K, V>,
        controller: controller,
        variableName: variableName,
        disableReactions: disableReactions,
        mutators: mutators,
        dataSafeMutations: dataSafeMutations
      );

  final Map<K, V> _map;

  final List<Mutator>? _mutators;

  final bool _dataSafeMutations;

  bool _disableReactions = false;

  NexusController? _controller;

  String? _variableName;

  @override
  V? operator [](Object? key) {
    if (_dataSafeMutations) {
      V? mutatedValue = _map[(key as K?)];

      if (_mutators != null && _mutators!.isNotEmpty) {
        for (var mutator in _mutators!) {
          mutatedValue = mutator.mutate(mutatedValue);
        }
      }

      return mutatedValue;
    } else {
      return _map[(key as K?)];
    }
  }

  @override
  void operator []=(K key, V value) {
    final oldValue = _map[key];

    Map<K, V> _oldMap = _disableReactions ? _map : Map<K, V>.from(_map);

    value = _performMutations(value);

    if (oldValue != value) {
      _map[key] = value;
      _finalizeCollectionAction(_oldMap);
    }
  }

  @override
  void clear() {
    Map<K, V> _oldMap = _disableReactions ? _map : Map<K, V>.from(_map);

    _map.clear();

    _finalizeCollectionAction(_oldMap);
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) {
    Map<K, V> _oldMap = _disableReactions ? _map : Map<K, V>.from(_map);

    V? result = _map.remove(key);

    _finalizeCollectionAction(_oldMap);

    return result;
  }

  @override
  Map<RK, RV> cast<RK, RV>() => ReactiveMap.of(super.cast<RK, RV>()).wrap(
        controller: _controller!,
        variableName: _variableName,
        disableReactions: _disableReactions,
        mutators: _mutators,
        dataSafeMutations: _dataSafeMutations
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

  V _performMutations(V value) {
    if (_mutators != null && _mutators!.isNotEmpty && !_dataSafeMutations) {
      for (var mutator in _mutators!) {
        value = mutator.mutate(value);
      }
    }

    return value;
  }

  void _finalizeCollectionAction(Map<K, V> oldValue) {
    _controller?.markNeedsUpdate();

    if (!_disableReactions)
      _controller?.initiateReactionsForVariable(_variableName, oldValue, _map);
  }
}