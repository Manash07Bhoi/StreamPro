import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/download_record.dart';
import '../../../../core/models/video_entity.dart';
import '../../data/repositories/download_repository.dart';

// Events
abstract class DownloadEvent extends Equatable {}

class LoadDownloads extends DownloadEvent {
  @override
  List<Object> get props => [];
}

class StartDownload extends DownloadEvent {
  final VideoEntity video;
  final String quality;
  StartDownload(this.video, this.quality);
  @override
  List<Object> get props => [video.id, quality];
}

class PauseDownload extends DownloadEvent {
  final String downloadId;
  PauseDownload(this.downloadId);
  @override
  List<Object> get props => [downloadId];
}

class ResumeDownload extends DownloadEvent {
  final String downloadId;
  ResumeDownload(this.downloadId);
  @override
  List<Object> get props => [downloadId];
}

class CancelDownload extends DownloadEvent {
  final String downloadId;
  CancelDownload(this.downloadId);
  @override
  List<Object> get props => [downloadId];
}

class DeleteDownload extends DownloadEvent {
  final String downloadId;
  DeleteDownload(this.downloadId);
  @override
  List<Object> get props => [downloadId];
}

class DownloadProgressTick extends DownloadEvent {
  final String downloadId;
  final double progress;
  DownloadProgressTick(this.downloadId, this.progress);
  @override
  List<Object> get props => [downloadId, progress];
}

class DownloadCompleted extends DownloadEvent {
  final String downloadId;
  DownloadCompleted(this.downloadId);
  @override
  List<Object> get props => [downloadId];
}

class ClearAllDownloads extends DownloadEvent {
  @override
  List<Object> get props => [];
}

// States
abstract class DownloadState extends Equatable {}

class DownloadInitial extends DownloadState {
  @override
  List<Object> get props => [];
}

class DownloadLoading extends DownloadState {
  @override
  List<Object> get props => [];
}

class DownloadLoaded extends DownloadState {
  final List<DownloadRecord> downloads;
  final int totalStorageBytes;
  DownloadLoaded(this.downloads, this.totalStorageBytes);
  @override
  List<Object> get props => [downloads, totalStorageBytes];
}

class DownloadError extends DownloadState {
  final String message;
  DownloadError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadRepository _repository;

  DownloadBloc(this._repository) : super(DownloadInitial()) {
    on<LoadDownloads>((event, emit) async {
      emit(DownloadLoading());
      try {
        final downloads = _repository.getAllDownloads();
        final totalStorage = _repository.getTotalStorageUsedBytes();
        emit(DownloadLoaded(downloads, totalStorage));
      } catch (e) {
        emit(DownloadError('Failed to load downloads: $e'));
      }
    });

    on<StartDownload>((event, emit) async {
      try {
        await _repository.startDownload(event.video.id, event.quality);
        final downloads = _repository.getAllDownloads();
        final totalStorage = _repository.getTotalStorageUsedBytes();
        emit(DownloadLoaded(downloads, totalStorage));
      } catch (e) {
        emit(DownloadError('Failed to start download: $e'));
      }
    });

    on<PauseDownload>((event, emit) async {
      try {
        await _repository.pauseDownload(event.downloadId);
        final downloads = _repository.getAllDownloads();
        final totalStorage = _repository.getTotalStorageUsedBytes();
        emit(DownloadLoaded(downloads, totalStorage));
      } catch (e) {
        emit(DownloadError('Failed to pause download: $e'));
      }
    });

    on<ResumeDownload>((event, emit) async {
      try {
        await _repository.resumeDownload(event.downloadId);
        final downloads = _repository.getAllDownloads();
        final totalStorage = _repository.getTotalStorageUsedBytes();
        emit(DownloadLoaded(downloads, totalStorage));
      } catch (e) {
        emit(DownloadError('Failed to resume download: $e'));
      }
    });

    on<CancelDownload>((event, emit) async {
      try {
        await _repository.cancelDownload(event.downloadId);
        final downloads = _repository.getAllDownloads();
        final totalStorage = _repository.getTotalStorageUsedBytes();
        emit(DownloadLoaded(downloads, totalStorage));
      } catch (e) {
        emit(DownloadError('Failed to cancel download: $e'));
      }
    });

    on<DeleteDownload>((event, emit) async {
      try {
        await _repository.deleteDownload(event.downloadId);
        final downloads = _repository.getAllDownloads();
        final totalStorage = _repository.getTotalStorageUsedBytes();
        emit(DownloadLoaded(downloads, totalStorage));
      } catch (e) {
        emit(DownloadError('Failed to delete download: $e'));
      }
    });

    on<DownloadProgressTick>((event, emit) async {
      try {
        final record = _repository.getDownloadForVideo(event.downloadId);
        if (record != null) {
          final newBytes = (record.fileSizeBytes * event.progress).toInt();
          await _repository.updateDownloadProgress(event.downloadId, event.progress, newBytes, 'downloading');
          final downloads = _repository.getAllDownloads();
          final totalStorage = _repository.getTotalStorageUsedBytes();
          emit(DownloadLoaded(downloads, totalStorage));
        }
      } catch (e) {
        emit(DownloadError('Failed to update progress: $e'));
      }
    });

    on<DownloadCompleted>((event, emit) async {
      try {
        final record = _repository.getDownloadForVideo(event.downloadId);
        if (record != null) {
          await _repository.updateDownloadProgress(event.downloadId, 1.0, record.fileSizeBytes, 'completed');
          final downloads = _repository.getAllDownloads();
          final totalStorage = _repository.getTotalStorageUsedBytes();
          emit(DownloadLoaded(downloads, totalStorage));
        }
      } catch (e) {
        emit(DownloadError('Failed to complete download: $e'));
      }
    });

    on<ClearAllDownloads>((event, emit) async {
      try {
        final downloads = _repository.getAllDownloads();
        for (var download in downloads) {
          await _repository.deleteDownload(download.id);
        }
        emit(DownloadLoaded(const [], 0));
      } catch (e) {
        emit(DownloadError('Failed to clear downloads: $e'));
      }
    });
  }
}
