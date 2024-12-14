import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:card_holder/core/models/card_model.dart';
import 'package:card_holder/core/repository/card_repository.dart';
import 'package:meta/meta.dart';

part 'card_event.dart';

part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardRepository repository = CardRepository();

  CardBloc() : super(CardInitial()) {
    on<CardEvent>((event, emit) async {
      if (event is SavePressed) {
        await _saveProcess(event, emit);
      }
    });
  }

  Future<void> _saveProcess(SavePressed event, Emitter<CardState> emit) async {
    emit(CardLoading());
    try {
      if (event.model.image != null) {
        await repository.uploadPhoto(event.model.image!);
      }
      await repository.saveCard(event.model);
      emit(CardSaved());
    } catch (err, second) {
      log('ERRIR IS $err ==== $second');
      emit(CardError(error: err.toString()));
    }
  }
}
