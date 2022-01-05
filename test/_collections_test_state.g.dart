// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_collections_test_state.dart';

// **************************************************************************
// NexusGenerator
// **************************************************************************

mixin _$DemoStateBaseMixin on DemoStateBase, NexusController {
  bool _$listGate = false;

  ReactiveList<int?> _getWrappedlist() {
    _$listGate = true;

    final result = this.list.wrap<int?>(
          controller: this,
          variableName: 'list',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$listGate = false;

    return result;
  }

  late ReactiveList<int?> _$list = _getWrappedlist();

  @override
  get list {
    if (!_$listGate) {
      return _$list;
    } else {
      return super.list;
    }
  }

  @override
  set list(ReactiveList<int?> newValue) {
    if (list != newValue) {
      var oldValue = list;
      super.list = newValue;
      _$list = _getWrappedlist();

      markNeedsUpdate();

      initiateReactionsForVariable('list', oldValue, newValue);
    }
  }

  bool _$listWithMutatorsGate = false;

  ReactiveList<int?> _getWrappedlistWithMutators() {
    _$listWithMutatorsGate = true;

    final result = this.listWithMutators.wrap<int?>(
      controller: this,
      variableName: 'listWithMutators',
      disableReactions: false,
      dataSafeMutations: false,
      mutators: [IntMockMutator()],
    );

    _$listWithMutatorsGate = false;

    return result;
  }

  late ReactiveList<int?> _$listWithMutators = _getWrappedlistWithMutators();

  @override
  get listWithMutators {
    if (!_$listWithMutatorsGate) {
      return _$listWithMutators;
    } else {
      return super.listWithMutators;
    }
  }

  @override
  set listWithMutators(ReactiveList<int?> newValue) {
    if (listWithMutators != newValue) {
      var oldValue = listWithMutators;
      super.listWithMutators = newValue;
      _$listWithMutators = _getWrappedlistWithMutators();

      markNeedsUpdate();

      initiateReactionsForVariable('listWithMutators', oldValue, newValue);
    }
  }

  bool _$nonNullableListGate = false;

  ReactiveList<int> _getWrappednonNullableList() {
    _$nonNullableListGate = true;

    final result = this.nonNullableList.wrap<int>(
          controller: this,
          variableName: 'nonNullableList',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$nonNullableListGate = false;

    return result;
  }

  late ReactiveList<int> _$nonNullableList = _getWrappednonNullableList();

  @override
  get nonNullableList {
    if (!_$nonNullableListGate) {
      return _$nonNullableList;
    } else {
      return super.nonNullableList;
    }
  }

  @override
  set nonNullableList(ReactiveList<int> newValue) {
    if (nonNullableList != newValue) {
      var oldValue = nonNullableList;
      super.nonNullableList = newValue;
      _$nonNullableList = _getWrappednonNullableList();

      markNeedsUpdate();

      initiateReactionsForVariable('nonNullableList', oldValue, newValue);
    }
  }

  bool _$setGate = false;

  ReactiveSet<int> _getWrappedset() {
    _$setGate = true;

    final result = this.set.wrap<int>(
          controller: this,
          variableName: 'set',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$setGate = false;

    return result;
  }

  late ReactiveSet<int> _$set = _getWrappedset();

  @override
  get set {
    if (!_$setGate) {
      return _$set;
    } else {
      return super.set;
    }
  }

  @override
  set set(ReactiveSet<int> newValue) {
    if (set != newValue) {
      var oldValue = set;
      super.set = newValue;
      _$set = _getWrappedset();

      markNeedsUpdate();

      initiateReactionsForVariable('set', oldValue, newValue);
    }
  }

  bool _$setWithMutatorsGate = false;

  ReactiveSet<int> _getWrappedsetWithMutators() {
    _$setWithMutatorsGate = true;

    final result = this.setWithMutators.wrap<int>(
      controller: this,
      variableName: 'setWithMutators',
      disableReactions: false,
      dataSafeMutations: false,
      mutators: [IntMockMutator()],
    );

    _$setWithMutatorsGate = false;

    return result;
  }

  late ReactiveSet<int> _$setWithMutators = _getWrappedsetWithMutators();

  @override
  get setWithMutators {
    if (!_$setWithMutatorsGate) {
      return _$setWithMutators;
    } else {
      return super.setWithMutators;
    }
  }

  @override
  set setWithMutators(ReactiveSet<int> newValue) {
    if (setWithMutators != newValue) {
      var oldValue = setWithMutators;
      super.setWithMutators = newValue;
      _$setWithMutators = _getWrappedsetWithMutators();

      markNeedsUpdate();

      initiateReactionsForVariable('setWithMutators', oldValue, newValue);
    }
  }

  bool _$mapGate = false;

  ReactiveMap<num, String> _getWrappedmap() {
    _$mapGate = true;

    final result = this.map.wrap<num, String>(
          controller: this,
          variableName: 'map',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$mapGate = false;

    return result;
  }

  late ReactiveMap<num, String> _$map = _getWrappedmap();

  @override
  get map {
    if (!_$mapGate) {
      return _$map;
    } else {
      return super.map;
    }
  }

  @override
  set map(ReactiveMap<num, String> newValue) {
    if (map != newValue) {
      var oldValue = map;
      super.map = newValue;
      _$map = _getWrappedmap();

      markNeedsUpdate();

      initiateReactionsForVariable('map', oldValue, newValue);
    }
  }

  bool _$mapWithMutatorsGate = false;

  ReactiveMap<num, String> _getWrappedmapWithMutators() {
    _$mapWithMutatorsGate = true;

    final result = this.mapWithMutators.wrap<num, String>(
      controller: this,
      variableName: 'mapWithMutators',
      disableReactions: false,
      dataSafeMutations: false,
      mutators: [StringMockMutator()],
    );

    _$mapWithMutatorsGate = false;

    return result;
  }

  late ReactiveMap<num, String> _$mapWithMutators =
      _getWrappedmapWithMutators();

  @override
  get mapWithMutators {
    if (!_$mapWithMutatorsGate) {
      return _$mapWithMutators;
    } else {
      return super.mapWithMutators;
    }
  }

  @override
  set mapWithMutators(ReactiveMap<num, String> newValue) {
    if (mapWithMutators != newValue) {
      var oldValue = mapWithMutators;
      super.mapWithMutators = newValue;
      _$mapWithMutators = _getWrappedmapWithMutators();

      markNeedsUpdate();

      initiateReactionsForVariable('mapWithMutators', oldValue, newValue);
    }
  }
}
