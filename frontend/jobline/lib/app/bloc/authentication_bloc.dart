import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobline/shared/data/authentication/authentication_repository.dart';
import 'package:jobline/shared/data/authentication/models/user.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.user.isNotEmpty
              ? AuthenticationState.authenticated(authenticationRepository.user)
              : const AuthenticationState.unauthenticated(),
        ) {
    // on<_AppUserChanged>(_onUserChanged);
    // on<AppLogoutRequested>(_onLogoutRequested);
    // _userSubscription = _authenticationRepository.user.listen(
    //   (user) => add(_AppUserChanged(user)),
    // );
  }

  final AuthenticationRepository _authenticationRepository;
  // late final StreamSubscription<User> _userSubscription;

  // void _onUserChanged(_AppUserChanged event, Emitter<AuthenticationState> emit) {
  //   emit(
  //     event.user.isNotEmpty
  //         ? AuthenticationState.authenticated(event.user)
  //         : const AuthenticationState.unauthenticated(),
  //   );
  // }

  // void _onLogoutRequested(AppLogoutRequested event, Emitter<AuthenticationState> emit) {
  //   unawaited(_authenticationRepository.logOut());
  // }

  @override
  Future<void> close() {
    // _userSubscription.cancel();
    return super.close();
  }
}
