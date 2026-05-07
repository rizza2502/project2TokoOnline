import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status = false;
  String? token;
  String? message;
  int? id;
  String? nama_user;
  String? email;
  String? role;

  UserLogin({
    this.status,
    this.token,
    this.message,
    this.id,
    this.nama_user,
    this.email,
    this.role,
  });

  Future prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // FIX: gunakan ?? agar tidak crash jika ada field null saat simpan
    prefs.setBool("status", status ?? false);
    prefs.setString("token", token ?? "");
    prefs.setString("message", message ?? "");
    prefs.setInt("id", id ?? 0);
    prefs.setString("nama_user", nama_user ?? "");
    prefs.setString("email", email ?? "");
    prefs.setString("role", role ?? "");
  }

  Future<UserLogin> getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // FIX: gunakan ?? agar tidak crash jika key belum ada (belum pernah login)
    UserLogin userLogin = UserLogin(
      status: prefs.getBool("status") ?? false,
      token: prefs.getString("token") ?? "",
      message: prefs.getString("message") ?? "",
      id: prefs.getInt("id") ?? 0,
      nama_user: prefs.getString("nama_user") ?? "",
      email: prefs.getString("email") ?? "",
      role: prefs.getString("role") ?? "",
    );
    return userLogin;
  }
}
