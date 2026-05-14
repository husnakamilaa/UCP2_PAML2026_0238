import 'package:driveease/data/repositories/admin/katalog_repository.dart';
import 'package:driveease/data/repositories/customer/katalogcust_repository.dart';
import 'package:driveease/logic/bloc/customer/katalogcust/katalogcust_event.dart';
import 'package:driveease/logic/bloc/customer/katalogcust/katalogcust_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KatalogCustomerBloc extends Bloc<KatalogCustomerEvent, KatalogCustomerState> {
  final KatalogcustRepository repository;

  KatalogCustomerBloc({required this.repository}) : super(KatalogCustomerInitial()) {
    on<FetchKatalogCustomer>((event, emit) async {
      emit(KatalogCustomerLoading());
      try {
        final list = await repository.getAllKatalogCustomer();
        emit(KatalogCustomerLoaded(list));
      } catch (e) {
        emit(KatalogCustomerError(e.toString()));
      }
    });

    on<SearchKatalogCustomer>((event, emit) async {
      emit(KatalogCustomerLoading());

      try {
        final result = await repository.searchKatalogCustomer(event.nama);

        emit(KatalogCustomerLoaded(result));
      } catch (e) {
        emit(KatalogCustomerError(e.toString()));
      }
    });

    on<FetchKatalogCustomerById>((event, emit) async {
      emit(KatalogCustomerLoading());

      try {
        final katalogcust = await repository.getKatalogCustomerById(event.id);

        emit(KatalogCustomerDetailLoaded(katalogcust));
      } catch (e) {
        emit(KatalogCustomerError(e.toString()));
      }
    });
  }
}
