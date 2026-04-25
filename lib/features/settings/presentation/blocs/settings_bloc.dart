import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/app_config.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateVideoQuality extends SettingsEvent {
  final String quality;
  const UpdateVideoQuality(this.quality);
  @override List<Object> get props => [quality];
}

class ToggleAutoPlay extends SettingsEvent {}
class ToggleAutoPlayNext extends SettingsEvent {}
class ToggleLoopVideo extends SettingsEvent {}
class ToggleNotifications extends SettingsEvent {}
class ToggleSubtitles extends SettingsEvent {}
class ClearWatchHistory extends SettingsEvent {}
class ClearImageCache extends SettingsEvent {}
class ClearAllDownloads extends SettingsEvent {}

class EnableParentalControl extends SettingsEvent {
  final String pin;
  const EnableParentalControl(this.pin);
  @override List<Object> get props => [pin];
}

class DisableParentalControl extends SettingsEvent {
  final String pin;
  const DisableParentalControl(this.pin);
  @override List<Object> get props => [pin];
}

class ChangeParentalPin extends SettingsEvent {
  final String oldPin;
  final String newPin;
  const ChangeParentalPin(this.oldPin, this.newPin);
  @override List<Object> get props => [oldPin, newPin];
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();
  @override List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}
class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppConfig config;
  const SettingsLoaded(this.config);
  @override List<Object> get props => [config];
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override List<Object> get props => [message];
}

class SettingsActionSuccess extends SettingsState {
  final String message;
  final AppConfig config;
  const SettingsActionSuccess(this.message, this.config);
  @override List<Object> get props => [message, config];
}

class ParentalPinError extends SettingsState {
  final String message;
  final int attemptsRemaining;
  const ParentalPinError(this.message, this.attemptsRemaining);
  @override List<Object> get props => [message, attemptsRemaining];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettings>((event, emit) async {
      emit(SettingsLoading());
      try {
        final box = Hive.box<AppConfig>('app_config_box');
        final config = box.isNotEmpty ? box.getAt(0)! : AppConfig();
        emit(SettingsLoaded(config));
      } catch (e) {
        emit(SettingsError(e.toString()));
      }
    });

    on<ToggleAutoPlay>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         config.autoPlayEnabled = !config.autoPlayEnabled;
         await config.save();
         emit(SettingsLoaded(config));
       }
    });

    on<ToggleAutoPlayNext>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         config.autoPlayNextEnabled = !config.autoPlayNextEnabled;
         await config.save();
         emit(SettingsLoaded(config));
       }
    });

    on<ToggleLoopVideo>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         config.loopVideoEnabled = !config.loopVideoEnabled;
         await config.save();
         emit(SettingsLoaded(config));
       }
    });

    on<ToggleSubtitles>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         config.showSubtitles = !config.showSubtitles;
         await config.save();
         emit(SettingsLoaded(config));
       }
    });

    on<UpdateVideoQuality>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         config.videoQuality = event.quality;
         await config.save();
         emit(SettingsLoaded(config));
       }
    });

    on<ToggleNotifications>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         config.notificationsEnabled = !config.notificationsEnabled;
         await config.save();
         emit(SettingsLoaded(config));
       }
    });

    on<ClearWatchHistory>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         await Hive.box('history_box').clear();
         emit(SettingsActionSuccess('Watch history cleared', config));
         emit(SettingsLoaded(config));
       }
    });

    on<ClearImageCache>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         // In real app, call CachedNetworkImage.evictFromCache()
         await Future.delayed(const Duration(milliseconds: 500));
         emit(SettingsActionSuccess('Image cache cleared', config));
         emit(SettingsLoaded(config));
       }
    });

    on<ClearAllDownloads>((event, emit) async {
       if (state is SettingsLoaded) {
         final config = (state as SettingsLoaded).config;
         await Hive.box('downloads_box').clear();
         emit(SettingsActionSuccess('Downloads cleared', config));
         emit(SettingsLoaded(config));
       }
    });

  }
}
