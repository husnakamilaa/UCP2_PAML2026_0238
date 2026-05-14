import 'dart:async';
import 'package:driveease/data/repositories/admin/katalog_repository.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_state.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_bloc.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_event.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_state.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_state.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_event.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/ui/pages/admin/katalog/add_katalog.dart';
import 'package:driveease/ui/pages/admin/katalog/detail_katalog.dart';
import 'package:driveease/ui/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

class ListKatalogPage extends StatefulWidget {
  const ListKatalogPage({super.key});

  @override
  State<ListKatalogPage> createState() => _ListKatalogPageState();
}

class _ListKatalogPageState extends State<ListKatalogPage> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _selectedKategori;
  
  @override
  void initState() {
    super.initState();
    
    context.read<KategoriBloc>().add(FetchKategori());
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value, KatalogBloc bloc) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;

      bloc.add(SearchKatalog(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          KatalogBloc(repository: KatalogRepository())..add(FetchKatalog()),

      // listener disini
      child: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Berhasil yeayy"),
                backgroundColor: Colors.green,
              ),
            );
            context.read<KatalogBloc>().add(FetchKatalog());
          }

          if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            final katalogBloc = context.read<KatalogBloc>();
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                title: const Text(
                  "List Katalog",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.navy,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Column(
                children: [
                  SearchBar(
                    controller: _searchController,
                    hintText: 'Carii jenis mobil...',
                    leading: const Icon(Icons.manage_search_rounded),
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    elevation: const WidgetStatePropertyAll(0),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    trailing: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            setState(_searchController.clear);
                            context.read<KatalogBloc>().add(FetchKatalog());
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                    ],
                    onChanged: (value) {
                      setState(() {});
                      _onSearchChanged(value, katalogBloc);
                    },
                  ),
                  BlocBuilder<KategoriBloc, KategoriState>(
                    
                    builder: (context, state) {
                      if (state is KategoriLoaded) {
                        final kategori = state.kategoriList;
                        return Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: kategori.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final category = kategori[index];
                              return FilterChip(
                                label: Text(category.merk),
                                selected: _selectedKategori == category.merk,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedKategori = selected
                                        ? category.merk
                                        : null;
                                  });
                                },
                                backgroundColor: Colors.white,
                                selectedColor: AppColors.navy.withOpacity(0.2),
                                checkmarkColor: AppColors.navy,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  // filter disiniii huss
                  Expanded(
                    child: BlocBuilder<KatalogBloc, KatalogState>(
                      builder: (context, state) {
                        if (state is KatalogLoading) {
                          return Center(
                            child: Lottie.asset(
                              'assets/loading.json',
                              width: 200,
                            ),
                          );
                        }
                        if (state is KatalogLoaded) {
                          final filtered = state.katalogList.where((k){
                            final matchesSearch = k.nama.toLowerCase().contains(_searchController.text.toLowerCase());
                            final matchesCategory = _selectedKategori == null || k.merk == _selectedKategori;
                            return matchesSearch && matchesCategory;
                          }).toList();
                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final katalog = filtered[index];
                              return _buildKatalogCard(context, katalog);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.navy,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<KatalogBloc>(),
                        child: const AddKatalogPage(),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKatalogCard(BuildContext context, dynamic katalog) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<KatalogBloc>(),
                child: DetailKatalogPage(katalog: katalog),
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.navygrey),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.navy,
                child: const Icon(Icons.category, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      katalog.nama,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp ${katalog.harga}",
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
