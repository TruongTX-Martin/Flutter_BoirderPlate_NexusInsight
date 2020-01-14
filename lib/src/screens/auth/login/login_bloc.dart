


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:inno_insight/src/blocs/blocs.dart';
import 'package:inno_insight/src/models/models.dart';
import 'package:inno_insight/src/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({ @required this.userRepository, @required this.authenticationBloc});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final currentState = state;
    if (currentState is LoginLoading) return;
    if(event is LoginButtonPressed){
      yield LoginLoading();
      try{
        print('Hanld login email: ${event.email}');
        print('Hanld login password: ${event.password}');
        LoginResponse loginResponse = await userRepository.login(event.email, event.password);
        if(loginResponse.getLoginModel != null){
          userRepository.localDataSource.saveAccessToken(loginResponse.getLoginModel.getAccessToken);
          authenticationBloc.add(LoggedIn());
        }else {
          yield LoginFailure(error: loginResponse.getRequestFailedModel.getDetail);
        }
        print('loginResponse: $loginResponse');
      }catch(error){
        print('failed login: $error');
      }
    }
  }

}