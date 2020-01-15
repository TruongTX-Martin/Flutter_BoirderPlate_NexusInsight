import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../home.dart';

abstract class MyRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MyRequestEventFetch extends MyRequestEvent {
  final String category;

  MyRequestEventFetch({@required this.category}) ;

}

class MyRequestEventPullToRefresh extends MyRequestEvent {
  final String category;

  MyRequestEventPullToRefresh({@required this.category}) ;
}

class MyRequestEventFetchMore extends MyRequestEvent {
final String category;

  MyRequestEventFetchMore({@required this.category}) ;

}

class MyRequestEventFailure extends MyRequestEvent {}

class MyRequestEventSuccess extends MyRequestEvent {}
