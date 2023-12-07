import 'package:equatable/equatable.dart';
import 'package:tik_at_app/models/ticket.dart';

class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<Ticket> tickets;

  const TicketLoaded({required this.tickets});

  @override
  List<Object> get props => [tickets];
}

class TicketFailure extends TicketState {
  final String message;

  const TicketFailure({required this.message});

  @override
  List<Object> get props => [message];
}
