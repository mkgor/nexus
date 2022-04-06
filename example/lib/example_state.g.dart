// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_state.dart';

// **************************************************************************
// NexusGenerator
// **************************************************************************

class ExampleStateBaseProperties {
  static const $_counter = '_counter';
  static const flag = 'flag';
  static const intList = 'intList';
  static const stringList = 'stringList';
  static const reactiveUser = 'reactiveUser';
  static const fullName = 'fullName';
  static const map = 'map';
}

mixin _$ExampleStateBaseMixin on ExampleStateBase, NexusController {
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
          controller: this,
          variableName: 'intList',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$intListGate = false;

    return result;
  }

  late ReactiveList<int> _$intList = _getWrappedintList();

  @override
  get intList {
    if (!_$intListGate) {
      return _$intList;
    } else {
      return super.intList;
    }
  }

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
          controller: this,
          variableName: 'stringList',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$stringListGate = false;

    return result;
  }

  late ReactiveSet<String> _$stringList = _getWrappedstringList();

  @override
  get stringList {
    if (!_$stringListGate) {
      return _$stringList;
    } else {
      return super.stringList;
    }
  }

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

  @override
  set reactiveUser(dynamic newValue) {
    if (reactiveUser != newValue) {
      var oldValue = reactiveUser;
      super.reactiveUser = newValue;

      markNeedsUpdate();

      initiateReactionsForVariable('reactiveUser', oldValue, newValue);
    }
  }

  @override
  set fullName(String newValue) {
    if (fullName != newValue) {
      var oldValue = fullName;
      super.fullName = newValue;

      markNeedsUpdate();

      initiateReactionsForVariable('fullName', oldValue, newValue);
    }
  }

  @override
  get fullName {
    var result = super.fullName;

    /// Mutators
    result = LastNameMutator().mutate(result);

    /// Guards

    return result;
  }

  bool _$mapGate = false;

  ReactiveMap<String, ReactiveMap<String, int>> _getWrappedmap() {
    _$mapGate = true;

    final result = this.map.wrap<String, ReactiveMap<String, int>>(
          controller: this,
          variableName: 'map',
          disableReactions: false,
          dataSafeMutations: true,
        );

    _$mapGate = false;

    return result;
  }

  late ReactiveMap<String, ReactiveMap<String, int>> _$map = _getWrappedmap();

  @override
  get map {
    if (!_$mapGate) {
      return _$map;
    } else {
      return super.map;
    }
  }

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
  Future<dynamic> increment(int value) async {
    return performAsyncAction<dynamic>(() => super.increment(value));
  }
}
