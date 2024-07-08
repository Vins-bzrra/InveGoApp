import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:invego_app/pages/util/clean_fields.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/formatters.dart';
import 'package:invego_app/pages/util/scan_barcode.dart';
import 'package:invego_app/pages/util/urls.dart';

class UpdateOthersScreen extends StatefulWidget {
  const UpdateOthersScreen({super.key});

  @override
  _UpdateOthersScreenState createState() => _UpdateOthersScreenState();
}

class _UpdateOthersScreenState extends State<UpdateOthersScreen> {
  final TextEditingController _patrimonyController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
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
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  bool _areOtherFieldsEditable = false;
  var _itemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Item de TI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _patrimonyController,
              decoration: InputDecoration(
                labelText: "Patrimônio",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.update),
                  onPressed: () {
                    _searchItemByPatrimony(context);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              enabled: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: "Marca",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: "Modelo",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: "Categoria",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _supplierController,
              decoration: const InputDecoration(
                labelText: "Fornecedor",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _purchasePriceController,
              decoration: const InputDecoration(
                labelText: "Preço de Compra",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _processNumberController,
              decoration: const InputDecoration(
                labelText: "Número do Processo",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _currentOwnerController,
              decoration: const InputDecoration(
                labelText: "Proprietário Atual",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _unitLocationController,
              decoration: const InputDecoration(
                labelText: "Localização",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: "Cor",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _materialController,
              decoration: const InputDecoration(
                labelText: "Material",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _dimensionsController,
              decoration: const InputDecoration(
                labelText: "Dimensões",
                hintText: 'C X L X A',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter,
                DimensionsInputFormatter(),
              ],
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _serialNumberController,
              decoration: InputDecoration(
                labelText: "Número de Série",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    _scanBarcode(context);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _acquisitionDateController,
              decoration: const InputDecoration(
                labelText: "Data de Aquisição",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: [_dateMaskFormatter],
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Descrição",
                border: OutlineInputBorder(),
              ),
              enabled: _areOtherFieldsEditable,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(300, 45)),
              ),
              child: const Text('Atualizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _fillFieldsWithItemDetails(Map<String, dynamic> itemDetails) {
    _brandController.text = itemDetails['brand'] ?? '';
    _modelController.text = itemDetails['model'] ?? '';
    _categoryController.text = itemDetails['category'] ?? '';
    _statusController.text = itemDetails['status'] ?? '';
    _supplierController.text = itemDetails['supplier'] ?? '';
    _purchasePriceController.text = itemDetails['purchasePrice'] != null
        ? itemDetails['purchasePrice'].toString()
        : '';
    _processNumberController.text = itemDetails['processNumber'] ?? '';
    _currentOwnerController.text = itemDetails['currentOwner'] ?? '';
    _unitLocationController.text = itemDetails['unitLocation'] ?? '';
    _colorController.text = itemDetails['color'] ?? '';
    _materialController.text = itemDetails['material'] ?? '';
    _dimensionsController.text = itemDetails['dimensions'] ?? '';
    _serialNumberController.text = itemDetails['serialNumber'] ?? '';
    _descriptionController.text = itemDetails['description'] ?? '';
    _acquisitionDateController.text =
        formatDateInput(itemDetails['acquisitionDate'] ?? '');
  }

  Future<void> _searchItemByPatrimony(BuildContext context) async {
    if (_patrimonyController.text.isNotEmpty) {
      final String patrimony = _patrimonyController.text;
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
              _fillFieldsWithItemDetails(responseData.first);
              setState(() {
                _areOtherFieldsEditable = true;
                _itemId = responseData.first['id'];
              });
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atualizar Item'),
          content: const Text(
              'Tem certeza de que deseja atualizar as informações do item?'),
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
                _updateItemDetails();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateItemDetails() async {
    final String? token = await storage.read(key: 'token');

    Map<String, dynamic> requestBody = {
      'id': _itemId,
      'brand': _brandController.text,
      'model': _modelController.text,
      'category': _categoryController.text,
      'status': _statusController.text,
      'supplier': _supplierController.text,
      'purchasePrice': _purchasePriceController.text,
      'processNumber': _processNumberController.text,
      'currentOwner': _currentOwnerController.text,
      'unitLocation': _unitLocationController.text,
      'color': _colorController.text,
      'material': _materialController.text,
      'dimensions': _dimensionsController.text,
      'serialNumber': _serialNumberController.text,
      'description': _descriptionController.text,
      'acquisitionDate': formatDateSend(_acquisitionDateController.text),
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.UpdateOthers.value),
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
              content: const Text('Item atualizado com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
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
                      colorController: _colorController,
                      materialController: _materialController,
                      dimensionsController: _dimensionsController,
                      serialNumberController: _serialNumberController,
                      descriptionController: _descriptionController,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          _areOtherFieldsEditable = false;
        });
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      } else {
        showUpdateFailedMesseger(context);
      }
    } catch (error) {
      showUpdateRequestErrorMesseger(context);
    }
  }

  Future<void> _scanBarcode(BuildContext context) async {
    var cod = await BarcodeUtils.scanBarcode(context);
    if (cod != null && cod.isNotEmpty) {
      _serialNumberController.text = cod;
    }
  }
}