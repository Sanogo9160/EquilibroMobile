import 'package:equilibromobile/models/profil_sante.dart';
import 'package:equilibromobile/models/utilisateur.dart'; 
import 'package:equilibromobile/screens/CreerProfilScreen.dart';
import 'package:equilibromobile/screens/ModifierProfilDeSanteScreen.dart';
import 'package:equilibromobile/services/profil_de_sante_service.dart';
import 'package:flutter/material.dart';

class ProfilDeSanteScreen extends StatefulWidget {
  @override
  _ProfilDeSanteScreenState createState() => _ProfilDeSanteScreenState();
}

class _ProfilDeSanteScreenState extends State<ProfilDeSanteScreen> {
  Future<ProfilDeSante?> _profilFuture = Future.value(null);
  Future<Utilisateur?> _utilisateurFuture = Future.value(null);
  int? _profilId;

  @override
  void initState() {
    super.initState();
    _loadProfil();
    _loadUtilisateur();
  }

  void _loadProfil() async {
    try {
      final profilData = await ProfilDeSanteService().obtenirMonProfil();
      if (profilData != null) {
        final profil = ProfilDeSante.fromJson(profilData);
        setState(() {
          _profilFuture = Future.value(profil);
          _profilId = profil.id;
        });
      } else {
        setState(() {
          _profilFuture = Future.value(null);
        });
      }
    } catch (e) {
      print('Erreur lors du chargement du profil : $e');
      setState(() {
        _profilFuture = Future.value(null);
      });
    }
  }

  void _loadUtilisateur() async {
    try {
      final utilisateurData = await ProfilDeSanteService().obtenirMonUtilisateur();
      setState(() {
        _utilisateurFuture = Future.value(utilisateurData);
      });
    } catch (e) {
      print('Erreur lors du chargement de l\'utilisateur : $e');
      setState(() {
        _utilisateurFuture = Future.value(null);
      });
    }
  }

  void _supprimerProfil() {
    if (_profilId == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce profil ?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () async {
                await ProfilDeSanteService().supprimerProfil(_profilId!);
                Navigator.of(context).pop();
                _loadProfil();
              },
            ),
          ],
        );
      },
    );
  }

  void _creerProfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreerProfilScreen()),
    );
  }

  void _modifierProfil() {
    _profilFuture.then((profil) {
      if (profil != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModifierProfilDeSanteScreen(profil: profil),
          ),
        ).then((_) {
          _loadProfil();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun profil à modifier.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil de Santé')),
      body: FutureBuilder<Utilisateur?>(
        future: _utilisateurFuture,
        builder: (context, utilisateurSnapshot) {
          if (utilisateurSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (utilisateurSnapshot.hasError) {
            return Center(child: Text('Erreur de chargement de l\'utilisateur.'));
          }

          return FutureBuilder<ProfilDeSante?>(
            future: _profilFuture,
            builder: (context, profilSnapshot) {
              if (profilSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (profilSnapshot.hasError) {
                return Center(child: Text('Erreur de chargement du profil.'));
              }

              final profil = profilSnapshot.data;
              final utilisateur = utilisateurSnapshot.data;

              if (profil == null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous n'avez aucune donnée de profil santé disponible. Veuillez créer un profil de santé.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _creerProfil,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Créer un Profil de Santé', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Less padding to reduce height
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Adjusts to content height
                      children: [
                        Text(
                          'Nom: ${utilisateur?.nom ?? "Inconnu"}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('Email: ${utilisateur?.email ?? "Inconnu"}', style: TextStyle(fontSize: 16)),
                        Divider(height: 16, thickness: 1),
                        Text('Objectif de Santé', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(profil.objectifs.isNotEmpty
                            ? profil.objectifs.map((o) => o.nom).join(', ')
                            : "Aucun"),
                        SizedBox(height: 12),
                        Text('Type de Maladie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(profil.maladies.isNotEmpty
                            ? profil.maladies.map((m) => m.nom).join(', ')
                            : "Je n'ai pas de maladie"),
                        SizedBox(height: 12),
                        Text('Préférences Alimentaires', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(profil.preferencesAlimentaires.isNotEmpty
                            ? profil.preferencesAlimentaires.map((p) => p.nom).join(', ')
                            : "Aucune"),
                        SizedBox(height: 12),
                        Text('Allergies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(profil.allergies.isNotEmpty
                            ? profil.allergies.map((a) => a.nom).join(', ')
                            : "Aucune"),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal), // Icon color changed to teal
                              onPressed: _modifierProfil,
                              tooltip: 'Modifier',
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: _supprimerProfil,
                              tooltip: 'Supprimer',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
