import 'package:driveease/data/repositories/admin/kategori_repository.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_event.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  KategoriBloc({required this.repository}) : super(KategoriInitial()) {
    on<FetchKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        final list = await repository.getAllKategori();
        emit(KategoriLoaded(list));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<CreateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.createKategori(event.data);
        emit(KategoriCreatedSuccess());
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<DeleteKategori>((event, emit) async {
      try {
        await repository.deleteKategori(event.id);
        emit(KategoriCreatedSuccess());
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

  }
}
