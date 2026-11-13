import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../services/haptics.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';
import 'review_screen.dart';
import 'roadmap_screen.dart';

class RootShell extends StatefulWidget {
  final AppState state;
  const RootShell({super.key, required this.state});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int index = 0;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: widget.state.refreshTimeSensitive,
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _open(int target) {
    if (target == index) return;
    Haptics.selection();
    setState(() => index = target);
  }

  void _openPractice() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PracticeScreen(state: widget.state)),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors.apply(Theme.of(context).brightness);
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final screens = [
          HomeScreen(
            state: widget.state,
            onOpenReview: () => _open(2),
            onOpenPractice: _openPractice,
            onOpenProfile: () => _open(3),
          ),
          RoadmapScreen(state: widget.state, onProfile: () => _open(3)),
          ReviewScreen(state: widget.state, onProfile: () => _open(3)),
          ProfileScreen(state: widget.state),
        ];
        return Scaffold(
          body: IndexedStack(index: index, children: screens),
          bottomNavigationBar: _BottomNav(
            index: index,
            dueCount: widget.state.dueCount,
            onSelect: _open,
          ),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final int dueCount;
  final ValueChanged<int> onSelect;
  const _BottomNav({
    required this.index,
    required this.dueCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, 'Hari Ini'),
      (Icons.map_outlined, Icons.map_rounded, 'Kurikulum'),
      (Icons.layers_outlined, Icons.layers_rounded, 'Review'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: AppColors.isLight ? 0.06 : 0.22,
            ),
            blurRadius: 18,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: items[i].$1,
                    selectedIcon: items[i].$2,
                    label: items[i].$3,
                    selected: index == i,
                    badge: i == 2 ? dueCount : 0,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final int badge;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.muted;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(selected ? selectedIcon : icon, size: 23, color: color),
                if (badge > 0)
                  Positioned(
                    right: -9,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      constraints: const BoxConstraints(minWidth: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
