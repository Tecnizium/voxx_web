part of 'details_poll_bloc.dart';

@immutable
sealed class DetailsPollEvent {}

class GetPollDetailsCachedEvent extends DetailsPollEvent {}

class GetPollStatEvent extends DetailsPollEvent {
  final String pollId;

  GetPollStatEvent({required this.pollId});
}

class EditPollButtonPressedEvent extends DetailsPollEvent {
  final PollModel poll;

  EditPollButtonPressedEvent({required this.poll});
  
}