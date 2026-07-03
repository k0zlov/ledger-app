import 'dart:async';

import 'package:flutter/material.dart';

class NavigationRefreshStream extends ChangeNotifier {
  NavigationRefreshStream({required Stream<dynamic> stream}) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  StreamSubscription<dynamic>? _subscription;

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    super.dispose();
  }
}
