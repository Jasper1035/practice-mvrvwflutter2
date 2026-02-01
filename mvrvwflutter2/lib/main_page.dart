import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvrvwflutter2/firebasefiles/crudop.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // local data for show in the table .. stored in local storage
  // final List<Map<String, dynamic>> _movieList = [
  //   {'name': 'john wick', 'type': 'Action', 'ratings': '8'},
  //   {'name': 'venom', 'type': 'sci', 'ratings': '5'},
  // ];

  // public / local controllers for chnage states.
  final TextEditingController _mnameController = TextEditingController();
  final TextEditingController _mtypeController = TextEditingController();
  final TextEditingController _ratings = TextEditingController();
  final Crudop _db = Crudop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Review app',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.movieStream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                dataTextStyle: TextStyle(color: Colors.white),
                dataRowColor: WidgetStatePropertyAll(Color(0xff878787)),
                headingRowColor: WidgetStateProperty.all(Color(0xff05ad98)),
                border: TableBorder.all(width: 2),
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Ratings')),
                  DataColumn(label: Text('Action')),
                ],
                rows: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return DataRow(
                    onSelectChanged: (selected) {
                      if (selected != null) {
                        _editFields(doc.id, data);
                      }
                    },
                    cells: [
                      DataCell(Text(data['name'] ?? '')),
                      DataCell(Text(data['type'] ?? '')),
                      DataCell(Text('${data['ratings'] ?? ''}/10')),

                      DataCell(
                        IconButton(
                          onPressed: () {
                            _db.delete(doc.id);
                          },
                          icon: Icon(Icons.delete, color: Colors.amber),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        //add button at the bottom right
        backgroundColor: Color(0xff05ad98),
        foregroundColor: Colors.white,
        onPressed: () {
          _addMovie(context);
        },

        child: Icon(Icons.add),
      ),
    );
  }

  //Add movie function
  void _addMovie(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Movie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _mnameController,
                decoration: InputDecoration(labelText: 'Movie Name'),
              ),
              TextField(
                controller: _mtypeController,
                decoration: InputDecoration(labelText: 'Movie Type'),
              ),
              TextField(
                controller: _ratings,
                decoration: InputDecoration(labelText: 'Ratings'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double? enteredRating = double.tryParse(_ratings.text);
                if (_mnameController.text.isNotEmpty &&
                    _mtypeController.text.isNotEmpty &&
                    _ratings.text.isNotEmpty) {
                  if (enteredRating! >= 0 && enteredRating <= 10) {
                    _db.addMovieFirebase(
                      _mnameController.text,
                      _mtypeController.text,
                      _ratings.text,
                    );
                    Navigator.pop(context);
                    _mnameController.clear();
                    _mtypeController.clear();
                    _ratings.clear();
                  }
                }
              },
              child: Text('add movie'),
            ),
          ],
        );
      },
    );
  }

  //Edit fields functions.
  void _editFields(String docId, Map<String, dynamic> movie) {
    _mnameController.text = movie['name'] ?? '';
    _mtypeController.text = movie['type'] ?? '';
    _ratings.text = movie['ratings'] ?? '';

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Edit Fields'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _mnameController,
                decoration: InputDecoration(labelText: 'Movie Name'),
              ),
              TextField(
                controller: _mtypeController,
                decoration: InputDecoration(labelText: 'Movie Type'),
              ),
              TextField(
                controller: _ratings,
                decoration: InputDecoration(labelText: 'Ratings'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double? ratings = double.tryParse(_ratings.text);

                if (_mnameController.text.isNotEmpty &&
                    _mtypeController.text.isNotEmpty &&
                    _ratings.text.isNotEmpty) {
                  if (ratings! >= 0 && ratings <= 10) {
                    _db.updateMovie(
                      docId,
                      _mnameController.text,
                      _mtypeController.text,
                      _ratings.text,
                    );
                  }
                }
                Navigator.pop(context);
                _mnameController.clear();
                _mtypeController.clear();
                _ratings.clear();
              },
              child: Text('Save changes'),
            ),
          ],
        );
      },
    );
  }
}
