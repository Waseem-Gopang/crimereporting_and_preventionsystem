import 'package:crimereporting_and_preventionsystem/login_register/components/header_widget.dart';
import 'package:crimereporting_and_preventionsystem/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final double _headerHeight = 250;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late String email;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPass(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset link has been sent to your email",
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Failed", "No user found with this email",
            duration: const Duration(seconds: 7),
            backgroundColor: Colors.lightBlueAccent);
      } else {
        Get.snackbar("Error", e.message ?? "An unexpected error occurred",
            duration: const Duration(seconds: 7),
            backgroundColor: Colors.lightBlueAccent);
      }
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    const Text(
                      'Forget Password',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'You can reset your Password here!',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          getTextField(
                            prefixIcon: const Icon(Icons.email_outlined),
                            text: 'E-mail address',
                            hint: 'Enter your email',
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(val)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            controller: emailController,
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Recover'.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                    resetPass(context);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    backToSignIn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField({
    required Icon prefixIcon,
    required String text,
    required String hint,
    required String? Function(String?) validator,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        obscureText: false,
        decoration:
            ThemeHelper().textInputDecoration(prefixIcon, text, hint, null),
        validator: validator,
        controller: controller,
      ),
    );
  }

  Widget backToSignIn() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "Do you want to go back? "),
            TextSpan(
              text: 'Login',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, "/login");
                },
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
