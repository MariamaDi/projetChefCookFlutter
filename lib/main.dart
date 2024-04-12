import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hello'),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> userData = {
    'Email': null,
    'Password': null,
  };
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        
      ),
      
      body:Form(
        key:formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Logo.png'
            ,height: 145,
            width: 145,
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: 50.0),
              child:TextFormField(
                decoration: InputDecoration(
                  label: Text('Email'), 
                  labelStyle: TextStyle(
                    fontFamily: 'Nunito',
                  )
                ),
                controller: emailController,
                validator: (String? value) {
                  return value?.isNotEmpty == true && value == 'test@mail.com' ? null : 'Identifiant invalide';
                },
                onSaved: (String? value) => userData['Email'] = value,
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 50.0),
              child:TextFormField(
                decoration: InputDecoration(
                  label: Text('Mot de passe'),
                  labelStyle: TextStyle(
                    fontFamily: 'Nunito',
                  )
                ),
                controller: passwordController,
                validator: (String? value) {
                  return value?.isNotEmpty == true && value == 'test' ? null : 'Mot de passe invalide';
                },
                onSaved: (String? value) => userData['Password'] = value,
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical:50.0),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFFFC500),
                  padding: EdgeInsets.symmetric(vertical:20, horizontal: 40)
                ),
                child: const Text(
                  'Connexion', 
                    style:TextStyle(
                      fontFamily: 'Nunito',
                    )
                  ),
                  onPressed: () => formKey.currentState!.validate()
                    ? {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Homepage())),
                    Authentication.isLoggedIn = true
                    }

                    : print('INVALID'),
                  
              ),
            ),

          ],
        ),

      )
    );
  }
}

class Authentication {
  static bool isLoggedIn = false;


  static void logIn() {
    isLoggedIn = true;
  }

  static void logOut() {
    isLoggedIn = false;
  }
}