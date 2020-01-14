class LoginModel {
  String accessToken;
  String tokenType;
  String refreshToken;
  int expiresIn;

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
  }

  String get getAccessToken =>  accessToken;
  String get getTokenType =>  tokenType;
  String get getRefreshToken =>  refreshToken;
  int get getExpiresIn =>  expiresIn;

}
