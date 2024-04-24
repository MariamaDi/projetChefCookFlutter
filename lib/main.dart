import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

Future<String> getImageDownloadUrl(String imagePath) async {
  // Obtenez une référence au fichier dans Firebase Storage
  Reference ref = FirebaseStorage.instance.ref().child(imagePath);

  try {
    // Obtenez l'URL de téléchargement du fichier
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    // Gérer les erreurs, par exemple si le fichier n'existe pas
    print('Erreur lors de l\'obtention de l\'URL de téléchargement : $e');
    return ''; // Retourner une chaîne vide ou une valeur par défaut en cas d'erreur
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecipesPage extends StatelessWidget {
  final String firstName;
  final String lastName;

  RecipesPage({required this.firstName, required this.lastName});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/Logo.png'),
          title: Text('Bonjour $firstName $lastName !',
              style: TextStyle(fontSize: 18, fontFamily: 'Nunito')),
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context)..pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePageScreen()));
                } catch (e) {
                  print('Erreur lors de la déconnexion: $e');
                }
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Text('On cuisine ?',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                          'assets/imageAccueil.jpg'), // Image en haut
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  child: TabBar(
                    // Centrage horizontal des onglets
                    tabs: [
                      Tab(
                          icon: Column(children: [
                        Image.asset('assets/entrees.png', height: 25),
                        Text('Entrées')
                      ])),
                      Tab(
                          icon: Column(children: [
                        Image.asset('assets/plats.png', height: 25),
                        Text('Plat')
                      ])),
                      Tab(
                          icon: Column(children: [
                        Image.asset('assets/desserts.png', height: 25),
                        Text('Desserts')
                      ])),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200, // Hauteur fixe pour le contenu des onglets
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

class Entree {
  final String image;
  final String title;
  final String description;
  final String duration;
  final List<String> steps;
  Entree(
      {required this.image,
      required this.title,
      required this.description,
      required this.duration,
      required this.steps});
}

class Plat {
  final String image;
  final String title;
  final String description;
  final String duration;
  final List<String> steps;

  Plat(
      {required this.image,
      required this.title,
      required this.description,
      required this.duration,
      required this.steps});
}

class Dessert {
  final String image;
  final String title;
  final String description;
  final String duration;
  final List<String> steps;

  Dessert({
    required this.image,
    required this.title,
    required this.description,
    required this.duration,
    required this.steps,
  });
}

class RecipeStepsPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<String> ingredients;
  final List<String> steps;

  const RecipeStepsPage({
    Key? key,
    required this.ingredients,
    required this.title,
    required this.imagePath,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imagePath, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:ingredients.map((step) => Text(step, style: TextStyle(fontSize: 16))).toList(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:steps.map((step) => Text(step, style: TextStyle(fontSize: 16))).toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntreesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Recipes').where('type', isEqualTo: 'Entrée').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement...');
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              List<String> ingredients = (data['ingrédients'] as List<dynamic>).map((step) => step.toString()).toList();
              List<String> steps = (data['étapes'] as List<dynamic>).map((step) => step.toString()).toList();

              return FutureBuilder<String>(
                future: getImageDownloadUrl(data['imageUrl']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Affiche un indicateur de chargement en attendant l'URL de l'image
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}'); // Affiche un message d'erreur s'il y a un problème
                  }
                  String imageUrl = snapshot.data!;

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: 75,
                      height: 75,
                    ),
                  ), // Image à gauche

                  title: Text(data['intitulé']),
                  subtitle: Text('${data['description']} - ${data['durée']}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecipeStepsPage(
                      title: data['intitulé'],
                      ingredients: ingredients,
                      imagePath: imageUrl,
                      steps: steps,
                    ),
                  )),
                );
                }
              );
            },
          );
        },
      ),
    );
  }
}

class PlatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Recipes').where('type', isEqualTo: 'Plat').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement...');
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              List<String> ingredients = (data['ingrédients'] as List<dynamic>).map((step) => step.toString()).toList();
              List<String> steps = (data['étapes'] as List<dynamic>).map((step) => step.toString()).toList();

              return FutureBuilder<String>(
                future: getImageDownloadUrl(data['imageUrl']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Affiche un indicateur de chargement en attendant l'URL de l'image
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}'); // Affiche un message d'erreur s'il y a un problème
                  }
                  String imageUrl = snapshot.data!;

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: 75,
                      height: 75,
                    ),
                  ), // Image à gauche

                  title: Text(data['intitulé']),
                  subtitle: Text('${data['description']} - ${data['durée']}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecipeStepsPage(
                      title: data['intitulé'],
                      ingredients: ingredients,
                      imagePath: imageUrl,
                      steps: steps,
                    ),
                  )),
                );
                }
              );
            },
          );
        },
      ),
    );
  }
}

class DessertsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Recipes').where('type', isEqualTo: 'Dessert').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement...');
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot document = documents[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              List<String> ingredients = (data['ingrédients'] as List<dynamic>).map((step) => step.toString()).toList();
              List<String> steps = (data['étapes'] as List<dynamic>).map((step) => step.toString()).toList();

              return FutureBuilder<String>(
                future: getImageDownloadUrl(data['imageUrl']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Affiche un indicateur de chargement en attendant l'URL de l'image
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}'); // Affiche un message d'erreur s'il y a un problème
                  }
                  String imageUrl = snapshot.data!;

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      width: 75,
                      height: 75,
                    ),
                  ), // Image à gauche

                  title: Text(data['intitulé']),
                  subtitle: Text('${data['description']} - ${data['durée']}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecipeStepsPage(
                      title: data['intitulé'],
                      ingredients: ingredients,
                      imagePath: imageUrl,
                      steps: steps,
                    ),
                  )),
                );
                }
              );
            },
          );
        },
      ),
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
  String firstName = '';
  String lastName = '';
  bool passwordVisible = true;
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
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null) {
          setState(() {
            firstName = userData['firstName'];
            lastName = userData['lastName'];
          });
        }

        // Connexion réussie
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                RecipesPage(firstName: firstName, lastName: lastName)));
      }
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
              obscureText: passwordVisible,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          passwordVisible = !passwordVisible;
                        },
                      );
                    },
                  ),
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
