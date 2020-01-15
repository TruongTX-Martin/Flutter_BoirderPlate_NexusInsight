import 'package:dio/dio.dart';
import 'package:inno_insight/src/data/local_data.dart';
import 'package:inno_insight/src/models/models.dart';
import 'package:inno_insight/src/utils/utils.dart';
import 'package:meta/meta.dart';

class APIDataSource {
  final Dio dio;
  final LocalDataSource localDataSource;

  APIDataSource({@required this.dio, @required this.localDataSource}) {
    this.setupLoggingInterceptor();
  }

  Future<LoginResponse> login(String username, String password) async {
    try {
      FormData formData = FormData.from({
        'email': username,
        'password': password,
        'client_id': Constants.CLIENT_ID,
        'client_secret': Constants.CLIENT_SECRET,
      });
      Response response = await dio.post('/signin', data: formData);
      return new LoginResponse(LoginModel.fromJson(response.data), null);
    } catch (error) {
      return new LoginResponse(null, this.handleError(error));
    }
  }

  Future<ResultRequestModel> getMyRequest({int page,String category,String status}) async {
    try {
      String token = await localDataSource.getCurrentToken();
      this.setupHeader(token);
      Response response = await dio.get('/request/my_requests',
          data: {"offset": page * 10, "limit": 10, "direction": 'desc', "category" : category, "status": status});
      if(response != null && response.statusCode == 200){
        ResultRequestModel resultRequestModel = ResultRequestModel.fromJson(response.data);
        return resultRequestModel;
      }
      return null;
    } catch (error) {}
  }

  RequestFailedModel handleError(Error error) {
    RequestFailedModel failedModel;
    if (error is DioError &&
        error.response != null &&
        error.response.data != null) {
      failedModel = RequestFailedModel.fromJson(error.response.data);
    }
    return failedModel;
  }

  setupHeader(String token) {
    dio.interceptor.request.onSend = (Options options) {
      options.headers["Accept"] = 'application/json';
      options.headers["Authorization"] = 'Bearer ' + token;
      return options;
    };
  }

  void setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;

    dio.interceptor.request.onSend = (Options options) {
      print("--> ${options.method} ${options.path}");
      print("Content type: ${options.contentType}");
      print("<-- END HTTP");
      return options;
    };

    dio.interceptor.response.onSuccess = (Response response) {
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP");
    };
    dio.interceptor.response.onError = (Error error) {
      if (error is DioError &&
          error.response != null &&
          error.response.data != null) {
        print('Error: ${error.response.data}');
        print("<-- END HTTP With Error");
      }
    };
  }
}
