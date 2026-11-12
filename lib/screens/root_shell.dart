import 'package:flutter/material.dart';

import '../services/app_state.dart';
import 'home_screen.dart';
import 'practice_screen.dart';
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

  void _open(int target) => setState(() => index = target);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final screens = [
          HomeScreen(
            state: widget.state,
            onOpenRoadmap: () => _open(1),
            onOpenReview: () => _open(2),
            onOpenPractice: () => _open(3),
          ),
          RoadmapScreen(state: widget.state),
          ReviewScreen(state: widget.state),
          PracticeScreen(state: widget.state),
        ];
        return Scaffold(
          body: IndexedStack(index: index, children: screens),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: _open,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Belajar',
              ),
              const NavigationDestination(
                icon: Icon(Icons.route_outlined),
                selectedIcon: Icon(Icons.route_rounded),
                label: 'Roadmap',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: widget.state.dueCount > 0,
                  label: Text('${widget.state.dueCount}'),
                  child: const Icon(Icons.style_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: widget.state.dueCount > 0,
                  label: Text('${widget.state.dueCount}'),
                  child: const Icon(Icons.style_rounded),
                ),
                label: 'Review',
              ),
              const NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Latihan',
              ),
            ],
          ),
        );
      },
    );
  }
}
