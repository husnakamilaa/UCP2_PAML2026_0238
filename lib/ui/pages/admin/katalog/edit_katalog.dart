import 'dart:convert';
import 'dart:io';

import 'package:driveease/logic/bloc/admin/katalog/katalog_bloc.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_event.dart';
import 'package:driveease/logic/bloc/admin/katalog/katalog_state.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_bloc.dart';
import 'package:driveease/logic/bloc/admin/kategori/kategori_state.dart';
import 'package:driveease/ui/components/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:http/http.dart' as http;

class EditKatalogPage extends StatefulWidget {
  final dynamic katalog;

  const EditKatalogPage({super.key, required this.katalog});

  @override
  State<EditKatalogPage> createState() => _EditKatalogPageState();
}

class _EditKatalogPageState extends State<EditKatalogPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _maxspeedController = TextEditingController();
  final _capacityController = TextEditingController();

  final _rupiahFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  int? _selectedKategoriId;
  String? _selectedTahun;
  String? _selectedTransmisi;

  final List<String> _listTahun = [
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
  ];
  final List<String> _listTransmisi = ['Automatic', 'Manual'];

  File? _imageFile; // image baru :karna hasilnya poto
  String? _imageUrl; //ini image lama urlnya
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.katalog.nama;

    _hargaController.text = widget.katalog.harga.toString();
    // _hargaController.text = _rupiahFormatter.formatString(
    //   widget.katalog.harga.toString(),
    // );

    _maxspeedController.text = widget.katalog.maxspeed.replaceAll(' km/jam', '');

    _capacityController.text = widget.katalog.capacity.replaceAll(' seats', '');

    _imageUrl = widget.katalog.image;

    _selectedKategoriId = widget.katalog.id_kategori;
    _selectedTahun = widget.katalog.tahun_produksi;

    _selectedTransmisi =
        widget.katalog.transmisi[0].toUpperCase() +
        widget.katalog.transmisi.substring(1).toLowerCase();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _maxspeedController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1920,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      final imageUrl = await uploadImageToCloudinary(
        pickedFile.path,
      );

      if (!mounted) return;

      setState(() {
        _imageUrl = imageUrl;
      });

      print("URL IMAGE: $imageUrl");
    }
  } catch (e) {
    print("Error mengambil gambar: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal mengambil gambar: $e")),
    );
  }
}

  Future<String> uploadImageToCloudinary(String imagePath) async {
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/dmluc0pml/image/upload",
    );

    final request = http.MultipartRequest("POST", uri);

    request.fields['upload_preset'] = 'driveease';

    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      return data['secure_url'];
    } else {
      throw Exception("Upload gambar gagal");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null && _imageUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Pilih gambar mobilll")));
        return;
      }

    //   String imageUrl = _imageUrl ?? '';

    // if (_imageFile != null) {
    //   imageUrl = await uploadImageToCloudinary(_imageFile!.path);
    // }


      if (_selectedKategoriId == null ||
          _selectedTahun == null ||
          _selectedTransmisi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Harap lengkapi semua pilihan!")),
        );
        return;
      }
      String hargaBersih = _hargaController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      final data = {
        'id_kategori': _selectedKategoriId,
        'nama': _namaController.text,
        'harga': int.parse(hargaBersih),
        'tahun_produksi': _selectedTahun,
        'transmisi': _selectedTransmisi,
        'maxspeed': "${_maxspeedController.text} km/jam",
        'capacity': "${_capacityController.text} seats",
        'image': _imageUrl,
      };

      context.read<KatalogBloc>().add(UpdateKatalog(widget.katalog.id, data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("Tambah Katalog")),
      body: BlocListener<KatalogBloc, KatalogState>(
        // listener
        listener: (context, state) {
          if (state is KatalogCreatedSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Katalog berhasil ditambahkan'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is KatalogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        // builder
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      padding: const EdgeInsets.all(5),
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
                            controller: _namaController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'nama harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // harga
                          BlocBuilder<KategoriBloc, KategoriState>(
                            builder: (context, state) {
                              List<DropdownMenuItem<int>> menuItems = [];
                              String hintText = "Memuat data merk...";
                              bool isLoading = true;

                              if (state is KategoriLoaded) {
                                isLoading = false;
                                hintText = "Pilih Merk Mobil";
                                // Mapping data dari backend
                                menuItems = state.kategoriList.map((kat) {
                                  return DropdownMenuItem<int>(
                                    value: kat.id,
                                    child: Text(kat.merk),
                                  );
                                }).toList();
                              }

                              return DropdownButtonFormField<int>(
                                value: _selectedKategoriId,
                                decoration: InputDecoration(
                                  labelText: "Merk Mobil",
                                  hintText: hintText,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: isLoading ? null : menuItems,
                                onChanged: isLoading
                                    ? null
                                    : (val) => setState(
                                        () => _selectedKategoriId = val,
                                      ),
                                validator: (val) =>
                                    val == null ? 'Pilih merk mobil' : null,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _hargaController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_rupiahFormatter],
                            decoration: InputDecoration(
                              labelText: "Harga Sewa",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Harga harus diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedTahun,
                                  decoration: InputDecoration(
                                    labelText: "Tahun",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: _listTahun.map((t) {
                                    return DropdownMenuItem(
                                      value: t,
                                      child: Text(t),
                                    );
                                  }).toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedTahun = val),
                                  validator: (val) =>
                                      val == null ? 'Wajib' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedTransmisi,
                                  decoration: InputDecoration(
                                    labelText: "Transmisi",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: _listTransmisi.map((t) {
                                    return DropdownMenuItem(
                                      value: t,
                                      child: Text(t),
                                    );
                                  }).toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedTransmisi = val),
                                  validator: (val) =>
                                      val == null ? 'Wajib' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _maxspeedController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Max Speed",
                                    suffixText: "km/jam",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Wajib' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _capacityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Kapasitas",
                                    suffixText: "Seats",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Wajib' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            "Foto Mobil",
                            style: TextStyle(
                              color: AppColors.navygrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // DISINIII TEMPATT FIELDD IMAGENYAA
                          InkWell(
                            onTap: _pickImage, // Panggil fungsi ambil gambar
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _imageFile != null
                                    ? Image.file(
                                        _imageFile!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                    : _imageUrl != null
                                    ? Image.network(
                                        _imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        //PAKE KLO ERROR AJA IMAHGENYAA!!!!
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                              );
                                            },
                                      )
                                    : Container(
                                        color: AppColors.white,
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "Tap untuk pilih dari galerimuuu",
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          BlocBuilder<KatalogBloc, KatalogState>(
                            builder: (context, state) {
                              if (state is KatalogLoading) {
                                return Center(
                                  child: SizedBox(
                                    height: 60,
                                    child: Lottie.asset('assets/loading.json'),
                                  ),
                                );
                              }
                              return ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.navy,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "Simpan",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
