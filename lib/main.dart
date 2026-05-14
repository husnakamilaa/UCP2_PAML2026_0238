import 'package:driveease/data/repositories/admin/kategori_repository.dart';
import 'package:driveease/data/repositories/admin/katalog_repository.dart';
import 'package:driveease/data/repositories/auth_repository.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_bloc.dart';
import 'package:driveease/logic/bloc/admin/auth/auth_state.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_bloc.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_event.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/ui/pages/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // repo provider (multi)
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => KategoriRepository()),
        RepositoryProvider(create: (context) => KatalogRepository()),
      ],
      // multi bloc provider
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                KategoriBloc(repository: context.read<KategoriRepository>())
                  ..add(FetchKategori()),
          ),
          BlocProvider(
            create: (context) =>
                KatalogBloc(repository: context.read<KatalogRepository>())
                  ..add(FetchKatalog()),
          ),
        ],
        child: MaterialApp(
          title: "Drive Ease",
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            primaryColor: AppColors.navy,
            scaffoldBackgroundColor: AppColors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          home: const LoginPage(),
        ),
      ),
    );
  }
}
