import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<T> debounceRestartable<T>(Duration duration) {
  return (events, mapper) {
    return restartable<T>().call(events.debounce(duration), mapper);
  };
}
