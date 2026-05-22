import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/url.dart' as url;
import '../services/product_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();
  final deskripsiController = TextEditingController(); // FIX: tambah deskripsi

  ProductService productService = ProductService();
  bool isLoading = false;

  Future<void> saveData() async {
    if (namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama produk tidak boleh kosong")),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih gambar produk terlebih dahulu")),
      );
      return;
    }

    setState(() => isLoading = true);

    Map<String, dynamic> result = await productService.addProduct(
      namaBarang: namaController.text.trim(),
      harga: hargaController.text.trim(),
      stok: stokController.text.trim(),
      image: _selectedImage!.path,
      deskripsi: deskripsiController.text.trim(),
    );

    print('RESULT: $result'); // untuk debug, boleh dihapus nanti

    setState(() => isLoading = false);

    // ← bagian ini yang hilang dari kode kamu
    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Produk berhasil ditambahkan"),
        ),
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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Fungsi pilih gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // atau ImageSource.camera untuk kamera
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gambar Produk'),
                SizedBox(height: 8),

                // Preview gambar
                if (_selectedImage != null)
                  Image.file(_selectedImage!, height: 150, fit: BoxFit.cover)
                else
                  Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, size: 60, color: Colors.grey),
                  ),

                SizedBox(height: 8),

                // Tombol pilih gambar
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo_library),
                  label: Text('Pilih Gambar dari Galeri'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF800000),
                ),
                onPressed: isLoading ? null : saveData,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan",
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
