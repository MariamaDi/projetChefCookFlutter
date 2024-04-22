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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mon Application'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Accueil', icon: Icon(Icons.home)),
              Tab(text: 'Deconnecter', icon: Icon(Icons.book)),
              Tab(text: 'Recettes', icon: Icon(Icons.login)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Page Accueil')),
            Center(child: Text('Page Connexion')),
            RecipesPage(), // La page "Recettes" avec onglets et contenu
          ],
        ),
      ),
    );
  }
}

class RecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Bonjour Sophie', style: TextStyle(fontSize: 24)),
                    Text('On cuisine?', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Image.asset('assets/imageAccueil.jpg'), // Image en haut
                  ],
                ),
              ),
              Center(
                child: TabBar(
                  // Centrage horizontal des onglets
                  tabs: [
                    Tab(
                        icon: Column(children: [
                      Image.asset('assets/entrees.png', height: 50),
                      Text('Entrées')
                    ])),
                    Tab(
                        icon: Column(children: [
                      Image.asset('assets/plats.png', height: 50),
                      Text('Plat')
                    ])),
                    Tab(
                        icon: Column(children: [
                      Image.asset('assets/desserts.png', height: 50),
                      Text('Desserts')
                    ])),
                  ],
                ),
              ),
              Container(
                height: 300, // Hauteur fixe pour le contenu des onglets
                child: TabBarView(
                  children: [
                    EntreesTab(), // Widget personnalisé pour afficher les entrées
                    Icon(Icons.lunch_dining), // Contenu pour Plats
                    Icon(Icons.cake), // Contenu pour Desserts
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Définition du modèle pour les entrées
class Entree {
  final String image;
  final String title;
  final String description;
  final String duration;

  Entree(
      {required this.image,
      required this.title,
      required this.description,
      required this.duration});
}

class EntreesTab extends StatelessWidget {
  // Création d'une liste d'exemple d'entrées
  final List<Entree> entrees = [
    Entree(
      image: 'assets/salade.jpg',
      title: 'Salade Niçoise',
      description: 'Une salade riche et fraîche parfaite pour l\'été.',
      duration: '15 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entrees.length,
      itemBuilder: (context, index) {
        Entree entree = entrees[index];
        return ListTile(
          leading: Image.asset(entree.image, width: 100), // Image à gauche
          title: Text(entree.title),
          subtitle: Text('${entree.description} - ${entree.duration}'),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
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
