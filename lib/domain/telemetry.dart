class TelemetryPoint {
  const TelemetryPoint({
    required this.vehicleId,
    required this.lat,
    required this.lng,
    required this.speedKph,
    required this.sentAt,
  });

  final String vehicleId;
  final double lat;
  final double lng;
  final double speedKph;
  final DateTime sentAt;
}

class TelemetryRules {
  const TelemetryRules();

  static const speedLimit = 80.0;

  bool isStale(TelemetryPoint point, DateTime now) =>
      now.difference(point.sentAt) > const Duration(minutes: 2);

  bool overSpeed(TelemetryPoint point) => point.speedKph > speedLimit;

  List<TelemetryPoint> dedupe(List<TelemetryPoint> points) {
    final seen = <String>{};
    final kept = <TelemetryPoint>[];
    for (final point in points) {
      final key = '${point.vehicleId}-${point.sentAt.toIso8601String()}';
      if (seen.add(key)) kept.add(point);
    }
    return kept;
  }
}
