import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../utils/theme.dart';
import '../components/header_widget.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPass(BuildContext context) async {
    final email = emailController.text.trim(); // Trim whitespace

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Check if the email is registered
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isEmpty) {
        // Email is registered, send password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Get.snackbar(
          "Success!",
          "Password reset link has been sent to your email",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Email is not registered
        Get.snackbar(
          "Failed!",
          "No user found with this email. Please check for typos!",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Try again later.";
          break;
        default:
          errorMessage = e.message ?? "An unexpected error occurred.";
      }
      Get.snackbar(
        "Error",
        errorMessage,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again later.",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
                                  await resetPass(context);
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
