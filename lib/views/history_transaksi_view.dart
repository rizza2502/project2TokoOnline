import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/pesan.dart';
import 'package:flutter_application_1/views/transaksi_view.dart';

class HistoryTransaksiView extends StatefulWidget {
  const HistoryTransaksiView({super.key});

  @override
  State<HistoryTransaksiView> createState() => _HistoryTransaksiViewState();
}

class _HistoryTransaksiViewState extends State<HistoryTransaksiView> {
  final Color mainColor = const Color(0xFF800000);
  List historyList = [];
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  void fetchHistory() async {
    var result = await PesanService().getHistory();

    print("STATUS: ${result.status}");
    print("DATA: ${result.data}");

    setState(() {
      isLoading = false;
      if (result.status == true) {
        historyList = List.from(result.data ?? []);
      } else {
        errorMsg = result.message;
      }
    });
  }

  String formatRupiah(dynamic harga) {
    int nominal = harga is int ? harga : int.tryParse(harga.toString()) ?? 0;
    return 'Rp${nominal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  Color statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'selesai':
      case 'success':
        return Colors.green;
      case 'proses':
      case 'pending':
        return Colors.orange;
      case 'batal':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      appBar: AppBar(
        title: const Text('History Transaksi'),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TransaksiView()),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    errorMsg!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMsg = null;
                      });
                      fetchHistory();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : historyList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada transaksi',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: mainColor,
              onRefresh: () async => fetchHistory(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  final trx = historyList[index];
                  final items = trx['detail'] as List? ?? [];

                  // ✅ Hitung total dari detail
                  int totalHarga = 0;
                  for (var item in items) {
                    int qty = int.tryParse(item['quantity'].toString()) ?? 0;
                    int harga =
                        int.tryParse(
                          (item['harga_beli'] ?? 0).toString().split('.')[0],
                        ) ??
                        0;
                    totalHarga += qty * harga;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Invoice #${trx['id_transaksi'] ?? '-'}', // ✅ fix
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor(
                                    trx['status']?.toString(),
                                  ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: statusColor(
                                      trx['status']?.toString(),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  trx['status']?.toString() ?? '-',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor(
                                      trx['status']?.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // ✅ Tanggal fix
                          Text(
                            'Tanggal: ${trx['tgl_transaksi'] ?? '-'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Divider(height: 16),

                          // ✅ List item
                          ...items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  // ✅ Placeholder karena API tidak kirim image
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 24,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['nama_barang']?.toString() ??
                                              '-', // ✅ fix
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${item['quantity']} x ${formatRupiah(item['harga_beli'] ?? 0)}', // ✅ fix
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formatRupiah(
                                      (int.tryParse(
                                                item['quantity'].toString(),
                                              ) ??
                                              0) *
                                          (int.tryParse(
                                                (item['harga_beli'] ?? 0)
                                                    .toString()
                                                    .split('.')[0],
                                              ) ??
                                              0),
                                    ), // ✅ fix
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formatRupiah(totalHarga), // ✅ fix
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
