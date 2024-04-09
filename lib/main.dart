// lib/main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/signup/signup_bloc.dart';
import 'package:tataguid/pages/onboarding_page.dart';
import 'package:tataguid/repository/auth_repo.dart';
// import 'package:tataguid/storage/token_storage.dart';
import 'package:provider/provider.dart';
import 'package:tataguid/ui/LoginUi.dart';
import 'package:tataguid/ui/get_contacts.dart';
import 'package:tataguid/ui/post_contacts.dart';

void main() => runApp(TataGuid());

class TataGuid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final TokenStorage tokenStorage = TokenStorage();
    final AuthRepository authRepository = AuthRepository();

    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => OnboardingPage(),
          '/user_dashboard': (context) => UserPage(), // Replace with your user dashboard widget
          '/agency_panel': (context) => AgencyPanelScreen(), // Replace with your agency panel widget
          '/login_ui': (context) => LoginUi(), // Replace with your agency panel widget
        },
        onGenerateRoute: (settings) {
          // Handle platform-specific error route
          if (Platform.isAndroid || Platform.isIOS) {
            return MaterialPageRoute(
              builder: (context) => PlatformErrorScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}

class PlatformErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Error'),
      ),
      body: Center(
        child: Text(
          'Unsupported operation: Platform._operatingSystem',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
