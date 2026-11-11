import 'package:fleetzen/domain/telemetry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rules = TelemetryRules();
  final now = DateTime.utc(2026, 11, 8, 8);
  final fresh = TelemetryPoint(
    vehicleId: 'van-12',
    lat: 1,
    lng: 2,
    speedKph: 90,
    sentAt: now.subtract(const Duration(seconds: 30)),
  );

  test('stale points and speed alerts', () {
    expect(rules.overSpeed(fresh), isTrue);
    expect(rules.isStale(fresh, now), isFalse);
    expect(
      rules.isStale(
        TelemetryPoint(
          vehicleId: 'van-12',
          lat: 1,
          lng: 2,
          speedKph: 10,
          sentAt: now.subtract(const Duration(minutes: 5)),
        ),
        now,
      ),
      isTrue,
    );
  });

  test('duplicate timestamps collapse', () {
    expect(rules.dedupe([fresh, fresh]).length, 1);
  });
}
