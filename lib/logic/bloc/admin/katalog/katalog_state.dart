import 'package:driveease/data/models/katalog.dart';
import 'package:equatable/equatable.dart';

abstract class KatalogState extends Equatable {
  @override
  List<Object> get props => [];
}

class KatalogInitial extends KatalogState {}

class KatalogLoading extends KatalogState {}

class KatalogLoaded extends KatalogState {
  final List<KatalogModel> katalogList;
  KatalogLoaded(this.katalogList);
  @override
  List<Object> get props => [katalogList];
}

class KatalogError extends KatalogState {
  final String message;
  KatalogError(this.message);
}

class KatalogCreatedSuccess extends KatalogState {}

class KatalogDetailLoaded extends KatalogState {
  final KatalogModel katalog;

  KatalogDetailLoaded(this.katalog);
}