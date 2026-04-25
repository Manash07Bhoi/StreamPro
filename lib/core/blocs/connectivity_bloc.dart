import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Events
abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override List<Object> get props => [];
}

class StartMonitoring extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  const ConnectivityChanged(this.isConnected);
  @override List<Object> get props => [isConnected];
}

// States
abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
  @override List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}
class ConnectivityOnline extends ConnectivityState {}
class ConnectivityOffline extends ConnectivityState {}

// Bloc
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<StartMonitoring>((event, emit) async {
       final results = await _connectivity.checkConnectivity();
       final isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
       emit(isConnected ? ConnectivityOnline() : ConnectivityOffline());

       _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> listenResults) {
          final connected = listenResults.isNotEmpty && listenResults.first != ConnectivityResult.none;
          add(ConnectivityChanged(connected));
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
}
