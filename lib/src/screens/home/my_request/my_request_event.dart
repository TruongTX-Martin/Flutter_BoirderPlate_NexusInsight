import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../home.dart';

abstract class MyRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MyRequestEventFetch extends MyRequestEvent {
  final String category;
  final String status;

  MyRequestEventFetch({@required this.category, @required this.status}) ;

}

class MyRequestEventPullToRefresh extends MyRequestEvent {
  final String category;
  final String status;

  MyRequestEventPullToRefresh({@required this.category,@required this.status}) ;
}

class MyRequestEventFetchMore extends MyRequestEvent {
final String category;
final String status;
  MyRequestEventFetchMore({@required this.category,@required this.status}) ;

}

class MyRequestEventFailure extends MyRequestEvent {}

class MyRequestEventSuccess extends MyRequestEvent {}
