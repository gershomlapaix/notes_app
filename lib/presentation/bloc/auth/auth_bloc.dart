import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/services/auth_service.dart';
import 'package:notes_app/presentation/bloc/auth/auth_event.dart';
import 'package:notes_app/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription? _authSubscription;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthUserChanged>(_onUserChanged);

    _authSubscription = _authService.authStateChanges.listen(
          (user) => add(AuthUserChanged(user)),
    );
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _authService.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _authService.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _authService.signOut();
  }

  void _onUserChanged(
      AuthUserChanged event,
      Emitter<AuthState> emit,
      ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
