import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/urls.dart';

class User {
  final int id;
  final String name;
  final String lastName;

  User({required this.id, required this.name, required this.lastName});
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late List<User> _users = [];
  String newPassword = '';

  @override
  void initState() {
    super.initState();
    _searchUsers();
  }

  Future<void> _searchUsers() async {
    final String? token = await storage.read(key: 'token');
    try {
      final response = await http.get(
        Uri.parse(Urls.SearchUsers.value),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _users = responseData
              .map((userData) => User(
                    id: userData['id'],
                    name: userData['name'],
                    lastName: userData['lastName'],
                  ))
              .toList();
        });
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao buscar os usuários.Tente novamente.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erro durante a requisição para obter a lista de usuários.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Usuários'),
      ),
      body: _users == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    title: Text(user.name),
                    subtitle: Text(user.lastName),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: {'action': 'edit', 'userId': user.id},
                          child: const Text('Resetar senha'),
                        ),
                        PopupMenuItem(
                          value: {'action': 'delete', 'userId': user.id},
                          child: const Text('Excluir'),
                        ),
                      ],
                      onSelected: (value) {
                        final String action = value['action'] as String;
                        final int userId = value['userId'] as int;
                        if (action == 'edit') {
                          _showPasswordResetDialog(userId);
                        } else if (action == 'delete') {
                          _deleteUser(userId);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteUser(int userId) async {
    final String? token = await storage.read(key: 'token');
    try {
      final response = await http.delete(
        Uri.parse('${Urls.DeleteUser.value}/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Usuário deletado com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchUsers();
                    });
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
            content: Text('Falha ao deletar o usuário.Tente novamente.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro durante a requisição para deletar o usuário.'),
        ),
      );
    }
  }

  Future<void> _resetPassword(String password, int userId) async {
    final String? token = await storage.read(key: 'token');
    try {
      final Map<String, dynamic> requestBody = {
        'idUser': userId,
        'newPassword': password,
      };

      final response = await http.patch(
        Uri.parse(Urls.ResetPassword.value),
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
              content: const Text('Senha redefinida com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _passwordController.clear();
                    setState(() {
                      _searchUsers();
                    });
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
            content:
                Text('Falha ao redefinir a senha do usuário.Tente novamente.'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Erro durante a requisição para redefinir a senha do usuário.'),
        ),
      );
    }
  }

  Future<void> _showPasswordResetDialog(int userId) async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (bool didPop) {
            _passwordController.clear();
            return;
          },
          
          child: AlertDialog(
            title: const Text('Digite a nova senha'),
            content: TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                   _passwordController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  _resetPassword(_passwordController.text, userId);
                  _passwordController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
