import 'package:flutter/material.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
          children: [

            productCard(
              image: "assets/iphone17.jpg",
              title: "Apple Iphone 17 Pro Max Ibox",
              price: "Rp24.749.000",
              sold: "202 terjual",
              location: "Kab. Tangerang",
            ),

            productCard(
              image: "assets/iphone16.jpg",
              title: "Apple Iphone 16 Plus Second Original",
              price: "Rp11.245.000",
              sold: "189 terjual",
              location: "Jakarta",
            ),

            productCard(
              image: "assets/iphone15.jpg",
              title: "Apple IPhone 15 128GB - Garansi Resmi",
              price: "Rp9.534.000",
              sold: "151 terjual",
              location: "Surabaya",
            ),

            productCard(
              image: "assets/iphone12pro.jpg",
              title: "Iphone 12 Pro 256GB resmi beacukai",
              price: "Rp6.840.000",
              sold: "90 terjual",
              location: "Bekasi",
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }

  // ================== CARD PRODUK ==================
  Widget productCard({
    required String image,
    required String title,
    required String price,
    required String sold,
    required String location,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // GAMBAR
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // BADGE MALL
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Mall | ORI",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // NAMA PRODUK
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                // HARGA
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // INFO PENGIRIMAN
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping,
                      size: 14,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        sold,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
