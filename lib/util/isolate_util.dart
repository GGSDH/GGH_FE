import 'dart:isolate';

import 'package:flutter/services.dart';

Future<dynamic> computeIsolate<T, R>(Future<R> Function(T) function, T param) async {
  final receivePort = ReceivePort();
  var rootToken = RootIsolateToken.instance!;

  await Isolate.spawn<_IsolateData<T, R>>(
    _isolateEntry,
    _IsolateData<T, R>(
      token: rootToken,
      function: function,
      param: param,
      answerPort: receivePort.sendPort,
    ),
  );

  return await receivePort.first;
}

void _isolateEntry<T, R>(_IsolateData<T, R> isolateData) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
  final answer = await isolateData.function(isolateData.param);
  isolateData.answerPort.send(answer);
}

class _IsolateData<T, R> {
  final RootIsolateToken token;
  final Future<R> Function(T) function;
  final T param;
  final SendPort answerPort;

  _IsolateData({
    required this.token,
    required this.function,
    required this.param,
    required this.answerPort,
  });
}
