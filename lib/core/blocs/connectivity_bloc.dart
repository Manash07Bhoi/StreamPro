import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../services/connectivity_service.dart';

// Events
abstract class ConnectivityEvent extends Equatable {}

class StartMonitoring extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  ConnectivityChanged(this.isConnected);
  @override
  List<Object> get props => [isConnected];
}

// States
abstract class ConnectivityState extends Equatable {}

class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityOnline extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityOffline extends ConnectivityState {
  @override
  List<Object> get props => [];
}

// BLoC
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _service;
  StreamSubscription? _subscription;

  ConnectivityBloc(this._service) : super(ConnectivityInitial()) {
    on<StartMonitoring>((event, emit) async {
      final initial = await _service.checkConnectivity();
      add(ConnectivityChanged(!initial.contains(ConnectivityResult.none)));

      _subscription = _service.onConnectivityChanged.listen((results) {
        add(ConnectivityChanged(!results.contains(ConnectivityResult.none)));
      });
    });

    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
