

import 'package:inno_insight/src/data/api_data.dart';
import 'package:inno_insight/src/data/local_data.dart';
import 'package:inno_insight/src/models/models.dart';

class UserRepository {

  final APIDataSource apiDataSource;
  final LocalDataSource localDataSource;

  UserRepository(this.apiDataSource, this.localDataSource);


  Future<LoginResponse> login(String username, String password) => apiDataSource.login(username, password);

  Future<ResultRequestModel> getMyRequest({int page,String category,String status}) => apiDataSource.getMyRequest(page: page,category: category, status: status);


  void saveAccessToken(String token) => localDataSource.saveAccessToken(token);

  Future<bool> isSignIn() => localDataSource.isSignIn();

  void signOut() => localDataSource.saveAccessToken(null);

}