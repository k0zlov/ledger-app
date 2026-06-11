import 'package:flutter/material.dart';
import 'package:ledger_app/application.dart';
import 'package:ledger_app/di_container.dart';

void main() async {
  await registerDependencies();

  runApp(const Application());
}
