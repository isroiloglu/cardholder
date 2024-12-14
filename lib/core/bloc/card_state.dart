part of 'card_bloc.dart';

@immutable
sealed class CardState {}

final class CardInitial extends CardState {}

final class CardLoading extends CardState {}

final class CardError extends CardState {
  final String error;

  CardError({required this.error});
}

final class CardSaved extends CardState {}
