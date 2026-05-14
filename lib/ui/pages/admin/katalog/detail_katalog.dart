import 'package:driveease/data/models/katalog.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_bloc.dart';
import 'package:driveease/ui/pages/admin/katalog/edit_katalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailKatalogPage extends StatelessWidget {
  const DetailKatalogPage({super.key, required this.katalog});

  final dynamic katalog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(katalog.nama),
        backgroundColor: AppColors.navygrey,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(katalog.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    katalog.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Rp ${katalog.harga}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    children: [
                      _buildItem(Icons.speed, "${katalog.maxspeed}"),
                      _buildItem(
                        Icons.calendar_today,
                        "Tahun ${katalog.tahun_produksi}",
                      ),
                      _buildItem(Icons.people, "${katalog.capacity}"),
                      _buildItem(Icons.settings, katalog.transmisi),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<KatalogBloc>(),
                        child: EditKatalogPage(katalog: katalog),
                      ),
                    ),
                  );
                          },
                          icon: const Icon(Icons.edit, color: AppColors.white),
                          label: const Text(
                            "Edit",
                            style: TextStyle(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showDeleteDialog(context, katalog),
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.navygrey,
                          ),
                          label: const Text(
                            "Hapus",
                            style: TextStyle(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String text){
    return Row(
      children: [
        Icon(icon, color: AppColors.navygrey, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic katalog) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.navygrey,
        title: const Text(
          'Hapus Katalog?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Anda yakin ingin menghapus ${katalog.nama}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<KatalogBloc>().add(DeleteKatalog(katalog.id));
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
