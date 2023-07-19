import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groceryapp/listpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListData {
  final String name;
  final Color backgroundColor;

  ListData({required this.name, required this.backgroundColor});
}

class ColorPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (Color color in Colors.primaries)
          GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = color;
              });
              widget.onColorChanged(color);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: color == selectedColor
                      ? Colors.black
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Stack(
                children: [
                  if (color == selectedColor)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  Positioned.fill(
                    child: ClipOval(
                      child: Container(
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final String name;
  const HomePage({Key? key, required this.name}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ListData> lists = [];
  late SharedPreferences _prefs;
  bool _isItemDeleted = false;
  int _deletedItemIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLists = _prefs.getStringList('lists');
    if (savedLists != null) {
      setState(() {
        lists = savedLists.map((item) {
          final listData = jsonDecode(item);
          return ListData(
            name: listData['name'],
            backgroundColor: Color(listData['backgroundColor']),
          );
        }).toList();
      });
    }
  }

  Future<void> _saveLists() async {
    final savedLists = lists
        .map((listData) => jsonEncode({
              'name': listData.name,
              'backgroundColor': listData.backgroundColor.value,
            }))
        .toList();
    await _prefs.setStringList('lists', savedLists);
  }

  void _showCreateListDialog(BuildContext context) {
    String newListName = '';
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Você está criando uma lista para armazenar os itens da sua compra',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newListName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nome da lista',
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Cor da lista',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ColorPicker(
                selectedColor: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Voltar'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        lists.add(
                          ListData(
                            name: newListName,
                            backgroundColor: selectedColor,
                          ),
                        );
                      });

                      _saveLists();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Criar',
                      style: TextStyle(
                        color: Color(0xFF407BFF),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteList(int index) {
    setState(() {
      _isItemDeleted = true;
      _deletedItemIndex = index;
      final deletedList = lists.removeAt(index);
      _saveLists();

      SharedPreferences.getInstance().then((prefs) {
        prefs.remove(deletedList.name);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Você excluiu a lista ${deletedList.name.toUpperCase()}',
            style: TextStyle(fontSize: 16),
          ),
          action: SnackBarAction(
            label: 'Desfazer',
            textColor: Color(0xFF407BFF),
            onPressed: () {
              setState(() {
                lists.insert(_deletedItemIndex, deletedList);
                _isItemDeleted = false;
              });
              _saveLists();
            },
          ),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text(
                  'Suas listas',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: Color(0xFF407BFF),
              thickness: 1,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: ListView.builder(
                itemCount: lists.length,
                itemBuilder: (BuildContext context, int index) {
                  final ListData listData = lists[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Material(
                      elevation:
                          _isItemDeleted && index == _deletedItemIndex ? 0 : 7,
                      child: ListTile(
                        title: Text(
                          listData.name.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        tileColor: listData.backgroundColor,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteList(index),
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPage(
                                        name: listData.name,
                                        backgroundColor:
                                            listData.backgroundColor,
                                        listId: '',
                                      )));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 35),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF407BFF),
        onPressed: () {
          _showCreateListDialog(context);
        },
        label: Text(
          'Criar uma nova Lista',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        icon: Icon(
          Icons.format_list_bulleted_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
