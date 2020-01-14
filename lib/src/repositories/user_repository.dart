

import 'package:inno_insight/src/data/api_data.dart';
import 'package:inno_insight/src/data/local_data.dart';
import 'package:inno_insight/src/models/models.dart';

class UserRepository {

  final APIDataSource apiDataSource;
  final LocalDataSource localDataSource;

  UserRepository(this.apiDataSource, this.localDataSource);


  Future<LoginResponse> login(String username, String password) => apiDataSource.login(username, password);

  void saveAccessToken(String token) => localDataSource.saveAccessToken(token);

  Future<bool> isSignIn() => localDataSource.isSignIn();

}