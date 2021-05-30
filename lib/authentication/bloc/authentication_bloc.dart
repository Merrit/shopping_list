import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shopping_list/authentication/enums/enums.dart';
import 'package:shopping_list/repositories/authentication_repository/repository.dart';

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
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
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
    return AuthenticationState.unauthenticated();
  }
}
