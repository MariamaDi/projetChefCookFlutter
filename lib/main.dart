import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
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
  }
}
