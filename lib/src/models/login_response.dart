import 'package:inno_insight/src/models/login_model.dart';
import 'package:inno_insight/src/models/request_failed_model.dart';

class LoginResponse {
  LoginModel loginModel;
  RequestFailedModel requestFailedModel;

  LoginResponse(this.loginModel, this.requestFailedModel);

  LoginModel get getLoginModel => loginModel;

  RequestFailedModel get getRequestFailedModel => requestFailedModel;
}
