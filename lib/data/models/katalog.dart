class KatalogModel {
  final int id;
  final int id_kategori;
  final String nama; 
  final int harga;
  final String tahun_produksi;
  final String transmisi;
  final String capacity;
  final String maxspeed;
  final String image;
  final String? merk;

  KatalogModel({
    required this.id,
    required this.id_kategori,
    required this.nama,
    required this.harga,
    required this.tahun_produksi,
    required this.transmisi,
    required this.capacity,
    required this.maxspeed,
    required this.image,
    required this.merk,
  });

   factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      id: json['id'],
      id_kategori: json['id_kategori'],
      nama: json['nama'],
      harga: json['harga'],
      tahun_produksi: json['tahun_produksi'],
      transmisi: json['transmisi'],
      capacity: json['capacity'],
      maxspeed: json['maxspeed'],
      image: json['image'],
      merk: json['merk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': id_kategori,
      'nama': nama, 
      'harga': harga,
      'tahun_produksi': tahun_produksi,
      'transmisi': transmisi,
      'capacity': capacity,
      'maxspeed': maxspeed,
      'image': image,
    };
  }
}