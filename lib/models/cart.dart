class Cart {
  final int? id;
  final String? idBarang;
  final String? namaBarang;
  final int? harga;
  final String? deskripsi;
  int? quantity;
  final String? image;

  Cart({
    required this.id,
    required this.idBarang,
    required this.namaBarang,
    required this.harga,
    required this.deskripsi,
    required this.quantity,
    required this.image,
  });

  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      idBarang: data['id'].toString(),
      namaBarang: data['nama_barang'],
      harga: data['harga'] != null ? (data['harga'] as num).toInt() : 0,
      deskripsi: data['deskripsi'],
      quantity: data['quantity'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_barang': idBarang,
      'nama_barang': namaBarang,
      'harga': harga,
      'deskripsi': deskripsi,
      'quantity': quantity,
      'image': image,
    };
  }
}