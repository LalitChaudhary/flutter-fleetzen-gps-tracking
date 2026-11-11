import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/telemetry.dart';

class FleetState extends Equatable {
  const FleetState({
    this.signedIn = false,
    this.points = const [],
    this.error,
  });

  final bool signedIn;
  final List<TelemetryPoint> points;
  final String? error;

  @override
  List<Object?> get props => [signedIn, points, error];
}

class FleetCubit extends Cubit<FleetState> {
  FleetCubit() : super(const FleetState());

  void signIn(String email, String password) {
    if (email.trim() == 'dispatch@fleetzen.dev' && password == 'demo1234') {
      emit(const FleetState(signedIn: true));
    } else {
      emit(state.copyWithError('Use the dispatch demo account.'));
    }
  }

  void ingest(List<TelemetryPoint> incoming) {
    final merged =
        const TelemetryRules().dedupe([...state.points, ...incoming]);
    emit(FleetState(signedIn: state.signedIn, points: merged));
  }

  void loadSample() {
    final start = DateTime.utc(2026, 11, 8, 6, 0);
    ingest([
      TelemetryPoint(
        vehicleId: 'van-12',
        lat: 19.07,
        lng: 72.87,
        speedKph: 42,
        sentAt: start,
      ),
      TelemetryPoint(
        vehicleId: 'van-12',
        lat: 19.08,
        lng: 72.88,
        speedKph: 88,
        sentAt: start.add(const Duration(minutes: 5)),
      ),
    ]);
  }
}

extension on FleetState {
  FleetState copyWithError(String message) =>
      FleetState(signedIn: signedIn, points: points, error: message);
}
