import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/blocs/blocs.dart';
import 'package:inno_insight/src/data/data.dart';
import 'package:inno_insight/src/repositories/repository_helper.dart';
import 'package:inno_insight/src/repositories/user_repository.dart';
import 'package:inno_insight/src/screens/auth/login/login.dart';
import 'package:inno_insight/src/screens/home/add_request/add_request_page.dart';
import 'package:inno_insight/src/screens/home/home.dart';
import 'package:inno_insight/src/screens/spash/spash_page.dart';
import 'src/utils/utils.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  Dio dio = Dio(Options(
      receiveTimeout: 5000, connectTimeout: 5000, baseUrl: Constants.BASE_URL));
  LocalDataSource localDataSource = new LocalDataSource();
  APIDataSource apiDataSource =
      new APIDataSource(dio: dio, localDataSource: localDataSource);
  final UserRepository userRepository =
      new UserRepository(apiDataSource, localDataSource);
  RepositoryHelper.userRepository = userRepository;
  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
    child: MyApp(userRepository: userRepository),
  ));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (contex, state) {
              if (state is Unauthenticated) {
                return LoginPage(userRepository: widget.userRepository);
              }
              if (state is Authenticated) {
                return HomePage(userRepository: widget.userRepository);
              }
              return SplashPage();
            },
          );
        },
        Routes.add_request: (context) {
          return AddRequestPage();
        }
      },
    );
  }
}
