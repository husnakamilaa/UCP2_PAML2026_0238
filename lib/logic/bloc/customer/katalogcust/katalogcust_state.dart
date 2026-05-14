import 'package:driveease/data/models/katalog.dart';
import 'package:equatable/equatable.dart';

abstract class KatalogCustomerState extends Equatable {
  @override
  List<Object> get props => [];
}

class KatalogCustomerInitial extends KatalogCustomerState {}

class KatalogCustomerLoading extends KatalogCustomerState {}

class KatalogCustomerLoaded extends KatalogCustomerState {
  final List<KatalogModel> katalogList;
  KatalogCustomerLoaded(this.katalogList);
  @override
  List<Object> get props => [katalogList];
}

class KatalogCustomerError extends KatalogCustomerState {
  final String message;
  KatalogCustomerError(this.message);
}

class KatalogCreatedSuccess extends KatalogCustomerState {}

class KatalogCustomerDetailLoaded extends KatalogCustomerState {
  final KatalogModel katalog;

  KatalogCustomerDetailLoaded(this.katalog);
}