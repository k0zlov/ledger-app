import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class TransactionNoteSection extends StatelessWidget {
  const TransactionNoteSection({
    required this.isEditing,
    required this.noteController,
    super.key,
  });

  final bool isEditing;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    if (!isEditing && noteController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;

    return CupertinoListSection.insetGrouped(
      header: Text(
        l10n.note,
        style: const TextStyle(
          fontSize: 13,
          color: CupertinoColors.systemGrey,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        if (isEditing)
          CupertinoTextField(
            controller: noteController,
            placeholder: l10n.addNote,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
            ),
            maxLines: null,
            clearButtonMode: OverlayVisibilityMode.editing,
          )
        else
          CupertinoListTile(
            title: Text(
              noteController.text,
              style: const TextStyle(color: CupertinoColors.label),
              maxLines: null,
            ),
          ),
      ],
    );
  }
}
