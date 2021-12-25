import 'dart:async';

import 'controller.dart';

class NexusAsyncAction {
  final NexusController _controllerInstance;

  NexusAsyncAction(this._controllerInstance);

  Zone? _zoneField;

  Zone get _zone {
    if (_zoneField == null) {
      final spec = ZoneSpecification(
        run: _run,
        runUnary: _runUnary,
      );
      _zoneField = Zone.current.fork(specification: spec);
    }

    return _zoneField!;
  }

  Future<R> run<R>(Future<R> Function() body) async {
    try {
      final result = await _zone.run(body);

      return result;
    } finally {
      await Future.microtask(_nullOperation);
    }
  }

  static dynamic _nullOperation() => null;

  R _run<R>(Zone self, ZoneDelegate parent, Zone zone, R Function() f) {
    try {
      final result = parent.run(zone, f);

      return result;
    } finally {
      if(_controllerInstance.dirty)
        _controllerInstance.update();
    }
  }

  R _runUnary<R, A>(
      Zone self, ZoneDelegate parent, Zone zone, R Function(A a) f, A a) {
    try {
      final result = parent.runUnary(zone, f, a);
      return result;
    } finally {
      if(_controllerInstance.dirty)
        _controllerInstance.update();
    }
  }
}