import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  final String name;
  final Color backgroundColor;
  final String listId;

  const ListPage({
    Key? key,
    required this.name,
    required this.backgroundColor,
    required this.listId,
  }) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> _enteredTexts = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedItems();
  }

  Future<void> _loadSavedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList(widget.name) ?? [];
    setState(() {
      _enteredTexts = savedItems;
    });
  }

  Future<void> _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.name, _enteredTexts);
  }

  void _sendTextToContainer() {
    final enteredText = _textEditingController.text;
    if (enteredText.isNotEmpty) {
      setState(() {
        _enteredTexts.add(enteredText);
        _textEditingController.clear();
      });
      _saveItems();
    }
  }

  void _removeTextFromContainer(int index) {
    setState(() {
      _enteredTexts.removeAt(index);
    });
    _saveItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        title: Text(widget.name.toUpperCase()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Text(
                    'Items da sua lista',
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
                color: Colors.black,
                thickness: 1,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: _enteredTexts
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: Container(
                        height: 40,
                        color: widget.backgroundColor,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _removeTextFromContainer(entry.key);
                                });
                              },
                              icon: Icon(
                                Icons.disabled_by_default,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemPopup(context),
        backgroundColor: widget.backgroundColor,
        label: Text(
          'Adicione itens em sua lista',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddItemPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Adicione um item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            labelText: 'Item',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _sendTextToContainer();
                          });
                        },
                        icon: Icon(
                          Icons.send,
                          color: widget.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Fechar',
                    style: TextStyle(
                      color: Color(0xFF407BFF),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
