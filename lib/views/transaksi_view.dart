import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/cart_provider.dart';
import 'package:flutter_application_1/models/cart.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/services/db_helper.dart';
import 'package:flutter_application_1/services/product_service.dart';
import 'package:flutter_application_1/widgets/alert.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final Color mainColor = const Color(0xFF800000);
  var dBHelper = DBHelper();
  final cartProvider = CartProvider();

  List<ProductModel>? products;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProducts();
    updateCount();
  }

  void updateCount() async {
    await cartProvider.getData();
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
  }

  void getProducts() async {
    var result = await ProductService().getProduct();

    print("STATUS: ${result.status}"); // ← tambah ini
    print("MESSAGE: ${result.message}"); // ← tambah ini
    print("DATA: ${result.data}"); // ← tambah ini

    setState(() {
      isLoading = false;
      if (result.status == true) {
        products = List<ProductModel>.from(result.data ?? []);
      }
    });
  }

  void saveToCart(ProductModel product) async {
    var detail = await dBHelper.getCartListDetail(product.id);
    var qty = 0;
    if (detail != null && detail.isNotEmpty) {
      qty = detail[0].quantity;
    }

    await dBHelper.insert(
      Cart(
        id: product.id,
        idBarang: product.id.toString(),
        namaBarang: product.namaBarang,
        harga: product.harga,
        deskripsi: product.deskripsi,
        quantity: qty + 1,
        image: product.image,
      ),
    );

    updateCount();
    AlertMessage().showAlert(
      context,
      "${product.namaBarang} ditambahkan ke keranjang",
      true,
    );
  }

  String formatRupiah(int harga) {
    return 'Rp${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      appBar: AppBar(
        title: const Text("Belanja"),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // IKON KERANJANG DENGAN BADGE
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              ListenableBuilder(
                listenable: cartProvider,
                builder: (context, child) {
                  if (cartProvider.cart.isEmpty) return const SizedBox();
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartProvider.cart.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products == null || products!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tidak ada produk tersedia",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.62,
              ),
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final product = products![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GAMBAR
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.image ?? '',
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.shade400,
                              size: 40,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        // ← tambah Expanded di sini
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween, // ← tambah ini
                            children: [
                              // nama, harga, stok, tombol...
                            ],
                          ),
                        ),
                      ),

                      // INFO
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.namaBarang ?? '-',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatRupiah(product.harga ?? 0),
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Stok: ${product.stok}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.add_shopping_cart,
                                  size: 16,
                                ),
                                label: const Text(
                                  '+ Keranjang',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onPressed: () => saveToCart(product),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
