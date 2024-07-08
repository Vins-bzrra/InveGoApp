import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invego_app/pages/form/transfer_form.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/urls.dart';
import 'package:invego_app/widgets/item_card.dart';

class TransferITScreen extends StatefulWidget {
  const TransferITScreen({super.key});

  @override
  _TransferITScreenState createState() => _TransferITScreenState();
}

class _TransferITScreenState extends State<TransferITScreen> {
  final TextEditingController _patrimonyController = TextEditingController();
  final TextEditingController _newOwnerController = TextEditingController();
  final TextEditingController _newLocationController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> _items = [];
  bool _isFieldsEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferência de Item de TI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TransferForm(
              newLocationController: _newLocationController,
              newOwnerController: _newOwnerController,
              patrimonyController: _patrimonyController,
              onSearch: () {
                _researhItem(context, _patrimonyController.text);
              },
              isFieldsEnable: _isFieldsEnable,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _transferItem(
                  context,
                  _patrimonyController.text,
                  _newOwnerController.text,
                  _newLocationController.text,
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 45)),
              ),
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 35),
            if (_items.isNotEmpty) buildItemCard(_items),
          ],
        ),
      ),
    );
  }

  Future<void> _researhItem(BuildContext context, String patrimony) async {
    if (_patrimonyController.text.isNotEmpty) {
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
              _isFieldsEnable = true;
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
    } else {
      showPatrimonyEmptyMesseger(context);
    }
  }

  Future<void> _transferItem(BuildContext context, String patrimony,
      String newOwner, String newLocation) async {
    if (_patrimonyController.text.isNotEmpty &&
        (_newOwnerController.text.isNotEmpty ||
            _newLocationController.text.isNotEmpty)) {
      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> requestBody = {
        'patrimony': patrimony,
        'newOwner': newOwner,
        'newUnitLocation': newLocation,
      };

      try {
        final http.Response response = await http.post(
          Uri.parse(Urls.TransferIT.value),
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
                content: const Text('Item transferido com sucesso!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
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
          showTransferFailedMesseger(context);
        }
      } catch (error) {
       showTransferRequestErrorMesseger(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'O campo "Patrimônio" deve estar preenchido e pelo menos um dos campos "Novo Proprietário" ou "Nova Localização" deve ser preenchido.'),
        duration: Duration(seconds: 6),
      ));
    }
  }
}
