// Copyright (c) 2022 Bruno Nova - MIT License
import 'dart:async';

import 'package:flutter/material.dart';

/// Schedules the given [callback] function to run on the next frame.
void onNextFrame(Function(Duration timestamp) callback) {
  WidgetsBinding.instance.addPostFrameCallback(callback);
}

/// Returns a awaitable [Future] that will be completed on the next frame.
Future<void> nextFrame() async {
  var completer = Completer<void>();
  onNextFrame((_) => completer.complete());
  return completer.future;
}
