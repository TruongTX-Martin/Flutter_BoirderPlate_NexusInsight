import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:inno_insight/src/models/models.dart';
import 'package:inno_insight/src/repositories/user_repository.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_event.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_state.dart';
import 'package:meta/meta.dart';

class MyRequestBloc extends Bloc<MyRequestEvent, MyRequestState> {
  final UserRepository userRepository;

  MyRequestBloc({@required this.userRepository});

  @override
  MyRequestState get initialState => MyRequestStateUnInittialized();

  @override
  Stream<MyRequestState> mapEventToState(MyRequestEvent event) async* {
    final currentState = state;
    if (event is MyRequestEventFetch || event is MyRequestEventPullToRefresh) {
      String category;
      String status;
      if (event is MyRequestEventFetch) {
        category = event.category;
        status = event.status;
        yield MyRequestStateLoading();
      }
      if (event is MyRequestEventPullToRefresh) {
        category = event.category;
        status = event.status;
      }
      ResultRequestModel requestModel = await userRepository.getMyRequest(
          page: 0, category: category, status: status);
      if (requestModel != null) {
        yield MyRequestStateLoaded(
            hasNext: requestModel.hasNext,
            offset: requestModel.offset,
            limit: requestModel.limit,
            listRequest: requestModel.getListRequestModel);
      } else {
        yield MyRequestStateUnInittialized();
      }
    }
    if (event is MyRequestEventFetchMore &&
        currentState is MyRequestStateLoaded &&
        !currentState.hasReachMax()) {
      ResultRequestModel requestModel = await userRepository.getMyRequest(
          page: currentState.getNextPage(),
          category: event.category,
          status: event.status);
      yield MyRequestStateLoaded(
          hasNext: requestModel.hasNext,
          offset: requestModel.offset,
          limit: requestModel.limit,
          listRequest:
              currentState.listRequest + requestModel.getListRequestModel);
    }
  }
}
