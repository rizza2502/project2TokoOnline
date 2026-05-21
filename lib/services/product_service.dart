import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/response_data_list.dart';
import 'package:flutter_application_1/models/user_login.dart';
import 'package:flutter_application_1/services/url.dart' as url;

class ProductService {

  // ================= READ PRODUCT =================
  Future<ResponseDataList> getProduct() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.token == null || user.token!.isEmpty) {
      return ResponseDataList(
        status: false,
        message: "Token kosong, silakan login ulang",
      );
    }

    var uri = Uri.parse("${url.BaseUrl}/admin/getbarang");

    try {
      var response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${user.token}',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        var apiStatus = jsonResponse['status'];

        bool isSuccess =
            (apiStatus == true ||
                apiStatus == "true" ||
                apiStatus == 1);

        if (isSuccess) {
          List data = jsonResponse['data'] ?? [];

          List<ProductModel> products = data
              .map((item) => ProductModel.fromJson(item))
              .toList();

          return ResponseDataList(
            status: true,
            message:
                jsonResponse['message']?.toString() ?? "Sukses",
            data: products,
          );
        } else {
          return ResponseDataList(
            status: false,
            message:
                jsonResponse['message']?.toString() ??
                    "Gagal memuat data",
          );
        }
      } else if (response.statusCode == 401) {
        return ResponseDataList(
          status: false,
          message: "Sesi habis, silakan login ulang",
        );
      } else {
        return ResponseDataList(
          status: false,
          message:
              "Server error (HTTP ${response.statusCode})",
        );
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: e.toString(),
      );
    }
  }

  // ================= ADD PRODUCT =================
  Future<bool> addProduct({
    required String namaBarang,
    required String harga,
    required String stok,
    required String image,
  }) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    var uri = Uri.parse("${url.BaseUrl}/admin/addbarang");

    try {
      var response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
        body: {
          "nama_barang": namaBarang,
          "harga": harga,
          "stok": stok,
          "image": image,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        return jsonResponse['status'] == true ||
            jsonResponse['status'] == "true";
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // ================= UPDATE PRODUCT =================
  Future<bool> updateProduct({
    required String id,
    required String namaBarang,
    required String harga,
    required String stok,
    required String image,
  }) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    var uri =
        Uri.parse("${url.BaseUrl}/admin/updatebarang/$id");

    try {
      var response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
        body: {
          "nama_barang": namaBarang,
          "harga": harga,
          "stok": stok,
          "image": image,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        return jsonResponse['status'] == true ||
            jsonResponse['status'] == "true";
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // ================= DELETE PRODUCT =================
  Future<bool> deleteProduct(String id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    var uri =
        Uri.parse("${url.BaseUrl}/admin/deletebarang/$id");

    try {
      var response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        return jsonResponse['status'] == true ||
            jsonResponse['status'] == "true";
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}