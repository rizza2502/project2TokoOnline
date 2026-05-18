import 'dart:convert';
import 'package:flutter_application_1/models/response_data_map.dart';
import 'package:flutter_application_1/models/user_login.dart';
import 'package:flutter_application_1/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  Future<ResponseDataMap> registerUser(Map<String, dynamic> data) async {
    try {
      // FIX: konversi semua value ke String, hindari null agar tidak throw "Cannot send Null"
      Map<String, String> cleanData = {};
      data.forEach((key, value) {
        cleanData[key] = value?.toString() ?? "";
      });

      var uri = Uri.parse("${url.BaseUrl}/auth/register");

      var register = await http
          .post(uri, body: cleanData)
          .timeout(const Duration(seconds: 10));

      if (register.statusCode == 200) {
        var res = json.decode(register.body);

        if (res["status"] == true) {
          return ResponseDataMap(
            status: true,
            message: "Sukses menambah user",
            data: res,
          );
        } else {
          String message = "";
          // FIX: jaga-jaga jika message bukan Map (bisa berupa String langsung)
          if (res["message"] is Map) {
            for (String key in res["message"].keys) {
              message += res["message"][key][0] + "\n";
            }
          } else {
            message = res["message"].toString();
          }
          return ResponseDataMap(status: false, message: message.trim());
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Gagal menambah user (HTTP ${register.statusCode})",
        );
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
      return ResponseDataMap(
        status: false,
        message: "Tidak dapat terhubung ke server: $e",
      );
    }
  }

  Future<ResponseDataMap> loginUser(Map<String, dynamic> data) async {
    try {
      // FIX: konversi semua value ke String, hindari null
      Map<String, String> cleanData = {};
      data.forEach((key, value) {
        cleanData[key] = value?.toString() ?? "";
      });

      var uri = Uri.parse("${url.BaseUrl}/auth/login");
      var response = await http
          .post(uri, body: cleanData)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var res = json.decode(response.body);
        if (res["status"] == true) {
          UserLogin userLogin = UserLogin(
            status: res["status"] ?? false,
            token: res["token"]?.toString() ?? "",
            message: res["message"]?.toString() ?? "",
            // FIX: id dari API kadang String, paksa ke int
            id: res["user"]["id"] is int
                ? res["user"]["id"]
                : int.tryParse(res["user"]["id"].toString()) ?? 0,
            nama_user: res["user"]["nama_user"]?.toString() ?? "",
            email: res["user"]["email"]?.toString() ?? "",
            role: res["user"]["role"]?.toString() ?? "",
          );
          await userLogin.prefs();
          return ResponseDataMap(
            status: true,
            message: "Sukses login user",
            data: res,
          );
        } else {
          return ResponseDataMap(
            status: false,
            message: res["message"]?.toString() ?? 'Email dan password salah',
          );
        }
      } else {
        return ResponseDataMap(
          status: false,
          message: "Gagal login (HTTP ${response.statusCode})",
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return ResponseDataMap(
        status: false,
        message: "Tidak dapat terhubung ke server: $e",
      );
    }
  }
}
