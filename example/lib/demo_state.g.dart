// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_state.dart';

// **************************************************************************
// NexusGenerator
// **************************************************************************

mixin _$DemoStateBaseMixin on DemoStateBase, NexusController {
  @override
  set counter(int newValue) {
    if (counter != newValue) {
      var oldValue = counter;
      super.counter = newValue;

      markNeedsUpdate();

      initiateReactionsForVariable('counter', oldValue, newValue);
    }
  }

  @override
  set flag(bool newValue) {
    if (flag != newValue) {
      var oldValue = flag;
      super.flag = newValue;

      markNeedsUpdate();
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

  @override
  void increment(int value) {
    return performAction(() => super.increment(value));
  }
}
