import 'package:inno_insight/src/models/request_model.dart';

class ResultRequestModel {
  int hasNext;
  int offset;
  int limit;
  List<RequestModel> listRequest;

  ResultRequestModel({
    this.hasNext,
    this.offset,
    this.limit,
    this.listRequest,
  });

  ResultRequestModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['hasNext'];
    offset = json['offset'];
    limit = json['limit'];
    listRequest = _parseResult(json['items']);
  }

  _parseResult(List<dynamic> data) {
    List<RequestModel> results = new List<RequestModel>();
    data.forEach((item) {
      results.add(RequestModel.fromJson(item));
    });
    return results;
  }

  List<RequestModel> get getListRequestModel => listRequest;
}
