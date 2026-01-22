import 'package:flutter/material.dart';
import 'package:toko_online/services/user.dart';
import 'package:toko_online/widgets/alert.dart';

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
                    /// ICON & TITLE
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

                    /// NAME
                    _inputField(
                      controller: name,
                      obscureText: true,
                      label: "Name",
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    /// EMAIL
                    _inputField(
                      controller: email,
                      obscureText: true,
                      label: "Email",
                      icon: Icons.email,
                      validator: (value) =>
                          value!.isEmpty ? 'Email harus diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    /// ROLE
                    DropdownButtonFormField(
                      value: role,
                      decoration: _decoration("Role", Icons.security),
                      items: roleChoice
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          role = value.toString();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Role harus dipilih' : null,
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
                              name.clear();
                              email.clear();
                              password.clear();
                              setState(() {
                                role = null;
                              });

                              // ALERT HIJAU
                              AlertMessage().showAlert(
                                context, result.message,
                                true,
                              );
                            } else {
                              // ALERT MERAH
                              AlertMessage().showAlert(
                                context,
                                result.message,
                                false,
                              );
                            }
                          }
                        },

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
     );
  }
}
