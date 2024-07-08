import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:invego_app/pages/form/others_form.dart';
import 'package:invego_app/pages/util/clean_fields.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/formatters.dart';
import 'package:invego_app/pages/util/scan_barcode.dart';
import 'package:invego_app/pages/util/urls.dart';

class RegisterOthersScreen extends StatefulWidget {
  const RegisterOthersScreen({super.key});

  @override
  _RegisterOthersScreenState createState() => _RegisterOthersScreenState();
}

class _RegisterOthersScreenState extends State<RegisterOthersScreen> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _patrimonyController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _acquisitionDateController =
      TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _processNumberController =
      TextEditingController();
  final TextEditingController _currentOwnerController = TextEditingController();
  final TextEditingController _unitLocationController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  int _numberOfItems = 1;
  int _currentItemIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Item de TI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Quantidade de itens a adicionar: $_numberOfItems'),
            ElevatedButton(
              onPressed: _showNumberOfItemsDialog,
              child: const Text('Alterar Quantidade'),
            ),
            const SizedBox(height: 25),
            OthersForm(
              brandController: _brandController,
              modelController: _modelController,
              categoryController: _categoryController,
              patrimonyController: _patrimonyController,
              statusController: _statusController,
              supplierController: _supplierController,
              purchasePriceController: _purchasePriceController,
              processNumberController: _processNumberController,
              currentOwnerController: _currentOwnerController,
              unitLocationController: _unitLocationController,
              acquisitionDateController: _acquisitionDateController,
              materialController: _materialController,
              dimensionsController: _dimensionsController,
              colorController: _colorController,
              serialNumberController: _serialNumberController,
              descriptionController: _descriptionController,
              onSearch: () => {_scanBarcode(context)},
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => _registerItems(context),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 45)),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNumberOfItemsDialog() async {
    int? numberOfItems = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informe a quantidade de itens'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantidade'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                int? quantity = int.tryParse(_quantityController.text);
                if (quantity != null && quantity > 0) {
                  setState(() {
                    _numberOfItems = quantity;
                    _currentItemIndex = 1;
                  });
                  Navigator.of(context).pop(quantity);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, insira uma quantidade válida.'),
                    ),
                  );
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerItems(BuildContext context) async {
    final String? token = await storage.read(key: 'token');
  
    final Map<String, dynamic> requestBody = {
      'brand': _brandController.text,
      'model': _modelController.text,
      'category': _categoryController.text,
      'patrimony': _patrimonyController.text,
      'status': _statusController.text,
      'acquisitionDate': formatDateSend(_acquisitionDateController.text),
      'supplier': _supplierController.text,
      'purchasePrice': double.parse(_purchasePriceController.text),
      'processNumber': _processNumberController.text,
      'currentOwner': _currentOwnerController.text,
      'unitLocation': _unitLocationController.text,
      'material': _materialController.text,
      'dimensions': _dimensionsController.text,
      'color': _colorController.text,
      'serialNumber': _serialNumberController.text,
      'description': _descriptionController.text,
    };
    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.RegisterOthers.value),
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
              content: const Text('Item registrado com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_currentItemIndex < _numberOfItems) {
                      setState(() {
                        _currentItemIndex++;
                        _patrimonyController.clear();
                        _serialNumberController.clear();
                        Navigator.of(context).pop();
                      });
                    } else {
                      FieldCleaner.cleanFields(
                        brandController: _brandController,
                        modelController: _modelController,
                        categoryController: _categoryController,
                        patrimonyController: _patrimonyController,
                        statusController: _statusController,
                        acquisitionDateController: _acquisitionDateController,
                        supplierController: _supplierController,
                        purchasePriceController: _purchasePriceController,
                        processNumberController: _processNumberController,
                        currentOwnerController: _currentOwnerController,
                        unitLocationController: _unitLocationController,
                        materialController: _materialController,
                        dimensionsController: _dimensionsController,
                        colorController: _colorController,
                        serialNumberController: _serialNumberController,
                        descriptionController: _descriptionController,
                      );
                      Navigator.of(context).pop();
                    }
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
        showRegisterFailedMesseger(context);
      }
    } catch (error) {
      showRegisterRequestErrorMesseger(context);
    }
  }

  Future<void> _scanBarcode(BuildContext context) async {
    var cod = await BarcodeUtils.scanBarcode(context);
    if (cod != null) {
      _serialNumberController.text = cod;
    }
  }
}