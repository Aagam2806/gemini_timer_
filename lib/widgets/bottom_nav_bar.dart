import 'package:flutter/material.dart';

/// Bottom navigation bar matching the Stitch design with 3 tabs.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.timer_rounded,
                label: 'Timer',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
                colorScheme: cs,
                textTheme: textTheme,
              ),
              _NavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Stats',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
                colorScheme: cs,
                textTheme: textTheme,
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
                colorScheme: cs,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSecondaryContainer;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isSelected ? 1.0 : 0.95,
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon pill
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.secondaryContainer.withValues(alpha: 0.35)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
                fill: isSelected ? 1.0 : 0.0,
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
