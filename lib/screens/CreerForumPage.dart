import 'package:equilibromobile/services/ForumService.dart';
import 'package:flutter/material.dart';


class CreerForumPage extends StatefulWidget {
  @override
  _CreerForumPageState createState() => _CreerForumPageState();
}

class _CreerForumPageState extends State<CreerForumPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> _createForum() async {
    setState(() {
      isLoading = true;
    });

    final service = ForumService();
    await service.createForum(_nameController.text, _descriptionController.text);

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context); // Retour à la liste des forums après création
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Forum')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom du forum'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createForum,
                    child: Text('Créer le forum'),
                  ),
          ],
        ),
      ),
    );
  }
}
