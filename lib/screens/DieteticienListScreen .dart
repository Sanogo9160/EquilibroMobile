import 'dart:convert';
import 'package:equilibromobile/config.dart';
import 'package:equilibromobile/models/dieteticien.dart';
import 'package:equilibromobile/screens/ReserverConsultationScreen.dart';
import 'package:equilibromobile/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DieteticienListScreen extends StatefulWidget {
  @override
  _DieteticienListScreenState createState() => _DieteticienListScreenState();
}

class _DieteticienListScreenState extends State<DieteticienListScreen> {
  List<Dieteticien> _dieteticiens = [];
  List<Dieteticien> _filteredDieteticiens = [];
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  List<bool> _isLiked = [];

  @override
  void initState() {
    super.initState();
    _fetchDieteticiens();
  }

  Future<void> _fetchDieteticiens() async {
    final authService = AuthService();
    String? token = await authService.getToken();

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/dieteticiens/liste'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _dieteticiens = data.map((json) => Dieteticien.fromJson(json)).toList();
        _filteredDieteticiens = _dieteticiens;
        _isLiked = List.generate(_dieteticiens.length, (_) => false);
      });
    } else {
      throw Exception('Erreur lors de la récupération des diététiciens');
    }
  }

  void _filterDieteticiens(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredDieteticiens = _dieteticiens;
      });
    } else {
      setState(() {
        _filteredDieteticiens = _dieteticiens.where((dieteticien) =>
            dieteticien.nom.toLowerCase().contains(query.toLowerCase()) ||
            (dieteticien.specialite ?? '').toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _selectButton(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _filteredDieteticiens = [];
      } else {
        _filterDieteticiens('');
      }
    });
  }

  void _toggleLike(int index) {
    setState(() {
      _isLiked[index] = !_isLiked[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisir un diététicien'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDieteticiens,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou spécialité',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _selectButton(0),
                child: Text('Recommandé'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: _selectedIndex == 0 ? Color(0xFF00796B) : Color(0xFF00796B).withOpacity(0.5),
                  foregroundColor: _selectedIndex == 0 ? Colors.white : Colors.black,
                ),
              ),
              ElevatedButton(
                onPressed: () => _selectButton(1),
                child: Text('Populaire'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: _selectedIndex == 1 ? Color(0xFF00796B) : Colors.grey[300],
                  foregroundColor: _selectedIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: _filteredDieteticiens.isEmpty
                ? Center(
                    child: _selectedIndex == 1
                        ? Text('Aucun contenu disponible pour "Populaire"')
                        : CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _filteredDieteticiens.length,
                    itemBuilder: (context, index) {
                      final dieteticien = _filteredDieteticiens[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReserverConsultationScreen(dieteticien: dieteticien),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            bottomLeft: Radius.circular(16.0),
                                          ),
                                          child: Image.network(
                                            dieteticien.imageUrl ?? '',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/profil.png',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  dieteticien.nom,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    _isLiked[index] ? Icons.favorite : Icons.favorite_border,
                                                    color: Color(0xFF00796B),
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    _toggleLike(index);
                                                  },
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '5.0',
                                                      style: TextStyle(
                                                        color: Colors.amber,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              dieteticien.specialite ?? 'Spécialité non renseignée',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Logique pour appeler le diététicien
                                        },
                                        child: Icon(Icons.phone, size: 20, color: Color(0xFF00796B)), 
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Logique pour envoyer un message
                                        },
                                        child: Icon(
                                          Icons.message,
                                          size: 20,
                                          color: Color(0xFF00796B),
                                        ),
                                      ),
                                      SizedBox(width: 8), // Espacement entre les icônes et le bouton
                                      ConstrainedBox(
                                        constraints: BoxConstraints.tightFor(width: 150), // Taille du bouton réduite
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ReserverConsultationScreen(dieteticien: dieteticien),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Prendre RDV',
                                            style: TextStyle(color: Colors.white), // Texte en blanc
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            backgroundColor: Color(0xFF00796B),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
