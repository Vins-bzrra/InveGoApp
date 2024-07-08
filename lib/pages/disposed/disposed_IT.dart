import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:invego_app/pages/form/disposed_form.dart';
import 'package:invego_app/pages/util/clean_fields.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/formatters.dart';
import 'package:invego_app/pages/util/urls.dart';
import 'package:invego_app/widgets/item_card.dart';

class DisposedITScreen extends StatefulWidget {
  const DisposedITScreen({super.key});

  @override
  _DisposedITScreenState createState() => _DisposedITScreenState();
}

class _DisposedITScreenState extends State<DisposedITScreen> {
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
            if (_items.isNotEmpty) buildItemCard(_items),
          ],
        ),
      ),
    );
  }

  Future<void> _researhItem(BuildContext context, String patrimony) async {
    final String? token = await storage.read(key: 'token');

    final Map<String, dynamic> requestBody = {
      'patrimony': patrimony,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.SearchIT.value),
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
        Uri.parse(Urls.DisposedIT.value),
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