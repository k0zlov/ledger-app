import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger_app/core/view/extensions/localization_build_context_x.dart';

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          navigationShell,
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context).withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: CupertinoColors.separator.resolveFrom(context).withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavBarItem(
                        icon: CupertinoIcons.settings,
                        activeIcon: CupertinoIcons.settings_solid,
                        label: l10n.settings,
                        isSelected: navigationShell.currentIndex == 0,
                        onTap: () => _onTap(0),
                      ),
                      _NavBarItem(
                        icon: CupertinoIcons.square_grid_2x2,
                        activeIcon: CupertinoIcons.square_grid_2x2_fill,
                        label: l10n.dashboard,
                        isSelected: navigationShell.currentIndex == 1,
                        onTap: () => _onTap(1),
                      ),
                      _NavBarItem(
                        icon: CupertinoIcons.chart_pie,
                        activeIcon: CupertinoIcons.chart_pie_fill,
                        label: l10n.analytics,
                        isSelected: navigationShell.currentIndex == 2,
                        onTap: () => _onTap(2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGrey;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
