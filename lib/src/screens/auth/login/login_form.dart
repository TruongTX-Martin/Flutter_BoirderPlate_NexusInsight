import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  handleLogin() {
    if (formKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
          email: emailController.text.trim(),
          password: passwordController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                      ),
                      hintText: 'Type your email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!this.validateEmail(value)) {
                      return 'Wrong email format';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                        ),
                        hintText: 'Type your password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  child: state is LoginLoading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: CircularProgressIndicator(),
                        )
                      : null,
                ),
                Container(
                  child: state is LoginFailure
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(state.error,
                              style: TextStyle(color: Colors.red)),
                        )
                      : null,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text('Login',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    shape: StadiumBorder(),
                    onPressed: () {
                      this.handleLogin();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
