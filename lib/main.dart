import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/telemetry.dart';
import 'fleet_cubit.dart';

void main() => runApp(const FleetZenApp());

class FleetZenApp extends StatelessWidget {
  const FleetZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FleetCubit(),
      child: MaterialApp(
        title: 'FleetZen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0B3C5D),
            brightness: Brightness.dark,
            primary: const Color(0xFF3DB9E0),
          ),
        ),
        home: const DispatchGate(),
      ),
    );
  }
}

class DispatchGate extends StatelessWidget {
  const DispatchGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FleetCubit, FleetState>(
      builder: (context, state) =>
          state.signedIn ? const MapPage() : const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController(text: 'dispatch@fleetzen.dev');
  final _password = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('FleetZen', style: Theme.of(context).textTheme.headlineMedium),
            const Text(
                'Sample telemetry only. This build does not read device GPS.'),
            const SizedBox(height: 16),
            TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            BlocBuilder<FleetCubit, FleetState>(
              builder: (context, state) => Text(state.error ?? ''),
            ),
            FilledButton(
              onPressed: () => context
                  .read<FleetCubit>()
                  .signIn(_email.text, _password.text),
              child: const Text('Open dispatch'),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FleetCubit, FleetState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sample route')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                  'Markers below are stored sample points, not a live feed.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.read<FleetCubit>().loadSample(),
                child: const Text('Load van-12 sample'),
              ),
              for (final point in state.points)
                ListTile(
                  title: Text(point.vehicleId),
                  subtitle: Text(
                    '${point.lat}, ${point.lng} · ${point.speedKph} km/h'
                    '${const TelemetryRules().overSpeed(point) ? ' · speed alert' : ''}',
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
