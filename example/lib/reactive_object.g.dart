// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactive_object.dart';

// **************************************************************************
// NexusObjectGenerator
// **************************************************************************

class UserAbstractProperties {
  static const name = 'name';
  static const weight = 'weight';
}

mixin _$UserAbstractMixin on UserAbstract, ReactiveObject {
  @override
  set name(String newValue) {
    if (name != newValue) {
      var oldValue = name;
      super.name = newValue;

      controller?.markNeedsUpdate();

      controller?.initiateReactionsForVariable('name', oldValue, newValue);
    }
  }

  @override
  set weight(int newValue) {
    if (weight != newValue) {
      var oldValue = weight;
      super.weight = newValue;

      controller?.markNeedsUpdate();

      controller?.initiateReactionsForVariable('weight', oldValue, newValue);
    }
  }
}
