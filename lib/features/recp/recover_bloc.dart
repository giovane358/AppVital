import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RecoverEvent {}

class RecoverStart extends RecoverEvent {
  final String email;
  RecoverStart({required this.email});
}

class RecoverRetried extends RecoverEvent {}

abstract class RecoverSate {}

class RecoverLoading extends RecoverSate {}

class RecoverSuccess extends RecoverSate {}

class RecoverFalied extends RecoverSate {}

class RecoverBloc extends Bloc<RecoverEvent, RecoverSate> {
  RecoverBloc() : super(RecoverLoading()) {
    on<RecoverStart>(_checkRecover);
  }

  Future<void> _checkRecover(
    RecoverStart event,
    Emitter<RecoverSate> emit,
  ) async {
    await Future.delayed(Duration(seconds: 2));

    final isValid = event.email.isNotEmpty;
    emit(isValid ? RecoverSuccess() : RecoverFalied());
  }
}
