class OrientationData {
  final double pitch;
  final double roll;
  final double yaw; // azimut magnétique corrigé
  final double altitude; // angle au-dessus de l’horizon

  OrientationData({
    required this.pitch,
    required this.roll,
    required this.yaw,
    required this.altitude,
  });

  Map<String, dynamic> toJson() => {
    'pitch_deg': pitch,
    'roll_deg': roll,
    'yaw_deg': yaw,
    'altitude_deg': altitude,
  };
}
