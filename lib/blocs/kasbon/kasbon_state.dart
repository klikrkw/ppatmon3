part of 'kasbon_bloc.dart';

@immutable
sealed class KasbonState {}

final class KasbonInitial extends KasbonState {}

final class KasbonRefreshList extends KasbonState {
  final String ramdomCode;
  KasbonRefreshList(this.ramdomCode);
}

final class KasbonNew extends KasbonState {
  final List<String> jenisKasbonOptions;
  final List<DbOption> instansiOptions;
  final double totalKasbon;
  KasbonNew(this.jenisKasbonOptions, this.instansiOptions, this.totalKasbon);
}

final class KasbonEdit extends KasbonState {
  // final Kasbon kasbon;
  final Kasbon kasbon;
  final List<DbOption> statusKasbonOptions;
  final String randomCode;
  KasbonEdit(this.kasbon, this.statusKasbonOptions, this.randomCode);
}

final class KasbonAddedSuccess extends KasbonState {
  final Kasbon kasbon;
  final String message;
  KasbonAddedSuccess(this.kasbon, this.message);
}

final class KasbonUpdatedSuccess extends KasbonState {
  final String kasbon;
  KasbonUpdatedSuccess(this.kasbon);
}

final class KasbonError extends KasbonState {
  final String error;
  KasbonError(this.error);
}
