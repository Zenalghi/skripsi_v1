class BmsState {
  BmsState({
    required this.socEKF,
    required this.socCC,
    required this.socKF,
    required this.soh,
    required this.totalVoltage,
    required this.current,
    required this.power,
    required this.tempMos,
    required List<double> cellVoltages,
    required this.isBalancing,
    required List<bool> relayStates,
  }) : assert(cellVoltages.length == 8),
       assert(relayStates.length == 4),
       cellVoltages = List<double>.of(cellVoltages),
       relayStates = List<bool>.of(relayStates);

  factory BmsState.initial() {
    const cellVoltages = <double>[
      3.32,
      3.31,
      3.34,
      3.30,
      3.33,
      3.31,
      3.35,
      3.32,
    ];

    const totalVoltage = 26.58;

    return BmsState(
      socEKF: 82.4,
      socCC: 81.9,
      socKF: 82.1,
      soh: 96.8,
      totalVoltage: totalVoltage,
      current: 4.2,
      power: totalVoltage * 4.2,
      tempMos: 34.6,
      cellVoltages: cellVoltages,
      isBalancing: false,
      relayStates: <bool>[false, false, false, false],
    );
  }

  final double socEKF;
  final double socCC;
  final double socKF;
  final double soh;
  final double totalVoltage;
  final double current;
  final double power;
  final double tempMos;
  final List<double> cellVoltages;
  final bool isBalancing;
  final List<bool> relayStates;

  BmsState copyWith({
    double? socEKF,
    double? socCC,
    double? socKF,
    double? soh,
    double? totalVoltage,
    double? current,
    double? power,
    double? tempMos,
    List<double>? cellVoltages,
    bool? isBalancing,
    List<bool>? relayStates,
  }) {
    return BmsState(
      socEKF: socEKF ?? this.socEKF,
      socCC: socCC ?? this.socCC,
      socKF: socKF ?? this.socKF,
      soh: soh ?? this.soh,
      totalVoltage: totalVoltage ?? this.totalVoltage,
      current: current ?? this.current,
      power: power ?? this.power,
      tempMos: tempMos ?? this.tempMos,
      cellVoltages: cellVoltages ?? this.cellVoltages,
      isBalancing: isBalancing ?? this.isBalancing,
      relayStates: relayStates ?? this.relayStates,
    );
  }
}
