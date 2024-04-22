import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              'assets/Logo.png',
              height: 145,
              width: 145,
            )),
            Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  "Devenir un chef",
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "Être un chef de la cuisine vous semblera simple grâce à nos recettes",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFFFFC500),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                  child: const Text('Démarrer',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                      )),
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()))
                      }),
            ),
          ],
        ));
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

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Connexion réussie
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePageScreen()));
    } catch (e) {
      // Gérer les erreurs de connexion
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Erreur lors de la connexion. Veuillez vérifier vos informations d\'identification.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png',
                height: 145,
                width: 145,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      label: Text('Email'),
                      labelStyle: TextStyle(
                        fontFamily: 'Nunito',
                      )),
                  controller: emailController,
                  validator: (String? value) {
                    return value?.isNotEmpty == true
                        ? null
                        : 'Veuillez renseigner votre adresse mail';
                  },
                  onSaved: (String? value) => userData['Email'] = value,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      label: Text('Mot de passe'),
                      labelStyle: TextStyle(
                        fontFamily: 'Nunito',
                      )),
                  controller: passwordController,
                  validator: (String? value) {
                    return value?.isNotEmpty == true
                        ? null
                        : 'Veuillez renseigner votre mot de passe';
                  },
                  onSaved: (String? value) => userData['Password'] = value,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFFFC500),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40)),
                    child: const Text('Connexion',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                        )),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        signInWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
