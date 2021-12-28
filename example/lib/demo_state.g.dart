// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_state.dart';

// **************************************************************************
// NexusGenerator
// **************************************************************************

mixin _$DemoStateBaseMixin on DemoStateBase, NexusController {
  @override
  set _counter(int newValue) {
    if (_counter != newValue) {
      var oldValue = _counter;
      super._counter = newValue;

      markNeedsUpdate();

      initiateReactionsForVariable('_counter', oldValue, newValue);
    }
  }

  @override
  set flag(bool newValue) {
    if (flag != newValue) {
      var oldValue = flag;
      super.flag = newValue;

      markNeedsUpdate();

      initiateReactionsForVariable('flag', oldValue, newValue);
    }
  }

  bool _$intListGate = false;

  ReactiveList<int> _getWrappedintList() {
    _$intListGate = true;

    final result = this.intList.wrap<int>(
        controller: this, variableName: 'intList', disableReactions: true);

    _$intListGate = false;

    return result;
  }

  late ReactiveList<int> _$intList = _getWrappedintList();

  @override
  get intList => !_$intListGate ? _$intList : super.intList;

  @override
  set intList(ReactiveList<int> newValue) {
    if (intList != newValue) {
      var oldValue = intList;
      super.intList = newValue;
      _$intList = _getWrappedintList();

      markNeedsUpdate();

      initiateReactionsForVariable('intList', oldValue, newValue);
    }
  }

  bool _$stringListGate = false;

  ReactiveSet<String> _getWrappedstringList() {
    _$stringListGate = true;

    final result = this.stringList.wrap<String>(
        controller: this, variableName: 'stringList', disableReactions: false);

    _$stringListGate = false;

    return result;
  }

  late ReactiveSet<String> _$stringList = _getWrappedstringList();

  @override
  get stringList => !_$stringListGate ? _$stringList : super.stringList;

  @override
  set stringList(ReactiveSet<String> newValue) {
    if (stringList != newValue) {
      var oldValue = stringList;
      super.stringList = newValue;
      _$stringList = _getWrappedstringList();

      markNeedsUpdate();

      initiateReactionsForVariable('stringList', oldValue, newValue);
    }
  }

  bool _$mapGate = false;

  ReactiveMap<String, ReactiveMap<String, int>> _getWrappedmap() {
    _$mapGate = true;

    final result = this.map.wrap<String, ReactiveMap<String, int>>(
        controller: this, variableName: 'map', disableReactions: false);

    _$mapGate = false;

    return result;
  }

  late ReactiveMap<String, ReactiveMap<String, int>> _$map = _getWrappedmap();

  @override
  get map => !_$mapGate ? _$map : super.map;

  @override
  set map(ReactiveMap<String, ReactiveMap<String, int>> newValue) {
    if (map != newValue) {
      var oldValue = map;
      super.map = newValue;
      _$map = _getWrappedmap();

      markNeedsUpdate();

      initiateReactionsForVariable('map', oldValue, newValue);
    }
  }

  @override
  void increment(int value) {
    return performAction(() => super.increment(value));
  }
}
