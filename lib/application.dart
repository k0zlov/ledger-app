import 'package:flutter/cupertino.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemRed,
        child: SizedBox(),
      ),
    );
  }
}
