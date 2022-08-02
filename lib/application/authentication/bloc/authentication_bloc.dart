import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../domain/authentication/authentication.dart';
import '../../../infrastructure/authentication_repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Monitor user authentication status.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final Logger _log = Logger('AuthenticationBloc');
  late StreamSubscription<User> _userSubscription;

  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          (authenticationRepository.currentUser != User.empty)
              ? AuthenticationState.authenticated(
                  authenticationRepository.currentUser)
              : const AuthenticationState.unauthenticated(),
        ) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) {
        _log.fine('User: $user');
        add(AuthenticationUserChanged(user));
      },
    );

    on<AuthenticationUserChanged>((event, emit) {
      emit(_mapAuthenticationUserChangedToState(event));
    });

    on<AuthenticationLogoutRequested>((event, emit) {
      _authenticationRepository.logOut();
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

AuthenticationState _mapAuthenticationUserChangedToState(
  AuthenticationUserChanged event,
) {
  if (event.user != User.empty) {
    return AuthenticationState.authenticated(event.user);
  } else {
    return const AuthenticationState.unauthenticated();
  }
}
