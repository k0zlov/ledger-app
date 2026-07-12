import 'package:flutter/cupertino.dart';

class SelectionItem extends StatelessWidget {
  const SelectionItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(title),
      trailing: isSelected
          ? const Icon(
              CupertinoIcons.checkmark_alt,
              color: CupertinoColors.activeBlue,
            )
          : null,
      onTap: onTap,
    );
  }
}
