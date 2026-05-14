import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_event.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_state.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:driveease/ui/pages/admin/kategori/list_kategori.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AddKategoriPage extends StatefulWidget {
  const AddKategoriPage({super.key});

  @override
  State<AddKategoriPage> createState() => _AddKategoriPageState();
}

class _AddKategoriPageState extends State<AddKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final _merkController = TextEditingController();

  @override
  void dispose() {
    _merkController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {'merk': _merkController.text};

      context.read<KategoriBloc>().add(CreateKategori(data));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori berhasil ditambahkan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("Tambah Kategori")),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.white),

        child: BlocConsumer<KategoriBloc, KategoriState>(
          // listener
          listener: (context, state) {
            if (state is KategoriCreatedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kategori berhasil ditambahkan'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is KategoriError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          // builder
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _merkController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'merk harus diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              if (state is KategoriLoading)
                                Center(
                                  child: SizedBox(
                                    height: 60,
                                    child: Lottie.asset('assets/loading.json'),
                                  ),
                                )
                              else
                                ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.navy,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 8,
                                    shadowColor: AppColors.navy.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  child: const Text(
                                    "Simpan",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
