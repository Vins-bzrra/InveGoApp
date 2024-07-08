
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:invego_app/pages/form/disposed_form.dart';
import 'package:invego_app/pages/util/clean_fields.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/formatters.dart';
import 'package:invego_app/pages/util/urls.dart';

class DisposedOthersScreen extends StatefulWidget {
  const DisposedOthersScreen({super.key});

  @override
  _DisposedITScreenState createState() => _DisposedITScreenState();
}

class _DisposedITScreenState extends State<DisposedOthersScreen> {
  final TextEditingController _patrimonyController = TextEditingController();
  List<Map<String, dynamic>> _items = [];
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baixa de Item de TI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DisposedForm(
              patrimonyController: _patrimonyController,
              onSearch: () {
                _researhItem(context, _patrimonyController.text);
              },
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 45)),
              ),
              child: const Text('Baixar Item'),
            ),
            const SizedBox(height: 30),
            if (_items.isNotEmpty) _buildItemCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _items[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Detalhes do Item',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Marca: ${item['brand'] ?? 'N/A'}'),
                Text('Modelo: ${item['model'] ?? 'N/A'}'),
                Text('Patrimônio: ${item['patrimony'] ?? 'N/A'}'),
                Text('Categoria: ${item['category'] ?? 'N/A'}'),
                Text('Proprietário: ${item['currentOwner'] ?? 'N/A'} '),
                Text('Unidade: ${item['unitLocation'] ?? 'N/A'} '),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _researhItem(BuildContext context, String patrimony) async {
    final String? token = await storage.read(key: 'token');

    final Map<String, dynamic> requestBody = {
      'patrimony': patrimony,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.SearchOthers.value),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        if (responseData.isNotEmpty) {
          setState(() {
            _items = responseData.cast<Map<String, dynamic>>();
          });
        } else {
          showItemNotFoundMesseger(context);
        }
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      } else {
        showSearchFailedMesseger(context);
      }
    } catch (error) {
      showSearchRequestErrorMesseger(context);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Baixar Item'),
          content: const Text('Tem certeza de que deseja dar baixa no item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _disposeItem();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _disposeItem() async {
    final String patrimony = _patrimonyController.text;
    final String? token = await storage.read(key: 'token');
    final Map<String, String> requestBody = {
      'patrimony': patrimony,
    };

    try {
      final http.Response response = await http.put(
        Uri.parse(Urls.DisposedOthers.value),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
        },
        body: encodeMapToFormUrlEncoded(requestBody),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sucesso'),
              content: const Text('Item registrado com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    FieldCleaner.cleanFields(
                      patrimonyController: _patrimonyController,
                    );
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
       showDisposedFailedMesseger(context);
      }
    } catch (error) {
     showDisposedRequestErrorMesseger(context);
    }
  }
}