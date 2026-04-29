import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../core/models/video_entity.dart';
import '../../../library/data/repositories/history_repository.dart';
import '../../data/datasources/brightness_channel.dart';
import '../../data/datasources/volume_channel.dart';

// Events
abstract class PlayerEvent extends Equatable {}

class InitializePlayer extends PlayerEvent {
  final VideoEntity video;
  InitializePlayer(this.video);
  @override
  List<Object> get props => [video];
}

class TogglePlayPause extends PlayerEvent {
  @override
  List<Object> get props => [];
}

class SeekTo extends PlayerEvent {
  final int seconds;
  SeekTo(this.seconds);
  @override
  List<Object> get props => [seconds];
}

class SeekDelta extends PlayerEvent {
  final int deltaSeconds;
  SeekDelta(this.deltaSeconds);
  @override
  List<Object> get props => [deltaSeconds];
}

class SetSpeed extends PlayerEvent {
  final double speed;
  SetSpeed(this.speed);
  @override
  List<Object> get props => [speed];
}

class SetBrightness extends PlayerEvent {
  final double brightness;
  SetBrightness(this.brightness);
  @override
  List<Object> get props => [brightness];
}

class SetVolume extends PlayerEvent {
  final double volume;
  SetVolume(this.volume);
  @override
  List<Object> get props => [volume];
}

class ToggleFitMode extends PlayerEvent {
  @override
  List<Object> get props => [];
}

class ShowControls extends PlayerEvent {
  @override
  List<Object> get props => [];
}

class HideControls extends PlayerEvent {
  @override
  List<Object> get props => [];
}

class ToggleControlsVisibility extends PlayerEvent {
  @override
  List<Object> get props => [];
}

class PlayerCompleted extends PlayerEvent {
  @override
  List<Object> get props => [];
}

class UpdateProgress extends PlayerEvent {
  final int currentSeconds;
  UpdateProgress(this.currentSeconds);
  @override
  List<Object> get props => [currentSeconds];
}

// States
abstract class PlayerState extends Equatable {}

class PlayerInitial extends PlayerState {
  @override
  List<Object> get props => [];
}

class PlayerLoading extends PlayerState {
  @override
  List<Object> get props => [];
}

class PlayerReady extends PlayerState {
  final VideoEntity video;
  final bool isPlaying;
  final bool isControlsVisible;
  final int currentSeconds;
  final int totalSeconds;
  final double progressPercent;
  final double speed;
  final double brightness;
  final double volume;
  final bool isFillMode;
  final bool isPipActive;

  PlayerReady({
    required this.video,
    this.isPlaying = true,
    this.isControlsVisible = true,
    this.currentSeconds = 0,
    this.totalSeconds = 0,
    this.progressPercent = 0.0,
    this.speed = 1.0,
    this.brightness = 0.5,
    this.volume = 1.0,
    this.isFillMode = false,
    this.isPipActive = false,
  });

  PlayerReady copyWith({
    bool? isPlaying,
    bool? isControlsVisible,
    int? currentSeconds,
    double? progressPercent,
    double? speed,
    double? brightness,
    double? volume,
    bool? isFillMode,
    bool? isPipActive,
  }) {
    return PlayerReady(
      video: video,
      totalSeconds: totalSeconds,
      isPlaying: isPlaying ?? this.isPlaying,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      currentSeconds: currentSeconds ?? this.currentSeconds,
      progressPercent: progressPercent ?? this.progressPercent,
      speed: speed ?? this.speed,
      brightness: brightness ?? this.brightness,
      volume: volume ?? this.volume,
      isFillMode: isFillMode ?? this.isFillMode,
      isPipActive: isPipActive ?? this.isPipActive,
    );
  }

  @override
  List<Object> get props => [
        video,
        isPlaying,
        isControlsVisible,
        currentSeconds,
        totalSeconds,
        progressPercent,
        speed,
        brightness,
        volume,
        isFillMode,
        isPipActive
      ];
}

class PlayerError extends PlayerState {
  final String message;
  PlayerError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final HistoryRepository _historyRepo;
  final BrightnessChannel _brightnessChannel;
  final VolumeChannel _volumeChannel;
  Timer? _progressTimer;
  Timer? _controlsTimer;

  PlayerBloc(this._historyRepo, this._brightnessChannel, this._volumeChannel) : super(PlayerInitial()) {
    on<InitializePlayer>((event, emit) async {
      emit(PlayerLoading());

      final currentBrightness = await _brightnessChannel.getCurrentBrightness();
      final currentVolume = await _volumeChannel.getCurrentVolume();

      // Setup initial state
      final readyState = PlayerReady(
        video: event.video,
        totalSeconds: event.video.durationSeconds,
        brightness: currentBrightness,
        volume: currentVolume,
      );
      emit(readyState);

      // Start progress simulation since we don't have true callback from iframe
      _startProgressTimer(readyState);
      _resetControlsTimer();
    });

    on<TogglePlayPause>((event, emit) {
      if (state is PlayerReady) {
        final currentState = state as PlayerReady;
        final isPlaying = !currentState.isPlaying;
        emit(currentState.copyWith(isPlaying: isPlaying));

        if (isPlaying) {
          _startProgressTimer(currentState);
        } else {
          _progressTimer?.cancel();
        }
        _resetControlsTimer();
      }
    });

    on<SeekDelta>((event, emit) {
      if (state is PlayerReady) {
        final currentState = state as PlayerReady;
        int newSeconds = currentState.currentSeconds + event.deltaSeconds;
        if (newSeconds < 0) newSeconds = 0;
        if (newSeconds > currentState.totalSeconds) newSeconds = currentState.totalSeconds;

        final progress = currentState.totalSeconds > 0 ? newSeconds / currentState.totalSeconds : 0.0;
        emit(currentState.copyWith(currentSeconds: newSeconds, progressPercent: progress));
        _resetControlsTimer();
      }
    });

    on<SeekTo>((event, emit) {
      if (state is PlayerReady) {
        final currentState = state as PlayerReady;
        int newSeconds = event.seconds;
        if (newSeconds < 0) newSeconds = 0;
        if (newSeconds > currentState.totalSeconds) newSeconds = currentState.totalSeconds;

        final progress = currentState.totalSeconds > 0 ? newSeconds / currentState.totalSeconds : 0.0;
        emit(currentState.copyWith(currentSeconds: newSeconds, progressPercent: progress));
        _resetControlsTimer();
      }
    });

    on<SetSpeed>((event, emit) {
      if (state is PlayerReady) {
        emit((state as PlayerReady).copyWith(speed: event.speed));
      }
    });

    on<SetBrightness>((event, emit) async {
      if (state is PlayerReady) {
        final val = event.brightness.clamp(0.05, 1.0);
        await _brightnessChannel.setBrightness(val);
        emit((state as PlayerReady).copyWith(brightness: val));
        _resetControlsTimer();
      }
    });

    on<SetVolume>((event, emit) async {
      if (state is PlayerReady) {
        final val = event.volume.clamp(0.0, 1.0);
        await _volumeChannel.setVolume(val);
        emit((state as PlayerReady).copyWith(volume: val));
        _resetControlsTimer();
      }
    });

    on<ToggleFitMode>((event, emit) {
      if (state is PlayerReady) {
        emit((state as PlayerReady).copyWith(isFillMode: !(state as PlayerReady).isFillMode));
      }
    });

    on<ShowControls>((event, emit) {
      if (state is PlayerReady) {
        emit((state as PlayerReady).copyWith(isControlsVisible: true));
        _resetControlsTimer();
      }
    });

    on<HideControls>((event, emit) {
      if (state is PlayerReady) {
        emit((state as PlayerReady).copyWith(isControlsVisible: false));
      }
    });

    on<ToggleControlsVisibility>((event, emit) {
      if (state is PlayerReady) {
        final isVisible = !(state as PlayerReady).isControlsVisible;
        emit((state as PlayerReady).copyWith(isControlsVisible: isVisible));
        if (isVisible) {
          _resetControlsTimer();
        } else {
          _controlsTimer?.cancel();
        }
      }
    });

    on<UpdateProgress>((event, emit) async {
      if (state is PlayerReady) {
        final currentState = state as PlayerReady;
        if (currentState.totalSeconds == 0) return;

        final progress = event.currentSeconds / currentState.totalSeconds;

        // Mark as completed if > 90%
        if (progress >= 0.9) {
           await _historyRepo.addOrUpdateHistory(currentState.video.id, watchedDurationSeconds: event.currentSeconds, progressPercent: progress);
        } else if (event.currentSeconds % 5 == 0) { // save every 5s
           await _historyRepo.addOrUpdateHistory(currentState.video.id, watchedDurationSeconds: event.currentSeconds, progressPercent: progress);
        }

        emit(currentState.copyWith(
          currentSeconds: event.currentSeconds,
          progressPercent: progress,
        ));
      }
    });
  }

  void _startProgressTimer(PlayerReady state) {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.state is PlayerReady) {
        final currentState = this.state as PlayerReady;
        if (!currentState.isPlaying) return;

        int nextSeconds = currentState.currentSeconds + (1 * currentState.speed).round();
        if (nextSeconds >= currentState.totalSeconds) {
          nextSeconds = currentState.totalSeconds;
          timer.cancel();
        }
        add(UpdateProgress(nextSeconds));
      }
    });
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      add(HideControls());
    });
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    _controlsTimer?.cancel();
    _brightnessChannel.restoreSystemBrightness();
    return super.close();
  }
}
