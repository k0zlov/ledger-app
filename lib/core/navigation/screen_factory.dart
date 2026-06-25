import 'package:flutter/widgets.dart';
import 'package:ledger_app/application.dart';

abstract class ScreenFactory {
  static Widget renderApplication() {
    return const Application();
  }
}
