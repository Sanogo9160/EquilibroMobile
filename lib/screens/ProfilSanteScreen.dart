import 'package:equilibromobile/models/profil_sante.dart';
import 'package:equilibromobile/services/profil_de_sante_service.dart';
import 'package:flutter/material.dart';

class ProfilDeSanteScreen extends StatefulWidget {
  @override
  _ProfilDeSanteScreenState createState() => _ProfilDeSanteScreenState();
}

class _ProfilDeSanteScreenState extends State<ProfilDeSanteScreen> {
  Future<ProfilDeSante?> _profilFuture = Future.value(null);

  @override
  void initState() {
    super.initState();
    _loadProfil(); 
  }

  void _loadProfil() async {
    try {
      final profilData = await ProfilDeSanteService().obtenirMonProfil();
      if (profilData != null) {
        // Convertir le Map en objet ProfilDeSante
        final profil = ProfilDeSante.fromJson(profilData);
        setState(() {
          _profilFuture = Future.value(profil);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil de Santé')),
      body: FutureBuilder<ProfilDeSante?>(
        future: _profilFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Erreur de chargement.'));
          } else {
            final profil = snapshot.data;
            if (profil == null) {
              return Center(child: Text('Aucune donnée disponible. Vous n\'êtes pas connecté.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Ajuste la taille de la colonne
                    children: [
                      Text('Nom: ${profil.utilisateur.nom}', style: TextStyle(fontSize: 16)),
                      Text('Email: ${profil.utilisateur.email}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Text('Maladies: ${profil.maladies.isNotEmpty ? profil.maladies.map((m) => m.nom).join(', ') : "Aucune"}'),
                      SizedBox(height: 8),
                      Text('Objectifs: ${profil.objectifs.isNotEmpty ? profil.objectifs.map((o) => o.nom).join(', ') : "Aucun"}'),
                      SizedBox(height: 8),
                      Text('Allergies: ${profil.allergies.isNotEmpty ? profil.allergies.map((a) => a.nom).join(', ') : "Aucune"}'),
                      SizedBox(height: 8),
                      Text('Préférences Alimentaires: ${profil.preferencesAlimentaires.isNotEmpty ? profil.preferencesAlimentaires.map((p) => p.nom).join(', ') : "Aucune"}'),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      
    );
  }
}