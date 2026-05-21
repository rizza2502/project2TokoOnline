import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/services/product_service.dart';

class EditProductView extends StatefulWidget {

  final ProductModel product;

  const EditProductView({
    super.key,
    required this.product,
  });

  @override
  State<EditProductView> createState() =>
      _EditProductViewState();
}

class _EditProductViewState
    extends State<EditProductView> {

  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();
  final imageController = TextEditingController();

  ProductService productService = ProductService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // ================= SET DATA LAMA =================
    namaController.text =
        widget.product.namaBarang ?? "";

    hargaController.text =
        widget.product.harga.toString();

    stokController.text =
        widget.product.stok.toString();

    imageController.text =
        widget.product.image ?? "";
  }

  // ================= UPDATE DATA =================
  Future<void> updateData() async {

    setState(() {
      isLoading = true;
    });

    bool success =
        await productService.updateProduct(

      id: widget.product.id.toString(),

      namaBarang: namaController.text,

      harga: hargaController.text,

      stok: stokController.text,

      image: imageController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Produk berhasil diupdate",
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal update produk",
          ),
        ),
      );
    }
  }

  // ================= UI =================
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

            // ================= NAMA =================
            TextField(
              controller: namaController,

              decoration: const InputDecoration(
                labelText: "Nama Produk",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ================= HARGA =================
            TextField(
              controller: hargaController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Harga",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ================= STOK =================
            TextField(
              controller: stokController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Stok",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // ================= IMAGE =================
            TextField(
              controller: imageController,

              decoration: const InputDecoration(
                labelText: "URL Gambar",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF800000),
                ),

                onPressed:
                    isLoading ? null : updateData,

                child: isLoading

                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                    : const Text(
                        "Update Produk",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}