import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:inno_insight/src/blocs/blocs.dart';
import 'package:inno_insight/src/repositories/repositories.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({this.userRepository});

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await userRepository.isSignIn();
      if (isSignedIn) {
        yield Authenticated('');
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated('');
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    // yield Unauthenticated();
    // _userRepository.signOut();
  }
}
