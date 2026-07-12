import 'package:flutter/cupertino.dart';

class ListSection extends StatelessWidget {
  const ListSection({
    required this.children,
    this.title,
    super.key,
  });

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: title == null
          ? null
          : Text(
              title!.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
      children: children,
    );
  }
}
