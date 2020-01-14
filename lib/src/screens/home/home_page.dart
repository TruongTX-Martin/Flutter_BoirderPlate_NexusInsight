import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/repositories/repositories.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_bloc.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_page.dart';

class HomePage extends StatefulWidget {

  final UserRepository userRepository;

  HomePage({ @required this.userRepository});

  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => MyRequestBloc(userRepository: widget.userRepository),
        child: MyRequestPage(),
      ),

    );
  }
}