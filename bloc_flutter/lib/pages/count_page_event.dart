part of 'count_page_bloc.dart';

abstract class CountPageEvent extends Equatable {
  const CountPageEvent();
}

/// 增加数字事件
class CountPageAddEvent extends CountPageEvent {
  @override
  List<Object> get props => [];
}

/// 减小数字事件
class CountPageMinusEvent extends CountPageEvent {
  @override
  List<Object> get props => [];
}
