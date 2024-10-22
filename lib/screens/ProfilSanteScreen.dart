import 'package:equilibromobile/models/profil_sante.dart';
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
  int? _profilId;

  @override
  void initState() {
    super.initState();
    _loadProfil();
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
      body: FutureBuilder<ProfilDeSante?>(
        future: _profilFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement.'));
          }

          final profil = snapshot.data;
          if (profil == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vous n'avez aucune donnée de profil santé disponible. Veuillez créer un profil de santé."),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _creerProfil,
                    child: Text('Créer un Profil de Santé'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Nom: ${profil.utilisateur.nom}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Email: ${profil.utilisateur.email}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    Text('Maladies: ${profil.maladies.isNotEmpty ? profil.maladies.map((m) => m.nom).join(', ') : "Aucune"}'),
                    SizedBox(height: 8),
                    Text('Objectifs: ${profil.objectifs.isNotEmpty ? profil.objectifs.map((o) => o.nom).join(', ') : "Aucun"}'),
                    SizedBox(height: 8),
                    Text('Allergies: ${profil.allergies.isNotEmpty ? profil.allergies.map((a) => a.nom).join(', ') : "Aucune"}'),
                    SizedBox(height: 8),
                    Text('Préférences Alimentaires: ${profil.preferencesAlimentaires.isNotEmpty ? profil.preferencesAlimentaires.map((p) => p.nom).join(', ') : "Aucune"}'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _modifierProfil,
                          tooltip: 'Modifier',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: _supprimerProfil,
                          tooltip: 'Supprimer',
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}