import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HomeEvent {}

class StartHome extends HomeEvent {
  final String token = 'Giovane';

  StartHome();
}

class CheckLogin extends HomeEvent {}

class CheckLoginRetried extends HomeEvent {}

abstract class HomeState {}

class LoadingHome extends HomeState {}

class CheckLoginSucess extends HomeState {}

class CheckLoginFaild extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static const _token = 'giovane';
  HomeBloc() : super(LoadingHome()) {
    on<StartHome>(_checkHome);
  }
  Future<void> _checkHome(StartHome event, Emitter<HomeState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    final isToken = event.token == _token;
    emit(isToken ? CheckLoginSucess() : CheckLoginFaild());
  }
}
