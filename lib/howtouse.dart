import 'package:flutter/material.dart';

import 'homepage.dart';

class HowToUse extends StatelessWidget {
  final String name;
  const HowToUse({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
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
                    'Bem-vindo(a)',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$name!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: 'O aplicativo',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Listas de Compras',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF407BFF),
                      ),
                    ),
                    TextSpan(
                      text:
                          ' foi criado com foco em ajudar o usuário a organizar e manter suas listas de compras em um único local.\n\nCrie suas listas e nunca mais esqueça um item no mercado ou farmácia.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/secondIcon.png',
                width: 250,
                height: 200,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                name: name,
                              )));
                },
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
                  'Vamos começar',
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
