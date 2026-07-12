import 'package:flutter/cupertino.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';
import 'package:ledger_app/core/view/widgets/list_section.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({
    required this.githubNickname,
    required this.githubUrl,
    required this.avatarUrl,
    super.key,
  });

  final String githubNickname;
  final String githubUrl;
  final String avatarUrl;

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(githubUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.helpSupport),
        previousPageTitle: l10n.settings,
      ),
      child: SafeArea(
        child: ListView(
          children: [
            ListSection(
              title: l10n.developer,
              children: [
                CupertinoListTile(
                  leadingSize: 44,
                  leading: ClipOval(
                    child: Image.network(
                      avatarUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          CupertinoIcons.person_circle_fill,
                          size: 44,
                          color: CupertinoColors.systemGrey,
                        );
                      },
                    ),
                  ),
                  title: Text(githubNickname),
                  subtitle: Text(githubUrl),
                  trailing: const CupertinoListTileChevron(),
                  onTap: _launchUrl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
