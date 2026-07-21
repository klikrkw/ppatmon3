part of 'kasbon_bloc.dart';

// enum FormStatus { initial, loading, success, failure }

@immutable
sealed class KasbonEvent {}

class NewKasbon extends KasbonEvent {
  final int? userId;
  NewKasbon({this.userId});
}

class AddKasbon extends KasbonEvent {
  final AddKasbonRequest addKasbonRequest;
  AddKasbon(this.addKasbonRequest);
}

class EditKasbon extends KasbonEvent {
  final Kasbon kasbon;
  EditKasbon(this.kasbon);
}

class UpdateKasbon extends KasbonEvent {
  final Kasbon kasbon;
  UpdateKasbon(this.kasbon);
}

class RefreshKasbonList extends KasbonEvent {}
