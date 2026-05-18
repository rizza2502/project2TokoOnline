import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/response_data_list.dart';
import 'package:flutter_application_1/models/user_login.dart';
import 'package:flutter_application_1/services/url.dart' as url;

class ProductService {
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

        // FIX: status bisa bool true atau string "true"
        var apiStatus = jsonResponse['status'];
        bool isSuccess =
            (apiStatus == true || apiStatus == "true" || apiStatus == 1);

        if (isSuccess) {
          List data = jsonResponse['data'] ?? [];
          List<ProductModel> products = data
              .map((item) => ProductModel.fromJson(item))
              .toList();

          return ResponseDataList(
            status: true,
            message: jsonResponse['message']?.toString() ?? "Sukses",
            data: products,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: jsonResponse['message']?.toString() ?? "Gagal memuat data",
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
          message: "Server error (HTTP ${response.statusCode})",
        );
      }
    } catch (e) {
      return ResponseDataList(status: false, message: e.toString());
    }
  }
}