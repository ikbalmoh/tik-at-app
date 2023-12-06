import 'package:equatable/equatable.dart';
import 'package:tik_at_app/models/user.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class UnAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  final String token;

  const Authenticated({required this.user, required this.token});

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
