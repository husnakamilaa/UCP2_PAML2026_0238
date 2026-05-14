import 'package:equatable/equatable.dart';

abstract class KategoriEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchKategori extends KategoriEvent {}

class CreateKategori extends KategoriEvent {
  final Map<String, dynamic> data;
  CreateKategori(this.data);
  @override
  List<Object> get props => [data];
}

class DeleteKategori extends KategoriEvent {
  final int id;
  DeleteKategori(this.id);
  @override
  List<Object> get props => [id];
}