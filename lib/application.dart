import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class Application extends StatelessWidget {
  const Application({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
