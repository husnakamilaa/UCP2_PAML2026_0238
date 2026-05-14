import 'package:driveease/data/models/auth_request.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_event.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driveease/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userProfile = await authRepository.login(
          event.email,
          event.password,
        );
        emit(AuthSuccess(userProfile));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.register(event.request);
        emit(Unauthenticated()); 
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await authRepository.logout();
        emit(Unauthenticated());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });  
  }
}