import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/services/url.dart' as url;

class EditProductView extends StatefulWidget {
  final ProductModel product;
  const EditProductView({super.key, required this.product});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final namaController      = TextEditingController();
  final hargaController     = TextEditingController();
  final stokController      = TextEditingController();
  final imageController     = TextEditingController();
  final deskripsiController = TextEditingController(); // FIX: tambah deskripsi

  ProductService productService = ProductService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaController.text      = widget.product.namaBarang ?? "";
    hargaController.text     = widget.product.harga.toString();
    stokController.text      = widget.product.stok.toString();
    deskripsiController.text = widget.product.deskripsi ?? ""; // FIX: isi dari model

    // Strip base URL dari image
    String fullImageUrl  = widget.product.image ?? "";
    String baseUrlPrefix = "${url.BaseUrlTanpaApi}/";
    imageController.text = fullImageUrl.startsWith(baseUrlPrefix)
        ? fullImageUrl.replaceFirst(baseUrlPrefix, "")
        : fullImageUrl;
  }

  Future<void> updateData() async {
    if (namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama produk tidak boleh kosong")),
      );
      return;
    }

    setState(() => isLoading = true);

    Map<String, dynamic> result = await productService.updateProduct(
      id:         widget.product.id.toString(),
      namaBarang: namaController.text.trim(),
      harga:      hargaController.text.trim(),
      stok:       stokController.text.trim(),
      image:      imageController.text.trim(),
      deskripsi:  deskripsiController.text.trim(), // FIX: kirim deskripsi
    );

    setState(() => isLoading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Produk berhasil diupdate")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal: ${result['message']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Produk"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Produk",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: deskripsiController, // FIX: field deskripsi
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: stokController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stok",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(
                labelText: "Path Gambar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF800000),
                ),
                onPressed: isLoading ? null : updateData,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Update Produk",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}