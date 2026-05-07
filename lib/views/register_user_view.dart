import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/widgets/alert.dart';
=======
import 'package:toko_online/services/user.dart';
import 'package:toko_online/widgets/alert.dart';
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  List roleChoice = ["admin", "user"];
  String? role;

  final Color merahHati = const Color(0xFF800000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Rizza's Store"),
        centerTitle: true,
        backgroundColor: merahHati,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
<<<<<<< HEAD
=======
                    /// ICON & TITLE
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                    Icon(Icons.person_add, size: 70, color: merahHati),
                    const SizedBox(height: 10),
                    Text(
                      "Register User",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: merahHati,
                      ),
                    ),
                    const SizedBox(height: 25),

<<<<<<< HEAD
                    /// NAME — FIX: obscureText false
                    _inputField(
                      controller: name,
                      obscureText: false,
=======
                    /// NAME
                    _inputField(
                      controller: name,
                      obscureText: true,
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                      label: "Name",
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 15),

<<<<<<< HEAD
                    /// EMAIL — FIX: obscureText false
                    _inputField(
                      controller: email,
                      obscureText: false,
=======
                    /// EMAIL
                    _inputField(
                      controller: email,
                      obscureText: true,
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                      label: "Email",
                      icon: Icons.email,
                      validator: (value) =>
                          value!.isEmpty ? 'Email harus diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    /// ROLE
<<<<<<< HEAD
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: _decoration("Role", Icons.security),
                      items: roleChoice
                          .map<DropdownMenuItem<String>>(
                            (r) => DropdownMenuItem<String>(
                              value: r.toString(),
=======
                    DropdownButtonFormField(
                      value: role,
                      decoration: _decoration("Role", Icons.security),
                      items: roleChoice
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                              child: Text(r.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
<<<<<<< HEAD
                          role = value;
                        });
                      },
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Role harus dipilih'
                          : null,
=======
                          role = value.toString();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Role harus dipilih' : null,
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                    ),
                    const SizedBox(height: 15),

                    /// PASSWORD
                    _inputField(
                      controller: password,
                      obscureText: true,
                      label: "Password",
                      icon: Icons.lock,
                      validator: (value) =>
                          value!.isEmpty ? 'Password harus diisi' : null,
                    ),
                    const SizedBox(height: 30),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: merahHati,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
<<<<<<< HEAD
                          if (formKey.currentState!.validate()) {
                            // FIX: pastikan role tidak null sebelum kirim
                            var data = {
                              "name": name.text.trim(),
                              "email": email.text.trim(),
                              "role": role ?? "",
                              "password": password.text,
                            };

                            var result = await user.registerUser(data);

                            if (result.status == true) {
=======
                          print("TOMBOL REGISTER DIPENCET");

                          if (formKey.currentState!.validate()) {
                            var data = {
                              "name": name.text,
                              "email": email.text,
                              "role": role,
                              "password": password.text,
                            };

                            print("DATA DIKIRIM: $data");

                            var result = await user.registerUser(data);

                            print("HASIL: ${result.message}");

                            if (result.status == true) {
                              // RESET FORM
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                              name.clear();
                              email.clear();
                              password.clear();
                              setState(() {
                                role = null;
                              });
<<<<<<< HEAD
                              AlertMessage().showAlert(
                                context,
                                result.message,
                                true,
                              );
                            } else {
=======

                              // ALERT HIJAU
                              AlertMessage().showAlert(
                                context, result.message,
                                true,
                              );
                            } else {
                              // ALERT MERAH
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                              AlertMessage().showAlert(
                                context,
                                result.message,
                                false,
                              );
                            }
                          }
                        },
<<<<<<< HEAD
=======

>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
=======
Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator, required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
      validator: validator,
      decoration: _decoration(label, icon),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: merahHati),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: merahHati),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: merahHati, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
<<<<<<< HEAD
    );
=======
     );
>>>>>>> 874a133f891163f73d120b5c17adabae4cceedff
  }
}
