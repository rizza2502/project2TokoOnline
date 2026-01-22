import 'dart:convert';
import 'package:toko_online/models/response_data_map.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  Future<ResponseDataMap> registerUser(data) async {
    try {
      var uri = Uri.parse("${url.BaseUrl}/auth/register");

      var register = await http
          .post(uri, body: data)
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
          for (String key in res["message"].keys) {
            message += res["message"][key][0] + "\n";
          }

          return ResponseDataMap(status: false, message: message);
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
        message: "Tidak dapat terhubung ke server $e",
      );
    }
  }

  Future<ResponseDataMap> loginUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/auth/login");
    var register = await http.post(uri, body: data);
    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        UserLogin userLogin = UserLogin(
          status: data["status"],
          token: data["token"],
          message: data["message"],
          id: data["user"]["id"],
          nama_user: data["user"]["nama_user"],
          email: data["user"]["email"],
          role: data["user"]["role"],
        );
        await userLogin.prefs();
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: "Sukses login user",
          data: data,
        );
        print(response);
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: 'Email dan password salah',
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "gagal login user dengan code error ${register.statusCode}",
      );
      return response;
    }
  }
}
