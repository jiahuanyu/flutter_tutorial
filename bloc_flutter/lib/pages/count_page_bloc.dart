import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'count_page_event.dart';

class CountPageBloc extends Bloc<CountPageEvent, int> {
  CountPageBloc() : super(0);

  @override
  Stream<int> mapEventToState(
    CountPageEvent event,
  ) async* {
    if (event is CountPageAddEvent) {
      yield state + 1;

      yield* _test();

      yield state + 1;
    } else if (event is CountPageMinusEvent) {
      yield state - 1;
    }
  }

  Stream<int> _test() async* {
    await Future.delayed(Duration(seconds: 5));
    yield 10;
  }
}
