import "package:flutter/material.dart";
import 'package:untitled2/services/auth/auth_service.dart';
import 'package:untitled2/components/my_button.dart';
import 'package:untitled2/components/my_textfield.dart';


class RegisterPage extends StatefulWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isHidden = true;


  //register method
  void register(BuildContext context) async {
    AuthService authService = AuthService();

    //check if passwords match
    if (widget._pwController.text == widget._confirmPwController.text) {
      try {
        await authService.signUpWithEmailAndPassword(
            widget._usernameController.text,
            widget._emailController.text,
            widget._pwController.text);
      }
      catch (e){
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Icon(
                      Icons.message,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    const SizedBox(height: 10), // Spacer

                    // Welcome back message
                    const Text(
                      "Let's create an account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), // Spacer

                    // Username TextField
                    MyTextField(
                      hintText: "Username",
                      obscureText: false,
                      controller: widget._usernameController,
                      vadiator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10), // Spacer

                    // Email TextField
                    MyTextField(
                      hintText: "Email",
                      obscureText: false,
                      controller: widget._emailController,
                      vadiator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10), // Spacer

                    // Password TextField
                    MyTextField(
                      hintText: "Password",
                      obscureText: _isHidden,
                      controller: widget._pwController,
                      vadiator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(_isHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10), // Spacer

                    // Confirm Password Textfield
                    MyTextField(
                      hintText: "Confirm Password",
                      obscureText: _isHidden,
                      controller: widget._confirmPwController,
                      vadiator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != widget._pwController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(_isHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20), // Spacer

                    // Register Button
                    MyButton(
                      text: "Register",
                      onTap: () => register(context),
                    ),
                    const SizedBox(height: 20), // Spacer

                    // Login Now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Login now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
