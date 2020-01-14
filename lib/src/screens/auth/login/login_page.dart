import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:inno_insight/src/repositories/repositories.dart';
import 'login.dart';

class LoginPage extends StatelessWidget {


  final UserRepository userRepository;

  LoginPage({ Key key,@required this.userRepository }) : assert(userRepository != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(
          authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
          userRepository: userRepository),
        child: GestureDetector(
          onTap: (){
            //call function hide keyboard
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}