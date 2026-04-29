import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/user_profile.dart';
import '../../data/repositories/profile_repository.dart';

// Events
abstract class ProfileEvent extends Equatable {}

class LoadProfile extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateDisplayName extends ProfileEvent {
  final String name;
  UpdateDisplayName(this.name);
  @override
  List<Object> get props => [name];
}

class UpdateAvatar extends ProfileEvent {
  final String? url;
  UpdateAvatar(this.url);
  @override
  List<Object> get props => [url ?? ''];
}

class UpdateInterests extends ProfileEvent {
  final List<String> interests;
  UpdateInterests(this.interests);
  @override
  List<Object> get props => [interests];
}

class SyncProfileStats extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class SetBirthYear extends ProfileEvent {
  final String year;
  SetBirthYear(this.year);
  @override
  List<Object> get props => [year];
}

// States
abstract class ProfileState extends Equatable {}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
  @override
  List<Object> get props => [profile];
}

class ProfileSaving extends ProfileState {
  final UserProfile profile;
  ProfileSaving(this.profile);
  @override
  List<Object> get props => [profile];
}

class ProfileSaved extends ProfileState {
  final UserProfile profile;
  ProfileSaved(this.profile);
  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = _repository.getOrCreateProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError('Failed to load profile: $e'));
      }
    });

    on<UpdateDisplayName>((event, emit) async {
      try {
        final currentProfile = _repository.getOrCreateProfile();
        emit(ProfileSaving(currentProfile));
        await _repository.updateDisplayName(event.name);
        final updatedProfile = _repository.getOrCreateProfile();
        emit(ProfileSaved(updatedProfile));
        emit(ProfileLoaded(updatedProfile));
      } catch (e) {
        emit(ProfileError('Failed to update display name: $e'));
      }
    });

    on<UpdateAvatar>((event, emit) async {
      try {
        final currentProfile = _repository.getOrCreateProfile();
        emit(ProfileSaving(currentProfile));
        await _repository.updateAvatar(event.url);
        final updatedProfile = _repository.getOrCreateProfile();
        emit(ProfileSaved(updatedProfile));
        emit(ProfileLoaded(updatedProfile));
      } catch (e) {
        emit(ProfileError('Failed to update avatar: $e'));
      }
    });

    on<UpdateInterests>((event, emit) async {
      try {
        final profile = _repository.getOrCreateProfile();
        emit(ProfileSaving(profile));

        final updatedProfile = UserProfile(
          id: profile.id,
          displayName: profile.displayName,
          avatarUrl: profile.avatarUrl,
          customAvatarPath: profile.customAvatarPath,
          createdAt: profile.createdAt,
          membershipType: profile.membershipType,
          totalLikes: profile.totalLikes,
          totalWatchedVideos: profile.totalWatchedVideos,
          totalWatchTimeSeconds: profile.totalWatchTimeSeconds,
          favoriteCategory: profile.favoriteCategory,
          interests: event.interests,
          birthYear: profile.birthYear,
          isAgeVerified: profile.isAgeVerified,
        );
        await _repository.updateProfile(updatedProfile);

        emit(ProfileSaved(updatedProfile));
        emit(ProfileLoaded(updatedProfile));
      } catch (e) {
        emit(ProfileError('Failed to update interests: $e'));
      }
    });

    on<SyncProfileStats>((event, emit) async {
      try {
        await _repository.syncStats();
        final profile = _repository.getOrCreateProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError('Failed to sync stats: $e'));
      }
    });

    on<SetBirthYear>((event, emit) async {
      try {
        final profile = _repository.getOrCreateProfile();
        emit(ProfileSaving(profile));

        final age = DateTime.now().year - int.parse(event.year);

        final updatedProfile = UserProfile(
          id: profile.id,
          displayName: profile.displayName,
          avatarUrl: profile.avatarUrl,
          customAvatarPath: profile.customAvatarPath,
          createdAt: profile.createdAt,
          membershipType: profile.membershipType,
          totalLikes: profile.totalLikes,
          totalWatchedVideos: profile.totalWatchedVideos,
          totalWatchTimeSeconds: profile.totalWatchTimeSeconds,
          favoriteCategory: profile.favoriteCategory,
          interests: profile.interests,
          birthYear: event.year,
          isAgeVerified: age >= 18,
        );
        await _repository.updateProfile(updatedProfile);

        emit(ProfileSaved(updatedProfile));
        emit(ProfileLoaded(updatedProfile));
      } catch (e) {
        emit(ProfileError('Failed to set birth year: $e'));
      }
    });
  }
}
