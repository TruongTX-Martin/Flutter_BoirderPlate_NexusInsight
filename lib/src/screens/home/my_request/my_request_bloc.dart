
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_insight/src/repositories/user_repository.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_event.dart';
import 'package:inno_insight/src/screens/home/my_request/my_request_state.dart';
import 'package:meta/meta.dart';

class MyRequestBloc extends Bloc<MyRequestEvent, MyRequestState> {

  final UserRepository userRepository;

  MyRequestBloc({
    @required this.userRepository
  });

  @override
  MyRequestState get initialState => MyRequestStateUnInittialized();

  @override
  Stream<MyRequestState> mapEventToState(MyRequestEvent event) async* {


  }

}