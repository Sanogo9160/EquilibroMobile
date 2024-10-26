import 'package:equilibromobile/screens/EditProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:equilibromobile/models/utilisateur.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        // Suppression de l'icône de flèche de retour
      ),
      body: FutureBuilder<Utilisateur?>(
        future: _authService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement du profil'),
            );
          }

          final utilisateur = snapshot.data;
          if (utilisateur == null) {
            return const Center(
              child: Text('Aucun utilisateur trouvé'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: utilisateur.imageUrl != null
                          ? NetworkImage(utilisateur.imageUrl!) // Utilisation de l'image de l'utilisateur
                          : const AssetImage('assets/default_avatar.png') as ImageProvider, // Image par défaut
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      utilisateur.nom,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00796B),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1, height: 32.0),
                  _buildProfileField('Email', utilisateur.email),
                  _buildProfileField('Téléphone', utilisateur.telephone ?? 'Non défini'),
                  _buildProfileField('Poids', '${utilisateur.poids ?? 'Non défini'} kg'),
                  _buildProfileField('Taille', '${utilisateur.taille ?? 'Non défini'} cm'),
                  _buildProfileField('Âge', '${utilisateur.age ?? 'Non défini'} ans'),
                  _buildProfileField('Sexe', utilisateur.sexe ?? 'Non défini'),
                  const SizedBox(height: 16.0), // Espacement
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(utilisateur: utilisateur),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            'Modifier',
                            style: TextStyle(color: Colors.white), 
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B),
                          ),
                        ),
                                              
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _authService.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        icon: const Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Se Deconnecter',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}