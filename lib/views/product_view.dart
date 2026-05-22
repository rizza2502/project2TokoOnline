import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/response_data_list.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:flutter_application_1/views/add_product.dart';
import 'package:flutter_application_1/views/edit_product.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductService productService = ProductService();

  List<ProductModel> listBarang = [];

  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  // ================= GET DATA =================
  Future<void> getBarang() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    ResponseDataList res = await productService.getProduct();

    setState(() {
      isLoading = false;

      if (res.status == true) {
        listBarang = List<ProductModel>.from(res.data ?? []);
      } else {
        errorMessage = res.message ?? "Terjadi kesalahan";
      }
    });
  }

  // ================= DELETE =================
  Future<void> deleteBarang(String id) async {
    // FIX: deleteProduct sekarang return Map bukan bool
    Map<String, dynamic> result = await productService.deleteProduct(id);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Produk berhasil dihapus")),
      );
      // FIX: Refresh list setelah delete berhasil
      getBarang();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // FIX: Tampilkan pesan error dari server agar bisa debug
          content: Text("Gagal menghapus: ${result['message']}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= DIALOG DELETE =================
  void showDeleteDialog(ProductModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hapus Produk"),
          content: Text("Yakin ingin menghapus ${item.namaBarang} ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

              onPressed: () {
                Navigator.pop(context);
                deleteBarang(item.id.toString());
              },

              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Katalog Produk",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: getBarang,
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
          ),
        ],
      ),

      // ================= ADD BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF800000),
        child: const Icon(Icons.add, color: Colors.white),

        onPressed: () async {
          // FIX: Cek return value dari AddProductView
          // Jika pop(true), artinya berhasil tambah, langsung refresh
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductView()),
          );

          // FIX: Refresh selalu setelah kembali dari add, bukan hanya kalau result == true
          getBarang();
        },
      ),

      body: _buildBody(),

      bottomNavigationBar: BottomNav(1),
    );
  }

  // ================= BODY =================
  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),

            const SizedBox(height: 12),

            Text(errorMessage, textAlign: TextAlign.center),

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

    if (listBarang.isEmpty) {
      return const Center(child: Text("Tidak ada produk"));
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      child: RefreshIndicator(
        onRefresh: getBarang,

        child: ListView.builder(
          itemCount: listBarang.length,

          itemBuilder: (context, index) {
            ProductModel item = listBarang[index];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProductView(product: item),
                    ),
                  );
                  getBarang();
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Gambar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.image ?? "",
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Info produk
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.namaBarang ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Rp${item.harga}",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 13,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Stok: ${item.stok}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Tombol aksi
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditProductView(product: item),
                                ),
                              );
                              getBarang();
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.orange,
                              size: 22,
                            ),
                            tooltip: "Edit",
                          ),
                          IconButton(
                            onPressed: () => showDeleteDialog(item),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 22,
                            ),
                            tooltip: "Hapus",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
