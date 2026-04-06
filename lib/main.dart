import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'models/bms_state.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamController<BmsState> _controller;
  Timer? _timer;
  final Random _random = Random();
  BmsState _state = BmsState.initial();

  @override
  void initState() {
    super.initState();
    _controller = StreamController<BmsState>.broadcast();
    _controller.add(_state);
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _state = _nextState(_state);
      _controller.add(_state);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
    super.dispose();
  }

  void _handleRelayToggle(int index, bool value) {
    _state = _state.copyWith(
      relayStates: List<bool>.generate(
        _state.relayStates.length,
        (itemIndex) =>
            itemIndex == index ? value : _state.relayStates[itemIndex],
      ),
    );
    _controller.add(_state);
  }

  BmsState _nextState(BmsState previous) {
    final nextCellVoltages = previous.cellVoltages
        .map((voltage) => _clamp(voltage + _jitter(0.01), 3.0, 3.65))
        .toList(growable: false);

    final totalVoltage = nextCellVoltages.fold<double>(
      0,
      (sum, value) => sum + value,
    );
    final baseSoc = _clamp(previous.socEKF + _jitter(0.1), 8.0, 100.0);
    final baseSoh = _clamp(previous.soh + _jitter(0.04), 75.0, 100.0);
    final current = _clamp(previous.current + _jitter(0.45), -18.0, 18.0);
    final tempMos = _clamp(previous.tempMos + _jitter(0.2), 24.0, 58.0);
    final isBalancing =
        totalVoltage > 27.1 || (_random.nextBool() && previous.isBalancing);

    return previous.copyWith(
      socEKF: baseSoc,
      socCC: _clamp(baseSoc + _jitter(0.25), 0.0, 100.0),
      socKF: _clamp(baseSoc + _jitter(0.12), 0.0, 100.0),
      soh: baseSoh,
      totalVoltage: totalVoltage,
      current: current,
      power: totalVoltage * current,
      tempMos: tempMos,
      cellVoltages: nextCellVoltages,
      isBalancing: isBalancing,
    );
  }

  double _jitter(double delta) => (_random.nextDouble() * 2 - 1) * delta;

  double _clamp(double value, double min, double max) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMART BMS IoT',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BCD4),
          brightness: Brightness.dark,
          surface: const Color(0xFF1A1A1A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1A1A),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: MainNavigation(
        stateStream: _controller.stream,
        onRelayToggle: _handleRelayToggle,
      ),
    );
  }
}
