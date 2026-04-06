import 'package:flutter/material.dart';

import '../models/bms_state.dart';
import 'analytics_screen.dart';
import 'control_screen.dart';
import 'metrics_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    required this.stateStream,
    required this.onRelayToggle,
  });

  final Stream<BmsState> stateStream;
  final void Function(int index, bool value) onRelayToggle;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BmsState>(
      stream: widget.stateStream,
      initialData: BmsState.initial(),
      builder: (context, snapshot) {
        final state = snapshot.data ?? BmsState.initial();

        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                MetricsScreen(state: state),
                AnalyticsScreen(state: state),
                ControlScreen(
                  state: state,
                  onRelayToggle: widget.onRelayToggle,
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            height: 72,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.bolt_outlined),
                selectedIcon: Icon(Icons.bolt),
                label: 'Metrics',
              ),
              NavigationDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: 'Analytics',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_remote_outlined),
                selectedIcon: Icon(Icons.settings_remote),
                label: 'Control',
              ),
            ],
          ),
        );
      },
    );
  }
}
