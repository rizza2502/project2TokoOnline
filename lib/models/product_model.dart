import 'package:flutter_application_1/services/url.dart' as url;

class ProductModel {
  int? id;
  String? namaBarang;
  String? deskripsi;
  int? harga;
  int? stok;
  String? image;

  ProductModel({
    this.id,
    this.namaBarang,
    this.deskripsi,
    this.harga,
    this.stok,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      namaBarang: json['nama_barang'],
      deskripsi: json['deskripsi'],
      // FIX: harga dari API bisa double (0.62) atau int, paksa ke int
      harga: json['harga'] != null ? (json['harga'] as num).toInt() : 0,
      stok: json['stok'],
      image: "${url.BaseUrlTanpaApi}/${json['image']}",
    );
  }
}
