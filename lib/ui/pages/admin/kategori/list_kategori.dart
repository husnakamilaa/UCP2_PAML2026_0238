import 'package:driveease/data/repositories/admin/kategori_repository.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_state.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_bloc.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_event.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_state.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_event.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/ui/pages/admin/kategori/add_kategori.dart';
import 'package:driveease/ui/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

class ListKategoriPage extends StatelessWidget {
  const ListKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          KategoriBloc(repository: KategoriRepository())..add(FetchKategori()),

      // listener disini
      child: BlocListener<KategoriBloc, KategoriState>(
        listener: (context, state) {
          if (state is KategoriCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Berhasil yeayy"),
                backgroundColor: Colors.green,
              ),
            );
            context.read<KategoriBloc>().add(FetchKategori());
          }

          if (state is KategoriError) {
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
            final kategoriBloc = context.read<KategoriBloc>();
            return Scaffold(
              backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text("List Kategori", style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.navy,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
              body: BlocBuilder<KategoriBloc, KategoriState>(
                builder: (context, state) {
                  if (state is KategoriLoading) {
                    return Center(
                      child: Lottie.asset('assets/loading.json', width: 200),
                    );
                  }
                  if (state is KategoriLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.kategoriList.length,
                      itemBuilder: (context, index) {
                        final kategori = state.kategoriList[index];

                        return _buildKategoriCard(context, kategori);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.navy,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<KategoriBloc>(),
                        child: const AddKategoriPage(),
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

  Widget _buildKategoriCard(BuildContext context, dynamic kategori) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: const Icon(Icons.category, color: Colors.white),
        ),
        title: Text(
          kategori.merk,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _showDeleteDialog(context, kategori),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic kategori) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.navygrey,
        title: const Text(
          'Hapus Kategori?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Anda yakin ingin menghapus ${kategori.merk}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<KategoriBloc>().add(DeleteKategori(kategori.id));
              Navigator.pop(dialogContext);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
