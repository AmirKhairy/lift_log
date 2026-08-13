import 'package:equatable/equatable.dart';

sealed class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object?> get props => [];
}

final class VideosInitial extends VideosState {
  const VideosInitial();
}

final class VideosLoading extends VideosState {
  const VideosLoading();
}

final class VideosLoaded extends VideosState {
  const VideosLoaded();
}

final class VideosError extends VideosState {
  const VideosError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
