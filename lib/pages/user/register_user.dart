import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/urls.dart';

class RegisterUserScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sobrenome',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _registrationNumberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Matrícula',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Senha',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _registerUser(context);
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    final String? token = await storage.read(key: 'token');
  
    final Map<String, dynamic> requestBody = {
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'registrationNumber': _registrationNumberController.text,
      'password': _passwordController.text,
    };
    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.RegisterUser.value),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Usuário registrado com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _nameController.clear();
                    _lastNameController.clear();
                    _registrationNumberController.clear();
                    _passwordController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Falha ao cadastrar o usuário. Verifique os dados e tente novamente.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro durante a requisição de registro do usuário.'),
        ),
      );
    }
  }
}
