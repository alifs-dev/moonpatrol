class DeviceInfo {
  final String model;
  final String manufacturer;
  final String version;

  const DeviceInfo({
    required this.model,
    required this.manufacturer,
    required this.version,
  });

  Map<String, dynamic> toJson() => {
    'model': model,
    'manufacturer': manufacturer,
    'version': version,
  };
}
