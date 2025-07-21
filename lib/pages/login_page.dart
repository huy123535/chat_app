import 'package:flutter/material.dart';
import 'package:untitled2/components/my_button.dart';
import 'package:untitled2/components/my_textfield.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  //email and pw controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  //tap to go register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});
  @override _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  //login method
  void login(BuildContext context) async{
    // auth database
    final authService = AuthService();

    // try login
    try{
      await authService.signInWithEmailAndPassword(
          widget._emailController.text,
          widget._pwController.text
      );
    }

    // catch any errors
    catch(e){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString(),
          ))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.message,
                size: 60,
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
              ),

              const SizedBox(height: 10), // Spacer

              // Welcome back message
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Spacer

              // Email TextField
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: widget._emailController,
              ),
              const SizedBox(height: 10), // Spacer

              // Password TextField

                  MyTextField(
                      hintText: "Password",
                      obscureText: _isHidden,
                      controller: widget._pwController,
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidden
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      )
                  ),
              const SizedBox(height: 20), // Spacer

              // Login Button
              MyButton(
                text: "Login",
                onTap: () => login(context),
              ),
              const SizedBox(height: 20), // Spacer

              // Register Now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style:
                    TextStyle(color: Theme
                        .of(context)
                        .colorScheme
                        .primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
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


  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}