import 'package:flutter/material.dart';
import 'package:ledger_app/core/navigation/screen_factory.dart';
import 'package:ledger_app/di_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await registerDependencies();

  runApp(ScreenFactory.renderApplication());
}
