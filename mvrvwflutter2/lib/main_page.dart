import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // local data for show in the table .. stored in local storage
  final List<Map<String, dynamic>> _movieList = [
    {'name': 'john wick', 'type': 'Action', 'ratings': '8'},
    {'name': 'venom', 'type': 'sci', 'ratings': '5'},
  ];

  // public / local controllers for chnage states.
  final TextEditingController _mnameController = TextEditingController();
  final TextEditingController _mtypeController = TextEditingController();
  final TextEditingController _ratings = TextEditingController();
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
      body: Padding(
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
            rows: _movieList.map((movie) {
              return DataRow(
                onSelectChanged: (bool? selected) {
                  if (selected != null) {
                    _editFields(movie);
                  }
                },
                cells: [
                  DataCell(Text(movie['name'] ?? '')),
                  DataCell(Text(movie['type'] ?? '')),
                  DataCell(Text('${movie['ratings'] ?? ''}/10')),
                  DataCell(
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _movieList.remove(movie); //delete button.
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.amber),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        //add button at the bottom right
        backgroundColor: Color(0xff05ad98),
        foregroundColor: Colors.white,
        onPressed: () {
          setState(() {
            _addMovie(context);
          });
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
                    setState(() {
                      _movieList.add({
                        'name': _mnameController.text,
                        'type': _mtypeController.text,
                        'ratings': _ratings.text,
                      });

                      Navigator.pop(context);
                      _mnameController.clear();
                      _mtypeController.clear();
                      _ratings.clear();
                    });
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
  void _editFields(Map<String, dynamic> movie) {
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
                double? rating = double.tryParse(_ratings.text);

                if (_mnameController.text.isNotEmpty &&
                    _mtypeController.text.isNotEmpty &&
                    _ratings.text.isNotEmpty) {
                  if (rating! >= 0 && rating <= 10) {
                    setState(() {
                      movie['name'] = _mnameController.text;
                      movie['type'] = _mtypeController.text;
                      movie['ratings'] = _ratings.text;
                    });
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
