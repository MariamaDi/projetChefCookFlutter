import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
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
                    PlatsTab(), // Contenu pour Plats
                    DessertsTab(), // Contenu pour Desserts
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

class Plat {
  final String image;
  final String title;
  final String description;
  final String duration;

  Plat(
      {required this.image,
      required this.title,
      required this.description,
      required this.duration});
}

class Dessert {
  final String image;
  final String title;
  final String description;
  final String duration;

  Dessert(
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
    Entree(
      // Nouvelle entrée ajoutée
      image: 'assets/salade.jpg',
      title: 'Houmous Lovers',
      description: 'Houmous savoureux.',
      duration: '25 min',
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
  }
}

class PlatsTab extends StatelessWidget {
  final List<Plat> plats = [
    Plat(
      image: 'assets/salade.jpg',
      title: 'Poulet Rôti',
      description:
          'Poulet rôti croustillant sur le dessus et juteux à l\'intérieur.',
      duration: '1h 30 min',
    ),
    Plat(
      image: 'assets/salade.jpg',
      title: 'Pasta Carbonara',
      description: 'Pâtes fraîches avec une sauce carbonara crémeuse.',
      duration: '25 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plats.length,
      itemBuilder: (context, index) {
        Plat plat = plats[index];
        return ListTile(
          leading: Image.asset(plat.image, width: 100),
          title: Text(plat.title),
          subtitle: Text('${plat.description} - ${plat.duration}'),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
    );
  }
}

class DessertsTab extends StatelessWidget {
  final List<Dessert> desserts = [
    Dessert(
      image: 'assets/salade.jpg',
      title: 'Tarte aux Pommes',
      description: 'Tarte aux pommes classique avec une pâte croustillante.',
      duration: '50 min',
    ),
    Dessert(
      image: 'assets/salade.jpg',
      title: 'Cheesecake',
      description: 'Cheesecake riche et crémeux sur une base de biscuit.',
      duration: '2h 20 min',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: desserts.length,
      itemBuilder: (context, index) {
        Dessert dessert = desserts[index];
        return ListTile(
          leading: Image.asset(dessert.image, width: 100),
          title: Text(dessert.title),
          subtitle: Text('${dessert.description} - ${dessert.duration}'),
          trailing: Icon(Icons.arrow_forward_ios),
        );
      },
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
          .push(MaterialPageRoute(builder: (context) => RecipesPage()));
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
