import 'package:chitchat/common/email_validator.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/custom_button.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country c) {
          setState(() {
            country = c;
          });
        });
  }

  void loginwithEmailandPassword() {
    String emailAddress = emailController.text;
    String password = passwordController.text;

    if (emailAddress.isValidEmail() && password.length > 6) {
      ref
          .read(authControllerProvider)
          .loginwithEmailandPassword(context, emailAddress, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill the details properly')));
    }
  }

  void signinwithGoogle() {
    ref.read(authControllerProvider).signinwithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your Email/Password'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Please enter login to continue.'),
              const SizedBox(height: 10),
              const SizedBox(height: 5),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: size.height * 0.1),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: loginwithEmailandPassword,
                  text: 'NEXT',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SignInButton(Buttons.google, onPressed: signinwithGoogle),
            ],
          ),
        ),
      ),
    );
  }
}
