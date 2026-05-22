import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/response_data_list.dart';
import 'package:flutter_application_1/models/user_login.dart';
import 'package:flutter_application_1/services/url.dart' as url;

class ProductService {
  bool _parseStatus(dynamic status) {
    return status == true || status == "true" || status == 1;
  }

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
        bool isSuccess = _parseStatus(jsonResponse['status']);
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

  Future<Map<String, dynamic>> addProduct({
  required String namaBarang,
  required String harga,
  required String stok,
  required String image,
  required String deskripsi,
}) async {
  UserLogin userLogin = UserLogin();
  var user = await userLogin.getUserLogin();

  var uri = Uri.parse("${url.BaseUrl}/admin/insertbarang"); // ← fix endpoint

  try {
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer ${user.token}';

    request.fields['nama_barang'] = namaBarang;
    request.fields['deskripsi'] = deskripsi;
    request.fields['harga'] = harga;
    request.fields['stok'] = stok;

    if (image.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', image));
    }

    var streamedResponse = await request.send().timeout(const Duration(seconds: 15));
    var response = await http.Response.fromStream(streamedResponse);

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      bool success = _parseStatus(jsonResponse['status']);
      return {
        'success': success,
        'message': jsonResponse['message']?.toString() ?? (success ? "Berhasil" : "Gagal"),
      };
    }
    return {'success': false, 'message': "Server error (HTTP ${response.statusCode})"};
  } catch (e) {
    return {'success': false, 'message': e.toString()};
  }
}

  Future<Map<String, dynamic>> updateProduct({
    required String id,
    required String namaBarang,
    required String harga,
    required String stok,
    required String image,
    required String deskripsi,
  }) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    var uri = Uri.parse("${url.BaseUrl}/admin/updatebarang/$id");

    try {
      var response = await http
          .post(
            uri,
            headers: {'Authorization': 'Bearer ${user.token}'},
            body: {
              "nama_barang": namaBarang,
              "deskripsi": deskripsi,
              "harga": harga,
              "stok": stok,
              "image": image,
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        bool success = _parseStatus(jsonResponse['status']);
        return {
          'success': success,
          'message':
              jsonResponse['message']?.toString() ??
              (success ? "Berhasil" : "Gagal"),
        };
      }
      return {
        'success': false,
        'message': "Server error (HTTP ${response.statusCode})",
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    Map<String, String> headers = {'Authorization': 'Bearer ${user.token}'};

    var uri = Uri.parse("${url.BaseUrl}/admin/hapusbarang/$id");

    try {
      var response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        bool success = _parseStatus(jsonResponse['status']);
        return {
          'success': success,
          'message':
              jsonResponse['message']?.toString() ??
              (success ? "Berhasil dihapus" : "Gagal menghapus"),
        };
      }
      return {
        'success': false,
        'message': "Server error (HTTP ${response.statusCode})",
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
