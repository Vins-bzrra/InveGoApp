import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:invego_app/pages/inventory_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _login() async {
    final String user = _userController.text;
    final String password = _passwordController.text;
    final url =
        // Uri.parse('http://10.0.0.107:8080/inveGo/api/users/login');
        Uri.parse('http://100.90.55.77:8080/inveGo/api/users/login');

    var data = {
      'registrationNumber': user,
      'password': password,
    };
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        final String responseToken = response.body;
        await _storage.write(key: 'token', value: responseToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InventoryPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Falha ao realizar login. Verifique suas credenciais.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Erro durante a requisição de login. Verifique sua conexão com a internet.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'assets/images/logoLogin.jpg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Usuário'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        16.0),
                child: ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(double.infinity,
                        40.0)),
                  ),
                  child: const Text('Login',
                      style: TextStyle(
                          fontSize:
                              14.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
