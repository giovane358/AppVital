import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

// Events
abstract class SplashEvent {}

class SplashStarted extends SplashEvent {}

class SplashRetried extends SplashEvent {}

// States
abstract class SplashState {}

class SplashLoading extends SplashState {}

class SplashConnected extends SplashState {}

class SplashNoConnected extends SplashState {}

class SplashAuthenticated extends SplashState {}

class SplashUnauthenticated extends SplashState {}

// BLoC
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashLoading()) {
    on<SplashStarted>(_checkConnection);

    on<SplashRetried>(_checkConnection);
  }

  Future<void> _checkConnection(
    SplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    final result = await Connectivity().checkConnectivity();

    final hasConnection = result.any(
      (r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet,
    );

    if (!hasConnection) {
      emit(SplashNoConnected());

      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      emit(SplashUnauthenticated());

      return;
    }

    final isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      await prefs.remove('token');
      emit(SplashUnauthenticated());
    } else {
      emit(SplashAuthenticated());
    }
  }
}
