import 'package:flutter/material.dart';

import '../models/bms_state.dart';
import '../widgets/relay_control_card.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({
    super.key,
    required this.state,
    required this.onRelayToggle,
  });

  final BmsState state;
  final void Function(int index, bool value) onRelayToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Hardware Control',
            subtitle: 'Relay outputs and connectivity status',
          ),
          const SizedBox(height: 16),
          _ConnectivityRow(state: state),
          const SizedBox(height: 16),
          RelayControlCard(
            relayStates: state.relayStates,
            onRelayChanged: onRelayToggle,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _ConnectivityRow extends StatelessWidget {
  const _ConnectivityRow({required this.state});

  final BmsState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatusPill(label: 'MQTT OK', color: Color(0xFF2E7D32)),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatusPill(label: 'FB SYNC', color: Color(0xFFFFC107)),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
