import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/video_entity.dart';

// Events
abstract class PipEvent extends Equatable {}

class ActivatePip extends PipEvent {
  final VideoEntity video;
  final int currentSeconds;
  ActivatePip(this.video, this.currentSeconds);
  @override
  List<Object> get props => [video.id, currentSeconds];
}

class DeactivatePip extends PipEvent {
  @override
  List<Object> get props => [];
}

class ReturnToFullscreen extends PipEvent {
  @override
  List<Object> get props => [];
}

class PipProgressUpdated extends PipEvent {
  final int currentSeconds;
  PipProgressUpdated(this.currentSeconds);
  @override
  List<Object> get props => [currentSeconds];
}

// States
abstract class PipState extends Equatable {}

class PipInactive extends PipState {
  @override
  List<Object> get props => [];
}

class PipActive extends PipState {
  final VideoEntity video;
  final int currentSeconds;
  final bool isMinimized;

  PipActive(
      {required this.video,
      required this.currentSeconds,
      this.isMinimized = false});

  @override
  List<Object> get props => [video.id, currentSeconds, isMinimized];
}

// BLoC
class PipBloc extends Bloc<PipEvent, PipState> {
  PipBloc() : super(PipInactive()) {
    on<ActivatePip>((event, emit) {
      emit(PipActive(
          video: event.video,
          currentSeconds: event.currentSeconds,
          isMinimized: true));
    });

    on<DeactivatePip>((event, emit) {
      emit(PipInactive());
    });

    on<ReturnToFullscreen>((event, emit) {
      // Typically we'd emit inactive, and the UI reacts by pushing the player route again
      emit(PipInactive());
    });

    on<PipProgressUpdated>((event, emit) {
      if (state is PipActive) {
        final current = state as PipActive;
        emit(PipActive(
            video: current.video,
            currentSeconds: event.currentSeconds,
            isMinimized: current.isMinimized));
      }
    });
  }
}
