import 'package:equilibromobile/screens/NotificationSceen.dart';
import 'package:equilibromobile/screens/ProfilSanteScreen.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isHydrationExpanded = false;
  bool _isAppleExpanded = false;
  int _currentIndex = 0;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                hintText: 'Recherche',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 2.0),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
              cursorColor: Color(0xFF00796B),
            ),
            SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _createButton('Profil de Santé', Icons.person_add,
                      onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilDeSanteScreen()),
                    );
                  }),
                  SizedBox(width: 16.0),
                  _createButton('Plan de Repas', Icons.fastfood,
                      onPressed: () {}),
                  SizedBox(width: 16.0),
                  _createButton('Consultation', Icons.local_hospital,
                      onPressed: () {}),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _createHydrationCard(),
                    SizedBox(height: 16.0),
                    _createAppleCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home, color: Color(0xFF00796B)),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu, color: Color(0xFF00796B)),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_nature_outlined),
            activeIcon: Icon(Icons.emoji_nature, color: Color(0xFF00796B)),
            label: 'Vertus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group, color: Color(0xFF00796B)),
            label: 'Communauté',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person, color: Color(0xFF00796B)),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF00796B),
        unselectedItemColor: Colors.black,
      ),
    );
  }

  Widget _createButton(String title, IconData icon,
      {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(120, 60), // Hauteur et largeur ajustées
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Color(0xFF00796B),
        elevation: 5,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 8.0), // Espacement entre l'icône et le texte
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _createHydrationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Conseil sur l\'Hydratation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Color(0xFF00796B),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Buvez au moins 8 verres d\'eau par jour.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      if (_isHydrationExpanded) ...[
                        SizedBox(height: 8.0),
                        Text(
                          'L\'hydratation est essentielle pour maintenir une santé optimale. '
                          'Elle aide à réguler la température corporelle, à lubrifier les articulations et à transporter les nutriments. '
                          'De plus, boire de l\'eau avant, pendant et après une activité physique peut améliorer les performances et favoriser la récupération.',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Image.asset(
                  'assets/images/image.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isHydrationExpanded = !_isHydrationExpanded;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00796B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  _isHydrationExpanded ? 'Voir moins' : 'Voir plus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAppleCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Conseil sur la Pomme',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Color(0xFF00796B),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'La pomme est riche en fibres et en vitamine C.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      if (_isAppleExpanded) ...[
                        SizedBox(height: 8.0),
                        Text(
                          'Elle aide à la digestion, renforce le système immunitaire, '
                          'et peut contribuer à réduire le cholestérol. Une pomme par jour peut améliorer votre santé cardiaque.',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Image.asset(
                  'assets/images/pommes.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAppleExpanded = !_isAppleExpanded;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00796B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  _isAppleExpanded ? 'Voir moins' : 'Voir plus',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}