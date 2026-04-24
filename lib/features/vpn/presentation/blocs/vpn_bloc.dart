import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../../../../core/models/app_config.dart';

// Events
abstract class VpnEvent {}

class ConnectVpnEvent extends VpnEvent {
  final String? country;
  ConnectVpnEvent({this.country});
}

class DisconnectVpnEvent extends VpnEvent {}

class AutoConnectVpnEvent extends VpnEvent {}

// States
abstract class VpnState {}

class VpnDisconnected extends VpnState {}

class VpnConnecting extends VpnState {}

class VpnConnected extends VpnState {
  final String country;
  VpnConnected(this.country);
}

// BLoC
class VpnBloc extends Bloc<VpnEvent, VpnState> {
  final List<String> _optimalCountries = [
    'Netherlands',
    'USA',
    'Germany',
    'Japan',
    'UK'
  ];

  VpnBloc() : super(VpnDisconnected()) {
    on<ConnectVpnEvent>((event, emit) async {
      emit(VpnConnecting());
      // Simulate connection time
      await Future.delayed(const Duration(seconds: 2));
      final selectedCountry = event.country ??
          _optimalCountries[Random().nextInt(_optimalCountries.length)];
      await _saveConfig(selectedCountry);
      emit(VpnConnected(selectedCountry));
    });

    on<AutoConnectVpnEvent>((event, emit) async {
      emit(VpnConnecting());
      await Future.delayed(
          const Duration(seconds: 1)); // Quick optimal selection
      final bestCountry =
          _optimalCountries[Random().nextInt(_optimalCountries.length)];
      await _saveConfig(bestCountry);
      emit(VpnConnected(bestCountry));
    });

    on<DisconnectVpnEvent>((event, emit) async {
      await _saveConfig('');
      emit(VpnDisconnected());
    });
  }

  Future<void> _saveConfig(String country) async {
    final box = await Hive.openBox<AppConfig>('app_config');
    final config = box.get('config') ?? AppConfig();
    config.isVpnEnabled = country.isNotEmpty;
    config.lastConnectedCountry = country;
    await box.put('config', config);
  }
}
