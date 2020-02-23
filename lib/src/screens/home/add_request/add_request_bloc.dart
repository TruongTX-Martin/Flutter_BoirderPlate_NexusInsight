

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/models/request_failed_model.dart';
import 'package:inno_insight/src/repositories/repositories.dart';
import 'package:inno_insight/src/screens/home/add_request/add_request_event.dart';
import 'package:inno_insight/src/screens/home/add_request/add_request_state.dart';
import 'package:meta/meta.dart';

class AddRequestBloc extends Bloc<AddRequestEvent, AddRequestState> {

  final UserRepository userRepository;
  final BuildContext context;

  AddRequestBloc({
    @required this.userRepository,
    @required this.context
  });


  @override
  AddRequestState get initialState => AddRequestInitState();

  @override
  Stream<AddRequestState> mapEventToState(AddRequestEvent event) async* {
    final currentState = state;
    if(event is AddRequestSendEvent){
      Map map = event.getParamsRemote();
      yield AddRequestLoadingState();
      RequestFailedModel requestModel = await userRepository.addRequestRemote(map, event.requestType);
      yield AddRequestResponseState(requestModel.getIsSuccess, requestModel.getDetail);
      if(requestModel.isSuccess){
        Navigator.pop(context, true);
      }
    }
  }

}