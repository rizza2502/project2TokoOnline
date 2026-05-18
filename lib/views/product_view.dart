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

    setState(() {
      isLoading = false;

      if (res.status == true) {
        listBarang = res.data;
      } else {
        errorMessage = res.message ?? "Terjadi kesalahan";
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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 12),

            Text(
              errorMessage,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: getBarang,
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (listBarang == null || listBarang!.isEmpty) {
      return const Center(
        child: Text("Tidak ada produk"),
      );
    }

    return ListView.builder(
      itemCount: listBarang!.length,
      itemBuilder: (context, index) {
        ProductModel item = listBarang![index];

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(
              item.image ?? "",
              width: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image);
              },
            ),
            title: Text(item.namaBarang ?? ""),
            subtitle: Text("Rp${item.harga}"),
          ),
        );
      },
    );
  }
}