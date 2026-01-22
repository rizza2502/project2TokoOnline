import 'package:flutter/material.dart';
import 'package:toko_online/services/user.dart';
import 'package:toko_online/widgets/alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

  final Color mainColor = const Color(0xFF800000); // merah maroon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      appBar: AppBar(
        title: const Text("Rizza's Store"),
        centerTitle: true,
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 70,
                    color: mainColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// EMAIL
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: mainColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  /// PASSWORD
                  TextFormField(
                    controller: password,
                    obscureText: showPass,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: mainColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  /// BUTTON LOGIN
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          var data = {
                            "email": email.text,
                            "password": password.text,
                          };
                          var result = await user.loginUser(data);

                          setState(() {
                            isLoading = false;
                          });

                          if (result.status == true) {
                            
                            AlertMessage().showAlert(
                              context,
                              result.message,
                              true,
                            );
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/dashboard',
                              );
                            });
                          } else {
                            AlertMessage().showAlert(
                              context,
                              result.message,
                              false,
                            );
                          }
                        }
                      },
                      child: isLoading 
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "LOGIN",
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
    );
  }
}
