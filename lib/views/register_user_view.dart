import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/widgets/alert.dart';

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

                    /// NAME — FIX: obscureText false
                    _inputField(
                      controller: name,
                      obscureText: false,
                      label: "Name",
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    /// EMAIL — FIX: obscureText false
                    _inputField(
                      controller: email,
                      obscureText: false,
                      label: "Email",
                      icon: Icons.email,
                      validator: (value) =>
                          value!.isEmpty ? 'Email harus diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    /// ROLE
                    DropdownButtonFormField<String>(
                      value: role,
                      decoration: _decoration("Role", Icons.security),
                      items: roleChoice
                          .map<DropdownMenuItem<String>>(
                            (r) => DropdownMenuItem<String>(
                              value: r.toString(),
                              child: Text(r.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          role = value;
                        });
                      },
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Role harus dipilih'
                          : null,
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
                              name.clear();
                              email.clear();
                              password.clear();
                              setState(() {
                                role = null;
                              });
                              AlertMessage().showAlert(
                                context,
                                result.message,
                                true,
                              );
                            } else {
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
    required bool obscureText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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
