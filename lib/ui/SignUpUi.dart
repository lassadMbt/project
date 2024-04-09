// lib/ui/SignUpUi.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/signup/signup_bloc.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';
import 'package:flutter/material.dart' show ScaffoldMessenger; // Use 'material.dart'
import 'package:provider/provider.dart';
import 'package:tataguid/components/my_textfield.dart';
import 'package:tataguid/repository/auth_repo.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:tataguid/ui/LoginUi.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController agencyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // For SnackBar

  String errorMessage = '';

  void _clearErrorMessage() {
    setState(() {
      errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = Provider.of<AuthRepository>(context,
        listen: false); // Access the repository
    final SignupBloc signupBloc = BlocProvider.of<SignupBloc>(context);

    const logo = Center(
      child: Icon(Icons.supervised_user_circle, size: 150, color: Colors.blue),
    );

    final username = TextField(
      controller: nameController,
      keyboardType: TextInputType.name,
      autofocus: false,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle_rounded),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Name',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final email = TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Email',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
    );

    final pass = TextField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'Password',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
    );

    final type = TextField(
      controller: typeController,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.app_registration_rounded),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          hintStyle: const TextStyle(color: Color(0xFF666666)),
          hintText: 'User Or Agency',
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))),
    );

    final agencyName = MyTextField(
      controller: agencyNameController,
      hintText: 'Agency Name',
      prefixIcon: Icons.business,
      obscureText: false,
      onChanged: _clearErrorMessage,
    );

    final language = MyTextField(
      controller: languageController,
      hintText: 'Language',
      prefixIcon: Icons.language,
      obscureText: false,
      onChanged: _clearErrorMessage,
    );

    final country = MyTextField(
      controller: countryController,
      hintText: 'Country',
      prefixIcon: Icons.location_on,
      obscureText: false,
      onChanged: _clearErrorMessage,
    );

    final location = MyTextField(
      controller: locationController,
      hintText: 'Location',
      prefixIcon: Icons.location_city,
      obscureText: false,
      onChanged: _clearErrorMessage,
    );

    final description = MyTextField(
      controller: descriptionController,
      hintText: 'Description',
      prefixIcon: Icons.description,
      obscureText: false,
      onChanged: _clearErrorMessage,
    );

    final signUpButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        onPressed: () {
          String name = nameController.text.trim(); //for user
          String agencyName = agencyNameController.text.trim(); //for user
          String email = emailController.text.trim(); //for bothe user/agency
          String password = passwordController.text.trim(); //for bothe user/agency
          String type = typeController.text.trim();
          String language = languageController.text.trim(); //for user
          String country = countryController.text.trim(); //for user
          String location = locationController.text.trim(); //for agency
          String description = descriptionController.text.trim(); //for agency

          if (_validateUserInput(name, email, password)) {
            signupBloc.add(RegisterButtonPressed(
              name: name,
              agencyName: agencyName,
              email: email,
              password: password,
              type: type,
              language: language,
              country: country,
              location: location,
              description: description,
            ));
          } else {
            _showErrorSnackBar('Please fill in all fields correctly.');
          }
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    final alreadyHave = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginUi(),
              ),
            );
          },
          child: Text(
            'Log In',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupErrorState || state is AgencySignupSuccessState) {
            _handleSuccessfulSignup(state);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo,
              const SizedBox(height: 20),
              username,
              const SizedBox(height: 20),
              email,
              const SizedBox(height: 20),
              pass,
              const SizedBox(height: 20),
              type,
              const SizedBox(height: 20),
              agencyName,
              const SizedBox(height: 20),
              language,
              const SizedBox(height: 20),
              country,
              const SizedBox(height: 20),
              location,
              const SizedBox(height: 20),
              description,
              const SizedBox(height: 20),
              signUpButton,
              const SizedBox(height: 40),
              alreadyHave,
            ],
          ),
        ),
      ),
    );
  }

  bool _validateUserInput(String name, String email, String password) {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleSuccessfulSignup(SignupState state) {
    if (state is UserSignupSuccessState) {
      Provider.of<AuthRepository>(context, listen: false)
          .retrieveToken()
          .then((token) {
        if (token != null) {
          _storeToken(token);
          Navigator.pushNamed(context, '/user_dashboard');
        } else {
          _showErrorSnackBar('Failed to retrieve token.');
        }
      }).catchError((error) {
        _showErrorSnackBar('Error retrieving token: $error');
      });
    } else if (state is AgencySignupSuccessState) {
      Provider.of<AuthRepository>(context, listen: false)
          .retrieveToken()
          .then((token) {
        if (token != null) {
          _storeToken(token);
          Navigator.pushNamed(context, '/Agency_panel');
        } else {
          _showErrorSnackBar('Failed to retrieve token.');
        }
      }).catchError((error) {
        _showErrorSnackBar('Error retrieving token: $error');
      });
    }
  }

  void _storeToken(String token) async {
    final TokenStorage tokenStorage = TokenStorage();
    await tokenStorage.storeToken(token);
  }
}
