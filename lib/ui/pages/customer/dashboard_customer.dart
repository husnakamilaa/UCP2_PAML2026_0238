import 'dart:async';

import 'package:driveease/logic/bloc/admin/auth/auth_bloc.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_event.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_state.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_bloc.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_state.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_event.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_state.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/ui/pages/auth/login.dart';
import 'package:driveease/ui/pages/customer/detail_katalog_cust.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';


class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
        }
      },
      child: Builder(
        builder: (context) {
          final katalogBloc = context.read<KatalogBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text("Drive Ease Katalog"),
              backgroundColor: AppColors.navy,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () =>
                      context.read<AuthBloc>().add(LogoutRequested()),
                ),
              ],
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
                // BUATTT FILTERR MAKANYA PERLU BLOC
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
                        final filtered = state.katalogList.where((k) {
                          final matchesSearch = k.nama.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          );
                          final matchesCategory =
                              _selectedKategori == null ||
                              k.merk == _selectedKategori;
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
          );
        },
      ),
    );
  }
  Widget _buildKatalogCard(BuildContext context, dynamic katalog) {
    final bool isKategoriDeleted = katalog.id_kategori == null;
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
                child: DetailKatalogCust(katalog: katalog),
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isKategoriDeleted
                ? Colors
                      .grey
                      .shade300 // ni buat truenya, alias kalau null
                : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isKategoriDeleted ? Colors.grey : AppColors.navygrey,),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isKategoriDeleted
                    ? Colors.grey
                    : AppColors.navy,
                child: const Icon(Icons.category, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      katalog.nama,
                      style: TextStyle(
                        color: isKategoriDeleted
                            ? Colors.grey.shade700
                            : AppColors.navy,
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
                    Text(
                      katalog.merk ?? "Kategori sudah dihapus",
                      style: TextStyle(
                        color: isKategoriDeleted ? Colors.red : AppColors.grey,
                        fontSize: 12,
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
