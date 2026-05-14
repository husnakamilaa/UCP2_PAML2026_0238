import 'package:driveease/data/models/katalog.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailKatalogCust extends StatelessWidget {
  const DetailKatalogCust({super.key, required this.katalog});

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
                      _buildItem(Icons.speed, "${katalog.maxspeed} km/h"),
                      _buildItem(
                        Icons.calendar_today,
                        "Tahun ${katalog.tahun_produksi}",
                      ),
                      _buildItem(Icons.people, "${katalog.capacity} Kursi"),
                      _buildItem(Icons.settings, katalog.transmisi),
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
}
