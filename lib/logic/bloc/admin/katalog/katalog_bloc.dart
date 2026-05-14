import 'package:driveease/data/repositories/admin/katalog_repository.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final KatalogRepository repository;

  KatalogBloc({required this.repository}) : super(KatalogInitial()) {
    on<FetchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final list = await repository.getAllKatalog();
        emit(KatalogLoaded(list));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<CreateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.createKatalog(event.data);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<UpdateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.updateKatalog(event.id, event.data);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<DeleteKatalog>((event, emit) async {
      try {
        await repository.deleteKatalog(event.id);
        emit(KatalogCreatedSuccess());
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<SearchKatalog>((event, emit) async {
      emit(KatalogLoading());

      try {
        final result = await repository.searchKatalog(event.nama);

        emit(KatalogLoaded(result));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<FetchKatalogById>((event, emit) async {
      emit(KatalogLoading());

      try {
        final katalog = await repository.getKatalogById(event.id);

        emit(KatalogDetailLoaded(katalog));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });
  }
}
