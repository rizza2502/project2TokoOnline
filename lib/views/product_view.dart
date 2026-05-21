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
    bool success = await productService.deleteProduct(id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Produk berhasil dihapus"),
        ),
      );

      getBarang();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal menghapus produk"),
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
          content: Text(
            "Yakin ingin menghapus ${item.namaBarang} ?",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),

              onPressed: () {
                Navigator.pop(context);

                deleteBarang(item.id.toString());
              },

              child: const Text("Hapus"),
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
        title: const Text("Katalog Produk"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),

      // ================= ADD BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF800000),

        child: const Icon(Icons.add),

        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddProductView(),
            ),
          );

          getBarang();
        },
      ),

      body: _buildBody(),

      bottomNavigationBar: BottomNav(1),
    );
  }

  // ================= BODY =================
  Widget _buildBody() {

    // ================= LOADING =================
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // ================= ERROR =================
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

    // ================= EMPTY =================
    if (listBarang.isEmpty) {
      return const Center(
        child: Text("Tidak ada produk"),
      );
    }

    // ================= LIST =================
    return RefreshIndicator(
      onRefresh: getBarang,

      child: ListView.builder(
        itemCount: listBarang.length,

        itemBuilder: (context, index) {

          ProductModel item = listBarang[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            elevation: 3,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: ListTile(

              contentPadding: const EdgeInsets.all(10),

              // ================= EDIT PAGE =================
              onTap: () async {

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProductView(
                      product: item,
                    ),
                  ),
                );

                getBarang();
              },

              // ================= IMAGE =================
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),

                child: Image.network(
                  item.image ?? "",

                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {

                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade300,

                      child: const Icon(
                        Icons.broken_image,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),

              // ================= TITLE =================
              title: Text(
                item.namaBarang ?? "-",

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              // ================= SUBTITLE =================
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const SizedBox(height: 6),

                  Text(
                    "Rp${item.harga}",

                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Stok : ${item.stok}",

                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              // ================= ACTION =================
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  // ================= EDIT =================
                  IconButton(
                    onPressed: () async {

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProductView(
                            product: item,
                          ),
                        ),
                      );

                      getBarang();
                    },

                    icon: const Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                  ),

                  // ================= DELETE =================
                  IconButton(
                    onPressed: () {
                      showDeleteDialog(item);
                    },

                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
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