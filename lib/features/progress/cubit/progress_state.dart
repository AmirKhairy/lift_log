import 'package:equatable/equatable.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

final class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

final class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

final class ProgressLoaded extends ProgressState {
  const ProgressLoaded();
}

final class ProgressError extends ProgressState {
  const ProgressError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
