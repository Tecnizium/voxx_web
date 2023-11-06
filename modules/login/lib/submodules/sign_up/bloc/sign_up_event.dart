part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}


class SignUpButtonPressed extends SignUpEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;

  SignUpButtonPressed({required this.firstName, required this.lastName, required this.username, required this.email, required this.password});
}