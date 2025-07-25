import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pokepedia/Auth/signup_page.dart';
import 'package:pokepedia/Auth/button_page.dart'; // Optional: if you’re using LoadingAnimatedButton

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  bool offsecureText = true;
  bool _showLottie = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showLottie = true;
        });
      }
    });
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 250,
                    width: 600,
                    child: _showLottie
                        ? Lottie.asset('assets/animation/001 Bulbasaur.json')
                        : Container(),
                  ),
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter Valid Username & Password",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: TextFormField(
                    controller: emailcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            emailcontroller.clear();
                            FocusScope.of(context).unfocus();
                          });
                        },
                        icon: const Icon(Icons.close, color: Colors.black),
                      ),
                      label: const Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    controller: passwordcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            offsecureText = !offsecureText;
                          });
                        },
                        icon: Icon(
                          offsecureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                      label: const Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: offsecureText,
                    autofillHints: const [AutofillHints.password],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(180.0, 10, 0, 10),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          content: const SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                "Create New account",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LoadingAnimatedButton(
                  width: 180,
                  height: 50,
                  borderRadius: 10,
                  borderColor: Colors.blue,
                  borderWidth: 2,
                  color: Colors.blue,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    if (formkey.currentState!.validate()) {
                      loginUser();
                    } else {
                      Fluttertoast.showToast(msg: "Please fill all fields");
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black26,
                        thickness: 1,
                        indent: 30,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      "Or Login with",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black26,
                        thickness: 1,
                        indent: 10,
                        endIndent: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimatedButton(
                      child: const Text('Facebook'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: const SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  "Login using Email & Password",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    LoadingAnimatedButton(
                      child: const Text('Google'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: const SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  "Login using Email & Password",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ✅ This function logs in the user and lets StreamBuilder auto-navigate
  Future<void> loginUser() async {
    if (emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email & password cannot be empty",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      final String email = emailcontroller.text.trim();
      final String password = passwordcontroller.text;

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print("Login successful: ${userCredential.user?.email}");

      /// ⚠️ Do NOT use Navigator here — StreamBuilder will auto-redirect to HomePage
    } catch (e) {
      print("Login failed: $e");
      Fluttertoast.showToast(
        msg: "Login failed: ${e.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }
}
