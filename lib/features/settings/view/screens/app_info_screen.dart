import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({
    required this.appName,
    required this.version,
    required this.buildNumber,
    this.developer,
    super.key,
  });

  final String appName;
  final String version;
  final String buildNumber;
  final String? developer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.appInfo),
        previousPageTitle: l10n.backButton,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 48),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.circular(22),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 140),
              child: const Center(
                child: Icon(
                  CupertinoIcons.square_stack_3d_up_fill,
                  size: 50,
                  color: CupertinoColors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ListSection(
              children: [
                CupertinoListTile(
                  title: Text(l10n.version),
                  additionalInfo: Text(version),
                ),
                CupertinoListTile(
                  title: Text(l10n.build),
                  additionalInfo: Text(buildNumber),
                ),
                if (developer != null)
                  CupertinoListTile(
                    title: Text(l10n.developer),
                    additionalInfo: Text(developer!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
