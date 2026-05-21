import 'package:flutter/material.dart';
import '../services/product_service.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();

  ProductService productService = ProductService();

  saveData() async {
    bool success = await productService.addProduct(
      namaBarang: namaController.text,
      harga: hargaController.text,
      stok: stokController.text,
      image: "",
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),

            TextField(
              controller: hargaController,
              decoration: const InputDecoration(labelText: "Harga"),
            ),

            TextField(
              controller: stokController,
              decoration: const InputDecoration(labelText: "Stok"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: saveData, child: const Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
