import 'package:flutter/material.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      appBar: AppBar(
        title: const Text("Pesanan Saya"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Dikemas"),
            Tab(text: "Dikirim"),
            Tab(text: "Selesai"),
            Tab(text: "Pengembalian"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKosong("Tidak ada pesanan dikemas"),
          _buildKosong("Tidak ada pesanan dikirim"),
          _buildList(),
          _buildKosong("Tidak ada pengembalian"),
        ],
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }

  // =========================
  // LIST TRANSAKSI
  // =========================
  Widget _buildList() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _transaksiCard(
          toko: "Ibox.id",
          produk: "Iphone 13 pink 128gb ibox",
          qty: 2,
          harga: "Rp8.000.000",
          total: "Rp16.000.000",
          status: "Selesai",
          image: "assets/iphone13.jpg",
        ),
        _transaksiCard(
          toko: "Ibox.id",
          produk: "Iphone XR White 64GB",
          qty: 1,
          harga: "Rp4.000.000",
          total: "Rp4.000.000",
          status: "Selesai",
          image: "assets/iphonexr.jpg",
        ),
      ],
    );
  }

  Widget _buildKosong(String text) {
    return Center(
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
            text,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // CARD TRANSAKSI
  // =========================
  Widget _transaksiCard({
    required String toko,
    required String produk,
    required int qty,
    required String harga,
    required String total,
    required String status,
    required String image,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER TOKO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Star+",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      toko,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFF800000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(),

            // PRODUK
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade300,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        produk,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text("x$qty"),
                    ],
                  ),
                ),
                Text(
                  harga,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // TOTAL
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total $qty produk: $total",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    "Lihat Penilaian",
                    selectionColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800000),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text("Beli Lagi"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
