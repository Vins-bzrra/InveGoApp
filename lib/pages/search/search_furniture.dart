import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:invego_app/pages/form/furniture_form.dart';
import 'package:invego_app/pages/util/dialogs_alert.dart';
import 'package:invego_app/pages/util/formatters.dart';
import 'package:invego_app/pages/util/urls.dart';
import 'package:invego_app/widgets/bottom_sheet.dart';

class SearchFurnitureScreen extends StatelessWidget {
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
  final FlutterSecureStorage storage = const FlutterSecureStorage();
 

  SearchFurnitureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Itens de Mobiliário'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FurnitureForm(
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
              descriptionController: _descriptionController,
              showDescription: false,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                onPressed: () => _searchItem(context),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(300, 45)),
                ),
                child: const Text('Pesquisar')),
          ],
        ),
      ),
    );
  }

  Future<void> _searchItem(BuildContext context) async {
    final String? token = await storage.read(key: 'token');

    Map<String, dynamic> requestBody = {
      if (_brandController.text.isNotEmpty) 'brand': _brandController.text,
      if (_modelController.text.isNotEmpty) 'model': _modelController.text,
      if (_categoryController.text.isNotEmpty)
        'category': _categoryController.text,
      if (_patrimonyController.text.isNotEmpty)
        'patrimony': _patrimonyController.text,
      if (_statusController.text.isNotEmpty) 'status': _statusController.text,
      if (_supplierController.text.isNotEmpty)
        'supplier': _supplierController.text,
      if (_purchasePriceController.text.isNotEmpty)
        'purchasePrice': double.parse(_purchasePriceController.text),
      if (_processNumberController.text.isNotEmpty)
        'processNumber': _processNumberController.text,
      if (_currentOwnerController.text.isNotEmpty)
        'currentOwner': _currentOwnerController.text,
      if (_unitLocationController.text.isNotEmpty)
        'unitLocation': _unitLocationController.text,
      if (_colorController.text.isNotEmpty) 'color': _colorController.text,
      if (_materialController.text.isNotEmpty)
        'material': _materialController.text,
      if (_dimensionsController.text.isNotEmpty)
        'dimensions': _dimensionsController.text,
      if (_descriptionController.text.isNotEmpty)
        'description': _descriptionController.text,
      if (_acquisitionDateController.text.isNotEmpty)
        'acquisitionDate': formatDateSend(_acquisitionDateController.text),
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(Urls.SearchFurniture.value),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        List<dynamic> itens = json.decode(utf8.decode(response.bodyBytes));
        showBottomSheetSearch(context, itens, "Furniture");
      } else if (response.statusCode == 403) {
        showSessionExpiredDialog(context);
      } else {
        showSearchFailedMesseger(context);
      }
    } catch (error) {
      showSearchRequestErrorMesseger(context);
    }
  }

}
