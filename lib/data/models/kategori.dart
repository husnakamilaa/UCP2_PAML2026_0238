class KategoriModel {
  final int id;
  final String merk; 

  KategoriModel({
    required this.id,
    required this.merk,
  });

   factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      merk: json['merk'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merk': merk,
    };
  }
}