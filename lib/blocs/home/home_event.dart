import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  final int? userId;
  const LoadHome(this.userId);
}

class RefreshHome extends HomeEvent {
  const RefreshHome();
}

class ToggleSaldo extends HomeEvent {
  const ToggleSaldo();
}
