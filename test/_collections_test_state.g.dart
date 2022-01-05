// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_collections_test_state.dart';

// **************************************************************************
// NexusGenerator
// **************************************************************************

mixin _$DemoStateBaseMixin on DemoStateBase, NexusController {
  bool _$listGate = false;

  ReactiveList<int> _getWrappedlist() {
    _$listGate = true;

    final result = this.list.wrap<int>(
          controller: this,
          variableName: 'list',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$listGate = false;

    return result;
  }

  late ReactiveList<int> _$list = _getWrappedlist();

  @override
  get list {
    if (!_$listGate) {
      return _$list;
    } else {
      return super.list;
    }
  }

  @override
  set list(ReactiveList<int> newValue) {
    if (list != newValue) {
      var oldValue = list;
      super.list = newValue;
      _$list = _getWrappedlist();

      markNeedsUpdate();

      initiateReactionsForVariable('list', oldValue, newValue);
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

  bool _$mapGate = false;

  ReactiveMap<int, String> _getWrappedmap() {
    _$mapGate = true;

    final result = this.map.wrap<int, String>(
          controller: this,
          variableName: 'map',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$mapGate = false;

    return result;
  }

  late ReactiveMap<int, String> _$map = _getWrappedmap();

  @override
  get map {
    if (!_$mapGate) {
      return _$map;
    } else {
      return super.map;
    }
  }

  @override
  set map(ReactiveMap<int, String> newValue) {
    if (map != newValue) {
      var oldValue = map;
      super.map = newValue;
      _$map = _getWrappedmap();

      markNeedsUpdate();

      initiateReactionsForVariable('map', oldValue, newValue);
    }
  }
}
