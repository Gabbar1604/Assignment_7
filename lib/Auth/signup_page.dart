import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pokepedia/Auth/button_page.dart';
import 'package:pokepedia/Auth/login_page.dart';
import 'package:pokepedia/home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool offsecureText = true;
  bool _showLottie = false;

  @override
  void initState() {
    super.initState();
    // Delay Lottie load
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showLottie = true;
        });
      }
    });
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
                        ? Lottie.asset('assets/animation/Pikachu.json')
                        : Container(), // or a placeholder
                  ),
                ),

                Text(
                  'Sign Up',
                  // If you want to ensure no underline:
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Create a new account",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: emailcontroller.text.isEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  namecontroller.clear();
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.black),
                            )
                          : null,
                      label: Text('Enter Your Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    autofillHints: [AutofillHints.name],
                  ),
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
                      prefixIcon: Icon(Icons.email),
                      suffixIcon: emailcontroller.text.isEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  emailcontroller.clear();
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.black),
                            )
                          : null,
                      label: Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [AutofillHints.email],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
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
                      label: Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: offsecureText,
                    autofillHints: [AutofillHints.password],
                  ),
                ),
                SizedBox(height: 20),

                LoadingAnimatedButton(
                  width: 180,
                  height: 50,
                  borderRadius: 10,
                  borderColor: Colors.blue,
                  borderWidth: 2,
                  color: Colors.blue,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    print("Sign Up Button Pressed");
                    RegistorUser();
                    final form = formkey.currentState!;
                    String email = emailcontroller.text;
                    String password = passwordcontroller.text;
                    String name = namecontroller.text;
                    print('Email: $email');
                    print('Password: $password');
                    print('Name: $name');
                    if (form.validate()) {
                      print("Form is valid");
                      final email = emailcontroller.text;
                      final password = passwordcontroller.text;
                    } else {
                      print("Form is invalid");
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Divider(
                      color: const Color.fromARGB(137, 206, 14, 14),
                      thickness: 1,
                      indent: 20,
                      endIndent: 120,
                    ),
                    Text(
                      "Or Sign Up with",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                      ),
                    ),
                    Divider(color: Colors.black54, thickness: 1),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadingAnimatedButton(
                      child: Text('Facebook'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  "Sign in using Email & Password",
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
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    LoadingAnimatedButton(
                      child: Text('Google'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  "Sign in using Email & Password",
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
                                child: Text(
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle sign up action
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
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

  void RegistorUser() {
    if (passwordcontroller.text == "") {
      Fluttertoast.showToast(
        msg: "Password cannot be blank",
        backgroundColor: Colors.red,
      );
    } else if (emailcontroller.text == "") {
      Fluttertoast.showToast(
        msg: "Email cannot be blank",
        backgroundColor: Colors.red,
      );
    } else {
      String email = emailcontroller.text;
      String password = passwordcontroller.text;
      String name = namecontroller.text;
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
            var user = value.user;
            var uid = user!.uid;
            addUserData(uid);
          })
          .catchError((e) {
            Fluttertoast.showToast(msg: '$e', backgroundColor: Colors.red);
            print(e);
          });
    }
  }

  void addUserData(String uid) {
    Map<String, dynamic> userData = {
      'name': namecontroller.text,
      'email': emailcontroller.text,
      'password': passwordcontroller.text,
      'uid': uid,
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userData)
        .then((value) {
          Fluttertoast.showToast(
            msg: "User Data Added",
            backgroundColor: Colors.green,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        })
        .catchError((e) {
          Fluttertoast.showToast(msg: '$e', backgroundColor: Colors.red);
          print(e);
        });
  }
}
