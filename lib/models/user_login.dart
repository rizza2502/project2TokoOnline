import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  bool? status = false;
  String? token;
  String? message;
  int? id;
  String? nama_user;
  String? email;
  String? role;
<<<<<<< HEAD

=======
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
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
<<<<<<< HEAD
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
=======
    prefs.setBool("status", status!);
    prefs.setString("token", token!);
    prefs.setString("message", message!);
    prefs.setInt("id", id!);
    prefs.setString("nama_user", nama_user!);
    prefs.setString("email", email!);
    prefs.setString("role", role!);
  }

  Future getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin(
      status: prefs.getBool("status")!,
      token: prefs.getString("token")!,
      message: prefs.getString("message")!,
      id: prefs.getInt("id")!,
      nama_user: prefs.getString("nama_user")!,
      email: prefs.getString("email")!,
      role: prefs.getString("role")!,
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
    );
    return userLogin;
  }
}
