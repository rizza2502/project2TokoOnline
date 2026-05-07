import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/response_data_list.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductService productService = ProductService();
  List? listBarang;

  // FIX: tambah state loading dan error agar spinner bisa berhenti
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  getBarang() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    ResponseDataList res = await productService.getProduct();

    // FIX: apapun hasilnya (sukses/gagal), loading harus berhenti
    setState(() {
      isLoading = false;
      if (res.status == true) {
        listBarang = res.data;
      } else {
        errorMessage = res.message; // tampilkan pesan error dari service
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Produk"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNav(1),
    );
  }

  Widget _buildBody() {
    // FIX: 3 state: loading, error, sukses
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    String? errorMessage;
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
                foregroundColor: Colors.white,
              ),
              onPressed: getBarang, // tombol retry
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (listBarang == null || listBarang!.isEmpty) {
      return const Center(child: Text("Tidak ada produk"));
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: listBarang!.length,
        itemBuilder: (context, index) {
          ProductModel item = listBarang![index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Image.network(
                item.image!,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
              title: Text(
                item.namaBarang ?? "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Harga: Rp${item.harga}"),
                  Text(
                    "Stok: ${item.stok}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
