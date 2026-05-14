import 'package:equatable/equatable.dart';

abstract class KatalogCustomerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchKatalogCustomer extends KatalogCustomerEvent {}

class SearchKatalogCustomer extends KatalogCustomerEvent {
  final String nama;

  SearchKatalogCustomer(this.nama);
}

class FetchKatalogCustomerById extends KatalogCustomerEvent {
  final int id;

  FetchKatalogCustomerById(this.id);
}