import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class VpnEvent {}
class ConnectVpnEvent extends VpnEvent {}
class DisconnectVpnEvent extends VpnEvent {}

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
  VpnBloc() : super(VpnDisconnected()) {
    on<ConnectVpnEvent>((event, emit) async {
      emit(VpnConnecting());
      // Simulate connection time
      await Future.delayed(const Duration(seconds: 2));
      emit(VpnConnected('Netherlands'));
    });

    on<DisconnectVpnEvent>((event, emit) async {
      emit(VpnDisconnected());
    });
  }
}
