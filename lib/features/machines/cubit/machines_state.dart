import 'package:equatable/equatable.dart';

sealed class MachinesState extends Equatable {
  const MachinesState();

  @override
  List<Object?> get props => [];
}

final class MachinesInitial extends MachinesState {
  const MachinesInitial();
}

final class MachinesLoding extends MachinesState {
  const MachinesLoding();
}

final class MachinesLoadedSuccess extends MachinesState {
  const MachinesLoadedSuccess();
}

final class MachinesError extends MachinesState {
  const MachinesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
