part of 'create_poll_bloc.dart';

@immutable
sealed class CreatePollState {}

final class CreatePollInitial extends CreatePollState {}

final class CreatePollLoading extends CreatePollState {}

final class CreatePollSuccess extends CreatePollState {}

final class CreatePollError extends CreatePollState {
  final String message;

  CreatePollError({required this.message});
}

final class DeletePollSuccess extends CreatePollState {}
final class CancelPollSuccess extends CreatePollState {}

final class EditPollSuccess extends CreatePollState {
  final PollModel poll;

  EditPollSuccess({required this.poll});
}
