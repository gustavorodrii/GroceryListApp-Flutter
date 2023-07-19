import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'howtouse.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    final String name = _nameController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HowToUse(name: name),
      ),
    );
  }

  void _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  name: '',
                )),
      );
    } else {
      prefs.setBool('seen', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkFirstSeen();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Olá',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Como posso te chamar ?',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF407BFF),
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF407BFF),
                      ),
                    ),
                    hintText: 'Digite o seu nome',
                  ),
                ),
              ),
              SizedBox(height: 30),
              Image.asset(
                'assets/mainIcon.png',
                height: 250,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _navigateToNextPage,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xFF407BFF),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size(320, 50),
                  ),
                ),
                child: Text(
                  'Continuar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
