import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/response_data_map.dart';
import 'package:flutter_application_1/models/user_login.dart';
import 'package:flutter_application_1/services/url.dart' as url;
import 'package:shared_preferences/shared_preferences.dart';

class PesanService {
  UserLogin userLogin = UserLogin();

  Future saveToDB(dataRequest) async {
    var uri = Uri.parse("${url.BaseUrl}/user/transaksi");
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataMap(
        status: false,
        message: 'Anda belum login / token invalid',
      );
    }

    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      'Content-Type': "application/json",
    };

    try {
      var simpanPesan = await http
          .post(uri, body: json.encode(dataRequest), headers: headers)
          .timeout(const Duration(seconds: 15));

      var data = json.decode(simpanPesan.body);

      if (simpanPesan.statusCode == 200) {
        if (data["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: "Pesanan berhasil dibuat",
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: data["message"] ?? "Gagal membuat pesanan",
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Gagal mengirim pesanan (HTTP ${simpanPesan.statusCode})",
        );
      }
    } catch (e) {
      return ResponseDataMap(status: false, message: "Fatal error: $e");
    }
  }

  Future<ResponseDataMap> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      var uri = Uri.parse("${url.BaseUrl}/user/history_trans");
      var response = await http
          .get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        if (res['status'] == true) {
          return ResponseDataMap(
            status: true,
            message: 'Sukses',
            data: res['data'],
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: res['message']?.toString() ?? 'Gagal memuat history',
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: 'HTTP Error ${response.statusCode}',
        );
      }
    } catch (e) {
      return ResponseDataMap(
        status: false,
        message: 'Tidak dapat terhubung ke server: $e',
      );
    }
  }
}
