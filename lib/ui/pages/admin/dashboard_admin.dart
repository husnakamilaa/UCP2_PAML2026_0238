import 'package:driveease/logic/bloc/admin/auth/auth_bloc.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_event.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_state.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/data/repositories/admin/kategori_repository.dart';
import 'package:driveease/ui/pages/admin/katalog/list_katalog.dart';
import 'package:driveease/ui/pages/admin/kategori/list_kategori.dart';
import 'package:driveease/ui/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driveease/ui/components/colours.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
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
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.white,
                  size: 28,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Drive Ease",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              icon: const Icon(Icons.logout, color: AppColors.white),
              tooltip: "Logout",
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Management Menu",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navygrey,
                      ),
                    ),
                    const Text(
                      "Quick access to operational tools",
                      style: TextStyle(color: AppColors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      Icons.car_crash,
                      "Manage Katalog",
                      "Manajemen Katalog Mobil",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ListKatalogPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.category,
                      "Kategori",
                      "Merk yang tersedia",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ListKategoriPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20), // Inkwell Splash Radius Fix
          onTap: onTap,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightblue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.navy),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.navygrey,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: AppColors.grey),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
