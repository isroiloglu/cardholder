part of 'card_bloc.dart';

@immutable
sealed class CardEvent {}

class SavePressed extends CardEvent {
  final CardModel model;

  SavePressed({required this.model});
}
